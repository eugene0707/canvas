class ProfilePolicy < ApplicationPolicy
  def permitted_attributes(action = nil)
    super(action) - %i[user_id]
  end
end
