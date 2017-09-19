class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      flash[:notice] = "Logged in using #{provider.titleize}!"
      redirect_to users_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        flash[:notice] = "Logged in from #{provider.titleize}!"
        redirect_to users_path
      rescue
        flash[:alert] = "Failed to login from #{provider.titleize}!"
        redirect_to users_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
