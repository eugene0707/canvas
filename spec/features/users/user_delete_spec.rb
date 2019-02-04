require 'rails_helper'

# Feature: User delete
#   As a user
#   I want to delete my user profile
#   So I can close my account
feature 'User delete', :devise, :js do
  # Scenario: User can delete own account
  #   Given I am signed in
  #   When I delete my account
  #   Then I should see an account deleted message
  scenario 'admin can delete user account' do
    user = FactoryGirl.create(:user, :admin)
    FactoryGirl.create(:user, :regular)
    signin(user.email, user.password)
    visit '/cabinet/user'
    first('li.icon.delete_member_link > a').trigger('click')
    expect(page).to have_content 'Вы уверены, что хотите удалить пользователь'
    click_button 'Да, уверен'
    expect(page).to have_content 'Пользователь успешно удалено'
  end
end
