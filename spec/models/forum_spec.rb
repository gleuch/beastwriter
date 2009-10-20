require File.dirname(__FILE__) + '/../spec_helper'
require 'model_stubbing'

describe Forum do
  define_models do
    model ForumThread do
      stub :sticky, :sticky => 1, :last_updated_at => current_time - 132.days
    end
  end

  it "formats description html" do
    f = Forum.new :description => 'bar'
    f.description_html.should be_nil
    f.send :format_attributes
    f.description_html.should == '<p>bar</p>'
  end
  
  it "lists threads with sticky threads first" do
    forums(:default).threads.should == [threads(:sticky), threads(:other), threads(:default)]
  end
  
  it "lists posts by created_at" do
    forums(:default).posts.should == [posts(:default), posts(:other)]
  end
  
  it "finds most recent post" do
    forums(:default).recent_post.should == posts(:default)
  end
  
  it "finds most recent thread" do
    forums(:default).recent_thread.should == threads(:other)
  end
  
  it "finds ordered forums" do
    Forum.ordered.should == [forums(:other), forums(:default)]
  end
end