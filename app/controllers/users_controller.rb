class UsersController < ApplicationController  
  
  def show
    # what the user shows to other users and guest
    @user = User.find(params[:id])
    @contents = @user.contents
  end
  
  def home
    @contents = current_user.contents
  end
end
