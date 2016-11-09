class CreateColors < ActiveRecord::Migration[5.0]
  def change
    create_table :colors do |t|
      t.string :rgb1
      t.string :rgb2
      t.string :rgb3
      t.string :rgb4
      t.string :rgb5
      t.string :rgb6
      t.string :rgb7
      t.string :rgb8
      t.string :rgb9
      t.string :rgb10
      t.float :score1
      t.float :score2
      t.float :score3
      t.float :score4
      t.float :score5
      t.float :score6
      t.float :score7
      t.float :score8
      t.float :score9
      t.float :score10
      t.references :picture, foreign_key: true

      t.timestamps
    end
  end
end
