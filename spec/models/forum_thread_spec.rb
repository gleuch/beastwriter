require File.dirname(__FILE__) + '/../spec_helper'

describe ForumThread do
  define_models

  it "updates forum_id for posts when thread forum is changed" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    threads(:default).update_attribute :forum, forums(:other)
    posts(:default).reload.forum.should == forums(:other)
  end
  
  it "leaves other thread post #forum_ids alone when updating forum" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    threads(:default).update_attribute :forum, forums(:other)
    posts(:other).reload.forum.should == forums(:default)
  end
  
  it "doesn't update last_updated_at when updating thread" do
    current_date = threads(:default).last_updated_at
    threads(:default).last_updated_at.should == current_date
  end

  [:title, :user_id, :forum_id].each do |attr|
    it "validates presence of #{attr}" do
      t = new_thread(:default)
      t.send("#{attr}=", nil)
      t.should_not be_valid
      t.errors.on(attr).should_not be_nil
    end
  end
  
  it "selects posts" do
    threads(:default).posts.should == [posts(:default)]
  end

  it "creates unsticky thread by default" do
    t = new_thread(:default)
    t.body = 'foo'
    t.sticky = nil
    t.save!
    t.should_not be_new_record
    t.should_not be_sticky
  end
  
  it "recognizes '1' as sticky" do
    threads(:default).should_not be_sticky
    threads(:default).sticky = 1
    threads(:default).should be_sticky
  end

  it "#hit! increments hits counter" do
    lambda { threads(:default).hit! }.should change { threads(:default).reload.hits }.by(1)
  end
  
  it "should know paged? status" do
    threads(:default).forum_posts_count = 0
    threads(:default).should_not be_paged
    threads(:default).forum_posts_count = ForumPost.per_page + 5
    threads(:default).should be_paged
  end
  
  it "knows last page number based on posts count" do
    {0.0 => 1, 0.5 => 1, 1.0 => 1, 1.5 => 2}.each do |multiplier, last_page|
      threads(:default).forum_posts_count = (ForumPost.per_page.to_f * multiplier).ceil
      threads(:default).last_page.should == last_page
    end
  end
  
  it "doesn't allow new posts for locked threads" do
    @thread = threads(:default)
    @thread.locked = true ; @thread.save
    @post = @thread.user.reply @thread, 'booya'
    @post.should be_new_record
    @post.errors.on(:base).should == 'Thread is locked'
  end
end

describe ForumThread, "being deleted" do
  define_models

  before do
    @thread = threads(:default)
    @deleting_thread = lambda { @thread.destroy }
  end
  
  it "deletes posts" do
    post = posts(:default).reload
    @deleting_thread.call
    lambda { post.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "decrements ForumThread.count" do
    @deleting_thread.should change { ForumThread.count }.by(-1)
  end
  
  it "decrements ForumPost.count" do
    @deleting_thread.should change { ForumPost.count }.by(-1)
  end
  
  it "decrements cached forum forum_threads_count" do
    @deleting_thread.should change { forums(:default).reload.forum_threads_count }.by(-1)
  end
  
  it "decrements cached forum forum_posts_count" do
    @deleting_thread.should change { forums(:default).reload.forum_posts_count }.by(-1)
  end
  
  it "decrements cached site forum_threads_count" do
    @deleting_thread.should change { sites(:default).reload.forum_threads_count }.by(-1)
  end
  
  it "decrements cached site forum_posts_count" do
    @deleting_thread.should change { sites(:default).reload.forum_posts_count }.by(-1)
  end
  
  it "decrements cached user forum_posts_count" do
    @deleting_thread.should change { users(:default).reload.forum_posts_count }.by(-1)
  end
end

describe ForumThread, "being moved to another forum" do
  define_models
  
  before do
    @forum     = forums(:default)
    @new_forum = forums(:other)
    @thread     = threads(:default)
    @moving_forum = lambda { @thread.forum = @new_forum ; @thread.save! }
  end
  
  it "decrements old forums cached forum_threads_count" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @forum.reload.threads.size }.by(-1)
  end
  
  it "decrements old forums cached forum_posts_count" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @forum.reload.posts.size }.by(-1)
  end
  
  it "increments new forums cached forum_threads_count" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @new_forum.reload.threads.size }.by(1)
  end
  
  it "increments new forums cached forum_posts_count" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @new_forum.reload.posts.size }.by(1)
  end
  
  it "moves posts to new forum" do
    pending('Causing SQLite3::SQLException') if ForumThread.connection.class.name =~ /sqlite/i
    @thread.posts.each { |p| p.forum.should == @forum }
    @moving_forum.call
    @thread.posts.each { |p| p.reload.forum.should == @new_forum }
  end
end

describe ForumThread, "#editable_by?" do
  before do
    @user  = mock_model User
    @thread = ForumThread.new :forum => @forum
    @forum = mock_model(Forum)
  end

  it "restricts user for other thread" do
    @user.should_receive(:moderator_of?).and_return(false)
    @thread.should_not be_editable_by(@user)
  end

  it "allows user" do
    @thread.user_id = @user.id
    @user.should_receive(:moderator_of?).and_return(false)
    @thread.should be_editable_by(@user)
  end
  
  it "allows moderator" do
    @thread.should_receive(:forum).and_return(@forum)
    @user.should_receive(:moderator_of?).with(@forum).and_return(true)
    # @thread.forum_id = 2
    @thread.should be_editable_by(@user)
  end
end