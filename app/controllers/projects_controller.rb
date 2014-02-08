class ProjectsController < ApplicationController
  def show
    @project = find_project
    authorize @project
    redirect_to action: 'edit'

    # TODO: redirect to current task
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    authorize @project
    @project.save
    respond_with @project
  end

  def edit
    @project = find_project
  end

  def update
    @project = find_project
    authorize @project
    @project.update(project_params)
    respond_with @project
  end

  def destroy
    @project = find_project
    authorize @project
    @project.destroy
    respond_with @project
  end

  private

  def find_project
    Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
