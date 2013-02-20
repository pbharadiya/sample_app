class StaticPagesController < ApplicationController
  def home
    if signed_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page]) 
    #render :text=>  @feed_items.inspect and return false

    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
