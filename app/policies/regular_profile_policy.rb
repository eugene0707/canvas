class RegularProfilePolicy < ProfilePolicy
  def index?
    user.admin? || user.regular?
  end

  def show?
    user.admin? || (user.regular? && user.id == record.user_id)
  end

  def permitted_attributes(action = nil)
    result = super(action)
    action == 'create' ? result - %i[type] : result
  end

  class Scope < ApplicationScope
    private

    def resolve_for_role
      scope.where(user_id: user.id)
    end
  end
end
