# @author Brendan MacDonell
class AttachmentPolicy < ApplicationPolicy
  def create?
    attachment.task.has_editor?(user)
  end

  alias_method :destroy?, :create?

  private

  alias_method :attachment, :record
end
