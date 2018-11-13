require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:michael) }
  # belongs_to/has_manyで関連付けをした後でないとmicropostのmethod errorとなる
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  it 'is valid' do
    expect(micropost).to be_valid
  end

  context 'when user id nil' do
    before do
      micropost.user = nil
    end
    it 'user id is not present' do
      expect(micropost).to_not be_valid
    end
  end

  it 'content empty not present' do
    micropost.content = '   '
    expect(micropost).to_not be_valid
  end

  it 'content is at most 140 characters' do
    micropost.content = 'a' * 141
    expect(micropost).to_not be_valid
  end

  # context 'order' do
  #   let(:most_recent) { FactoryBot.create(:most_recent) }
  #   it 'order is most resent first' do
  #     expect(most_recent).to eq Micropost.first
  #   end
  # end

end
