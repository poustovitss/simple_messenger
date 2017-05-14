class MailboxPage
  include Capybara::DSL

  def visit_page
    visit('/conversations')
    self
  end

  def find_user(user)
    within(:css, 'form#user_search') do
      fill_in('q_first_name_or_last_name_cont', with: user.first_name)
    end
    click_button 'Search'
    self
  end

  def send_message_to_another_user
    click_button 'Send message'
    self
  end

  def enter_existing_conversation
    find("a.conversation-body").click
    self
  end

  def delete_existing_conversation
    within(:css, 'div#conversations') do
      find(:css, 'a.delete_conversation').click
    end
    self
  end

  def visit_unread_messages_page
    visit('/unread')
    self
  end

  def visit_conversation_with_unread_messages
    find(:css, 'a#unread_message').click
    self
  end
end
