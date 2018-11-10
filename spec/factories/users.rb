FactoryBot.define do
  factory :michael, class: User do
    name { 'Michael Example' }
    email { 'michael@example.com' }
    password { 'password' }
    password_digest { User.digest('password') }
    admin true
  end

  factory :archer, class: User do
    name { 'Sterling Archer' }
    email { 'duchess@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :lana, class: User do
    name { 'Lana Kane' }
    email { 'hands@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :malory, class: User do
    name {'Malory Archer' }
    email  { 'boss@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :user, class: User do
    sequence(:name) do |n|
      "User #{n}"
    end
    sequence(:email) do |n|
      "user-#{n}@example.com"
    end
    password { 'password' }
    password_digest { User.digest('password') }
  end
end
