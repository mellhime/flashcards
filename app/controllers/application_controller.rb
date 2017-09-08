class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception

  before_action :require_login, except: [:not_authenticated]

  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
