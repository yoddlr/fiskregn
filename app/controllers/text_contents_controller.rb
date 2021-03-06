class TextContentsController < ContentsController

  def new
    # Must be signed in to create contents
    if current_user
      # Attempted target location, defaulting to current user's location
      # @location_id = params[:location] || current_user.location.id
      @content = TextContent.new
      @content.parent_id = params[:parent_id] if params[:parent_id]
      # @content.publish_to_location(Location.find(@location_id))
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
      # @location_id = params[:location_id] || current_user.location.id
      @content = TextContent.new(params[:text_content])
      @content.user = current_user
      # @content.publish_to_location(Location.find(@location_id))
      if @content.save
        if @content.parent
          # Saving content as a reply
          redirect_to content_path(@content.parent), notice: I18n.t('.content_saved')
        else
          # redirect_to user_path(Location.find(@location_id).user_id), notice: I18n.t('.content_saved')
          redirect_to user_path(current_user), notice: I18n.t('.content_saved')
        end
      else
        render_template :new, alert: I18n.t('.content_not_saved')
      end
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_create_contents')
    end
  end

  def update
    @content = Content.find(params[:id])
    if current_user && @content.user == current_user
      if @content.update_attributes(params[:text_content])
        redirect_to root_url, notice: I18n.t('.content_updated')
      else
        render action: "edit", notice: I18n.t('.content_not_updated')
      end
    elsif current_user
      # signed in user does not own content
      redirect_to root_path, notice: I18n.t('.only_owner_allowed_to_modify_contents')      
    else
      # not signed in
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_modify_contents')
    end
  end

  def destroy
    @content = Content.find(params[:id])
    if current_user && @content.user == current_user
      if @content.children.empty?
        super
      else
        # Virtual suicide - drop all class specific data of this object, and revert type
        @content.text = nil
        @content.tag_list.clear
        @content.type = nil
        if @content.save
          redirect_to root_url, notice: I18n.t('.content_deleted')
        else
          redirect_to content_path(@content), notice: I18n.t('.content_not_deleted')
        end
      end
    elsif current_user
      # signed in user does not own content
      redirect_to root_path, notice: I18n.t('.only_owner_allowed_to_delete_contents')      
    else
      # not signed in
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_delete_contents')
    end
  end


end
