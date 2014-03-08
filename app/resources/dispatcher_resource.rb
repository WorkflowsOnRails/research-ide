# RackDAV resource that acts as an adapter to application-specific resources.
# Application-specific resources should inherit from BaseResource;
# DispatcherResource only exists to delegate requests to appropriate resource
# instances.
#
# @author Brendan MacDonell

require 'digest/md5'

class DispatcherResource < RackDAV::Resource
  include RackDAV::HTTPStatus

  Logger = ActiveSupport::TaggedLogging.new(Rails.logger)

  # Possible resource classes that could serve a request. Note that we can't
  # use BaseResource.subclasses to get this information, as Rails' lazy-loading
  # ensures that the classes aren't present until they are used.
  RESOURCE_CLASSES = [
    RootResource,
    ProjectResource,
    TaskResource,
    TaskMarkdownResource,
    TaskLatexResource,
    AttachmentResource,
  ]

  def current_user
    if @current_user.nil?
      username = @request.env['REMOTE_USER']
      @current_user = User.find_by(email: username)
    end

    @current_user
  end

  def children
    resource.children.map { |c| child c.id.to_s }
  end

  def collection?
    resource.collection?
  end

  def content_length
    resource.content_length
  end

  def content_type
    resource.content_type
  end

  def creation_date
    resource.creation_date
  end

  def display_name
    resource.display_name
  end

  def etag
    Digest::MD5.hexdigest(last_modified.httpdate)
  end

  def exist?
    resource.exist?
  end

  def last_modified
    resource.last_modified
  end

  def last_modified=(time)
    # TODO: Should we just silently ignore this?
    raise Forbidden
  end

  def make_collection
    raise Forbidden
  end

  def name
    display_name
  end

  def get
    raise NotFound unless resource.exist?
    resource.get(@request, @response)
  end

  def post
    resource.post(@request, @response)
  end

  def put
    resource.put(@request, @response)
  rescue NotFound
    raise Forbidden
  end

  def copy(destination)
    resource.copy(destination.resource, @request, @response)
  end

  def delete
    resource.delete(@request, @response)
  end

  def resource
    return @resource if @resource.present?

    Logger.tagged(self.class.name) do
      Rails.logger.info "Fetching: #{path}"
    end

    RESOURCE_CLASSES.each do |klass|
      match = klass::REGEXP.match(path)

      if match
        @resource = klass.create(current_user, match) if match
        return @resource
      end
    end

    raise NotFound
  end

end
