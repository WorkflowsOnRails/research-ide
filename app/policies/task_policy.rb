# @author Brendan MacDonell
class TaskPolicy < ApplicationPolicy
  EDIT_POLICIES = ActiveSupport::HashWithIndifferentAccess.new({
    writing_hypothesis: proc { project.have_not_started? :gathering_data },
    writing_literature_review: proc { project.have_not_started? :completed },
    describing_method: proc { project.have_not_started? :gathering_data },
    gathering_data: proc { project.have_not_started? :analyzing_results },
    analyzing_results: proc { project.have_not_started? :completed },
    drawing_conclusions: proc { project.have_not_started? :completed },
    completed: proc { true },
  })

  def show?
    task.has_viewer?(user)
  end

  def edit?
    is_editor = task.has_editor?(user)
    currently_editable = self.instance_eval(&EDIT_POLICIES[task.task_type])
    is_editor && currently_editable
  end

  alias_method :update?, :edit?

  private

  alias_method :task, :record

  def project
    task.project
  end
end
