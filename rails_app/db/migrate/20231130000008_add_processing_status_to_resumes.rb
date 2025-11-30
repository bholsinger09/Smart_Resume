class AddProcessingStatusToResumes < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :processing_status, :string, default: 'pending'
    add_column :resumes, :processing_error, :text
  end
end
