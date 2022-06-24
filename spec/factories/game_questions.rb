# frozen_string_literal: true

FactoryBot.define do
  factory :game_question do
    association :game
    association :question

    # всегда одинаковое распределение ответов
    a { 4 }
    b { 3 }
    c { 2 }
    d { 1 }
  end
end
