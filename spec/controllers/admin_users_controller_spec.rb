require 'rails_helper'

describe UsersController do
  describe 'authenticated admin user' do
    let(:admin) { FactoryGirl.create(:user, :admin, email: 'admin@admin.com') }
    before do
      sign_in(admin)
    end

    describe 'GET index' do
      before do
        get :index
      end

      it 'renders :index template' do
        expect(response).to render_template(:index)
      end

      it 'response with 200' do
        expect(response.status).to eq(200)
      end

      it 'assigns @users' do
        user1 = FactoryGirl.create(:user)
        expect(assigns(:users)).to match_array([admin, user1])
      end
    end

    describe 'GET edit' do
      let(:user) { FactoryGirl.create(:user, :admin, email: 'user@user.com') }
      before do
        get :edit, params: { id: user }
      end

      it 'renders :edit template' do
        expect(response).to render_template(:edit)
      end

      it 'response with 200 status' do
        expect(response.status).to eq 200
      end

      it 'assigns the requested user to template' do
        expect(assigns(:user)).to eq(user)
      end
    end

    describe 'PUT update' do
      let(:user) { FactoryGirl.create(:user, :admin, email: 'user@user.com') }

      context 'valid data' do
        let(:valid_data) { FactoryGirl.attributes_for(:user, email: 'new@new.com') }

        it 'redirects to users#index' do
          put :update, params: { id: user, user: valid_data }
          expect(response).to redirect_to(users_path)
        end

        it 'updates user in the database' do
          put :update, params: { id: user, user: valid_data }
          user.reload
          expect(user.email).to eq('new@new.com')
        end

        it 'shows flash message' do
          put :update, params: { id: user, user: valid_data }
          expect(flash[:notice]).to eq('User was updated.')
        end
      end

      context 'invalid data' do
        let(:invalid_data) { FactoryGirl.attributes_for(:user, first_name: '', last_name: 'Last') }

        it 'renders :edit template' do
          put :update, params: { id: user, user: invalid_data }
          expect(response).to render_template(:edit)
        end

        it 'doesn\'t update user in the database' do
          put :update, params: { id: user, user: invalid_data }
          user.reload
          expect(user.last_name).not_to eq('Last')
        end
      end
    end

    describe 'GET new' do
      before do
        get :new
      end

      it 'renders :new template' do
        expect(response).to render_template(:new)
      end

      it 'assigns new user to @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe 'POST create' do
      let(:valid_data) { FactoryGirl.attributes_for(:user) }

      context 'valid data' do
        it 'redirects to users#index' do
          post :create, params: { user: valid_data }
          expect(response).to redirect_to(users_path)
        end

        it 'creates new user in database' do
          expect {
            post :create, params: { user: valid_data }
          }.to change(User, :count).by(1)
        end

        it 'shows flash message' do
          post :create, params: { user: valid_data }
          expect(flash[:notice]).to eq('User was created.')
        end
      end

      context 'invalid data' do
        let(:invalid_data) { FactoryGirl.attributes_for(:user, first_name: '') }

        it 'renders :new template' do
          post :create, params: { user: invalid_data }
          expect(response).to render_template(:new)
        end

        it 'does\'nt create new user in the database' do
          expect {
            post :create, params: { user: invalid_data }
          }.not_to change(User, :count)
        end
      end
    end

    describe 'DELETE destroy' do
      let(:user) { FactoryGirl.create(:user) }

      it 'redirects to users#index' do
        delete :destroy, params: { id: user }
        expect(response).to redirect_to(users_path)
      end

      it 'deletes users from database' do
        delete :destroy, params: { id: user }
        expect(User.exists?(user.id)).to be_falsy
      end

      it 'shows flash message' do
        delete :destroy, params: { id: user }
        expect(flash[:notice]).to eq('User was successfully deleted.')
      end

      context 'admin cannot delete himself' do
        it 'redirects to users#index' do
          delete :destroy, params: { id: admin }
          expect(flash[:alert]).to eq('This user cannot be deleted.')
          expect(response).to redirect_to(users_path)
        end

        it 'does not deletes himself from database' do
          delete :destroy, params: { id: admin }
          expect(User.exists?(admin.id)).to be_truthy
        end
      end
    end

    describe 'GET role' do
      before do
        get :role, params: { id: admin }
      end

      it 'renders :role template' do
        expect(response).to render_template(:role)
      end

      it 'assigns new user to @user' do
        expect(assigns(:user)).to eq(admin)
      end
    end

    describe 'PUT role' do
      let(:user) { FactoryGirl.create(:user, role: :user, email: 'user@user.com') }
      let(:valid_data) { FactoryGirl.attributes_for(:user, role: 'admin') }
      before do
        put :role_update, params: { id: user, user: valid_data }
      end

      it 'redirects to users index page' do
        expect(response).to redirect_to(users_path)
      end

      it 'changes user role in database' do
        user.reload
        expect(user.role).to eq('admin')
      end

      it 'shows flash message' do
        expect(flash[:notice]).to eq('User\'s role was updated.')
      end
    end

    describe 'PUT toggle user state' do
      context 'of another user' do
        let(:disable_user) { FactoryGirl.attributes_for(:user, active: false) }
        let(:enable_user)  { FactoryGirl.attributes_for(:user, active: true) }

        after do
          expect(response).to redirect_to(users_path)
        end

        context 'disable user' do
          let(:user) { FactoryGirl.create(:user) }
          before do
            put :toggle_user_state, params: { id: user, user: disable_user }
          end

          it 'change user status in database' do
            user.reload
            expect(user.active).to be false
          end

          it 'shows flash message' do
            expect(flash[:notice]).to eq('User was disabled.')
          end
        end

        context 'enable user' do
          let(:user) { FactoryGirl.create(:user, active: false) }
          before do
            put :toggle_user_state, params: { id: user, user: enable_user }
          end

          it 'changes user status' do
            user.reload
            expect(user.active).to be true
          end

          it 'shows flash message' do
            expect(flash[:notice]).to eq('User was enabled.')
          end
        end
      end

      context 'of himself' do
        before do
          put :toggle_user_state, params: { id: admin, user: { active: false } }
        end

        it 'redirects to users index page' do
          expect(response).to redirect_to(users_path)
        end

        it 'doesnt change user status in database' do
          admin.reload
          expect(admin.active).to eq true
        end

        it 'renders error message' do
          expect(flash[:alert]).to eq('You cannot disable yourself.')
        end
      end
    end
  end
end
