class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :require_current_user, only: :destroy
  def create
    @micropost = current_user&.microposts.build(micropost_params)
    @micropost.image.attach(micropost_params[:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Your post was deleted"
    # referrer will sometimes be nil in tests
    redirect_back_or_to(root_url, status: :see_other)
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end
  
  def require_current_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @micropost.nil?
  end
end
