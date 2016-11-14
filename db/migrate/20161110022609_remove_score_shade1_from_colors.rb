class RemoveScoreShade1FromColors < ActiveRecord::Migration[5.0]
  def change
  	remove_column :colors, :score_shade1, :float
  end
end
