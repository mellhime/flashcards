class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception
  before_action :require_login, except: [:not_authenticated]
  before_action :set_locale

  private

  def set_locale
    I18n.locale = if current_user
                    current_user.locale
                  elsif params[:locale]
                    params[:locale]
                  else
                    http_accept_language.compatible_language_from(I18n.available_locales)
                  end
  end

  def not_authenticated
    redirect_to login_path, notice: I18n.t('layouts.application.notice')
  end
end
