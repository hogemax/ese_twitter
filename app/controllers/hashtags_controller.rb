class HashtagsController < ApplicationController
  def destroy
    Hashtag.find(params[:id]).destroy
    flash[:success] = 'Hashtag destroyed.'
    redirect_to root_url
  end
end
