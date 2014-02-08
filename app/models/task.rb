class Task < ActiveRecord::Base
  TYPES = %w(hypothesis literature_review method results analysis conclusions)

  belongs_to :project
  belongs_to :last_updater, class_name: 'User'

  validates :task_type, inclusion: { in: TYPES }
  validates :content, presence: true, allow_blank: true
  validates :project_id, presence: true
  validates :last_updater_id, presence: true
end
