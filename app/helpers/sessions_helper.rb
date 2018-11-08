module SessionsHelper

  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue
  # current_user.presentではダメなのか？
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する

  def forget(_user)
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end