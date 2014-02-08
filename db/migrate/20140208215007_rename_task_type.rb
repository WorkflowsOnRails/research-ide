class RenameTaskType < ActiveRecord::Migration
  def change
    remove_index :tasks, [:project_id, :type]
    rename_column :tasks, :type, :task_type
    add_index :tasks, [:project_id, :task_type], unique: true
  end
end
