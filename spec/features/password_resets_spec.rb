require 'rails_helper'

RSpec.feature 'PasswordResets', type: :feature do
  let(:user) { FactoryBot.create(:michael) }
  context 'password reset' do
    before do
      ActionMailer::Base.deliveries.clear
      visit new_password_reset_path
    end
    scenario 'when password resets' do
      expect(page).to have_selector 'h1', text: 'Forgot password'

      # メールアドレスが無効
      fill_in 'Email', with: ''
      click_button 'Submit'
      expect(page).to have_selector '.alert'
      expect(page).to have_selector 'h1', text: 'Forgot password'

      # メールアドレスが有効
      fill_in 'Email', with: user.email
      click_button 'Submit'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(user.reload.reset_digest).to eq user.reset_digest
      expect(page).to have_selector '.alert'
      expect(current_path).to eq root_path

      # パスワード再設定用フォーム
      mail = ActionMailer::Base.deliveries.last
      reset_token = mail.body.encoded[%r{(?<=password_resets\/)[^\/]+}]

      # メールアドレスが無効
      visit edit_password_reset_path(reset_token, email: '')
      expect(current_path).to eq root_path

      # 無効なユーザー
      user.toggle!(:activated)
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(current_path).to eq root_path
      user.toggle!(:activated)

      # メールアドレスが有効で、トークンが無効
      visit edit_password_reset_path('wrong token', email: user.email)
      expect(current_path).to eq root_path

      # メールアドレスが有効で、トークンも有効
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(page).to have_selector 'h1', text: 'Reset password'
      expect(find('input[name=email]', visible: false).value).to eq user.email

      # 無効なパスワードとパスワード確認
      fill_in 'Password',     with: 'foobaz'
      fill_in 'Confirmation', with: 'barquux'
      click_button 'Update password'
      expect(page).to have_selector 'div#error_explanation'

      # パスワードが空
      fill_in 'Password',     with: ''
      fill_in 'Confirmation', with: ''
      expect(page).to have_selector 'div#error_explanation'

      # 有効なパスワードとパスワード確認
      fill_in 'Password',     with: 'foobaz'
      fill_in 'Confirmation', with: 'foobaz'
      click_button 'Update password'
      expect(logged_on?(user)).to be_truthy
      expect(page).to have_selector '.alert'
      expect(current_path).to eq user_path(user)
    end
  end
end
