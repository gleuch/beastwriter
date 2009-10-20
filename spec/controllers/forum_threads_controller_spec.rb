require File.dirname(__FILE__) + '/../spec_helper'

describe ForumThreadsController, "GET #index" do
  define_models

  act! { get :index, :forum_id => @forum.to_param }

  before do
    @forum  = forums(:default)
  end

  it_assigns :forum, :threads => nil
  it_redirects_to { forum_path(@forum) }

  describe ForumThreadsController, "(xml)" do
    define_models
    
    act! { get :index, :forum_id => @forum.to_param, :page => 5, :format => 'xml' }

    it_assigns :threads, :forum
    it_renders :xml
  end
end

describe ForumThreadsController, "GET #show" do
  define_models

  act! { get :show, :forum_id => @forum.to_param, :id => @thread.to_param, :page => 5 }

  before do
    @forum  = forums(:default)
    @thread  = threads(:default)
  end
  
  it_assigns :thread, :forum, :posts, :session => {:threads => nil}
  it_renders :template, :show
  
  it "should render atom feed" do
    pending "no atom support yet"
  end
  
  it "increments thread hit count" do
    stub_thread!
    @thread.should_receive(:hit!)
    act!
  end
  
  it "assigns new post record" do
    act!
    assigns[:post].should be_new_record
  end
  
  describe ForumThreadsController, "(logged in)" do
    define_models

    act! { get :show, :forum_id => @forum.to_param, :id => @thread.to_param, :page => 5 }
  
    before do
      login_as :default
    end

    it_assigns :thread, :forum, :session => {:threads => :not_nil}
  
    it "increments thread hit count" do
      stub_thread!
      @thread.user_id = 5
      @thread.should_receive(:hit!)
      act!
    end
  
    it "doesn't increment thread hit count for same user" do
      stub_thread!
      @thread.stub!(:hit!).and_return { raise "Noooooo" }
      act!
    end
    
    it "marks User#last_seen_at" do
      @controller.stub!(:current_user).and_return(@user)
      @user.should_receive(:seen!)
      act!
    end
  end
  
  describe ForumThreadsController, "(xml)" do
    define_models
    
    act! { get :show, :forum_id => @forum.to_param, :id => @thread.to_param, :format => 'xml' }

    it_assigns :thread, :post => nil, :posts => nil

    it_renders :xml, :thread
  end

protected
  def stub_thread!
    Forum.stub!(:find_by_permalink).with(@forum.to_param).and_return(@forum)
    @forum.stub!(:threads).and_return([])
    @forum.threads.should_receive(:find_by_permalink).with(@thread.to_param).and_return(@thread)
  end
end

describe ForumThreadsController, "GET #new" do
  define_models
  act! { get :new, :forum_id => @forum.to_param }
  before do
    login_as :default
    @forum  = forums(:default)
  end

  it_assigns :forum, :thread

  it "assigns @thread" do
    act!
    assigns[:thread].should be_new_record
  end
  
  it_renders :template, :new
  
  describe ForumThreadsController, "(xml)" do
    define_models
    act! { get :new, :forum_id => @forum.to_param, :format => 'xml' }

    it_assigns :forum, :thread

    it_renders :xml
  end
end

describe ForumThreadsController, "GET #edit" do
  define_models
  act! { get :edit, :forum_id => @forum.to_param, :id => @thread.to_param }
  
  before do
    login_as :default
    @forum  = forums(:default)
    @thread  = threads(:default)
  end

  it_assigns :thread, :forum
  it_renders :template, :edit
end

describe ForumThreadsController, "POST #create" do
  before do
    login_as :default
    @forum  = forums(:default)
  end
  
  describe ForumThreadsController, "(successful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :thread => {:title => 'foo', :body => 'bar'} }
    
    it_assigns :forum, :thread, :flash => { :notice => :not_nil }
    it_redirects_to { forum_thread_path(@forum, assigns(:thread)) }
  end

  describe ForumThreadsController, "(unsuccessful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :thread => @attributes }

    before do
      @attributes = {:title => ''}
    end

    it_assigns :forum, :thread
    it_renders :template, :new
  end
  
  describe ForumThreadsController, "(successful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :thread => {:title => 'foo', :body => 'bar'}, :format => 'xml' }
    
    it_assigns :forum, :thread, :headers => { :Location => lambda { forum_thread_url(@forum, assigns(:thread)) } }
    it_renders :xml, :status => :created
  end
  
  describe ForumThreadsController, "(unsuccessful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :thread => {}, :format => 'xml' }

    it_assigns :forum, :thread
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe ForumThreadsController, "PUT #update" do
  before do
    login_as :default
    @forum = forums(:default)
    @thread = threads(:default)
  end
  
  describe ForumThreadsController, "(successful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :id => @thread.to_param, :thread => {} }
    
    it_assigns :forum, :thread, :flash => { :notice => :not_nil }
    it_redirects_to { forum_thread_path(@forum, @thread) }
  end

  describe ForumThreadsController, "(unsuccessful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :id => @thread.to_param, :thread => @attributes }

    before do
      @attributes = {:title => ''}
      @thread.update_attributes @attributes
    end
    
    it_assigns :thread, :forum
    it_renders :template, :edit
  end
  
  describe ForumThreadsController, "(successful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :id => @thread.to_param, :thread => {}, :format => 'xml' }
    
    it_assigns :thread, :forum
    it_renders :blank
  end
  
  describe ForumThreadsController, "(unsuccessful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :id => @thread.to_param, :thread => @attributes, :format => 'xml' }

    before do
      @attributes = {:title => ''}
      @thread.update_attributes @attributes
    end
    
    it_assigns :thread, :forum
    it_renders :xml, "thread.errors", :status => :unprocessable_entity
  end
end

describe ForumThreadsController, "DELETE #destroy" do
  define_models
  act! { delete :destroy, :forum_id => @forum.to_param, :id => @thread.to_param }
  
  before do
    login_as :default
    @forum = forums(:default)
    @thread = threads(:default)
  end

  it_assigns :thread, :forum
  it_redirects_to { forum_path(@forum) }
  
  describe ForumThreadsController, "(xml)" do
    define_models
    act! { delete :destroy, :forum_id => @forum.to_param, :id => @thread.to_param, :format => 'xml' }

    it_assigns :thread, :forum
    it_renders :blank
  end
end
