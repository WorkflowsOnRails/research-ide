# @author Brendan MacDonell
class TaskPolicy < ApplicationPolicy
  def show?
    project.owned_by?(user) || task.has_viewer?(user)
  end

  def edit?
    project.owned_by?(user) || task.has_editor?(user)
  end

  alias_method :update?, :edit?

  private

  alias_method :task, :record

  def project
    task.project
  end
end
