class UserSearch < Searchlight::Search
  def base_query
    User.all
  end

  def search_user
    query.where('first_name LIKE ? OR last_name LIKE ? OR email LIKE ?', "%#{user}%", "%#{user}%", "%#{user}%")
  end
end
