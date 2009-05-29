# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "public/public"

  include PingbackHelper
  helper :pingback

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_title(title)
    @title = title
  end

  def month_name_from_number(num)
    if num
      Date::MONTHNAMES[num.to_i]
    end
  end

end
