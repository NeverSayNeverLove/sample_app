class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controller.user.create.wellcome"
      redirect_to @user
    else
      flash[:danger] = t "controller.user.create.error"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.show.notfind"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
