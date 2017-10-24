class Home::UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('.success')
      auto_login(@user)
      redirect_to dashboard_user_path(@user)
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end
end
