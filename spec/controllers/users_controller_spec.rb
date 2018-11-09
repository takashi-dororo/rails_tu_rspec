require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:michael) }
  let(:other_user) { FactoryBot.create(:archer)}

  describe 'Get #index' do
    context 'when not logged in' do
      it 'redirect to index' do
        get :index
        expect(response.status).to eq 302
        expect(response).to redirect_to(login_url) 
      end
    end
  end

  describe 'Get #new' do
    it 'returns http success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'Get #edit and Patch #update' do
    context 'when not logged in edit' do
      before do
        get :edit, params: { id: user }
      end
      it 'redirect to login url' do
        expect(flash).to be_present
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when not logged in update' do
      before do
        patch :update, params: { id: user, user: FactoryBot.attributes_for(:user) }
      end
      it 'success update' do
        expect(response.status).to eq 302
        expect(flash).to be_present
      end
      it 'redirect to login url' do
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when logged in a wrong user' do
      before do
        log_in_as(other_user)
      end
      it 'edit redirect to root_url' do
        get :edit, params: { id: user }
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end

      it 'update redirect to root_url' do
        patch :update, params: { id: user, user: FactoryBot.attributes_for(:user) }
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end
    end
  end

end
