# @author Alexander Clelland

require 'test_helper'

class CreateProjectTest < ActiveSupport::TestCase
  include TestHelper
  include TestHelper::Users

  test "Test Create and Project States" do
    visit '/'
    login_user

    click_on 'New Project'
    assert page.has_content?("Create Project")

    project_name = Random.alphanumeric
    fill_in 'project_name', with: project_name
    click_on 'Create Project'
    assert page.has_content?(project_name)

    #assert can't click ahead of next stage
    assert has_no_button?("Method")

    #make an edit to the hypothesis
    hypothesis_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: hypothesis_text
    click_on 'preview'
    assert page.has_content?(hypothesis_text)
    click_on 'Save'
    assert page.has_content?(hypothesis_text)

    #go forward to literature review
    click_on 'Literature Review'

    #go back to Hypothesis and make another edit
    click_on 'Hypothesis'
    hypothesis_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: hypothesis_text
    click_on 'preview'
    assert page.has_content?(hypothesis_text)
    click_on 'Save'
    assert page.has_content?(hypothesis_text)

    #click through to results
    #cannot make changes to Hypothesis, Method
    click_on 'Method'
    click_on 'Results'

    click_on 'Hypothesis'
    assert has_no_link?("edit")
    click_on 'Method'
    assert has_no_link?("edit")

    #go to Analysis, no longer edit Results
    click_on 'Analysis'
    click_on 'Results'
    assert has_no_link?("edit")

    #go to completed, no longer edit Literature Review, Analysis, Conclusions
    click_on 'Conclusions'
    click_on 'Completed'
    click_on 'Literature Review'
    assert has_no_link?("edit")
    click_on 'Analysis'
    assert has_no_link?("edit")
    click_on 'Conclusions'
    assert has_no_link?("edit")
  end

end
