# Controller to handle uploading and deleting attachments. As these
# actions are only triggered from the tasks view, it presents validation
# errors and using flash messages.
#
# @author Brendan MacDonell
class AttachmentsController < ApplicationController
  def create
    task = Task.find(params[:task_id])
    attachment = Attachment.new(attachment_params)
    attachment.task = task
    attachment.uploader = current_user
    authorize attachment

    if attachment.save
      file_name = attachment.file_file_name
      flash[:notice] = "#{file_name} was successfully uploaded"
    else
      # TODO: Use this style of rendering validation errors everywhere,
      #       if we have time.
      message = render_to_string partial: 'errors/flash', locals: {
        summary: 'The attachment could not be uploaded',
        errors: attachment.errors.full_messages,
      }
      flash[:error] = message.html_safe
    end

    redirect_to task_path(task)
  end

  def destroy
    attachment = Attachment.find(params[:id])
    authorize attachment
    task = attachment.task #get the task so it can render the correct page when deleted
    file_name = attachment.file_file_name #to store name for the flash display later
    attachment.destroy

    flash[:notice] = "#{file_name} was deleted"
    redirect_to task_path(task)
  end

  private

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
