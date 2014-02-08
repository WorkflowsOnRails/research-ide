class Project < ActiveRecord::Base
  include AASM

  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'

  aasm do
    state :writing_hypothesis, initial: true
  end

  validates :name, presence: true, allow_blank: false
  validates :owner_id, presence: true
  validates :last_updater_id, presence: true

  def owned_by?(user)
    owner_id == user.id
  end
end
