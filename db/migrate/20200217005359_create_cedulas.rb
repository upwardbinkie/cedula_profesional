class CreateCedulas < ActiveRecord::Migration[5.2]
  def change
    create_table :cedulas do |t|
      t.string :cedula_number
      t.string :cedula_type
      t.string :name
      t.string :last_name_1
      t.string :last_name_2
      t.boolean :gender
      t.string :title
      t.string :institution
      t.integer :year

      t.timestamps
    end
  end
end
