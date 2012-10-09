class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @contents = @user.contents.all
  end
  
  def index
    @users = User.all
  end
end
