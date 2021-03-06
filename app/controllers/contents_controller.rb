class ContentsController < ApplicationController

  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def edit
    if user_signed_in?
      @content = Content.find(params[:id])
      render :new
    else
      redirect_to root_url, notice: I18n.t('.must_be_signed_in_to_create_contents')
    end
  end

  def publish
    if current_user
      @content = Content.find(params[:id])
      if params[:contents]
        # Second time around - having selected location in contents publication form
        @content.publish_to_location(Location.find(params[:contents][:location]))
        redirect_to content_path(@content), notice: I18n.t('.content_published')
      else
        # First time around
        # Enable publication of this content to locations
        @locations = Location.all # - @content.locations
        @action = 'publish'
      end
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_modify_contents')
    end
  end

  def withdraw
    if current_user
      @content = Content.find(params[:id])
      if params[:contents]
        # Second time around - having selected location in contents publication form
        @content.withdraw_from_location(Location.find(params[:contents][:location]))
        redirect_to content_path(@content), notice: I18n.t('.content_withdrawn')
      else
        # First time around
        # Enable withdrawal from locations having published this content
        @locations = @content.locations
        @action = 'withdraw'
        # Same template to select publisher both for publication and withdrawal
        render :action => 'publish'
      end
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_modify_contents')
    end
  end
  
  def show
    @content = Content.find(params[:id])
  end

  def tag
    if current_user
      @content = Content.find(params[:id])
      # Default tags are the ones that are or are not already there
      tag_list = @content.tag_list
      params.values.each do |value|
        if value.kind_of?(Hash) && value.keys
          # Tag list embedded with hash key 'tag_list' somewhere in params
          tag_list << value['tag_strings']
        end
      end
      @content = Content.find(params[:id])
      # Set current user as tagger in the context interests
      current_user.tag(@content, :with => tag_list, :on => 'interest')
      render :action => 'show'
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_modify_contents')
    end
  end

  # Remove tags. Currently (5.11-12) as checked in tag_content partial. Actually the tag itself remains - only the
  # the (tagging) relation between taggable and tag is removed.
  def untag
    if current_user
      @content = Content.find(params[:id])
      if params[:tag]
        params[:tag][:remove].each do |tag_name|
          tag_id = ActsAsTaggableOn::Tag.find_by_name(tag_name).id
          tagging = ActsAsTaggableOn::Tagging.find_by_tag_id(tag_id)
          tagging.destroy if tagging.taggable_id == @content.id && tagging.taggable_type == 'Content' && tagging.context == 'interest'
        end
      end
      render :action => 'show'
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_modify_contents')
    end
  end
  
  def destroy
    if current_user
      @content = Content.find(params[:id])

      if @content.children.empty?
        @content.destroy
        redirect_to root_url, notice: I18n.t('.content_deleted')
      else
        redirect_to content_path(@content), notice: I18n.t('.content_not_deleted')
      end
    else
      redirect_to root_path, notice: I18n.t('.must_be_signed_in_to_delete_contents')
    end
  end
  
  def record_not_found
    redirect_to root_url, alert: I18n.t('.content_not_found') + " content id: #{params[:id]}"
  end

  def grant_find_access
    @content = Content.find(params[:id])
    accessor = User.find_by_email(params[:grant_find_access])
    # Set submitted user as tagger in the context access
    accessor.tag(@content, :with => ['find'], :on => 'access')
    redirect_to @content
  end

  def revoke_find_access
    @content = Content.find(params[:id])
    redirect_to @content
  end
  
  def grant_read_access
    @content = Content.find(params[:id])
    accessor = User.find_by_email(params[:grant_read_access])
    # Set submitted user as tagger in the context access
    accessor.tag(@content, :with => ['find','read'], :on => 'access')
    redirect_to @content
  end

  def revoke_read_access
    @content = Content.find(params[:id])
    redirect_to @content
  end
  
  def unpublished
    @user = current_user
    # @contents = @user.contents - content_location.where(:content => @user.contents)
    # @contents = @user.contents.exists(locations)
    # @contents = Content.excludes(:locations).where( :locations => {:location_id => nil})
    # @contents = @user.contents.where(locations: empty?)
    # select * from contents inner join content_location as cl on cl.content_id!=content.id
    @contents = @user.contents.where('id NOT IN (SELECT DISTINCT(content_id) FROM contents_locations)')
  end
end
