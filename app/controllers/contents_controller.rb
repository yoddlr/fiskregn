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
        @locations = Location.all - @content.locations
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
          tag_list = value['tag_list']
        end
      end
      @content = Content.find(params[:id])
      # (Re)assign tags to content
      @content.tag_list = tag_list
      # Set current user as tagger in the context tags
      current_user.tag(@content, :with => tag_list, :on => 'tags')
      @content.save
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
end