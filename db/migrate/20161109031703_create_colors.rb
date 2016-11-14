class CreateColors < ActiveRecord::Migration[5.0]
  def change
    create_table :colors do |t|
      t.string :rgb
      t.float :score
      t.references :picture, foreign_key: true
    end
  end
end
