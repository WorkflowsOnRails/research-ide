# Resource class representing the body content of a Task.
# TaskMarkdownResources are leaf resources that allow users to fetch and
# edit the markdown content for a task.
#
# TaskMarkdownResources only accept valid textual content, so that there is
# no risk of a user accidentally copying a diagram over their content.
# As RackDAV deletes resources before performing a MOVE, TaskMarkdownResources
# also ignore DELETE requests, so that the content will not be changed if
# a MOVE or COPY fails due to content with an inappropriate encoding.
#
# TaskMarkdownResources are always named 'Content.md'.
#
# @author Brendan MacDonell
class TaskMarkdownResource < BaseResource
  FILENAME = 'Content.md'
  PATTERN = "#{TaskResource::PATTERN}/#{FILENAME}"
  REGEXP = anchored_regexp(PATTERN)

  include LeafResourceable
  include ModelResourceable

  alias_method :task, :instance

  def self.create(current_user, match)
    task = TaskResource.create(current_user, match).instance
    self.new(current_user, task)
  end

  def content_length
    task.content.length
  end

  def content_type
    'text/x-markdown'
  end

  def display_name
    id
  end

  def exist?
    task.present?
  end

  def get(request, response)
    authorize instance, :show?
    response.body = [task.content]
  end

  def put(request, response)
    write(request.body)
  end

  def copy(destination, request, response)
    io = StringIO.new(task.content)
    authorize instance, :show?
    destination.write(io)
  ensure
    io.close()
  end

  def delete(request, response)
    # Don't do anything -- we don't want the content to be cleared
    # when somebody copies a file to content but it fails to update.
  end

  def id
    FILENAME
  end

  def write(io)
    authorize instance, :update?

    task.content = io.read()
    task.last_updater = current_user

    if task.content.valid_encoding?
      task.save!
    else
      raise BadRequest
    end
  end

end
