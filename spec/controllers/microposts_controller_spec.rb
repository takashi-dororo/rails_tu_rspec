require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:michael) }
  let(:micropost) { FactoryBot.create(:ants) }

  context 'when not logged in' do
    it 'redirect create' do
      expect{ post :create, params: { micropost: { content: 'Lorem ipsum' } } }.to_not change { Micropost.count }
      expect(response).to redirect_to login_url
    end
    before do
      micropost
    end
    it 'redirect destroy' do
      expect{ delete :destroy, params: { id: micropost } }.to_not change { Micropost.count }
      expect(response).to redirect_to login_url
    end
  end

  context 'when logged in other user' do
    before do
      log_in_as(user)
      micropost
    end
    it 'redirect destroy' do
      expect { delete :destroy, params: { id: micropost } }.to_not change { Micropost.count}
      expect(response).to redirect_to root_url
    end
  end
end
