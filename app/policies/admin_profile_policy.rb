class AdminProfilePolicy < ProfilePolicy
  def destroy?
    return true if user.admin? && record.is_a?(Class)
    user.admin? && (user.id != record.user_id)
  end

  def edit?
    return true if user.admin? && record.is_a?(Class)
    user.admin? && (user.id != record.user_id)
  end

  def permitted_attributes(action = nil)
    result = super(action)
    case action
    when 'edit'
      result - (user.profile.id == record.id ? %i[type user] : [])
    when 'create'
      result - %i[type]
    else
      result
    end
  end
end
