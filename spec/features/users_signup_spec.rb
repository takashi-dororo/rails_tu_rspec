require 'rails_helper'

RSpec.feature 'UsersSignup', type: :feature do
  describe 'users signup' do
    context 'when valid signup information' do
      before do
        visit signup_path
      end
      scenario 'user count plus one' do
        fill_in 'Name',                  with: 'Example User'
        fill_in 'Email',                 with: 'user@example.com'
        fill_in 'Password',              with: 'password'
        fill_in 'Confirmation',          with: 'password'
        expect { click_on 'Create my account' }.to change { User.count }.by(1)
        user = User.last
        visit user_path(user)
      end
    end

    context 'when invalid signup information' do
      before do
        visit signup_path
      end
      scenario 'display error messages' do
        fill_in 'Name', with: ' '
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        expect { click_button 'Create my account' }.to_not change { User.count }
        expect(page).to have_selector 'h1', text: 'Sign up'
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
