class AddColorRgBsAndColorScoresToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :colorRGBs, :text, array:true, default: []
    add_column :pictures, :colorScores, :float, array:true, default: []
  end
end
