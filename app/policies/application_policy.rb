class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Warden::NotAuthenticated if user.nil?
    @user = user
    @record = record
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def edit?
    update?
  end

  def new?
    create?
  end

  def create?
    user.admin?
  end

  def export?
    user.admin?
  end

  def dashboard?
    true
  end

  def permitted_attributes(_action = nil)
    (record.class.reflections.keys + record.attributes.keys).map(&:to_sym) -
      %i[id created_at updated_at]
  end

  class ApplicationScope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Warden::NotAuthenticated if user.nil?
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        resolve_for_role
      end
    end

    private

    def resolve_for_role
      scope.none
    end
  end
end
