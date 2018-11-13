# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { FactoryBot.build(:one) }

  it 'is valid' do
    expect(relationship).to be_valid
  end

  context 'folower_id' do
    before do
      relationship.follower_id = nil
    end
    it 'is require a follower_id' do
      expect(relationship).to_not be_valid
    end
  end

  context 'followed_id' do
    before do
      relationship.followed_id = nil
    end
    it 'is require a followed_id' do
      expect(relationship).to_not be_valid
    end
  end
end
