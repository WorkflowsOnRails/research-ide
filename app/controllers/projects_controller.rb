class ProjectsController < ApplicationController

  def index
    @active_projects = Project.active_for(current_user)
    @inactive_projects = Project.inactive_for(current_user)

    [@active_projects, @inactive_projects].each do |projects|
      ActiveRecord::Associations::Preloader.new(projects, :last_updater).run
    end
  end

  def show
    @project = find_project
    authorize @project
    redirect_to task_path(@project.current_task)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    @project.last_updater = current_user
    authorize @project
    @project.save
    respond_with @project
  end

  def edit
    @project = find_project
    authorize @project
    @participants = @project
      .participants
      .order(:full_name)
      .map { |u| Participant.new(@project, u) }
  end

  def update
    @project = find_project
    authorize @project
    @project.update(project_params)
    @project.last_updater = current_user
    respond_with @project, location: edit_project_path(@project)
  end

  def destroy
    @project = find_project
    authorize @project
    @project.destroy
    respond_with @project
  end

  def enter_state
    @project = find_project
    authorize @project

    next_state = params[:state].to_sym

    begin
      @project.enter_state(next_state)
    rescue AASM::InvalidTransition
      flash[:error] = "You cannot go to #{next_state} from current state!"
    end

    redirect_to task_path(@project.current_task)
  end

  # TODO: Explain why these are not in their own controller.
  def add_participant
    project = find_project
    authorize project
    email = params[:email]
    participant = User.find_by(email: email)

    if participant.nil?
      flash[:error] = "There is no user with the email \"#{email}\""
    elsif project.add_participant participant
      flash[:notice] = "User #{email} was added successfully"
    else
      flash[:error] = "\"#{email}\" is already a project participant"
    end

    redirect_to edit_project_path(project)
  end

  def update_participant
    project = find_project
    participant = find_participant_by_user_id
    authorize project

    roles = project.roles_for(participant).index_by(&:name)

    Role.transaction do
      params[:roles].each do |k, v|
        roles[k].value = v
        roles[k].save!
      end
    end

    flash[:notice] = "User #{participant.email} was updated successfully"
    redirect_to edit_project_path(project)
  end

  def destroy_participant
    project = find_project
    participant = find_participant_by_user_id
    authorize project

    project.remove_participant participant

    flash[:notice] = "User #{participant.email} was removed successfully"
    redirect_to edit_project_path(project)
  end

  private

  def find_project
    Project.find(params[:id])
  end

  def find_participant_by_user_id
    User.find(params[:user_id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
