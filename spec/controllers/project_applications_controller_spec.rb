require 'rails_helper'

# project applications will be removed
RSpec.describe ProjectApplicationsController, type: :controller do
#  before(:each) do
#    @user = FactoryGirl.create(:user)
#    @wimi = FactoryGirl.create(:wimi, user: FactoryGirl.create(:user), chair: FactoryGirl.create(:chair), representative: true).user
#    @project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
#    @wimi.projects << @project
#    login_with @user
#    @request.env['HTTP_REFERER'] = 'http://test.host/'
#  end
#
#  # This should return the minimal set of attributes required to create a valid
#  # ProjectApplication. As you add validations to ProjectApplication, be sure to
#  # adjust the attributes here as well.
#  let(:valid_attributes) {
#    {user: @user, project_id: @wimi.projects.first.id}
#  }
#
#  let(:invalid_attributes) {
#    {}
#  }
#
#  # This should return the minimal set of values that should be in the session
#  # in order to pass any filters (e.g. authentication) defined in
#  # ProjectApplicationsController. Be sure to keep this updated too.
#  let(:valid_session) { {} }
#
#  describe 'GET #index' do
#    it 'assigns all project_applications as @project_applications' do
#      project_application = ProjectApplication.create! valid_attributes
#      get :index, {}, valid_session
#      expect(assigns(:project_applications)).to eq([project_application])
#    end
#  end
#
#  describe 'POST #create' do
#    context 'with valid params' do
#      it 'creates a new ProjectApplication' do
#        expect {
#          post :create, {project_application: valid_attributes, id: @project.id}, valid_session
#        }.to change(ProjectApplication, :count).by(1)
#      end
#
#      it 'assigns a newly created project_application as @project_application' do
#        post :create, {project_application: valid_attributes, id: @project.id}, valid_session
#        expect(assigns(:project_application)).to be_a(ProjectApplication)
#        expect(assigns(:project_application)).to be_persisted
#      end
#
#      it 'redirects to the project_application index' do
#        post :create, {project_application: valid_attributes, id: @project.id}, valid_session
#        expect(response).to redirect_to(ProjectApplication)
#      end
#    end
#
#    context 'with invalid params' do
#      it 'redirects back to index page' do
#        post :create, {project_application: invalid_attributes, id: @project.id}, valid_session
#        expect(response).to redirect_to(project_applications_path)
#      end
#    end
#
#    it 'does not accept applications if user is superadmin' do
#      superadmin = FactoryGirl.create(:user, superadmin: true)
#      login_with superadmin
#      expect {
#        post :create, {project_application: {user: superadmin, project_id: @wimi.projects.first.id}, id: @project.id}, valid_session
#      }.to change(ProjectApplication, :count).by(0)
#    end
#  end
#
#  describe 'DELETE #destroy' do
#    it 'destroys the requested project_application' do
#      project_application = ProjectApplication.create! valid_attributes
#      expect {
#        delete :destroy, {id: project_application.to_param}, valid_session
#      }.to change(ProjectApplication, :count).by(-1)
#    end
#
#    it 'redirects to the project_applications list' do
#      project_application = ProjectApplication.create! valid_attributes
#      delete :destroy, {id: project_application.to_param}, valid_session
#      expect(response).to redirect_to(:back)
#    end
#  end
#
#  describe 'GET #accept' do
#    it 'accepts the project application' do
#      project_application = ProjectApplication.create! valid_attributes
#      login_as @wimi
#      get :accept, {id: project_application.id}, valid_session
#      expect(response).to redirect_to(:back)
#      expect(project_application.reload.accepted?).to eq(true)
#    end
#  end
#
#  describe 'GET #decline' do
#    it 'declines the project application' do
#      project_application = ProjectApplication.create! valid_attributes
#      login_as @wimi
#      get :decline, {id: project_application.id}, valid_session
#      expect(response).to redirect_to(:back)
#      expect(project_application.reload.declined?).to eq(true)
#    end
#  end
#
#  describe 'GET #reapply' do
#    it 'reapplies for a project' do
#      project_application = ProjectApplication.create! valid_attributes
#      project_application.update(status: :declined)
#      get :reapply, {id: project_application.id}, valid_session
#      expect(response).to redirect_to(:back)
#      expect(project_application.reload.pending?).to eq(true)
#    end
#  end
end
