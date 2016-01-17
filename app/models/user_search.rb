class UserSearch < Searchlight::Search
  def base_query
    User.all
  end

  def search_typeahead
    print query
    query.where('email LIKE ?', "%#{typeahead.split(',').last}%")
  end
end
