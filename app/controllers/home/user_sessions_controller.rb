module Home
  class UserSessionsController < ApplicationController
    skip_before_action :require_login

    def new
      @user = User.new
    end

    def create
      if @user = login(params[:email], params[:password])
        flash[:success] = t('.success')
        redirect_back_or_to(:home_users)
      else
        flash.now[:danger] = t('.danger')
        render action: 'new'
      end
    end
  end
end
