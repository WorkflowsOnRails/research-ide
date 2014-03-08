# Resource class for projects. Project resources are collections
# containing whatever tasks have been created so far for the project.
# See TaskResource for more information.
#
# Note that project resources are named following the form "${id}_${name}".
# As the names of the projects assigned to a user are neither static nor
# necessarily unique, we need to include the ID to disambiguate them.
#
# @author Brendan MacDonell
class ProjectResource < BaseResource
  PATTERN = "#{RootResource::PATTERN}/(?<project_id>\\d+)_([^/]+)"
  REGEXP = anchored_regexp(PATTERN)

  include CollectionResourceable
  include ModelResourceable

  alias_method :project, :instance

  def self.create(current_user, match)
    project = Project.find(match[:project_id])
    self.new(current_user, project)
  end

  def children
    authorize instance, :show?
    project
      .tasks
      .map { |t| TaskResource.new(current_user, t) }
      .sort_by { |t| t.display_name }
  end

  def display_name
    project.name
  end

  def exist?
    project.present?
  end

  def id
    "#{project.id}_#{project.name}"
  end
end
