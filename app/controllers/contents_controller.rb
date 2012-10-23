class ContentsController < ApplicationController
  
  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def new
    # Must be signed in to create contents
    if current_user
      # Attempted target location, defaulting to current user's location
      @location_id = params[:location] || current_user.location.id
      @content = Content.new
      @content.parent_id = params[:parent_id] if params[:parent_id]
      @content.add_location(Location.find(@location_id))
    elsif params[:location]
      # Back to attempted target location if not signed in
      redirect_to user_path(User.find(Location.find(params[:location]).user_id)), notice: I18n.t('.must_be_signed_in_to_create_contents')
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_create_contents')
    end
  end
  
  def create
    if current_user
      # Attempted target location, defaulting to current user's location
      # Psychopathically changing param name from location to location_id :-|
      @location_id = params[:location_id] || current_user.location.id
      @content = Content.new(params[:content])
      @content.user = current_user
      @content.add_location(Location.find(@location_id))
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

  def publish
    @content = Content.find(params[:id])
    if params[:contents]
      # Second time around - having selected location in contents post form
      @content.add_location(Location.find(params[:contents][:location]))
      redirect_to content_path(@content), notice: I18n.t('.content_published')
    else
      # First time around
      # Enable post to all not already having this content
      @locations = Location.all - @content.locations
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