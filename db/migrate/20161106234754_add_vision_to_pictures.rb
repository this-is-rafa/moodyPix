class AddVisionToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :vision, :json
  end
end
