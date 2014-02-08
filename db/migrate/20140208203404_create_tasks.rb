class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :type, null: false
      t.text :content, null: false
      t.references :project, null: false, index: true
      t.references :last_updater, null: false, index: true

      t.timestamps
    end

    add_index :tasks, [:project_id, :type], unique: true
  end
end
