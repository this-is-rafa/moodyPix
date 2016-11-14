class AddShade2AndShade3AndTint1AndTint2AndTint3ToColors < ActiveRecord::Migration[5.0]
  def change
  	add_column :colors, :shade2, :string
  	add_column :colors, :shade3, :string
  	add_column :colors, :tint1, :string
  	add_column :colors, :tint2, :string
  	add_column :colors, :tint3, :string
  end
end
