require 'rails_helper'

feature 'User create' do
  scenario 'create hotelier' do
    user = FactoryGirl.create(:user, :admin)
    signin(user.email, user.password)
    visit '/cabinet/user/new'
    fill_in 'Email', with: 'newemail@example.com'
    fill_in 'Пароль', with: 'other_password'
    fill_in 'Подтверждение пароля', with: 'other_password'
    fill_in 'Имя пользователя', with: 'James H.F.'
    click_link 'Добавить Профиль'
    expect(page).to have_content('Тип профиля')
    find(:xpath, "//*[@id='user_profile_attributes_hotel_id_field']/div/div/span/label").click
    option_xpath = "//*[@class='ui-autocomplete ui-front ui-menu ui-widget ui-widget-content']/li"
    find(:xpath, option_xpath).click
    click_button 'Сохранить'
    expect(page).to have_content('Пользователь успешно создано')
  end
end
