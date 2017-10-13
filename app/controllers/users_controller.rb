class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create, :change_locale]
  before_action :find_user, only: [:show, :destroy]

  def show; end

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
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @locales = Rails.configuration.i18n.available_locales
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = t('.success')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
