require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ProjectsController, type: :controller do
  before(:each) do
    login_with create (:user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {:title => 'My Project'}
  }

  let(:invalid_attributes) {
    { title: '' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all projects as @projects' do
      project = Project.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:projects)).to eq(Project.all)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :show, {id: project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    it 'assigns a new project as @project' do
      get :new, {}, valid_session
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :edit, {id: project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, {project: valid_attributes}, valid_session
        }.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, {project: valid_attributes}, valid_session
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, {project: valid_attributes}, valid_session
        expect(response).to redirect_to(Project.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, {project: invalid_attributes}, valid_session
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        post :create, {project: invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {title: 'New Title'}
      }

      it 'updates the requested project' do
        project = Project.create! valid_attributes
        put :update, {id: project.to_param, project: new_attributes}, valid_session
        project.reload
        expect(project.title).to eq('New Title')
      end

      it 'assigns the requested project as @project' do
        project = Project.create! valid_attributes
        put :update, {id: project.to_param, project: valid_attributes}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        project = Project.create! valid_attributes
        put :update, {id: project.to_param, project: valid_attributes}, valid_session
        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid params' do
      it 'assigns the project as @project' do
        project = Project.create! valid_attributes
        put :update, {id: project.to_param, project: invalid_attributes}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        put :update, {id: project.to_param, project: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, {id: project.to_param}, valid_session
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = Project.create! valid_attributes
      delete :destroy, {id: project.to_param}, valid_session
      expect(response).to redirect_to(projects_url)
    end
  end

  describe 'POST #invite_user' do
    it 'adds the user to the project if a valid email was given' do
      project = Project.create! valid_attributes
      user = FactoryGirl.create(:user)
      expect(Notification.all.size).to eq(0)
      expect {
        put :invite_user, { id: project.to_param, :invite_user => { :email => user.email } }, valid_session
      }.to change(project.users, :count).by(1)
      expect(Notification.all.size).to eq 1
      expect(Notification.first.user).to eq user
      expect(Notification.first.message).to have_content project.title
    end

    it 'does not add the user to the project if an invalid email was given' do
      project = Project.create! valid_attributes
      user = FactoryGirl.create(:user)
      expect {
        put :invite_user, { id: project.to_param, :invite_user => { :email => 'invalid@email' } }, valid_session
      }.to change(project.users, :count).by(0)
    end

    it 'does not add the user to the project if he already is a member' do
      project = Project.create! valid_attributes
      user = FactoryGirl.create(:user)
      project.users << user
      expect {
        put :invite_user, { id: project.to_param, :invite_user => { :email => user.email } }, valid_session
      }.to change(project.users, :count).by(0)
    end
  end

  describe 'GET #typeahead' do
    it 'returns the query result as json' do
      project = Project.create! valid_attributes
      matching_user = User.create(name: 'Max Mueller', email: 'max.mueller@student.hpi.de')
      not_matching_user = User.create(name: 'Not Matching', email: 'not.matching@email.de')
      get :typeahead, { query: 'hpi' }, valid_session
      expect(response.body).to have_content matching_user.email
      expect(response.body).to_not have_content not_matching_user.email
    end
  end
end