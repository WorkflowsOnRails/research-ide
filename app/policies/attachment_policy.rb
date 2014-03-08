# @author Brendan MacDonell
class AttachmentPolicy < ApplicationPolicy
  def show?
    task_policy.show?
  end

  def create?
    task_policy.edit?
  end

  alias_method :update?, :create?
  alias_method :destroy?, :create?

  private

  alias_method :attachment, :record

  def task_policy
    TaskPolicy.new(user, attachment.task)
  end
end
