class ContentsController < ApplicationController
  
  def new
    @content = Content.new
  end
  
  def create
    
    @content = Content.new(data: params[:content][:data], user_id: current_user.id)
    if @content.save
      redirect_to user_path(current_user), notice: I18n.t('.content_saved')
    else
      render_template :new, alert: I18n.t('.content_not_saved')
    end
  end
end
