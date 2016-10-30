class Message
  def self.empty_invalid_token
    "Empty or Invalid header token"
  end

  def self.unauthorized_user
    "Unauthorized User"
  end

  def self.logged_in
    "You are still logged in"
  end

  def self.invalid_login
    "Invalid Login Details"
  end

  def self.logout
    "Successfully logged out"
  end

  def self.no_bucketlist
    "No Bucketlist at the moment"
  end

  def self.bucketlist_name
    "Bucketlist Name can't be blank"
  end

  def self.bucketlist_deleted
    "Bucketlist successfully deleted"
  end

  def self.bucketlist_not_found
    "Bucketlist not found"
  end

  def self.empty_search_result
    "Search result is empty"
  end

  def self.empty_bucketlist
    "This Bucketlist is empty"
  end

  def self.item_deleted
    "Bucketlist Item deleted"
  end

  def self.item_not_found
    "Bucketlist Item not found"
  end

  def self.email_required
    "Email can't be blank"
  end

  def self.name_exist_already
    "Name has already been taken"
  end

  def self.name_required
    "Name can't be blank"
  end
end
