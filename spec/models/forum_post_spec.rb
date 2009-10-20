require File.dirname(__FILE__) + '/../spec_helper'

describe ForumPost do
  define_models
  
  it "finds thread" do
    posts(:default).thread.should == threads(:default)
  end
  
  it "requires body" do
    p = new_post(:default)
    p.body = nil
    p.should_not be_valid
    p.errors.on(:body).should_not be_nil
  end

  it "formats body html" do
    p = ForumPost.new :body => 'bar'
    p.body_html.should be_nil
    p.send :format_attributes
    p.body_html.should == '<p>bar</p>'
  end
end

describe ForumPost, "being deleted" do
  define_models do
    model ForumPost do
      stub :second, :body => 'second', :created_at => current_time - 6.days
    end
  end
  
  before do
    @deleting_post = lambda { posts(:default).destroy }
  end

  it "decrements cached forum forum_posts_count" do
    @deleting_post.should change { forums(:default).reload.forum_posts_count }.by(-1)
  end
  
  it "decrements cached site forum_posts_count" do
    @deleting_post.should change { sites(:default).reload.forum_posts_count }.by(-1)
  end
  
  it "decrements cached user forum_posts_count" do
    @deleting_post.should change { users(:default).reload.forum_posts_count }.by(-1)
  end

  it "fixes last_user_id" do
    threads(:default).last_user_id = 1; threads(:default).save
    posts(:default).destroy
    threads(:default).reload.last_user.should == users(:default)
  end
  
  it "fixes last_updated_at" do
    posts(:default).destroy
    threads(:default).reload.last_updated_at.should == posts(:second).created_at
  end
  
  it "fixes #last_post" do
    threads(:default).recent_post.should == posts(:default)
    posts(:default).destroy
    threads(:default).recent_post(true).should == posts(:second)
  end
end

describe ForumPost, "being deleted as sole post in thread" do
  define_models
  
  it "clears thread" do
    posts(:default).destroy
    lambda { threads(:default).reload }.should raise_error(ActiveRecord::RecordNotFound)
  end
end

describe ForumPost, "#editable_by?" do
  before do
    @user  = mock_model User
    @post  = ForumPost.new :forum => @forum
    @forum = mock_model Forum, :user_id => @user.id
  end

  it "restricts user for other post" do
    @user.should_receive(:moderator_of?).and_return(false)
    @post.should_not be_editable_by(@user)
  end

  it "allows user" do
    @post.user_id = @user.id
    @user.should_receive(:moderator_of?).and_return(false)
    @post.should be_editable_by(@user)
  end
  
  it "allows admin" do
    @user.should_receive(:moderator_of?).and_return(true)
    @post.should be_editable_by(@user)
  end
  
  it "restricts moderator for other forum" do
    @post.should_receive(:forum).and_return @forum
    @user.should_receive(:moderator_of?).with(@forum).and_return(false)
    @post.should_not be_editable_by(@user)
  end
  
  it "allows moderator" do
    @post.should_receive(:forum).and_return @forum
    @user.should_receive(:moderator_of?).with(@forum).and_return(true)
    @post.should be_editable_by(@user)
  end
end