class AddDetectedTextToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :detectedText, :text
  end
end
