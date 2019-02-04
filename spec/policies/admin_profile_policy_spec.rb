require 'rails_helper'

describe AdminProfilePolicy do
  subject { described_class }
  let(:other_admin) { FactoryGirl.create(:user, :admin) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  permissions :destroy? do
    it 'prevents deleting your own profile' do
      expect(subject).not_to permit(admin, admin.profile)
    end

    it "allows an admin to delete other user's profiles" do
      expect(subject).to permit(admin, other_admin.profile)
    end

    it "doesn't raise error if object is a AdminProfile class" do
      expect { Pundit.policy(admin, AdminProfile).destroy? }.not_to raise_error
    end
  end

  describe '#permitted_attributes' do
    subject { described_class.new(admin, admin.profile) }

    context 'when action is edit' do
      it 'hides type and user fields' do
        expect(subject.permitted_attributes('edit')).to eq([])
      end
    end

    context 'when action is nil' do
      it 'returns user and type' do
        expect(subject.permitted_attributes).to eq(%i[user type])
      end
    end
  end
end
