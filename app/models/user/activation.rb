class User
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  after_create :set_first_user_as_activated
  def set_first_user_as_activated
    puts "set first user as activated"
    register! && activate! if is_first_user?
  end
  
  def is_first_user?
    site.nil? or site.users.size <= 1
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil? || activation_code.blank?
  end

end
