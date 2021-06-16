class AboutUsersController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @user.create_about_user(about_user_params)
    redirect_to user_path(@user)
  end

  def edit
    @user = User.find(params[:user_id])
    @about_user = @user.about_user
  end

  def update
    @user = User.find(params[:user_id])
        
    if @user.about_user.update_attributes(about_user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private 
    def about_user_params
      params.require(:about_user).permit(:name, :description, :is_alumni, :image)
    end
end
