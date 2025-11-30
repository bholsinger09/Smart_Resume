class CreateJobSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :job_skills do |t|
      t.references :job, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :required, default: false
      t.integer :importance, default: 1
      
      t.timestamps
    end
    
    add_index :job_skills, [:job_id, :skill_id], unique: true
  end
end
