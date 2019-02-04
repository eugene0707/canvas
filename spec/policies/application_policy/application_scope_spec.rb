require 'rails_helper'

describe ApplicationPolicy::ApplicationScope do
  describe '#resolve' do
    let(:scope) { User }
    subject { described_class.new(user, scope).resolve }

    context 'when user is nil' do
      let(:user) { nil }

      it 'raise Warden::NotAuthenticated error' do
        expect { subject }.to raise_error(Warden::NotAuthenticated)
      end
    end

    context 'when user is admin' do
      let(:user) { FactoryGirl.create(:user, :admin) }

      it 'returns scope.all' do
        expect(subject).to eq(scope.all)
      end
    end

    context 'when user is not admin' do
      let(:user) { FactoryGirl.create(:user, :regular) }

      it 'returns scope.none' do
        expect(subject).to eq(scope.none)
      end
    end
  end
end
