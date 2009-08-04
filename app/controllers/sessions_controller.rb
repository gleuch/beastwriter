# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    params[:login] = params[:login].downcase
    self.current_user = current_site.users.authenticate(params[:login], params[:password])
    
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me
        cookies[:auth_token] = { :value => current_user.remember_token , :expires => current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      if using_open_id?
        cookies[:use_open_id] = {:value => '1', :expires => 1.year.from_now.utc}
        open_id_authentication(params[:openid_url])
      else
        cookies[:use_open_id] = {:value => '0', :expires => 1.year.ago.utc}
        password_authentication params[:login], params[:password]
      end
    end
  end
  
  def create
    if using_open_id?
      cookies[:use_open_id] = {:value => '1', :expires => 1.year.from_now.utc}
      open_id_authentication(params[:openid_url])
    else
      cookies[:use_open_id] = {:value => '0', :expires => 1.year.ago.utc}
      password_authentication params[:login], params[:password]
      flash[:error] = "Invalid login"
    end
  end

  def destroy
    current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  
  def password_authentication(name, password)
    if @current_user = current_site.users.authenticate(params[:name], params[:password])
      successful_login
    else
      failed_login "Sorry, that username/password doesn't work"
   end
  end

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, openid_url, registration|
    if result.successful?
      @user = User.find_or_initialize_by_openid_url(openid_url)
      @current_user  = @user
      if @current_user
        if @user.new_record?
          @user.login = openid_url
          @user.email = registration['email']
          @user.password = 123456
          @user.site = Site.find(:first)
          @user.display_name = registration['nickname']
          @user.save(false)
        end
        successful_login
      else
        failed_login "Sorry, no user by the identity URL {openid_url} exists"[:openid_no_user_message, openid_url.inspect]
      end
    else
      failed_login result.message
    end
  end
  end


  private
  def successful_login
    flash[:notice] = 'You are now logged in! Welcome.'
    session[:user_id] = @current_user.id
    redirect_back_or_default('/')
  end

  def failed_login(message)
    flash[:error] = message
    redirect_to(new_session_url)
  end

end
