class AddLatexContentToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :cached_latex_content, :text
  end
end
