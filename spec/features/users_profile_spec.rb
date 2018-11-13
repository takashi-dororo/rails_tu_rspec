# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'UsersProfile', type: :feature do
  include ApplicationHelper # いるのか？
  let(:user) { FactoryBot.create(:user) }
  context 'when show user page' do
    before do
      visit user_path(user)
    end
    scenario 'display microposts' do
      expect(current_path).to eq user_path(user)
      expect(page).to have_title full_title(user.name)
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_selector 'h1>img.gravatar'
      # expect(page).to have_content user.microposts.content
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end
end
