class CreateResumeSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :resume_skills do |t|
      t.references :resume, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      
      t.timestamps
    end
    
    add_index :resume_skills, [:resume_id, :skill_id], unique: true
  end
end
