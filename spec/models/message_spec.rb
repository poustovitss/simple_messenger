require 'rails_helper'

RSpec.describe Message, type: :model do
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
  end
end
