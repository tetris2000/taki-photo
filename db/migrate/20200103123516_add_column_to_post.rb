class AddColumnToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :taken_at_year, :integer
    add_column :posts, :taken_at_month, :integer
  end
end
