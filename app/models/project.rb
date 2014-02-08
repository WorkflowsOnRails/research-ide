class Project < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'

  include AASM

  aasm do
    state :writing_hypothesis, initial: true
  end

  def owned_by?(user)
    owner_id == user.id
  end
end
