class CitationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @micropost = Micropost.find(params[:citation][:repost_id])
    Micropost.repost!(@micropost)
    redirect_to @micropost
  end

  def destroy
    @micropost = Citation.find(params[:id]).reposted
    @micropost.destroy
  end
end
