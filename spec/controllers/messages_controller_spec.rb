require 'rails_helper'

describe MessagesController do
  describe 'authenticated admin user' do
    let(:admin) { FactoryGirl.create(:user, :admin, email: 'admin@admin.com') }
    let(:user) { FactoryGirl.create(:user) }
    let(:conversation) { FactoryGirl.create(:conversation,
                                            sender_id: admin.id,
                                            recipient_id: user.id) }
    before do
      sign_in(admin)
    end

    describe 'POST create' do
      let(:valid_data) { FactoryGirl.attributes_for(:message, user_id: admin.id) }
      let(:invalid_data) { FactoryGirl.attributes_for(:message,
                                                      user_id: admin.id,
                                                      body: nil) }
      let(:request) do
        post :create, params: { message: valid_data,
                                conversation_id: conversation.id }
      end
      let(:invalid_request) do
        post :create, params: { message: invalid_data,
                                conversation_id: conversation.id }
      end

      context 'valid data' do
        it 'response with success status' do
          request
          expect(response.status).to eq 200
        end

        it 'creates new message in database' do
          expect {
            request
          }.to change(conversation.messages, :count).by(1)
        end

        it 'updates message recipient' do
          request
          expect(conversation.messages.last.to).to eq(user.id)
        end
      end

      context 'invalid data' do
        it 'response redirect status' do
          invalid_request
          expect(response.status).to eq 302
        end

        it 'does\'nt create new message in the database' do
          expect {
            invalid_request
          }.not_to change(conversation.messages, :count)
        end

        it 'shows flash message' do
          invalid_request
          expect(flash[:alert]).to eq('Message length must be from 1 to 1000 symbols')
        end
      end
    end

    describe 'GET unread' do
      it 'get unread messages' do
        message = FactoryGirl.create(:message,
                                     user_id: user.id,
                                     conversation_id: conversation.id,
                                     to: admin.id)
        get :unread
        expect(admin.new_messages).to eq([message])
      end
    end
  end
end
