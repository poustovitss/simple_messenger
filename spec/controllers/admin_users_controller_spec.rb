require 'rails_helper'

describe UsersController do
  describe 'authenticated admin user' do
    let(:admin) { FactoryGirl.create(:user, :admin, email: 'admin@admin.com') }
    before do
      sign_in(admin)
    end

    describe 'GET index' do
      it 'renders :index template' do
        get :index
        expect(response).to render_template(:index)
        expect(response.status).to eq(200)
      end
    end

    describe 'GET edit' do
      let(:user) { FactoryGirl.create(:user, :admin, email: 'user@user.com') }
      it 'renders :edit template' do
        get :edit, params: { id: user }
        expect(response).to render_template(:edit)
      end

      it 'assigns the requested user to template' do
        get :edit, params: { id: user }
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
          expect(flash[:notice]).to eq('User was successfully updated.')
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
      it 'renders :new template' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'assigns new User to @user' do
        get :new
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
          expect(flash[:notice]).to eq('User was successfully created.')
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
  end
end
