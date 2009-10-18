require 'test_helper'

class PostTest < ActiveSupport::TestCase

  test "should not save post without title" do
    post = Post.new
    post.content = "Blah blah content"
    post.permalink = "blah-blah-permalink"
    assert !post.save, "Saved the post without a title"
  end

  test "should not save post without content" do
    post = Post.new
    post.title = "Blah blah title"
    post.permalink = "blah-blah-permalink"
    assert !post.save, "Saved the post without content"
  end

  test "should not save post without permalink" do
    post = Post.new
    post.title = "Blah blah title"
    post.content = "Blah blah content"
    post.save
    assert_not_nil post.permalink, "Saved the post without a permalink"
  end

  test "should not allow duplicate title" do
    post = Post.new
    post.title = "My First Post"
    assert !post.save
  end

  test "should not allow duplicate permalink" do
    post = Post.new
    post.permalink = "my-first-post"
    assert !post.save
  end

end
