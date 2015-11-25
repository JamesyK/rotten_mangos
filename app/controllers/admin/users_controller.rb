class Admin::UsersController < ApplicationController

  before_action :admin?

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Successfully created user, #{@user.firstname}!"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  def swap_account
    if pseudo_user
      session[:user_id] = pseudo_user.id
      session[:admin_id] = nil
      redirect_to admin_users_path
    else
      session[:admin_id] = current_user.id
      session[:user_id] = params[:id]
      redirect_to root_path
    end
  end

  private

  def admin?
    redirect_to root_path, flash: { user: "Must be an admin." } unless current_user.admin || pseudo_user.admin
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

end
