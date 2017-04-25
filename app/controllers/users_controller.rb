class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.where(activated: true).paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.order_by_created.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "deleted"
      redirect_to users_url
    else
      flash[:danger] = t "not_delete"
      redirect_to users_url
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "user_exsit"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    unless @user.current_user? current_user
      flash[:danger] = t "login_other"
      redirect_to root_path
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
