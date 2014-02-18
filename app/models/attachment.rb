# Model representing uploaded files and other attachments. Each Attachment
# must be associated with the user who uploaded it, and the task it is
# attached to.
#
# @author Brendan MacDonell
class Attachment < ActiveRecord::Base
  has_attached_file :file
  belongs_to :task
  belongs_to :uploader, class_name: 'User'

  validates :file, attachment_presence: true
end
