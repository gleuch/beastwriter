class ForumPostsSweeper < ActionController::Caching::Sweeper
  observe ForumPost
  
  def after_save(post)
    FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'forums', post.forum_id.to_s, 'posts.rss')
    FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'forums', post.forum_id.to_s, 'threads', "#{post.forum_thread_id}.rss")
    FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'users')
    FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'posts.rss')
  end
  
  alias_method :after_destroy, :after_save
end