class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    project.owned_by? user
  end

  def create?
    true
  end

  def edit?
    project.owned_by? user
  end

  alias_method :destroy?, :edit?
  alias_method :add_participant?, :edit?
  alias_method :update_participant?, :edit?
  alias_method :destroy_participant?, :edit?

  private

  alias_method :project, :record
end
