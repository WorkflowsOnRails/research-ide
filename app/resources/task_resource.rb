# Resource class for Tasks. Task resources are collections which contain
# attachment resources, as well as a specialized resources that present the
# task body in markdown and LaTeX. See AttachmentResource, TaskMarkdownResource,
# and TaskLatexResource for more information.
#
# @author Brendan MacDonell
class TaskResource < BaseResource
  PATTERN = "#{ProjectResource::PATTERN}/(?<task_folder>[^/]+)"
  REGEXP = anchored_regexp(PATTERN)

  # Set up a mapping so that we can assign tasks readable IDs. Normally we
  # would use i18n for this sort of thing, but we have no language information
  # and want the folder names to be consistent.
  FOLDER_FOR_TASK_TYPE = {
    Task::TYPE.writing_hypothesis.to_s => '1 Hypothesis',
    Task::TYPE.writing_literature_review.to_s => '2 Literature Review',
    Task::TYPE.describing_method.to_s => '3 Method',
    Task::TYPE.gathering_data.to_s => '4 Results',
    Task::TYPE.analyzing_results.to_s => '5 Analysis',
    Task::TYPE.drawing_conclusions.to_s => '6 Conclusions',
    Task::TYPE.completed.to_s => '7 Errata',
  }
  TASK_TYPE_FOR_FOLDER = FOLDER_FOR_TASK_TYPE.invert

  include CollectionResourceable
  include ModelResourceable

  alias_method :task, :instance

  def self.create(current_user, match)
    task_type = TASK_TYPE_FOR_FOLDER[match[:task_folder]]
    task = Task.find_by(project_id: match[:project_id], task_type: task_type)
    self.new(current_user, task)
  end

  def children
    authorize instance, :show?
    elts = task.attachments.map { |a| AttachmentResource.new(current_user, a) }
    builtin_elts = [
     TaskMarkdownResource.new(current_user, task),
     TaskLatexResource.new(current_user, task),
    ]
    builtin_elts + elts
  end

  def display_name
    id
  end

  def exist?
    task.present?
  end

  def id
    FOLDER_FOR_TASK_TYPE[task.task_type]
  end
end
