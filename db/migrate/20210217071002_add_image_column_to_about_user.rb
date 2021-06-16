class AddImageColumnToAboutUser < ActiveRecord::Migration
  def up
    add_attachment :about_users, :image 
  end

  def down
    remove_attachment :about_users, :image
  end
end
