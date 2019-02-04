# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'
describe Profile do
  context 'when user_id present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    it { expect(user.profile).to respond_to(:user_id) }
  end

  context 'when user_id present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    it { expect(user.profile).to respond_to(:type) }
  end

  context 'when user_id and type present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    it 'is valid with valid attributes' do
      expect(user.profile).to be_valid
    end
  end

  context 'when user_id and type present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    it 'is valid with valid attributes' do
      expect { user.profile.update(type: 'WrongType') }.to raise_error(ArgumentError)
    end
  end

  context 'when user_id and type present' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    before do
      user.profile.update(type: nil)
    end
    it 'is not valid with invalid attributes' do
      expect(user.profile).not_to be_valid
    end
  end
end
