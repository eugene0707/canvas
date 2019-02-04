require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class }

  ACTIONS = %i[index? show? update? destroy? create? export? edit? new?].freeze

  let(:regular) { FactoryGirl.create(:user, :regular) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  context 'when user is nil' do
    it 'raise Warden::NotAuthenticated error' do
      expect { Pundit.policy(nil, regular) }.to raise_error(Warden::NotAuthenticated)
    end
  end

  permissions(*ACTIONS) do
    it 'allows access if user is admin' do
      expect(subject).to permit(admin)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(regular)
    end
  end

  permissions :dashboard? do
    it 'allows access both admin and regular' do
      expect(subject).to permit(admin)
      expect(subject).to permit(regular)
    end
  end
end
