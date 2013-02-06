class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index,:edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def new
    unless signed_in?
      @user = User.new
    else
    redirect_to root_path
    end
   # @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user=User.find(params[:id])
    @microposts=@user.microposts.paginate(page: params[:page])
  end
  
  def create
    
      @user = User.new(params[:user])
    
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
    
  end
  
  def edit
   # @user = User.find(params[:id])
  end
  
  def update
    #@user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if (user==current_user) && (current_user.admin?)
      flash[:error] = "Sorry! You can not delete admin."
    else
      user.destroy
      flash[:success] = "Successfully deleted"
    end
    redirect_to users_url
  end
  
  private
   
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end
  
  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
