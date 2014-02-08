class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :aasm_state, null: false
      t.string :name, null: false
      t.references :owner, null: false, index: true
      t.references :last_updater, null: false, index: true

      t.timestamps
    end
  end
end
