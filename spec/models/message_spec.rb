require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'scopes' do
    let(:user) { FactoryGirl.create(:user) }
    let(:recipient) { FactoryGirl.create(:user) }
    let(:conversation) { FactoryGirl.create(:conversation) }
    before do
      @message1 = FactoryGirl.create(:message,
                                     conversation: conversation,
                                     user_id: user.id,
                                     to: recipient.id,
                                     created_at: Time.zone.now)
      @message2 = FactoryGirl.create(:message,
                                     conversation: conversation,
                                     user_id: user.id,
                                     to: recipient.id,
                                     created_at: Time.zone.now + 1)
    end

    it 'messages for display' do
      expect(Message.for_display).to eq([@message1, @message2])
    end

    it 'shows messages sent to specific user' do
      expect(Message.to(recipient)).to eq([@message1, @message2])
    end

    it 'shows unread messages' do
      expect(Message.unread).to eq([@message1, @message2])
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:conversation_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_length_of(:body) }
  end

  describe 'instance methods' do
    it 'format messages time' do
      message = FactoryGirl.build(:message, created_at: Time.at(1364046539))

      expect(message.message_time).to eq('15:48:59 March 23, 2013')
    end

    it 'checks for message owner' do
      user = FactoryGirl.create(:user)
      message = FactoryGirl.build(:message, user_id: user.id)

      expect(message.owner?(user)).to be true
    end

    it 'shows user name' do
      user = FactoryGirl.create(:user, first_name: 'First', last_name: 'Last')
      message = FactoryGirl.build(:message, user_id: user.id)

      expect(message.owner_name).to eq('First Last')
    end
  end
end
