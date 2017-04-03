require 'rails_helper' 

feature 'Routes' do  
  scenario 'GET routes load correctly' do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    @time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
    filtered_routes.each(&check_route)
  end 

  let :check_route do
    lambda do |route|
      login_as @wimi
      visit route
      # save_and_open_page if page.status_code != 200 
      expect(page.status_code).to be 200 
    end 
  end 

  let :filtered_routes do 
    WimiPortal::Application
      .routes
      .routes
      .select(&verb_get)
      .map(&extract_path)
      .reject(&excluded_routes)
      .reject(&excluded_prefixes)
      .map(&assign_id)
  end

  let(:verb_get) { -> (r) { r.verb.to_s.include? 'GET' } }
  let(:extract_path) { -> (r) { r.path.spec.to_s.chomp('(.:format)') } }
  let(:excluded_routes) { -> (r) { problematic_routes.include?(r) } }
  let(:excluded_prefixes) { -> (r) { problematic_prefixes.any? {|pre| r.start_with?(pre)} } }

  # This function replaces some parts of the URL with the id's of example data.
  let :assign_id do
    lambda do |route|
      route
        .sub(':id', '1')
        .sub(':holiday_id', '1')
        .sub(':contract_id', '1')
        .sub(':trip_id', '1')
        .sub(':query', 'some_query')
    end
  end

  # The following routes are excluded from the tests. Please, fix them
  # or update the tests if necessary.
  let :problematic_prefixes do
    [
      '/chair_applications',
      '/holidays',
      '/trips',
      '/project_applications'
    ]
  end

  let :problematic_routes do
    [
      '/projects/typeahead/:query',
      '/documents/generate_pdf',
      '/users/edit_leave',
      '/time_sheets/:id/accept_reject',
      # too slow
      '/time_sheets/:id/download'
    ]
  end
end