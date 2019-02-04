module Cabinet
  class DashboardController < BaseController
    def dashboard
      authorize current_user
    end
  end
end
