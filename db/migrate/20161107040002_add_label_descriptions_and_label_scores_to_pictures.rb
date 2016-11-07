class AddLabelDescriptionsAndLabelScoresToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :labeldescriptions, :text, array:true, default: []
    add_column :pictures, :labelscores, :float, array:true, default: []
  end
end
