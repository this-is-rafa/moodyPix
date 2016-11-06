class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.references :picture, foreign_key: true

      t.timestamps
    end
  end
end
