class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include PingbackHelper
  include Haml

  helper :all # include all helpers, all the time
  helper :pingback

  before_filter :set_language
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  layout "public/public"


  def set_title(title); @title = title; end

  def month_name_from_number(num); Date::MONTHNAMES[num.to_i] if num; end

  # raised in #current_site
  # rescue_from Site::UndefinedError do |e|
  #   redirect_to new_site_path
  # end

  def current_page; @page ||= params[:page].blank? ? 1 : params[:page].to_i; end
  helper_method :current_page


private

  def set_language; I18n.locale = :en || I18n.default_locale; end

end
