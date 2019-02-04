# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#

require 'rails_helper'
describe User do
  context 'when email present' do
    let(:user) { FactoryGirl.create(:user) }
    it { should respond_to(:email) }
  end

  context 'when email present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    it { should respond_to(:admin?) }
  end

  context 'when password present' do
    let(:user) { FactoryGirl.create(:user) }
    it { should respond_to(:password) }
  end
end
