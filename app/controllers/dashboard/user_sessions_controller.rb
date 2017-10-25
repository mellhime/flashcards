module Dashboard
  class UserSessionsController < ApplicationController
    skip_before_action :require_login, except: [:destroy]

    def destroy
      logout
      redirect_to(:home_users, notice: t('.notice'))
    end
  end
end
