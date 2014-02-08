class ProjectPolicy < ApplicationPolicy
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

  private

  alias_method :project, :record
end
