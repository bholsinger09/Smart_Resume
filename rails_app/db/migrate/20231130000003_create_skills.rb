class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :name, null: false
      t.string :category
      t.text :description
      
      t.timestamps
    end
    
    add_index :skills, :name, unique: true
    add_index :skills, :category
  end
end
