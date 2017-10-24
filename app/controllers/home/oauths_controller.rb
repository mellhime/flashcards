module Home
  class OauthsController < ApplicationController
    skip_before_action :require_login

    def oauth
      login_at(auth_params[:provider])
    end

    def callback
      provider = auth_params[:provider]
      if @user = login_from(provider)
        flash[:success] = t('.success')
        redirect_to home_users_path
      else
        begin
          @user = create_from(provider)
          reset_session
          auto_login(@user)
          flash[:success] = t('.success')
          redirect_to home_users_path
        rescue
          flash[:danger] = t('.danger')
          redirect_to home_users_path
        end
      end
    end

    private

    def auth_params
      params.permit(:code, :provider)
    end
  end
end
