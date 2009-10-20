class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  include PingbackHelper
  include Haml

  helper :all # include all helpers, all the time
  helper :pingback

  before_filter :set_language


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  def set_title(title); @title = title; end

  def month_name_from_number(num); Date::MONTHNAMES[num.to_i] if num; end

  def current_page; @page ||= params[:page].blank? ? 1 : params[:page].to_i; end
  helper_method :current_page



  def admin?; (logged_in? && current_user.has_role?(:admin)); end
  def staff?; (logged_in? && current_user.has_role?(:staff)); end
  helper_method :admin?, :staff?

  def dev?; ENV['RAILS_ENV'] == 'development'; end
  def prod?; ENV['RAILS_ENV'] == 'production'; end
  alias :is_dev? :dev?
  helper_method :is_dev?, :dev?, :prod?


private

  def set_language; I18n.locale = :en || I18n.default_locale; end

end
