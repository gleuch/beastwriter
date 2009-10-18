class Admin::ApplicationController < ApplicationController

  layout "admin/admin"
  before_filter :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && password == "password"
    end
  end
  
end