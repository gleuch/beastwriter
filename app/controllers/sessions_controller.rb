# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    reset_session
    params[:login] = sanitized_login_name(params[:login])
    self.current_user = current_site.users.authenticate(params[:login], params[:password])
    
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me
        cookies[:auth_token] = { :value => current_user.remember_token , :expires => current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = I18n.t 'txt.successful_login', :default => "Logged in successfully"
    else
      flash[:error] = I18n.t 'txt.invalid_login', :default => "Invalid login"
      redirect_back_or_default(login_path)
    end
  end

  def destroy
    current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = I18n.t 'txt.logged_out', :default => "You have been logged out."
    redirect_back_or_default('/')
  end
end
