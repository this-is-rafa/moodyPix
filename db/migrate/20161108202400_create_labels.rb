class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.string :label1
      t.string :label2
      t.string :label3
      t.string :label4
      t.string :label5
      t.string :label6
      t.string :label7
      t.string :label8
      t.string :label9
      t.string :label10
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
