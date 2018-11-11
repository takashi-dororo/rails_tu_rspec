class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] #パスワード再設定の有効期限がきれていないか

  def new
  end


  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to(root_url)
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank) # 空文字になっていた場合
      render 'edit'
    elsif @user.update_attributes(user_params) # 新しいパスワードが有効なら、更新
      log_in(@user)
      flash[:success] = 'Password has been reset.'
      redirect_to(@user)
    else
      render 'edit' # 無効なパスワードであれば失敗する
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to(root_url)
      end
    end

    # トークンが有効切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.'
        redirect_to(new_password_reset_url)
      end
    end
end
