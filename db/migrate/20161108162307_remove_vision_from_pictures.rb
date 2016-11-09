class RemoveVisionFromPictures < ActiveRecord::Migration[5.0]
  def change
  	remove_column :pictures, :vision
  	remove_column :pictures, :labeldescriptions
  	remove_column :pictures, :labelscores
  	remove_column :pictures, :colorRGBs
  	remove_column :pictures, :colorScores
  	remove_column :pictures, :detectedText
  	remove_column :pictures, :joy
  	remove_column :pictures, :sorrow
  	remove_column :pictures, :anger
  	remove_column :pictures, :surprise
  end
end
