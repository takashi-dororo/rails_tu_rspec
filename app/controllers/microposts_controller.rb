# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :current_micropost, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to(root_url)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url # referrer 一つ前のURLを返す
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def current_micropost
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to(root_url) if @micropost.nil?
  end
end
