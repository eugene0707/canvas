require 'rails_helper'

describe RegularProfilePolicy::Scope do
  describe '#resolve' do
    let(:scope) { User }
    subject { described_class.new(user, scope).resolve }

    context 'when user is not admin' do
      let(:user) { FactoryGirl.create(:user, :regular) }

      it 'returns scope.where(user_id: user.id)' do
        expect(subject).to eq(scope.where(user_id: user.id))
      end
    end
  end
end
