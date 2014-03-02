# @author Brendan MacDonell
class AttachmentPolicy < ApplicationPolicy
  def create?
    TaskPolicy.new(user, attachment.task).edit?
  end

  alias_method :destroy?, :create?

  private

  alias_method :attachment, :record
end
