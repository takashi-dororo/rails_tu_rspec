# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Following', type: :feature do
  let(:user) { FactoryBot.create(:michael) }
  let(:other) { FactoryBot.create(:archer) }
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

  describe 'follow' do
    context 'when the standard way' do
      before do
        visit user_path(other)
      end
      scenario 'follow a user' do
        expect { click_button 'Follow' }.to change { user.following.count }.by(1)
      end
    end
    context 'with Ajax' do
      before do
        visit user_path(other)
      end
      scenario 'follow a user' do
        expect(page).to have_selector '[data-remote="true"]'
        expect { click_button 'Follow' }.to change { user.following.count }.by(1)
      end
    end
  end

  describe 'unfollow' do
    let(:relationship) { user.active_relationships.find_by(followed_id: other.id) }
    context 'when the standard way' do
      before do
        user.follow(other)
        visit user_path(other)
      end
      scenario 'unfollow a user' do
        expect { click_button 'Unfollow' }.to change { user.following.count }.by(-1)
      end
    end
    context 'with Ajax' do
      before do
        user.follow(other)
        visit user_path(other)
      end
      scenario 'follow a user' do
        expect(page).to have_selector '[data-remote="true"]'
        expect { click_button 'Unfollow' }.to change { user.following.count }.by(-1)
      end
    end
  end
end
