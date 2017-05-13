require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'scopes' do
    it 'shows conversation between 2 users' do
      user = FactoryGirl.create(:user)
      user1 = FactoryGirl.create(:user)
      conversation = FactoryGirl.create(:conversation,
                                        sender_id: user.id,
                                        recipient_id: user1.id)
      FactoryGirl.create(:conversation, sender_id: user.id)
      result = Conversation.between(user, user1)

      expect(result).to match_array([conversation])
    end
  end

  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
    it { should have_many(:messages) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  end

  describe 'instance methods' do
    before do
      @user = FactoryGirl.create(:user)
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @conversation = FactoryGirl.create(:conversation,
                                         sender_id: @user.id,
                                         recipient_id: @user1.id)
      @message = FactoryGirl.create(:message,
                                    user_id: @user.id,
                                    conversation_id: @conversation.id,
                                    to: @user1.id,
                                    read: false)
    end

    it 'finds conversation owner' do
      expect(@conversation.owner(@user)).to eq(@user1)
    end

    context 'conversation owner' do
      it 'is owner' do
        expect(@conversation.owner?(@user)).to be true
      end
      it 'isn\'t owner' do
        expect(@conversation.owner?(@user2)).to be false
      end
    end

    it 'mark user messages as read' do
      @conversation.mark_messages_as_read(@user1)
      @message.reload
      expect(@message.read).to eq true
    end
  end
end
