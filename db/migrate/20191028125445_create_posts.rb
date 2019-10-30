class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :photo
      t.string :explanation
      t.string :waterfall
      
      # Exif data
      t.datetime :taken_at
      t.string :shutter_speed
      t.string :f_number
      t.string :iso
      t.string :focal_length
      t.string :camera
      t.boolean :use_exif

      t.timestamps
    end
  end
end
