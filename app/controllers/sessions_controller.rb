class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = t "not_act"
        message += t "check_act"
        flash[:warning] = message
        redirect_to root_path
      end
    else
      # Create an error message.
      flash.now[:danger] = t "errlogin"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t "nodata"
  end
end
