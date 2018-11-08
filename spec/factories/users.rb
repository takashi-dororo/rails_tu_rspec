FactoryBot.define do
  factory :michael do
    name { 'Michael Example' }
    email { 'michael@example.com' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :archer do
    name { 'Sterling Archer' }
    email { 'duchess@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :lana do
    name { 'Lana Kane' }
    email { 'hands@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :malory do
    name {'Malory Archer' }
    email  { 'boss@example.gov' }
    password { 'password' }
    password_digest { User.digest('password') }
  end

  factory :user do
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
