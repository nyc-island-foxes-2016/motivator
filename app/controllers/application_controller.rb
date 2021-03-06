class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_news_feed

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end

  def authorize_user!
    redirect_to new_admin_session_path unless current_user.present?
  end

  def logged_in?
    !!current_user
  end

  private

    def load_news_feed
      @messages = Message.includes(:user, goal: :setter).order(created_at: :desc).limit(20)
    end

end
