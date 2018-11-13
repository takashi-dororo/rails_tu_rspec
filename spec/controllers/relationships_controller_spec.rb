require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:one) { FactoryBot.create(:one) }
  it 'create require logged-in user' do
    expect { post :create }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  context 'when not logged-in' do
    before do
      one
    end
    it 'destroy require logged-in user' do
      expect { delete :destroy, params: { id: one } }.to_not change { Relationship.count }
      expect(response).to redirect_to login_url
    end
  end

end
