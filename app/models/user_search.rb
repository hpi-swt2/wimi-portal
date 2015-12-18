class UserSearch < Searchlight::Search

  def base_query
    User.all
  end

  def search_typeahead
    query.where("email LIKE ?", "%#{typeahead}%")
  end
end