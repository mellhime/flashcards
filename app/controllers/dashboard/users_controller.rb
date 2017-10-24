class Dashboard::UsersController < ApplicationController
  before_action :find_user, only: [:show, :destroy]

  def show; end

  def edit
    @user = current_user
    @locales = Rails.configuration.i18n.available_locales
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = t('.success')
      redirect_to dashboard_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to home_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
