# Resource class representing the LaTeX-encoded body content of a Task.
#
# A TaskLatexResource is automatically generated from the Markdown content
# of a Task, so it cannot be edited or deleted by users.
#
# TaskLatexResources are always named 'Content.tex'.
#
# @author Brendan macDonell
class TaskLatexResource < BaseResource
  FILENAME = 'Content.tex'
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
    task.latex_content.length
  end

  def content_type
    'application/x-tex'
  end

  def display_name
    id
  end

  def exist?
    task.present?
  end

  def get(request, response)
    authorize instance, :show?
    response.body = [task.latex_content]
  end

  def put(request, response)
    raise Forbidden
  end

  def copy(destination, request, response)
    io = StringIO.new(task.latex_content)
    authorize instance, :show?
    destination.write(io)
  ensure
    io.close()
  end

  def delete(request, response)
    raise Forbidden
  end

  def id
    FILENAME
  end

  def write(io)
    raise Forbidden
  end
end
