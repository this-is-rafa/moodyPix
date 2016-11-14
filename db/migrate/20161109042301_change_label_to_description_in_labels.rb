class ChangeLabelToDescriptionInLabels < ActiveRecord::Migration[5.0]
  def change
  	rename_column :labels, :label, :description
  end
end
