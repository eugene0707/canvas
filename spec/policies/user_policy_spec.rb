require 'rails_helper'

describe UserPolicy do
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
      expect(subject).not_to permit(current_regular, other_regular)
    end

    it 'allows you to see your own profile' do
      expect(subject).to permit(current_regular, current_regular)
    end

    it 'allows an admin to see any profile' do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'prevents deleting yourself' do
      expect(subject).not_to permit(admin, admin)
    end

    it 'allows an admin to delete any user' do
      expect(subject).to permit(admin, other_regular)
    end

    it "doesn't allow not the admin to delete any user" do
      expect(subject).not_to permit(current_regular, other_regular)
    end

    it "doesn't raise error if object is a User class" do
      expect { Pundit.policy(admin, User).destroy? }.not_to raise_error
    end
  end
end
