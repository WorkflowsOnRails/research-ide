# @author Alexander Clelland

require 'test_helper'

class CreateProjectTest < ActiveSupport::TestCase
  include TestHelper
  include TestHelper::Users

  test "create/delete project test" do
    login_user
    create_project
    assert page.has_content?('Project was successfully created.')
    delete_project
    assert page.has_content?('Project was successfully destroyed. ')
  end

  test "update project name test" do
    login_user
    create_project

    new_name = Random.alphanumeric
    click_on 'Manage Project'
    fill_in 'project_name', with: new_name
    click_on 'Update Name'
    assert page.has_content?('Project was successfully updated. ')
    click_on 'Delete' #manually delete because of new name, already on manage page
  end

  test "hypothesis test" do
    login_user    
    create_project

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Literature Review'
    click_on 'Hypothesis'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Method'
    click_on 'Hypothesis'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Results'
    click_on 'Hypothesis'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Analysis'
    click_on 'Hypothesis'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Conclusions'
    click_on 'Hypothesis'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Completed'
    click_on 'Hypothesis'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "literature_review test" do
    login_user    
    create_project
    click_on 'Literature Review'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Method'
    click_on 'Literature Review'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Results'
    click_on 'Literature Review'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Analysis'
    click_on 'Literature Review'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Conclusions'
    click_on 'Literature Review'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Completed'
    click_on 'Literature Review'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "method test" do
    login_user    
    create_project
    click_on 'Literature Review'
    click_on 'Method'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Results'
    click_on 'Method'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Analysis'
    click_on 'Method'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Conclusions'
    click_on 'Method'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Completed'
    click_on 'Method'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "results test" do
    login_user    
    create_project
    click_on 'Literature Review'
    click_on 'Method'
    click_on 'Results'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Analysis'
    click_on 'Results'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Conclusions'
    click_on 'Results'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    click_on 'Completed'
    click_on 'Results'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "analysis test" do
    login_user    
    create_project
    click_on 'Literature Review'
    click_on 'Method'
    click_on 'Results'
    click_on 'Analysis'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Conclusions'
    click_on 'Analysis'
    assert has_link?("edit")
    assert has_link?("upload")

    click_on 'Completed'
    click_on 'Analysis'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "conclusions test" do
    login_user    
    create_project
    click_on 'Literature Review'
    click_on 'Method'
    click_on 'Results'
    click_on 'Analysis'
    click_on 'Conclusions'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    #advance to each state and assert that the edit and attach buttons are working as intended
    click_on 'Completed'
    click_on 'Conclusions'
    assert has_no_link?("edit")
    assert has_no_link?("upload")

    delete_project
  end

  test "completed test" do
    login_user    
    create_project
    click_on 'Literature Review'
    click_on 'Method'
    click_on 'Results'
    click_on 'Analysis'
    click_on 'Conclusions'
    click_on 'Completed'

    #add attachment
    attach_file('task-attachments-upload-field', File.join(Rails.root, "/test/integration/project_test.rb"))
    find("#new_attachment").submit_form!
    assert page.has_content?("project_test.rb was successfully uploaded")

    #delete attachment
    click_on 'delete'
    assert page.has_content?("project_test.rb was deleted")

    #edit -> preview -> save
    edit_text = Random.alphanumeric
    click_on 'edit'
    fill_in 'task-body-edit-field', with: edit_text
    click_on 'preview'
    assert page.has_content?(edit_text)
    click_on 'Save'
    assert page.has_content?(edit_text)

    delete_project
  end

  private
  
  def create_project
    @project_name = Random.alphanumeric #store project name for asserts
    visit '/'
    click_on 'New Project'
    fill_in 'project_name', with: @project_name
    click_on 'Create Project'    
  end

  def delete_project
    visit '/'
    click_on "#{@project_name}"
    click_on 'Manage Project'
    click_on 'Delete'
  end
end
