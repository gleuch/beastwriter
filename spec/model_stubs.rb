module ModelStubbing
  define_models do
    time 2007, 6, 15

    model User do
      stub :login => 'normal-user', :email => 'normal-user@example.com', :state => 'active',
        :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
        :created_at => current_time - 5.days, :site => all_stubs(:site), :remember_token => 'foo-bar', :remember_token_expires_at => current_time + 5.days,
        :activation_code => '8f24789ae988411ccf33ab0c30fe9106fab32e9b', :activated_at => current_time - 4.days, :forum_posts_count => 3, :permalink => 'normal-user'
    
      stub :activated, :login => 'activated-user', :email => 'activated-user@example.com', :state => 'active',
        :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
        :created_at => current_time - 5.days, :site => all_stubs(:site), :remember_token => 'foo-bar-activated', :remember_token_expires_at => current_time + 5.days,
        :activation_code => nil, :activated_at => current_time - 4.days, :forum_posts_count => 3, :permalink => 'activated-user'
    end
  
    model Forum do
      stub :name => "Default", :forum_threads_count => 2, :forum_posts_count => 2, :position => 1, :state => 'public', :permalink => 'default'
      stub :other, :name => "Other", :forum_threads_count => 1, :forum_posts_count => 1, :position => 0, :permalink => 'other'
    end
  
    model ForumThread do
      stub :forum => all_stubs(:forum), :user => all_stubs(:user), :title => "initial", :hits => 0, :sticky => 0, :forum_posts_count => 1,
        :last_post_id => 1000, :last_updated_at => current_time - 5.days, :permalink => 'initial', :created_at => current_time - 3.years
      stub :other, :title => "Other", :last_updated_at => current_time - 4.days, :permalink => 'other'
      stub :other_forum, :forum => all_stubs(:other_forum)
    end

    model ForumPost do
      stub :thread => all_stubs(:thread), :forum => all_stubs(:forum), :user => all_stubs(:user), :body => 'initial', :created_at => current_time - 5.days
      stub :other, :thread => all_stubs(:other_thread), :body => 'other', :created_at => current_time - 13.days
      stub :other_forum, :forum => all_stubs(:other_forum), :thread => all_stubs(:other_forum_thread)
    end
  end

  define_models :users do 
    model User do
      stub :admin,     :login => 'admin-user',     :email => 'admin-user@example.com', :remember_token => 'blah', :admin => true
      stub :pending,   :login => 'pending-user',   :email => 'pending-user@example.com',   :state => 'pending', :activated_at => nil, :remember_token => 'asdf'
      stub :suspended, :login => 'suspended-user', :email => 'suspended-user@example.com', :state => 'suspended', :remember_token => 'dfdfd'
    end
  end
end
