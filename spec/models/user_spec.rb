require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'scopes' do
    it 'order by created_at field in asc' do
      user1 = FactoryGirl.create(:user, created_at: Time.now-10)
      user2 = FactoryGirl.create(:user, created_at: Time.now-5)

      expect(User.created).to match_array([user1, user2])
    end

    it 'shows only active users' do
      user1 = FactoryGirl.create(:user)
      FactoryGirl.create(:user, active: false)

      expect(User.active).to match_array([user1])
    end
  end

  describe 'user roles' do
    let(:role) { %i[user admin] }

    it 'has the right index' do
      role.each_with_index do |role, index|
        expect(described_class.roles[role]).to eq(index)
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:first_name) }
    it { should validate_length_of(:last_name) }
  end

  describe 'callbacks' do
    it 'set user role to user after create' do
      user = FactoryGirl.create(:user)

      expect(user.role).to eq('user')
    end
  end

  describe 'instance methods' do
    it 'checks if user is an admin' do
      user = FactoryGirl.create(:user, :admin)
      expect(user.admin?).to be_truthy
    end

    it 'returns user\'s formatted full name' do
      user = FactoryGirl.create(:user, first_name: 'first', last_name: 'last')
      expect(user.name).to eq('First Last')
    end

    it 'checks if user is current user' do
      user = FactoryGirl.create(:user)

      expect(user.current_user?).to be false
    end

    it 'shows related conversations' do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      conversation = FactoryGirl.create(:conversation, sender_id: user1.id, recipient_id: user2.id)
      FactoryGirl.create(:conversation, sender_id: user2.id, recipient_id: 100)

      expect(user1.conversations).to match_array([conversation])
    end
  end
end
