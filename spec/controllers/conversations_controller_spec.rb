require 'rails_helper'

describe ConversationsController do
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

      it 'assigns only active @users without current user' do
        user1 = FactoryGirl.create(:user)
        expect(assigns(:users)).to match_array([user1])
      end

      it 'disabled users dont assigns to @users' do
        disable_user = FactoryGirl.create(:user, active: false)
        expect(assigns(:users)).not_to match_array([disable_user])
      end

      it 'assigns @conversations for current user' do
        conversation = FactoryGirl.create(:conversation, sender_id: admin.id)
        expect(assigns(:conversations)).to match_array([conversation])
      end

      it 'assigns new conversation to @conversation' do
        expect(assigns(:conversation)).to be_a_new(Conversation)
      end
    end

    describe 'POST create' do
      context 'new conversation' do
        let(:sender) { FactoryGirl.create(:user) }
        let(:recipient) { FactoryGirl.create(:user) }
        let(:new_conversation) do
          FactoryGirl.attributes_for(:conversation, sender_id: sender.id,
                                     recipient_id: recipient.id)
        end

        it 'redirects to conversation show page' do
          post :create, params: { conversation: new_conversation }
          expect(response).to redirect_to(Conversation.last)
        end

        it 'creates new conversation in database' do
          expect {
            post :create, params: { conversation: new_conversation }
          }.to change(Conversation, :count).by(1)
        end
      end

      context 'existing conversation' do
        before do
          FactoryGirl.create(:conversation, sender_id: admin.id,
                             recipient_id: admin.id)
        end

        it 'redirects to conversation show page' do
          post :create, params: { conversation: { sender_id: admin.id,
                                                  recipient_id: admin.id } }
          expect(response).to redirect_to(Conversation.last)
        end

        it 'doesn\'t create new conversation in database' do
          expect {
            post :create, params: { conversation: { sender_id: admin.id,
                                                    recipient_id: admin.id } }
          }.to change(Conversation, :count).by(0)
        end
      end
    end

    describe 'GET show' do
      let(:foreign_conversation) { FactoryGirl.create(:conversation) }

      context 'conversation for owners' do
        before do
          @conversation = FactoryGirl.create(:conversation, sender_id: admin.id)
          @message = FactoryGirl.create(:message,
                                        user_id: admin.id,
                                        conversation_id: @conversation.id,
                                        to: admin.id)
          get :show, params: { id: @conversation.id }
        end

        it 'response with 200' do
          expect(response.status).to eq(200)
        end

        it 'assigns @messages for current conversation' do
          expect(assigns(:messages)).to match_array([@message])
        end

        it 'assigns @message' do
          expect(assigns(:message)).to be_a_new(Message)
        end

        it 'set all messages to read status' do
          @message.reload
          expect(@message.read).to eq true
        end
      end

      context 'access denied to foreign conversation' do
        before do
          get :show, params: { id: foreign_conversation.id }
        end

        it 'redirects to conversations index page' do
          expect(response).to redirect_to(conversations_path)
        end

        it 'shows flash message' do
          expect(flash[:alert]).to eq('Access denied')
        end
      end
    end

    describe 'DELETE destroy' do
      let(:own_conversation) { FactoryGirl.create(:conversation, sender_id: admin.id) }

      context 'own conversation' do
        before do
          delete :destroy, params: { id: own_conversation }
        end
        it 'redirects to conversations#index' do
          expect(response).to redirect_to(conversations_path)
        end

        it 'from database' do
          subject = Conversation.exists?(own_conversation.id)
          expect(subject).to be_falsy
        end

        it 'messages from database' do
          expect(own_conversation.messages).to be_empty
        end
      end

      context 'foreign conversation' do
        let(:foreign_conversation) { FactoryGirl.create(:conversation) }

        before do
          delete :destroy, params: { id: foreign_conversation }
        end

        it 'do not deletes conversation from database' do
          subject = Conversation.exists?(foreign_conversation.id)
          expect(subject).to be_truthy
        end

        it 'do not deletes conversation messages from database' do
          FactoryGirl.create(:message,
                             conversation_id: foreign_conversation.id,
                             user_id: admin.id)
          expect(foreign_conversation.messages).not_to be_empty
        end
      end
    end
  end
end
