class ChangeTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :shutter_speed, :float
    change_column :posts, :f_number, :float
    change_column :posts, :iso, :integer
    change_column :posts, :focal_length, :float
  end
end
