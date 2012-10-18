class ContentsController < ApplicationController
  
  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def new
    redirect_to root_url unless user_signed_in?
    @content = Content.new
    @content.parent_id = params[:parent_id]if params[:parent_id]
    # @content.add_location(Location.find(params[:location])) if params[:location]
    @location_id = params[:location] || current_user.location.id
    ALog.debug @location_id
  end
  
  def create
    ALog.debug params
    if current_user
      @content = Content.new(params[:content]) 
      @content.user = current_user
      @content.add_location(Location.find(params[:location_id])) if params[:location_id].length > 0 
      # @content.parent = Content.find(params[:content][:parent_id]) if params[:content][:parent_id]
      if @content.save
        if @content.parent
          redirect_to content_path(@content.parent), notice: I18n.t('.content_saved')
        else
        redirect_to user_path(current_user), notice: I18n.t('.content_saved')
        end
      else
        render_template :new, alert: I18n.t('.content_not_saved')
      end
    else
      ALog.debug 'no current_user'
      redirect_to home_index_path, notice: I18n.t('.content_not_saved')
      # render_template :new, alert: I18n.t('.content_not_saved')
    end
  end
  
  def edit
    if user_signed_in?
      @content = Content.find(params[:id])
      render  :new
    else
      redirect_to root_url
    end
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
  
  def destroy
    @content = Content.find(params[:id])
    if @content.destroy
      redirect_to root_url, notice: I18n.t('.content_deleted')
    else
      redirect_to show_content_path(@content), notice: I18n.t('.content_not_deleted')
    end
  end
  
  def record_not_found
    redirect_to root_url, alert: I18n.t('.content_not_found') + " content id: #{params[:id]}"
  end
end