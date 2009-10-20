class CreateInitialData < ActiveRecord::Migration
  def self.up
    # Create generic list of roles.
    roles = {}
    roles[:admin] = Role.create(:slug => 'admin', :name => 'Site Admin', :description => 'Site admins, given access to primary areas.')
    roles[:staff] = Role.create(:slug => 'staff', :name => 'Staff Member', :description => 'Staff members, just for decoration.')
    roles[:editor] = Role.create(:slug => 'blog_editor', :name => 'Blog Editor', :description => 'Blog editors can create, edit, delete blog entries, categories, and tags')
    roles[:moderator] = Role.create(:slug => 'forum_moderator', :name => 'Forum Moderator', :description => 'Forum moderators can create, edit, delete, and ban forum threads, posts, and users.')
    roles[:manager] = Role.create(:slug => 'users_manager', :name => 'Users Manager', :description => 'User managers can edit and delete/ban users.')
    
    # Create admin user and assign roles.
    user = User.create(:display_name => 'Admin', :login => 'admin', :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
    roles.each{|k,v| user.roles << v}
    user.save # Just in case...

    forum = Forum.create(:name => 'My First Forum') rescue nil
    # thread = ForumThread.create(:title => 'My First Thread', :user => user, :forum => forum) rescue nil
    # post = ForumPost.create(:forum => forum, :forum_thread => thread, :user => user, :body => 'This is a post.', :body_html => '<p>This is a post.</p>') rescue nil
  end

  def self.down
    # No way, friend.
  end
end
