# Resource class for Attachments. AttachmentResources are leaf resources
# that allow users to create, fetch, modify, and delete attachments.
#
# As the only resource type that can be created, it will instantiate new,
# empty, unsaved attachments when resources are accessed that do not
# already exist. This makes its operation somewhat more complex than other
# resources, as several operations need to provide appropriate fallbacks
# for properties that may not be defined.
#
# Note that Paperclip does not provide a rich storage abstraction for clients,
# so the resource is hard-coded to work only with the Filesystem storage layer.
# Adding support for other storage layers (ex. S3-based storage) will require
# modifications to #get, #copy, and #write.
#
# @author Brendan MacDonell
class AttachmentResource < BaseResource
  PATTERN = "#{TaskResource::PATTERN}/(?<file_name>.*)"
  REGEXP = anchored_regexp(PATTERN)

  include LeafResourceable
  include ModelResourceable

  alias_method :attachment, :instance

  def self.create(current_user, match)
    task = TaskResource.create(current_user, match).instance
    name = match[:file_name]
    attachment = task.attachments.find_or_initialize_by(file_file_name: name)

    self.new(current_user, attachment)
  end

  def initialize(current_user, instance)
    super(current_user, instance)

    # Paperclip rewrites the file name when it changes the file content,
    # so we need to save the filename separately.
    @filename = attachment.file_file_name
  end

  def content_length
    attachment.file_file_size || 0
  end

  def content_type
    attachment.file_content_type || 'application/x-zerosize'
  end

  def display_name
    attachment.file_file_name || ''
  end

  def exist?
    !attachment.new_record?
  end

  def get(request, response)
    authorize instance, :show?

    File.open(disk_path) do |file|
      response['Content-Length'] = file.size
    end
    response['Content-Type'] = attachment.file_content_type
    response['rack.hijack'] = lambda do |io|
      begin
        file = File.new(disk_path)
        while !file.eof?
          io.write(file.read(1024 * 1024))
          io.flush()
        end
      ensure
        io.close()
        file.close()
      end
    end
  end

  def put(request, response)
    # NOTE: Authorization is checked in write.
    write(request.body)
  end

  def copy(destination, request, response)
    file = File.new(attachment.file.path)
    authorize instance, :show?
    destination.write(file)
  ensure
    file.close()
  end

  def delete(request, response)
    authorize instance, :destroy?
    attachment.destroy
  end

  def id
    attachment.file_file_name
  end

  def write(io)
    # RackDAV performs a recursive delete on the target before it begins
    # to perform a copy or move. This means that the destination resource
    # that it gives us will no longer exist, so we need to reload it.
    reload! if instance.destroyed?

    authorize attachment, :update?
    attachment.file = io
    attachment.file_file_name = @filename
    attachment.uploader = current_user
    attachment.save!
  end

  private

  def disk_path
    attachment.file.path
  end

  def reload!
    task = instance.task
    name = instance.file_file_name
    @instance = task.attachments.find_or_initialize_by(file_file_name: name)
  end
end
