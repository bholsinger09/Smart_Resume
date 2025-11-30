class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :resume, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.decimal :score, precision: 5, scale: 2, null: false
      t.json :matched_skills, default: []
      t.json :missing_skills, default: []
      t.text :recommendations
      
      t.timestamps
    end
    
    add_index :matches, [:resume_id, :job_id], unique: true
    add_index :matches, :score
  end
end
