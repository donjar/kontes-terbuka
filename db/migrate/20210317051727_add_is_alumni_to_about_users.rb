class AddIsAlumniToAboutUsers < ActiveRecord::Migration
  def up
    add_column :about_users, :is_alumni, :boolean
  end

  def down
    remove_column :about_users, :is_alumni, :boolean
  end
end
