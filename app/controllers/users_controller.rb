class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_by, only: [:show, :edit, :update, :correct_user, :destroy]

  def index
    @users = User.where(activated: true).paginate page: params[:page],
      per_page: Settings.paginate.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.user.create.check_email"
      redirect_to root_url
    else
      flash[:danger] = t "controller.user.create.error"
      render :new
    end
  end

  def show
    return redirect_to root_path unless @user&.activated
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.paginate.per_page
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.user.update.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.user.destroy.deleted"
      redirect_to users_url
    else
      flash[:warning] = t "controller.user.update.update_false"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.user.logged.please_loggin"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_by
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.find_by.cannot_find"
  end
end
