require 'rails_helper'

describe UserPolicy::Scope do
  describe '#resolve' do
    let(:scope) { User }
    subject { described_class.new(user, scope).resolve }

    context 'when user is not admin' do
      let(:user) { FactoryGirl.create(:user, :regular) }

      it 'returns scope.where(id: user.id)' do
        expect(subject).to eq(scope.where(id: user.id))
      end
    end
  end
end
