class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :company, null: false
      t.text :description, null: false
      t.text :requirements
      t.string :location
      t.string :employment_type
      t.decimal :salary_min, precision: 10, scale: 2
      t.decimal :salary_max, precision: 10, scale: 2
      t.boolean :active, default: true
      
      t.timestamps
    end
    
    add_index :jobs, :title
    add_index :jobs, :company
    add_index :jobs, :active
  end
end
