class UserSearch < Searchlight::Search

  def base_query
    User.all
  end

  # Note: these two methods are identical but they could reasonably differ.
  def search_email_like
    query.where("email LIKE ?", "%#{name_like}%")
  end

  def search_typeahead
    query.where("email LIKE ?", "%#{typeahead}%")
  end
end