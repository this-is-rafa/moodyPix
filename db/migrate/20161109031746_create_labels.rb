class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.string :label
      t.float :score
      t.references :picture, foreign_key: true
    end
  end
end
