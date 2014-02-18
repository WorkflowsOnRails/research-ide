class Task < ActiveRecord::Base
  TYPE = Enum.new(:HYPOTHESIS, :LIT_REVIEW, :METHOD, :RESULTS,
                  :ANALYSIS, :CONCLUSIONS)

  belongs_to :project
  belongs_to :last_updater, class_name: 'User'
  has_many :attachments, dependent: :destroy

  validates :task_type, inclusion: { in: TYPE.values }
  validates :content, presence: true, allow_blank: true
  validates :project_id, presence: true
  validates :last_updater_id, presence: true
end
