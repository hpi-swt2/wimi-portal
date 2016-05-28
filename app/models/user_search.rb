class UserSearch < Searchlight::Search
  def base_query
    User.all
  end

  def search_typeahead
    query.where('first_name LIKE ? OR last_name LIKE ? OR email LIKE ?', "%#{typeahead}%", "%#{typeahead}%", "%#{typeahead}%")
  end
end
