class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.references :user, null: false
      t.references :resource, polymorphic: true
      t.string :value
    end

    add_index :roles, :name
    add_index :roles, [:user_id, :resource_type, :resource_id, :name],
              unique: true, name: 'unique_role_name_per_user_resource_pair'
  end
end
