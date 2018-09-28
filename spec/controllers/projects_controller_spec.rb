require 'rails_helper'
require 'cancan/matchers'

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
    @user = create(:user)
    create(:wimi, user: @user)
    login_with @user
  end

  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      title: 'My Project',
      chair_id: @user.chair.id
    }
  }
  let(:invalid_attributes) {
    {
      title: ''
    }
  }

  describe 'GET #index' do
    it 'lists projects of user' do
      project = Project.create! valid_attributes
      project.add_user @user

      get :index, {}

      expect(assigns(:projects))
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes

      get :show, {id: project.to_param}

      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    it 'assigns a new project as @project' do
      get :new, {}

      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      @user.projects << project

      get :edit, {id: project.to_param}

      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, {project: valid_attributes}
        }.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, {project: valid_attributes}
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, {project: valid_attributes}
        expect(response).to redirect_to(Project.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, {project: invalid_attributes}
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        post :create, {project: invalid_attributes}
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
        @user.projects << project

        put :update, {id: project.to_param, project: new_attributes}
        project.reload

        expect(project.title).to eq('New Title')
      end

      it 'assigns the requested project as @project' do
        project = Project.create! valid_attributes
        @user.projects << project

        put :update, {id: project.to_param, project: valid_attributes}

        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        project = Project.create! valid_attributes
        @user.projects << project

        put :update, {id: project.to_param, project: valid_attributes}

        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid params' do
      it 'assigns the project as @project' do
        project = Project.create! valid_attributes
        @user.projects << project

        put :update, {id: project.to_param, project: invalid_attributes}

        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        @user.projects << project

        put :update, {id: project.to_param, project: invalid_attributes}

        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      @user.projects << project

      expect {
        delete :destroy, {id: project.to_param}
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = Project.create! valid_attributes
      @user.projects << project

      delete :destroy, {id: project.to_param}

      expect(response).to redirect_to(projects_url)
    end
  end

  describe 'POST #add_user_from_email' do
    before :each do
      @project = FactoryGirl.create(:project, chair: @user.chair)
      @project.users << @user
    end

    it 'can be accessed by wimis of that project' do
      ability = Ability.new(@user)
      expect(ability).to be_able_to(:add_user_from_email, @project)
    end

    context 'with a valid email' do
      before :each do
        @first_name = "test"
        @last_name = "user"
        @hpiusername = @first_name + "." + @last_name 
        @email = @hpiusername + "@student.hpi.de"
      end

      it 'creates a new user' do
        expect{post :add_user_from_email, {id: @project.to_param, email: @email}}.to change{User.count}.by(1)
        expect(User.last.first_name).to eq(@first_name.titleize)
        expect(User.last.last_name).to eq(@last_name.titleize)
        expect(User.last.identity_url).to eq(Rails.configuration.identity_url + @hpiusername)
      end

      it 'adds the new user to the project' do
        expect{post :add_user_from_email, {id: @project.to_param, email: @email}}.to change{@project.users.count}.by(1)        
      end

      it 'sends an email to the new user' do
        expect { post :add_user_from_email, {id: @project.to_param, email: @email} }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      context 'and the create contract flag' do
        before :each do
          post :add_user_from_email, {id: @project.to_param, email: @email, create_contract: true}
        end

        it 'creates a contract belonging to the projects chair' do
          expect(Contract.count).to eq(1)
          expect(Contract.first.chair).to eq(@project.chair)
          expect(Contract.first.hiwi.email).to eq(@email)
        end

        it 'sets the wimi as the contracts responsible' do
          expect(Contract.first.responsible).to eq(@user)
        end
      end

      context 'without the create contract flag' do
        it 'does not create a contract' do
          expect{post :add_user_from_email, {id: @project.to_param, email: @email}}.not_to change{Contract.count}
        end
      end
    end

    context 'with an invalid email' do
      before :each do
        @email = "external.person@example.com"
      end

      it 'does not create a new user' do
        expect{post :add_user_from_email, {id: @project.to_param, email: @email}}.not_to change{User.count}
      end
    end
  end
end
