class AddUniqueIndexToAttachmentFilename < ActiveRecord::Migration
  def change
    add_index :attachments, [:task_id, :file_file_name], unique: true
  end
end
