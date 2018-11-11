require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation }
    let(:user) { FactoryBot.create(:michael) }
    # context 'when mail send display' do
    #   before do
    #     user.activation_token = User.new_token
    #   end
    #   it 'display variable contents' do
    #     # expect(mail).to have_attributes subject: 'Account activation', to: [user.email], from: ['from@example.com']
    #     expect(mail.body.encoded).to match user.name
    #     expect(mail.body.encoded).to match user.activation_token
    #     expect(mail.body.encoded).to match CGI.escape(user.email)
    #   end
    # end
  end

end
