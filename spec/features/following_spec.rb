# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Following', type: :feature do
  let(:user) { FactoryBot.create(:michael) }
  before do
    log_in_with_remember(user)
  end

  describe 'following and followers page' do
    context 'when following' do
      before do
        visit following_user_path(user)
      end
      scenario 'display page' do
        # expect(user.following.empty?).to_not be_truthy
        expect(page).to have_content user.following.count
        user.following.each do |user|
          expect(page).to have_link nil, href: user_path(user)
        end
      end
    end

    context 'when followers' do
      before do
        visit followers_user_path(user)
      end

      scenario 'display page' do
        # expect(user.followers.empty?).to be_falsey
        expect(page).to have_content user.followers.count
        user.followers.each do |user|
          expect(page).to have_link nil, href: user_path(user)
        end
      end
    end
  end
end
