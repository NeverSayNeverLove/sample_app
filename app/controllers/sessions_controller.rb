class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      activation
    else
      flash.now[:danger] = t "controller.session.create.can_not_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_user user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def activation
    if user.activated?
      log_in user
      remember_user user
      redirect_back_or user
    else
      flash[:warning] = t "controller.sesion.create.cannot_activated"
      redirect_to root_url
    end
  end
end
