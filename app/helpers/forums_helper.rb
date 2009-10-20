module ForumsHelper
  # used to know if a thread has changed since we read it last
  def recent_thread_activity(thread)
    return false unless logged_in?
    return thread.last_updated_at > ((session[:threads] ||= {})[thread.id] || last_active)
  end 

  # used to know if a forum has changed since we read it last
  def recent_forum_activity(forum)
    return false unless logged_in? && forum.recent_thread
    return forum.recent_thread.last_updated_at > ((session[:forums] ||= {})[forum.id] || last_active)
  end
  
  def last_active
    session[:last_active] ||= Time.now.utc
  end
  
  # Ripe for optimization
  def voice_count
    pluralize Forum.threads.to_a.sum { |t| t.voice_count }, 'voice'
  end

end
