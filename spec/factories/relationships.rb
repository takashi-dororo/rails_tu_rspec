# frozen_string_literal: true

FactoryBot.define do
  factory :one, class: Relationship do
    association :follower, factory: :michael
    association :followed, factory: :lana
  end

  # factory :two, class: Relationship do
  #   association :follower, factory: :michael
  #   asscciation :followed, factory: :malory
  # end
  #
  # factory :three, class: Relationship do
  #   association :follower, factory: :lana
  #   asscciation :followed, factory: :michael
  # end
  #
  # factory :four, class: Relationship do
  #   association :follower, factory: :archer
  #   asscciation :followed, factory: :michael
  # end
end
