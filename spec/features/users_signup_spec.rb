# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'UsersSignup', type: :feature do
  describe 'users signup' do
    before do
      ActionMailer::Base.deliveries.clear
    end
    context 'when valid signup information' do
      before do
        visit signup_path
      end
      scenario 'user count plus one' do
        fill_in 'Name',                  with: 'Example User'
        fill_in 'Email',                 with: 'user@example.com'
        fill_in 'Password',              with: 'password'
        fill_in 'Confirmation',          with: 'password'
        expect { click_on 'Create my account' }.to change { User.count }.by(1)
        expect(ActionMailer::Base.deliveries.size).to eq 1
        user = User.last
        expect(user.activated?).to be_falsey
        # 有効化していない状態でログインしてみる
        log_in_with_remember(user)
        expect(logged_on?(user)).to be_falsey
        # 有効化トークンが不正な場合
        visit edit_account_activation_path('invalid token', email: user.email)
        expect(logged_on?(user)).to be_falsey
        # ここ以下はあとで勉強
        mail = ActionMailer::Base.deliveries.last
        mail_body = mail.body.encoded
        mail_body.split('\r\n').detect { |s| s.start_with?('http') }
        activation_token = mail_body.split('/')[5]
        # トークンは正しいがメールアドレスが無効な場合
        visit edit_account_activation_path(activation_token, email: 'wrong')
        expect(logged_on?(user)).to be_falsey
        # 有効化トークンが正しい場合
        visit edit_account_activation_path(activation_token, email: user.email)
        expect(user.reload.activated?).to be_truthy
        expect(page).to have_selector 'h1', text: user.name
        expect(logged_on?(user)).to be_truthy
      end
    end

    context 'when invalid signup information' do
      before do
        visit signup_path
      end
      scenario 'display error messages' do
        fill_in 'Name', with: ' '
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        expect { click_button 'Create my account' }.to_not change { User.count }
        expect(page).to have_selector 'h1', text: 'Sign up'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
