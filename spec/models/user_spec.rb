# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 名前がなければ無効な状態であること
  it 'is invalid without a name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 名前の長さの上限が50であること
  it 'is invalid with a name too long' do
    user = User.new(name: 'a' * 51)
    user.invalid?
    expect(user).to be_invalid
  end

  # メールアドレスの長さの上限が255であること
  it 'is invalid with an email address length too long' do
    user = User.new(email: 'a' * 244 + '@example.com')
    user.invalid?
    expect(user).to be_invalid
  end

  # 有効なメールアドレスのフォーマットの検証
  it 'is valid with an email format' do
    valid_addresses = %w[user@example.com USER@foo.COM A_USER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user = FactoryBot.build(:user)
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  # 無効なメールアドレスのフォーマット検証
  it 'is invalid with an email format' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user = FactoryBot.build(:user, email: nil)
      user.email = invalid_address
      expect(user).to be_invalid, "#{invalid_address.inspect} should be invalid"
    end
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    User.create(name: 'John', email: 'tester@example.com',
                password: 'foobar', password_confirmation: 'foobar')

    user = User.new(name: 'June', email: 'tester@example.com',
                    password: 'foobar', password_confirmation: 'foobar')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  # パスワードが空白では無効である
  it 'is invalid without a password present' do
    user = FactoryBot.build(:user)
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to be_invalid
  end

  # パスワードの文字数が最低６文字なけらばらない
  it 'is invalid without a password length minimum' do
    user = FactoryBot.build(:user)
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to be_invalid
  end

  describe 'authenticated' do
    context 'when a user with nil digest' do
      it 'return false authenticated?' do
        user = User.create(name: 'John', email: 'tester@example.com',
                           password: 'foobar', password_confirmation: 'foobar')
        expect(user).to_not be_authenticated(:remember, '')
      end
    end
  end

  describe 'associated microposts' do
    context 'when user id delete' do
      user = User.new(name: 'Exmple User', email: 'user@example.com',
                      password: 'foobar', password_confirmation: 'foobar')
      it 'is destroyed with microposts' do
        user.save
        user.microposts.create!(content: 'Lorem ipsum')
        expect { user.destroy }.to change { Micropost.count }.by(-1)
      end
    end
  end

  describe 'follow and follwer' do
    let(:michael) { FactoryBot.create(:michael) }
    let(:archer) { FactoryBot.create(:archer) }
    context 'when a user following' do
      it 'user follow other' do
        expect(michael.following?(archer)).to be_falsey
        michael.follow(archer)
        expect(michael.following?(archer)).to be_truthy
        expect(archer.followers.include?(michael)).to be_truthy
        michael.unfollow(archer)
        expect(michael.following?(archer)).to be_falsey
      end
    end
  end
end
