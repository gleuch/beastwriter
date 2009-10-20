require File.dirname(__FILE__) + '/../spec_helper'

module ForumPostsControllerParentObjects
  def self.included(base)
    base.define_models
    base.before do
      login_as :default
      @user  = users(:default)
      @post  = posts(:default)
      @forum = forums(:default)
      @thread = threads(:default)
    end
  endthread
end

describe ForumPostsController, "GET #index" do
  include ForumPostsControllerParentObjects

  act! { get :index, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :user => nil, :q => 'foo', :page => 5 }
  
  it_assigns :posts, :forum, :thread, :parent => lambda { @thread }
  it_renders :template, :index

  describe ForumPostsController, "(xml)" do
    define_models
    
    act! { get :index, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :user => nil, :q => 'foo', :page => 5, :format => 'xml' }

    it_assigns :posts, :forum, :thread, :parent => lambda { @thread }
    it_renders :xml
  end

  describe ForumPostsController, "(atom)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :user => nil, :q => 'foo', :page => 5, :format => 'atom' }

    it_assigns :posts, :forum, :thread, :parent => lambda { @thread }
    it_renders :template, :index, :format => :atom
  end
end

describe ForumPostsController, "GET #index (for forums)" do
  include ForumPostsControllerParentObjects

  act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo' }

  it_assigns :posts, :forum, :thread => nil, :user => nil, :parent => lambda { @forum }
  it_renders :template, :index

  describe ForumPostsController, "(atom)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo', :format => 'atom' }
    
    it_assigns :posts, :forum, :thread => nil, :user => nil, :parent => lambda { @forum }
    it_renders :template, :index, :format => "atom"
  end

  describe ForumPostsController, "(xml)" do
    define_models
    
    act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :forum, :thread => nil, :user => nil, :parent => lambda { @forum }
    it_renders :xml
  end
end

describe ForumPostsController, "GET #index (for users)" do
  include ForumPostsControllerParentObjects

  act! { get :index, :user_id => @user.to_param, :q => 'foo', :page => 5 }

  it_assigns :posts, :user, :forum => nil, :thread => nil, :parent => lambda { @user }
  it_renders :template, :index

  describe ForumPostsController, "(xml)" do
    define_models
    
    act! { get :index, :user_id => @user.to_param, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :user, :forum => nil, :thread => nil, :parent => lambda { @user }
    it_renders :xml
  end
end

describe ForumPostsController, "GET #index (globally)" do
  include ForumPostsControllerParentObjects

  act! { get :index, :page => 5, :q => 'foo' }

  it_assigns :posts, :user => nil, :forum => nil, :thread => nil, :parent => nil
  it_renders :template, :index
  
  describe ForumPostsController, "(xml)" do
    define_models
    
    act! { get :index, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :user => nil, :forum => nil, :thread => nil, :parent => nil
    it_renders :xml
  end

  describe ForumPostsController, "(atom)" do
    define_models
    
    act! { get :index, :page => 5, :q => 'foo', :format => 'atom' }

    it_assigns :posts, :user => nil, :forum => nil, :thread => nil, :parent => nil
    it_renders :template, :index, :format => 'atom'
  end
end

describe ForumPostsController, "GET #show" do
  include ForumPostsControllerParentObjects
  define_models

  act! { get :show, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param }
  
  it_assigns :forum, :thread, :parent => lambda { @thread }, :post => nil
  it_redirects_to { forum_thread_path(@forum, @thread) }
  
  describe ForumPostsController, "(xml)" do
    define_models
    
    it_assigns :post, :forum, :thread, :parent => lambda { @thread }

    act! { get :show, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :format => 'xml' }

    it_renders :xml, :post
  end
end

describe ForumPostsController, "GET #edit" do
  include ForumPostsControllerParentObjects
  act! { get :edit, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param }

  it_assigns :post, :forum, :thread, :parent => lambda { @thread }
  it_renders :template, :edit
end

describe ForumPostsController, "POST #create" do
  include ForumPostsControllerParentObjects

  before do
    @post = nil
  end

  describe ForumPostsController, "(successful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :post => {:body => 'foo'} }

    it_assigns :post, :forum, :thread, :parent => lambda { @thread }, :flash => { :notice => :not_nil }
    it_redirects_to { forum_thread_post_path(@forum, @thread, assigns(:post), :anchor => "post_#{assigns(:post).id}") }
  end

  describe ForumPostsController, "(unsuccessful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :post => {:body => ''} }

    it_assigns :post, :forum, :thread, :parent => lambda { @thread }
    it_redirects_to { forum_thread_url(@forum, @thread) }
  end
  
  describe ForumPostsController, "(successful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :post => {:body => 'foo'}, :format => 'xml' }

    it_assigns :post, :forum, :thread, :parent => lambda { @thread }, :headers => { :Location => lambda { forum_thread_post_url(@forum, @thread, assigns(:post)) } }
    it_renders :xml, :status => :created
  end
  
  describe ForumPostsController, "(unsuccessful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :post => {:body => ''}, :format => 'xml' }

    it_assigns :post, :forum, :thread, :parent => lambda { @thread }
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe ForumPostsController, "PUT #update" do
  include ForumPostsControllerParentObjects
  
  describe ForumPostsController, "(successful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :post => {} }
    
    it_assigns :post, :forum, :thread, :parent => lambda { @thread }, :flash => { :notice => :not_nil }
    it_redirects_to { forum_thread_path(@forum, @thread, :anchor => "post_#{@post.id}") }
  end

  describe ForumPostsController, "(unsuccessful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :post => {:body => ''} }

    it_assigns :post, :forum, :thread, :parent => lambda { @thread }
    it_renders :template, :edit
  end
  
  describe ForumPostsController, "(successful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :post => {}, :format => 'xml' }

    it_assigns :post, :forum, :thread
    it_renders :blank
  end
  
  describe ForumPostsController, "(unsuccessful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :post => {:body => ''}, :format => 'xml' }
    
    it_assigns :post, :forum, :thread, :parent => lambda { @thread }
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe ForumPostsController, "DELETE #destroy" do
  include ForumPostsControllerParentObjects
  act! { delete :destroy, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param }

  it_assigns :post, :forum, :thread, :parent => lambda { @thread }
  it_redirects_to { forum_thread_path(@forum, @thread) }
  
  describe ForumPostsController, "(xml)" do
    define_models
    act! { delete :destroy, :forum_id => @forum.to_param, :forum_thread_id => @thread.to_param, :id => @post.to_param, :format => 'xml' }

    it_assigns :post
    it_renders :blank
  end
end
