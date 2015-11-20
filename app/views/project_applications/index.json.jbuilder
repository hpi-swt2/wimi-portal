json.array!(@project_applications) do |project_application|
  json.extract! project_application, :id, :project_id, :user_id, :status
  json.url project_application_url(project_application, format: :json)
end
