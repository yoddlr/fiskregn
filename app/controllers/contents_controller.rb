class ContentsController < ApplicationController
  
  def new
    redirect_to root_url unless user_signed_in?
    @content = Content.new
  end
  
  def create
    if current_user
      @content = Content.new(data: params[:content][:data], user_id: current_user.id)
      if @content.save
        redirect_to user_path(current_user), notice: I18n.t('.content_saved')
      else
        render_template :new, alert: I18n.t('.content_not_saved')
      end
    else
      redirect_to home_index_path, notice: I18n.t('.content_not_saved')
      # render_template :new, alert: I18n.t('.content_not_saved')
    end
  end
  
  def edit
    redirect_to root_url unless user_signed_in?
    @content = Content.find(params[:id])
    render :new
  end
  
  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      redirect_to root_url, notice: I18n.t('.content_updated')
    else
      render action: "edit", notice: I18n.t('.content_not_updated')
    end
  end
  
  def show
    @content = Content.find(params[:id])
  end
end
