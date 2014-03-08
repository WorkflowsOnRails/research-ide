# Model representing uploaded files and other attachments. Each Attachment
# must be associated with the user who uploaded it, and the task it is
# attached to.
#
# @author Brendan MacDonell
class Attachment < ActiveRecord::Base
  has_attached_file :file
  belongs_to :task, inverse_of: :attachments
  belongs_to :uploader, class_name: 'User'

  validates :file, attachment_presence: true
  validates :file_file_name, uniqueness: { scope: :task_id }
  validate :file_name_cannot_be_reserved

  after_save { |attachment| attachment.task.touch! }

  RESERVED_FILENAMES = [
    TaskMarkdownResource::FILENAME,
    TaskLatexResource::FILENAME,
  ].map(&:downcase)

  def file_name_cannot_be_reserved
    if RESERVED_FILENAMES.include?(file_file_name.downcase)
      errors.add(:file_file_name, "#{file_file_name} is a reserved filename")
    end
  end
end
