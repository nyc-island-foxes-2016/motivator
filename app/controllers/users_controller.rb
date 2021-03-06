class UsersController < ApplicationController

  def index
    @users = User.real_users
  end

  def new
    @user = User.new
  end

  def show
    if params[:notification]
      @goal = Goal.find_by(id: params[:goal])
      @goal.update_attributes(notification: params[:notification])
    end

    @user = User.includes(:set_goals, :tended_goals).find_by(id: params[:id])
    @pledges = @user.pledges.includes(:goal)
    @messages = @user.load_news_feed
  end

  def create
    puts Rails.application.config.action_mailer.smtp_settings
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      session[:user_id] = @user.id
      redirect_to user_path(id: @user.id)
    else
      @errors = @user.errors.full_messages
      render new_user_path
    end
  end

  private

  def user_params
    user_params = params.require(:user).permit(:username, :email, :password)
  end

end