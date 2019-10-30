class AddPrefectureToPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :prefecture, foreign_key: true
  end
end
