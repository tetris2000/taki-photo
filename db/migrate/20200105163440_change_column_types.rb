class ChangeColumnTypes < ActiveRecord::Migration[5.2]
  def up
    if Rails.env.development? || Rails.env.test?
      change_column :posts, :shutter_speed, :float
      change_column :posts, :f_number, :float
      change_column :posts, :iso, :integer
      change_column :posts, :focal_length, :float
    else Rails.env.production?
      change_column :posts, :shutter_speed, 'float USING CAST(shutter_speed AS float)'
      change_column :posts, :f_number, 'float USING CAST(f_number AS float)'
      change_column :posts, :iso, 'integer USING CAST(iso AS integer)'
      change_column :posts, :focal_length, 'float USING CAST(focal_length AS float)'
    end
  end
  
  def down
    change_column :posts, :shutter_speed, :string
    change_column :posts, :f_number, :string
    change_column :posts, :iso, :string
    change_column :posts, :focal_length, :string
  end
end