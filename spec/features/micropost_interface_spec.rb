require 'rails_helper'

RSpec.feature 'MicropostInterface', type: :feature do
  describe 'Micropost interface' do
    let(:user){ FactoryBot.create(:michael) }
    let(:another_user) { FactoryBot.create(:archer) }
    context 'when micropost interface' do
      before do
        log_in_with_remember(user)
        visit root_path
      end

      scenario 'various input' do
        # 無効な送信
        fill_in 'micropost_content', with: ''
        expect{ click_button 'Post' }.to_not change { Micropost.count }
        expect(page).to have_selector 'div#error_explanation'

        # 有効な送信
        content = 'This micropost really ties the room together'
        fill_in 'micropost_content', with: content
        expect{ click_button }.to change { Micropost.count }.by(1)
        expect(current_path).to eq root_path
        expect(page).to have_content content

        # 投稿を削除する
        expect(page).to have_selector 'a[data-method=delete]', text: 'delete'
        first_micropost = user.microposts.paginate(page: 1).first
        expect{ click_link 'delete', href: micropost_path(first_micropost) }.to change { Micropost.count}.by(-1)

        # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
        visit user_path(another_user)
        expect(page).to_not have_link 'delete'
      end
    end
  end
end
