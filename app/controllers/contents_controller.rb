class ContentsController < ApplicationController
  
  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def new
    # Is there an attempted target location?
    if params[:location]
      # Attempted target location, defaulting to current user's location
      @location_id = params[:location] || current_user.location.id
      if current_user
        @content = Content.new
        @content.parent_id = params[:parent_id] if params[:parent_id]
      else
        # Back to attempted target location if not signed in
        redirect_to user_path(User.find(Location.find(@location_id).user_id)), notice: I18n.t('.must_be_signed_in_to_create_contents')
      end
    else
      # Unforeseen nirvana: Calling new_content_path without location
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_create_contents')
    end
  end
  
  def create
    # Psychopathically changing param name from location to location_id :-|
    if params[:location_id]
      # Attempted target location, defaulting to current user's location
      @location_id = params[:location_id] || current_user.location.id
      if current_user
        @content = Content.new(params[:content])
        @content.user = current_user
        @content.add_location(Location.find(@location_id))
        # @content.parent = Content.find(params[:content][:parent_id]) if params[:content][:parent_id]
        if @content.save
          if @content.parent
            # Saving content as a reply
            redirect_to content_path(@content.parent), notice: I18n.t('.content_saved')
          else
            redirect_to user_path(Location.find(@location_id).user_id), notice: I18n.t('.content_saved')
          end
        else
          render_template :new, alert: I18n.t('.content_not_saved')
        end
      else
        redirect_to home_index_path, notice: I18n.t('.content_not_saved')
        # render_template :new, alert: I18n.t('.content_not_saved')
      end
    else
      # Unforeseen nirvana: Calling create_content_path without location
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_create_contents')
    end
  end
  
  def edit
    if user_signed_in?
      @content = Content.find(params[:id])
      render  :new
    else
      redirect_to root_url, notice: I18n.t('.must_be_signed_in_to_create_contents')
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