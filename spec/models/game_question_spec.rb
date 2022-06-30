# frozen_string_literal: true

# (c) goodprogrammer.ru

require 'rails_helper'

# Тестовый сценарий для модели игрового вопроса,
# в идеале весь наш функционал (все методы) должны быть протестированы.
RSpec.describe GameQuestion, type: :model do
  # задаем локальную переменную game_question, доступную во всех тестах этого сценария
  # она будет создана на фабрике заново для каждого блока it, где она вызывается
  let(:game_question) { FactoryBot.create(:game_question, a: 2, b: 1, c: 4, d: 3) }

  # группа тестов на игровое состояние объекта вопроса
  context 'game status' do
    it 'correct .variants' do
      expect(game_question.variants).to eq({ 'a' => game_question.question.answer2,
                                             'b' => game_question.question.answer1,
                                             'c' => game_question.question.answer4,
                                             'd' => game_question.question.answer3 })
    end

    it 'correct .answer_correct?' do
      # именно под буквой b в тесте мы спрятали указатель на верный ответ
      expect(game_question.answer_correct?('b')).to be_truthy
    end
  end

  # help_hash у нас имеет такой формат:
  # {
  #   fifty_fifty: ['a', 'b'], # При использовании подсказски остались варианты a и b
  #   audience_help: {'a' => 42, 'c' => 37 ...}, # Распределение голосов по вариантам a, b, c, d
  #   friend_call: 'Василий Петрович считает, что правильный ответ A'
  # }
  #

  describe "#help_hash" do
    it "correct .help_hash" do
      expect(game_question.help_hash).to eq ({})

      game_question.help_hash[:hint] = 'a'
      game_question.help_hash['hint'] = 'c'
      
      expect(game_question.save).to be_truthy
      bd = GameQuestion.find(game_question.id)

      expect(bd.help_hash).to eq({:hint=>"a", "hint"=>"c"})
    end
  end

  describe '#add_fifty_fifty' do
    context 'when fifty_fifty not used' do
      it 'should return hint not used' do
        expect(game_question.help_hash).not_to include(:fifty_fifty)
      end
    end

    context 'when fifty_fifty used' do
      before { game_question.add_fifty_fifty }
      let!(:variants) { game_question.help_hash[:fifty_fifty] }

      it 'should return hint used' do
        expect(game_question.help_hash).to include(:fifty_fifty)
      end

      it 'return correct variant' do
        expect(variants).to include('b')
      end

      it 'return size variants' do
        expect(variants.size).to eq(2)
      end
    end
  end

  describe '#add_friend_call' do
    context 'when friend_call not used' do
      it 'should return hint not used' do
        expect(game_question.help_hash).not_to include(:friend_call)
      end
    end

    context 'when friend_call used' do
      before { game_question.add_friend_call }
      let!(:variant) { game_question.help_hash[:friend_call] }

      it 'should return hint used' do
        expect(game_question.help_hash).to include(:friend_call)
      end

      it 'return correct variant' do
        expect(game_question.help_hash).to include({ friend_call: variant })
      end
    end
  end

  describe '#add_audience_help' do
    context 'when audience_help not used' do
      it 'should return hint not used' do
        expect(game_question.help_hash).not_to include(:audience_help)
      end
    end

    context 'when audience_help used' do
      before { game_question.add_audience_help }
      let!(:variant) { game_question.help_hash[:audience_help] }

      it 'should return hint used' do
        expect(game_question.help_hash).to include(:audience_help)
      end

      it 'return correct variant' do
        expect(variant.keys).to contain_exactly('a', 'b', 'c', 'd')
      end
    end

  end

  describe '#text & #level' do
    it 'correct .level & .text delegates' do
      expect(game_question.text).to eq(game_question.question.text)
      expect(game_question.text).to eq(game_question.question.text)
    end
  end

  # # ключ правильного ответа 'a', 'b', 'c', или 'd' correct_answer_key
  describe '#correct_answer_key' do
    it 'returns the correct key' do
      expect(game_question.correct_answer_key).to eq('b')
      expect(game_question.correct_answer_key).to_not eq('g')
    end
  end
end
