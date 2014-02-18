class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.attachment :file
      t.references :task, null: false, index: true
      t.references :uploader, null: false, index: true

      t.timestamps
    end
  end
end
