# TODO: Pull more hard-coded view logic into this class.
#
# @author Brendan MacDonell
class Participant
  class Role
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper

    extend Forwardable
    def_delegators :@role, :name, :value

    def initialize(role)
      @role = role
    end

    def field_name
      "roles[#{self.name}]"
    end

    def field_label
      I18n.t("task_type.#{self.name}")
    end

    def custom_label_tag(**options)
      label_tag field_name, field_label, **options
    end

    def custom_select_tag(**html_options)
      role_options = Task::ROLE.values.map do |role_type|
        [I18n.t("task_role.#{role_type}"), role_type]
      end

      select 'roles', self.name, role_options,
             { selected: self.value, include_blank: false },
             html_options
    end
  end

  extend Forwardable
  def_delegators :@user, :id, :email, :full_name, :affiliation
  attr_reader :roles

  def initialize(project, user)
    @user = user
    @roles = project
      .roles_for(user)
      .map { |r| Role.new(r) }
      .sort_by { |r| Task::TYPE.values.index(r.name) }
  end
end
