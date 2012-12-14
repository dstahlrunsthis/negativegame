class AddDefaultValuesForLike < ActiveRecord::Migration
  def up
  	change_column :posts, :likes, :integer, :default => 0
  	change_column :posts, :dislikes, :integer, :default => 0 
  end

  def down
  	change_column :posts, :likes, :integer
  	change_column :posts, :dislikes, :integer
  end
end
