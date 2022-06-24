# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    # Ответы сделаем рандомными для красоты
    answer1 { rand(2001).to_s }
    answer2 { rand(2001).to_s }
    answer3 { rand(2001).to_s }
    answer4 { rand(2001).to_s }

    sequence(:text) { |n| "В каком году была космическая одиссея #{n}?" }

    sequence(:level) { |n| n % 15 }
  end
end
