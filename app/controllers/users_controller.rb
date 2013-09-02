class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index,:edit, :update, :destroy,:followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def new 
    unless signed_in?
      @user = User.new
    else
    redirect_to root_path
    end
  end

  def index
    @users = User.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.csv {send_data @users.to_csv}
      #format.xls {send_data @users.to_csv(col_sep: "\t")}
      format.xls
    end
  end

  def show
    @user=User.find(params[:id])
    @microposts=@user.microposts.paginate(include: :user, page: params[:page])
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
  end

  def update
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

  def following
    if signed_in?
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page])
      render 'show_follow'
    else
      flash[:notice]= "Please Sign in"
      redirect_to signin_path
    end  
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def import
    #User.import(params[:file])
    CSV.foreach(params[:file].path, headers: true) do |row|
      @user = User.new row.to_hash
      @user.save
    end
    flash[:success] = "Users imported!"
    redirect_to users_path
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
