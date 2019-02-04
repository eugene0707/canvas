require 'rails_helper'

# Feature: User profile page
#   As a user
#   I want to visit my user profile page
#   So I can see my personal account data
feature 'User profile page', :devise do
  # Scenario: User sees own profile
  #   Given I am signed in
  #   When I visit the user profile page
  #   Then I see my own email address
  scenario 'user sees own profile' do
    user = FactoryGirl.create(:user, :regular)
    signin(user.email, user.password)
    visit "/cabinet/user/#{user.id}"
    expect(page).to have_content 'User'
    expect(page).to have_content user.email
  end

  # Scenario: User cannot see another user's profile
  #   Given I am signed in
  #   When I visit another user's profile
  #   Then I see an 'access denied' message
  scenario "user cannot see another user's profile" do
    me = FactoryGirl.create(:user, :regular)
    other = FactoryGirl.create(:user, :regular, email: 'other@example.com')
    signin(me.email, me.password)
    expect do
      visit "/cabinet/user/#{other.id}"
      page.has_text? I18n.t('pundit.default')
    end.to raise_error(Pundit::NotAuthorizedError)
  end
end
