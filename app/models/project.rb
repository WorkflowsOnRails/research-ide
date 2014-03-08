class Project < ActiveRecord::Base
  include AASM
  include AasmProgressable::ModelMixin

  belongs_to :owner, class_name: 'User'
  belongs_to :last_updater, class_name: 'User'
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :participants, class_name: 'User'

  # Though this would be logically modelled by an after_enter callback, the
  # project will not have been saved when that callback is called, and so the
  # task can't be attached to the project as it lacks an ID. Unfortunately,
  # there's no after_commit for initial states either, so we need to use an
  # ActiveRecord hook to create the initial task instead.
  after_create :create_task_for_new_state

  aasm do
    state :writing_hypothesis, initial: true
    state :writing_literature_review, after_enter: :create_task_for_new_state
    state :describing_method, after_enter: :create_task_for_new_state
    state :gathering_data, after_enter: :create_task_for_new_state
    state :analyzing_results, after_enter: :create_task_for_new_state
    state :drawing_conclusions, after_enter: :create_task_for_new_state
    state :completed, after_enter: :create_task_for_new_state

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

  aasm_state_order [:writing_hypothesis, :writing_literature_review, :describing_method, 
                    :gathering_data, :analyzing_results, :drawing_conclusions, :completed]

  validates :name, presence: true, allow_blank: false
  validates :owner_id, presence: true
  validates :last_updater_id, presence: true

  def current_task
    Task.for_project_state(self)
  end

  def existing_tasks
    self.tasks.index_by(&:task_type)
  end

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

  def add_participant(user)
    transaction do
      return false if self.has_participant? user

      self.participants << user
      Task.create_roles_for_project(self, user)
    end

    true
  end

  def remove_participant(user)
    transaction do
      self.participants.destroy(user)
      self.roles_for(user).destroy_all
    end
  end

  # Utility function to map from a target state to an event triggering entry
  # to the target state. This is somewhat unusual for a workflow, but users
  # interact with the system by advancing it to a specific next state, instead
  # of performing a "next" action (as this could lead to races advancing the
  # state several times.)
  def enter_state(next_state)
    # Find all events transitioning from the current state to the target state.
    current_state = self.aasm.current_state
    events = self.class.aasm.events.values.select do |event|
      event.transitions.any? { |t| t.from == current_state && t.to == next_state }
    end

    if events.empty?
      current_state = self.aasm.current_state
      raise AASM::InvalidTransition,
            "No transition found from #{current_state} to #{next_state}"
    end

    self.send("#{events.first.name}!")
  end

  private

  def create_task_for_new_state
    Task.create_for_project_state(self, self.owner)
  end
end
