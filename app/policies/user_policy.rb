class UserPolicy < ApplicationPolicy
  def index?
    user.admin? || user.regular?
  end

  def show?
    user.admin? || (user.regular? && user.id == record.id)
  end

  def destroy?
    return true if user.admin? && record.is_a?(Class)
    user.admin? && (user.id != record.id)
  end

  class Scope < ApplicationScope
    private

    def resolve_for_role
      scope.where(id: user.id)
    end
  end
end
