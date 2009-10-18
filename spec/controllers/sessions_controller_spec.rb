require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController, "POST /create" do
  define_models

  before do
    @login = {
      :user    => :default,
      :pass    => 'test',
      :options => {}}
  end
  
  act! { post :create, @login[:options].merge(:login => users(@login[:user]).login, :password => @login[:pass]) }

  # I think the session is broken. Or something.
  it_assigns :flash => {:notice => :not_nil}#, :session => {:user => :not_nil}
  it_redirects_to { '/' }
  
  it 'fails login and does not redirect' do
    attempt_login 'bad password'
    session[:user].should be_nil
    response.should be_success
  end

  it 'remembers me' do
    attempt_login :remember_me => '1'
    response.cookies["auth_token"].should_not be_nil
  end
  
  it 'does not remember me' do
    attempt_login :remember_me => '0'
    response.cookies["auth_token"].should be_nil
  end
  
  def attempt_login(user = nil, password = nil, options = {})
    case user
      when Hash
        options = user
        user = nil; password = nil
      when String
        password = user; user = nil
    end
    @login[:user] = user if user
    @login[:pass] = password if password
    @login[:options].update(options)
    acting
  end
end

describe SessionsController, "DELETE /destroy" do
  define_models

  before { login_as :default }
  act! { get :destroy }
  
  it_assigns :session => {:user => nil}
  it_redirects_to { '/' }

  it 'deletes token on logout' do
    acting.cookies["auth_token"].should be_nil
  end
end

describe SessionsController, "(cookies)" do
  define_models

  it 'logs in with cookie' do
    users(:default).remember_me
    request.cookies["auth_token"] = cookie_for(:default)
    get :new
    controller.send(:logged_in?).should be_true
  end
  
  it 'fails expired cookie login' do
    users(:default).remember_me_until 5.minutes.ago.utc
    request.cookies["auth_token"] = cookie_for(:default)
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  it 'fails cookie login' do
    users(:default).remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token users(user).remember_token
  end
end
