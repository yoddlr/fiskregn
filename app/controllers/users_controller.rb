class UsersController < ApplicationController  
  
  def show
    # what the user shows to other users and guest
    @user = User.find(params[:id])
    #@contents = @user.contents.tagged_with(["troll","snor"], :any => true )
    #@contents = Content.tagged_with(["troll","snor"], :any => true )
    #@contents = @user.owned_taggings
    #@contents = Content.tagged_with( ["apon", "snor"], :any => true, :owned_by => @user.id)
    @contents = @user.contents
  end
  
  def home
    #@contents = @user.contents.tagged_with(["troll","snor"], :any => true )
    #@contents = Content.tagged_with(["troll","snor"], :any => true )
    #@contents = Content.tagged_with("troll" , :owned_by => current_user)
    @contents = current_user.contents
  end
end
