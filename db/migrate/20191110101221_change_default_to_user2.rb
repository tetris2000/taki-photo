class ChangeDefaultToUser2 < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :icon_photo, from: "/icon/default.jpg", to: "image/upload/v1573380465/default.jpg"
  end
end
