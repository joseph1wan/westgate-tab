class CreateCreditors < ActiveRecord::Migration[7.0]
  def change
    create_table :creditors do |t|
      t.string :name, null: false
      t.integer :basic_drinks, null: false, default: 0
      t.integer :specialty_drinks, null: false, default: 0

      t.timestamps
    end
  end
end
