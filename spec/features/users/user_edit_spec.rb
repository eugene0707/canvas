require 'rails_helper'

# Feature: User edit
#   As a user
#   I want to edit my user profile
#   So I can change my email address
feature 'User edit', :devise do
  # Scenario: User changes email address
  #   Given I am signed in
  #   When I change my email address
  #   Then I see an account updated message
  xscenario 'user cannot changes email address' do
    user = FactoryGirl.create(:user, :hotelier)
    signin(user.email, user.password)
    visit "/cabinet/user/#{user.id}/edit"
    expect(page).to raise_error(Pundit::NotAuthorizedError)
  end

  xscenario 'admin changes email address' do
    user = FactoryGirl.create(:user, :admin)
    other = FactoryGirl.create(:user, :hotelier)
    signin(user.email, user.password)
    visit "/cabinet/user/#{other.id}/edit"
    fill_in 'Email', with: 'newemail@example.com'
    fill_in 'Пароль', with: other.password
    click_button 'Сохранить'
    expect(page).to have_content('Пользователь успешно сохранено')
  end
end
