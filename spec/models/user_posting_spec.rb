require File.dirname(__FILE__) + '/../spec_helper'

module ForumThreadCreateForumPostHelper
  def self.included(base)
    base.define_models
    
    base.before do
      @user  = users(:default)
      @attributes = {:body => 'booya', :title => 'foo'}
      @creating_thread = lambda { post! }
    end
  
    base.it "sets thread's last_updated_at" do
      @thread = post!
      @thread.should_not be_new_record
      @thread.reload.last_updated_at.should == @thread.posts.first.created_at
    end
  
    base.it "sets thread's last_user_id" do
      @thread = post!
      @thread.should_not be_new_record
      @thread.reload.last_user.should == @thread.posts.first.user
    end

    base.it "increments ForumThread.count" do
      @creating_thread.should change { ForumThread.count }.by(1)
    end
    
    base.it "increments ForumPost.count" do
      @creating_thread.should change { ForumPost.count }.by(1)
    end
    
    base.it "increments cached site forum_threads_count" do
      @creating_thread.should change { sites(:default).reload.forum_threads_count }.by(1)
    end
    
    base.it "increments cached forum forum_threads_count" do
      @creating_thread.should change { forums(:default).reload.forum_threads_count }.by(1)
    end
    
    base.it "increments cached site forum_posts_count" do
      @creating_thread.should change { sites(:default).reload.forum_posts_count }.by(1)
    end
    
    base.it "increments cached forum forum_posts_count" do
      @creating_thread.should change { forums(:default).reload.forum_posts_count }.by(1)
    end
    
    base.it "increments cached user forum_posts_count" do
      @creating_thread.should change { users(:default).reload.forum_posts_count }.by(1)
    end
  end

  def post!
    @user.post forums(:default), new_thread(:default, @attributes).attributes.merge(:body => @attributes[:body])
  end
end

describe User, "#post for users" do  
  include ForumThreadCreateForumPostHelper
  
  it "ignores sticky bit" do
    @attributes[:sticky] = 1
    @thread = post!
    @thread.should_not be_sticky
  end
  
  it "ignores locked bit" do
    @attributes[:locked] = true
    @thread = post!
    @thread.should_not be_locked
  end
end

describe User, "#post for moderators" do
  include ForumThreadCreateForumPostHelper
  
  before do
    @user.stub!(:moderator_of?).and_return(true)
  end
  
  it "sets sticky bit" do
    @attributes[:sticky] = 1
    @thread = post!
    @thread.should be_sticky
  end
  
  it "sets locked bit" do
    @attributes[:locked] = true
    @thread = post!
    @thread.should be_locked
  end
end

describe User, "#post for admins" do
  include ForumThreadCreateForumPostHelper
  
  before do
    @user.admin = true
  end
  
  it "sets sticky bit" do
    @attributes[:sticky] = 1
    @thread = post!
    @thread.should_not be_new_record
    @thread.should be_sticky
  end
  
  it "sets locked bit" do
    @attributes[:locked] = true
    @thread = post!
    @thread.should_not be_new_record
    @thread.should be_locked
  end
end

module ForumThreadUpdateForumPostHelper
  def self.included(base)
    base.define_models
    
    base.before do
      @user  = users(:default)
      @thread = threads(:default)
      @attributes = {:body => 'booya'}
    end
  end
  
  def revise!
    @user.revise @thread, @attributes
  end
end

describe User, "#revise(thread) for users" do  
  include ForumThreadUpdateForumPostHelper
  
  it "ignores sticky bit" do
    @attributes[:sticky] = 1
    revise!
    @thread.should_not be_sticky
  end
  
  it "ignores locked bit" do
    @attributes[:locked] = true
    revise!
    @thread.should_not be_locked
  end
end

describe User, "#revise(thread) for moderators" do
  include ForumThreadUpdateForumPostHelper
  
  before do
    @user.stub!(:moderator_of?).and_return(true)
  end
  
  it "sets sticky bit" do
    @attributes[:sticky] = 1
    revise!
    @thread.should be_sticky
  end
  
  it "sets locked bit" do
    @attributes[:locked] = true
    revise!
    @thread.should be_locked
  end
end

describe User, "#revise(thread) for admins" do
  include ForumThreadUpdateForumPostHelper
  
  before do
    @user.admin = true
  end
  
  it "sets sticky bit" do
    @attributes[:sticky] = 1
    revise!
    @thread.should be_sticky
  end
  
  it "sets locked bit" do
    @attributes[:locked] = true
    revise!
    @thread.should be_locked
  end
end

describe User, "#reply" do
  define_models
  
  before do
    @user  = users(:default)
    @thread = threads(:default)
    @creating_post = lambda { post! }
  end
  
  it "doesn't post if thread is locked" do
    @thread.locked = true; @thread.save
    @post = post!
    @post.should be_new_record
  end

  it "sets thread's last_updated_at" do
    @post = post!
    @thread.reload.last_updated_at.should == @post.created_at
  end

  it "sets thread's last_user_id" do
    ForumThread.update_all 'last_user_id = 3'
    @post = post!
    @thread.reload.last_user.should == @post.user
  end
  
  it "increments ForumPost.count" do
    @creating_post.should change { ForumPost.count }.by(1)
  end
  
  it "increments cached thread forum_posts_count" do
    @creating_post.should change { threads(:default).reload.forum_posts_count }.by(1)
  end
  
  it "increments cached forum forum_posts_count" do
    @creating_post.should change { forums(:default).reload.forum_posts_count }.by(1)
  end
  
  it "increments cached site forum_posts_count" do
    @creating_post.should change { sites(:default).reload.forum_posts_count }.by(1)
  end
  
  it "increments cached user forum_posts_count" do
    @creating_post.should change { users(:default).reload.forum_posts_count }.by(1)
  end

  def post!
    @user.reply threads(:default), 'duane, i think you might be color blind.'
  end
end