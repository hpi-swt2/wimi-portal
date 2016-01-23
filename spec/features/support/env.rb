ActionController::Base.class_eval do
  private

  def begin_open_id_authentication(identity_url, _options = {})
    yield OpenIdAuthentication::Result.new(:failure), identity_url, nil
  end
end
