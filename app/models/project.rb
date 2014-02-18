class Project < ActiveRecord::Base
  include AASM

  ROLE = Enum.new(:NONE, :VIEWER, :EDITOR)

  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'
  has_many :tasks, dependent: :destroy

  has_many :tasks
  has_and_belongs_to_many :participants, class_name: 'User'

  # Though this would be logically modelled by an after_enter callback, the
  # project will not have been saved when that callback is called, and so the
  # task can't be attached to the project as it lacks an ID. Unfortunately,
  # there's no after_commit for initial states either, so we need to use an
  # ActiveRecord hook to create the initial task instead.
  after_create :create_hypothesis

  aasm do
    state :writing_hypothesis, initial: true
    state :writing_literature_review, after_enter: :create_literature_review
    state :describing_method
    state :gathering_data
    state :analyzing_results
    state :drawing_conclusions
    state :completed

    event :begin_literature_review do
      transitions from: :writing_hypothesis,
                  to: :writing_literature_review
    end

    event :begin_method_definition do
      transitions from: :writing_literature_review,
                  to: :describing_method
    end

    event :begin_experiment do
      transitions from: :describing_method,
                  to: :gathering_data
    end

    event :begin_analysis do
      transitions from: :gathering_data,
                  to: :analyzing_results
    end

    event :begin_concluding do
      transitions from: :analyzing_results,
                  to: :drawing_conclusions
    end

    event :finish_project do
      transitions from: :drawing_conclusions,
                  to: :completed
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

  private

  def create_hypothesis
    Task.create(task_type: Task::TYPE.HYPOTHESIS,
                project: self,
                last_updater: self.owner,
                content: "")
  end

  def create_literature_review
    Task.create(task_type: Task::TYPE.LIT_REVIEW,
                project: self,
                last_updater_id: owner_id,
                content: "")
  end

end
