class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controller.password.create.email_with_resetpass"
      redirect_to root_url
    else
      flash.now[:danger] = t "controller.password.create.email_notfound"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].present?
      if @user.update_attributes user_params
        log_in @user
        @user.update_attributes reset_digest: nil
        flash[:success] = t "controller.password.update.pass_reseted"
        redirect_to @user
      else
        render :edit
      end
    else
      @user.errors.add :password, :blank
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "controller.user.find_by.cannot_find"
  end

  def valid_user
    return if @user&.activated? &&
              @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controller.password.check_expiration.expired"
    redirect_to new_password_reset_url
  end
end
