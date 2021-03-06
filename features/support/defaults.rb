module Default
  
  module Users
    # An account to be created
    def new_account
      @new_account ||= build :user
    end

    # The default account to use for account actions
    def my_account
      @my_account ||= create :user
    end
  
    # Default account for not signed in user
    def guest
      @guest ||= User.new
    end
  
    # Default account for content not owned by active user
    def other_account
      @other_account ||= create :user
    end
  end

  module TextContents
    def new_text_content
      @new_text_content ||= build :text_content
    end
    
    def new_text
      @text ||= Faker::Lorem.sentences(sentence_count = 3, supplemental = false)
    end

    # TODO: Remove? You can't create content without an owner
    def text_content
      @text_content ||= create :text_content
    end

    def text_reply(parent = text_parent)
      @text_reply ||= create :text_content, parent: parent
    end

    def text_parent
      @text_parent ||= create :text_content
      text_content.parent ||= @text_parent
    end

    def my_text_content
      @my_text_content ||= create :text_content, user: my_account
    end

    def other_text_content
      @other_text_content ||= create :text_content, user: other_account
    end
  end

  module Groups
    def my_admin_group
      @my_admin_group ||= create :group, admins: [my_account], members: [my_account]
    end

    def my_group
      @my_group ||= create :group, admins: [other_account], members: [my_account]
    end
  end
end
