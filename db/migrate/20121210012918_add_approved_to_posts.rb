class AddApprovedToPosts < ActiveRecord::Migration
  def change
    change_column :posts, :approved, :boolean, :default => false

  end
end
