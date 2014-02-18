class Project < ActiveRecord::Base
  include AASM

  ROLE = Enum.new(:NONE, :VIEWER, :EDITOR)

  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'
  has_many :tasks, dependent: :destroy

  has_many :tasks
  has_and_belongs_to_many :participants, class_name: 'User'

  aasm do
    state :writing_hypothesis, initial: true, after_enter: :create_hypothesis
    state :writing_literature_review, after_enter: :create_literature_review
    state :describe_method
    state :performing_experiment
    state :analyze_results
    state :drawing_conclusions

    event :writing_literature_review do
      transitions from: :writing_hypothesis,
                  to: :writing_literature_review
    end

    event :describe_method do
      transitions from: :writing_literature_review,
                  to: :describe_method
    end

    event :performing_experiment do
      transitions from: :describe_method,
                  to: :performing_experiment
    end

    event :analyze_results do
      transitions from: :performing_experiment,
                  to: :analyze_results
    end

    event :drawing_conclusions do
      transitions from: :analyze_results,
                  to: :drawing_conclusions
    end

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

  def create_hypothesis
    Task.new(task_type: Task::TYPES[0], project_id: id, last_updater_id: owner_id, content: "").save
  end

  def create_literature_review
    Task.new(task_type: Task::TYPES[1], project_id: id, last_updater_id: owner_id, content: "").save
  end

end
