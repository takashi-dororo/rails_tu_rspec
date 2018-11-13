# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:mail) { UserMailer.account_activation(user) }
  let(:user) { FactoryBot.create(:michael) }
  describe 'account_activation' do
    context 'when activatite account sent email' do
      before do
        user.activation_token = User.new_token
      end
      it 'display variable contents' do
        expect(mail).to have_attributes subject: 'Account activation', to: [user.email], from: ['noreply@example.com']
        expect(mail.body.encoded).to match user.name
        expect(mail.body.encoded).to match user.activation_token
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }
    let(:user) { FactoryBot.create(:michael) }
    context 'when password reset sent email' do
      before do
        user.reset_token = User.new_token
      end
      it 'display variable contents' do
        expect(mail).to have_attributes subject: 'Password reset', to: [user.email], from: ['noreply@example.com']
        expect(mail.body.encoded).to match user.reset_token
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
  end
end
