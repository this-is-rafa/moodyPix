class AddJoyAndSorrowAndAngerAndSurpriseToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :joy, :string
    add_column :pictures, :sorrow, :string
    add_column :pictures, :anger, :string
    add_column :pictures, :surprise, :string
  end
end
