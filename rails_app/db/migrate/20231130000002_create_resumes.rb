class CreateResumes < ActiveRecord::Migration[7.1]
  def change
    create_table :resumes do |t|
      t.string :filename, null: false
      t.string :content_type
      t.text :extracted_text
      t.text :summary
      t.json :extracted_skills, default: []
      t.json :entities, default: {}
      
      t.timestamps
    end
    
    add_index :resumes, :created_at
  end
end
