# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include PingbackHelper
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_page
  before_filter :set_language
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]

  layout "public/public"

  helper :pingback

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def set_title(title)
    @title = title
  end

  def month_name_from_number(num)
    if num
      Date::MONTHNAMES[num.to_i]
    end
  end

  # raised in #current_site
  rescue_from Site::UndefinedError do |e|
    redirect_to new_site_path
  end
  
  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end


private

  def set_language
    I18n.locale = :en || I18n.default_locale
  end

end
