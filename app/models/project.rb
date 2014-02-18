class Project < ActiveRecord::Base
  include AASM

  ROLE = Enum.new(:NONE, :VIEWER, :EDITOR)

  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'

  has_many :tasks
  has_and_belongs_to_many :participants, class_name: 'User'

  aasm do
    state :writing_hypothesis, initial: true
  end

  validates :name, presence: true, allow_blank: false
  validates :owner_id, presence: true
  validates :last_updater_id, presence: true

  def owned_by?(user)
    owner_id == user.id
  end

  def has_participant?(user)
    is_owner = user.id == owner_id
    is_member = participants.where(id: user.id).exists?
    is_owner or is_member
  end

  def roles_for(user)
    Role.where(resource: self, user: user)
  end

  def create_tasks_for(user)
    transaction do
      Task::TYPE.values.each do |task_type|
        Task.create(project: self,
                    last_updater: user,
                    task_type: task_type,
                    content: '')
      end
    end
  end

  def add_participant(user)
    transaction do
      return false if self.has_participant? user

      self.participants << user

      Task::TYPE.values.each do |task_type|
        Role.create(resource: self,
                    user: user,
                    name: task_type,
                    value: ROLE.NONE)
      end
    end

    true
  end

  def remove_participant(user)
    transaction do
      self.participants.destroy(user)
      self.roles_for(user).destroy_all
    end
  end
end
