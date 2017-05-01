require 'rails_helper'

RSpec.describe User, type: :model do
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
  end
end
