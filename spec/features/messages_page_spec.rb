require 'rails_helper'
require_relative '../support/log_in_form'
require_relative '../support/mailbox_page'

feature 'authenticated user' do
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:login_form) { LogInForm.new }
  let(:mailbox_page) { MailboxPage.new }
  let(:conversation) do
    FactoryGirl.create(:conversation,
                       sender_id: user.id,
                       recipient_id: another_user.id)
  end
  let(:message) do
    FactoryGirl.create(:message,
                       conversation_id: conversation.id,
                       user_id: user.id,
                       body: 'Hello capybara',
                       to: another_user.id)
  end

  before :each do
    conversation
    message
    login_form.visit_page.login_as(user)
  end

  scenario 'shows existing message in conversation' do
    mailbox_page.visit_page.enter_existing_conversation
    expect(page).to have_content('Hello capybara')
  end
end
