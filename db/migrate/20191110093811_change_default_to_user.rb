class ChangeDefaultToUser < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :icon_photo, from: nil, to: "/icon/default.jpg"
  end
end
