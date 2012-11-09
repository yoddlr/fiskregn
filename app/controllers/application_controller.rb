class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :set_current_user

  # Set the default language on every page load, or use url param if present.
  def set_locale
    ActiveRecord::Base.connection.uncached do
      current_locale = params[:locale] || 'en'
      # Update current locale.
      I18n.locale = current_locale
    end
  end

  # Returns current locale
  def current_locale
    # Order of importance:
    # 0. user settings
    # 1. url-param
    # 2. browser_language
    # 3. default_locale  (en)

    locale = I18n.default_locale # 3

    if cookies.has_key? :locale
      locale = cookies[:locale] # 0
    elsif params[:locale].nil? || params[:locale] == ''
      browser_language = extract_locale_from_accept_language_header

      if defined? browser_language
        locale = browser_language  # 2
      end
    else
      locale = params[:locale] # 1
    end

    locale
  end

  # Thanks: http://stackoverflow.com/questions/3742785/rails-3-devise-current-user-is-not-accessible-in-a-model
  # Make devise's current_user globally available. Static and ThreadLocal apparently...
  def set_current_user
    User.current_user = current_user
  end


  protected

  def extract_locale_from_accept_language_header
    # NOTE: There are better ways to do this,
    # please see http://guides.rubyonrails.org/i18n.html
    # for a list of gems.
    #

    # Sometimes, especially during testing in capybara, the request object is not defined,
    # creating an exception. Let's catch the exception and return nil.
    begin
      return request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    rescue
      return nil
    end
  end

  # Will add url param locale to each link.
  # Rails calls this for every call to url_for(), which is used for every link_to etc.
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"

    { :locale => I18n.locale }
  end
end