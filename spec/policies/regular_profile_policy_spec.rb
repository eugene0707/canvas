require 'rails_helper'

describe RegularProfilePolicy do
  subject { described_class }
  let(:current_regular) { FactoryGirl.create(:user, :regular) }
  let(:other_regular) { FactoryGirl.create(:user, :regular) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  permissions :index? do
    it 'allows access for an admin' do
      expect(subject).to permit(admin)
    end

    it 'allows access for an regular' do
      expect(subject).to permit(current_regular)
    end
  end

  permissions :show? do
    it 'prevents other users from seeing your profile' do
      expect(subject).not_to permit(current_regular, other_regular.profile)
    end

    it 'allows you to see your own profile' do
      expect(subject).to permit(current_regular, current_regular.profile)
    end

    it 'allows an admin to see any profile' do
      expect(subject).to permit(admin)
    end
  end
end
