class Task < ActiveRecord::Base
  TYPE = Enum.new(*(Project.aasm.states.map(&:name)))
  ROLE = Enum.new(:NONE, :VIEWER, :EDITOR)

  belongs_to :project
  belongs_to :last_updater, class_name: 'User'
  has_many :attachments, inverse_of: :task, dependent: :destroy

  validates :task_type, inclusion: { in: TYPE.values }
  validates :content, presence: true, allow_blank: true
  validates :project_id, presence: true
  validates :last_updater_id, presence: true

  after_save { |task| task.project.touch! }

  def has_editor?(user)
    project.owned_by?(user) || has_role?(user, ROLE.EDITOR)
  end

  def has_viewer?(user)
    project.owned_by?(user) || has_role?(user, [ROLE.EDITOR, ROLE.VIEWER])
  end

  # Clear the cached LaTeX content so that it will be regenerated when
  # the cached LaTeX is next accessed.
  def content=(new_content)
    self.cached_latex_content = nil
    super(new_content)
  end

  def latex_content
    if cached_latex_content.nil?
      as_latex = Kramdown::Document.new(content).to_latex
      self.cached_latex_content = as_latex
      self.save!
    end

    cached_latex_content
  end

  # Update the updated_at field in a way that triggers after_save callbacks.
  def touch!
    self.updated_at = Time.now
    self.save!
  end

  def self.create_for_project_state(project, user)
    self.create!(task_type: project.aasm.current_state.to_s,
                 project: project,
                 last_updater: user,
                 content: '')
  end

  def self.for_project_state(project)
    project.tasks.find_by(task_type: project.aasm.current_state.to_s)
  end

  def self.create_roles_for_project(project, user)
    Task::TYPE.values.each do |task_type|
      Role.create(resource: project,
                  user: user,
                  name: task_type,
                  value: ROLE.NONE)
    end
  end

  private

  def has_role?(user, role)
    Role
      .where(resource: project,
             name: task_type,
             user: user,
             value: role)
      .exists?
  end
end
