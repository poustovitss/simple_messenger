require 'rails_helper'
require_relative '../support/log_in_form'

feature 'users accesses' do
  let(:login_form) { LogInForm.new }

  let(:user)       { FactoryGirl.create(:user) }
  let(:admin)      { FactoryGirl.create(:user, :admin) }

  let(:conversation) { FactoryGirl.create(:conversation, sender_id: admin.id) }

  context 'authenticated admin' do
    before :each do
      login_form.visit_page.login_as(admin)
    end

    context 'has access' do
      scenario 'to conversations page' do
        visit('/conversations')

        expect(page).to have_content('Mailbox')
      end

      scenario 'to users management page' do
        visit('/users')

        expect(page).to have_content('Users')
      end
    end
  end

  context 'authenticated user' do
    before :each do
      login_form.visit_page.login_as(user)
    end

    context 'has access' do
      scenario 'to conversations page' do
        visit('/conversations')

        expect(page).to have_content('Mailbox')
      end

      scenario 'to edit his profile' do
        visit("/users/#{user.id}/edit")

        expect(page.has_css?("form#edit_user_#{user.id}")).to be true
      end
    end

    context 'has denied access' do
      after :each do
        expect(page).to have_content('Access denied')
      end

      scenario 'to logs page' do
        visit('/users')
      end

      scenario 'to edit foreign profile' do
        visit("/users/#{admin.id}/edit")
      end

      scenario 'to foreign conversation' do
        visit("/conversations/#{conversation.id}")
      end
    end
  end
end
