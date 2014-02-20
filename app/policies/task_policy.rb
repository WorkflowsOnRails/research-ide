# @author Brendan MacDonell
class TaskPolicy < ApplicationPolicy
  def show?
    task.has_viewer?(user)
  end

  def edit?
    task.has_editor?(user)
  end

  alias_method :update?, :edit?

  private

  alias_method :task, :record
end
