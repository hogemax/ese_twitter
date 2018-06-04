class UsersController < ApplicationController
  before_action :authenticate_user!, :except=>[:show]
  before_action :admin_user,     only: :destroy
  def index
    #@users = User.paginate(page: params[:page])
    @users = User.paginate(page: params[:page]).name_like(params[:search])
    @searched_text = params[:search]
  end

  def show
    @user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(:page => params[:page])
    @microposts = @user.microposts.paginate(:page => params[:page]).search(params[:search])
    @micropost = Micropost.new
    @likes = Like.where(micropost_id: params[:micropost_id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
