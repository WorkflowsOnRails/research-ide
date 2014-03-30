ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'capybara/dsl'
require 'capybara/rails'


SimpleCov.start


class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end


module TestHelper
  ActiveRecord::Migration.check_pending!

  extend ActiveSupport::Concern
  include Capybara::DSL

  included do
    setup :setup_database
  end

  def setup_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def refresh_page
    visit current_url
  end

  class Capybara::Driver::Node
    def submit_form!
      raise NotImplementedError
    end
  end

  class Capybara::RackTest::Node
    def submit_form!
      Capybara::RackTest::Form.new(driver, self.native).submit({})
    end
  end

  class Capybara::Node::Element
    def submit_form!
      base.submit_form!
    end
  end

  module Users
    extend ActiveSupport::Concern

    included do
      setup :setup_users
    end

    def setup_users
      # Keep track of the attributes so that we have access to the password
      @user_attrs = attributes_for(:user)
      @user = User.create(@user_attrs)
    end

    def login_user
      login_with_attrs @user_attrs
    end

    def logout
      click_on 'logout'
    end

    private

    def login_with_attrs attrs
      visit '/'
      within 'form#new_user' do
        fill_in 'Email', with: attrs[:email]
        fill_in 'Password', with: attrs[:password]
        click_on 'Sign in'
      end
    end
  end
end
