# Controller for individual task pages associated with a project. Refer
# to the Task model to find out more about the design of the application.
#
# @author Brendan MacDonell
class TasksController < ApplicationController
  def show
    @task = find_task
    @attachments = @task.attachments.order(:file_file_name).includes(:uploader)
    authorize @task
  end

  def edit
    @task = find_task
    authorize @task
  end

  def update
    @task = find_task
    authorize @task
    @task.update(task_params)
    respond_with @task
  end

  def preview
    @content = params[:content]
    render layout: false
  end

  private

  def find_task
    Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content)
  end
end
