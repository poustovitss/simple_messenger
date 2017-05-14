require 'rails_helper'
require_relative '../support/log_in_form'
require_relative '../support/mailbox_page'

feature 'authenticated user' do
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:login_form) { LogInForm.new }
  let(:mailbox_page) { MailboxPage.new }

  before :each do
    login_form.visit_page.login_as(user)
  end

  context 'shows default message' do
    scenario 'if no users' do
      mailbox_page.visit_page
      expect(page).to have_content('No users :(')
    end

    scenario 'if no conversations' do
      mailbox_page.visit_page
      expect(page).to have_content('No conversations yet. Create one!')
    end
  end

  context 'users panel' do
    before do
      another_user
    end

    scenario 'search user' do
      mailbox_page.visit_page.find_user(another_user)
      expect(page).to have_content("#{another_user.name}")
      expect(page).to have_button('Send message')
    end

    scenario 'send user new message' do
      mailbox_page.visit_page.send_message_to_another_user
      expect(page).to have_content('From 1 to 1000 characters')
    end
  end

  context 'mailbox panel' do
    let(:conversation) do
      FactoryGirl.create(:conversation,
                         sender_id: user.id,
                         recipient_id: another_user.id)
    end

    before do
      conversation
    end

    scenario 'enters existing conversation with another user' do
      mailbox_page.visit_page.enter_existing_conversation
      expect(page).to have_content('From 1 to 1000 characters')
    end

    scenario 'deletes existing conversation' do
      mailbox_page.visit_page.delete_existing_conversation
      expect(page).to have_content('No conversations yet. Create one!')
    end
  end

  context 'navigation panel' do
    let(:conversation) do
      FactoryGirl.create(:conversation,
                         sender_id: user.id,
                         recipient_id: another_user.id)
    end
    let(:message) do
      FactoryGirl.create(:message,
                         conversation_id: conversation.id,
                         user_id: another_user.id,
                         body: 'Hello capybara',
                         to: user.id)
    end

    before do
      conversation
      message
    end

    scenario 'shows unread messages' do
      mailbox_page.visit_page
      within(:css, 'a#unread_messages') {
        expect(page).to have_content('1')
      }
    end

    scenario 'shows conversations with unread messages' do
      mailbox_page.visit_page.visit_unread_messages_page
      expect(page).to have_content("#{another_user.name}")
    end

    context 'enter conversation with unread messages' do
      before do
        mailbox_page
            .visit_page
            .visit_unread_messages_page
            .visit_conversation_with_unread_messages

      end

      scenario 'icon in navigation disappear' do
        within(:css, 'a#unread_messages') {
          expect(page).to have_content('')
        }
      end

      scenario 'see unread message' do
        expect(page).to have_content("#{message.body}")
      end
    end
  end
end
