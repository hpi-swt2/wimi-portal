module ProjectScopes
  def self.included(premiere)
    # premiere.class_eval  do
    #   scope :active, -> { where("kill_date >= ?", DateTime.now) }
    #   scope :archived, -> { where("kill_date < ?", DateTime.now) }
    # end

    add_filter_and_search_scopes premiere
  end

  def self.add_filter_and_search_scopes(premiere)
    premiere.class_eval do
      scope :search, -> search_string { where('lower(title) LIKE ?', "%#{search_string}%".downcase) }
    end
  end
end