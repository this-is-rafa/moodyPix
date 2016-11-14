class AddShade1AndScoreShade1ToColors < ActiveRecord::Migration[5.0]
  def change
  	add_column :colors, :shade1, :string
  	add_column :colors, :score_shade1, :float
  end
end
