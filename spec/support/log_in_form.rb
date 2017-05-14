class LogInForm
  include Capybara::DSL

  def visit_page
    visit('/users/sign_in')
    self
  end

  def login_as(user)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Sign in'
    self
  end
end
