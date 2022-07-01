# frozen_string_literal: true

# (c) goodprogrammer.ru

require 'rails_helper'
require 'support/my_spec_helper' # наш собственный класс с вспомогательными методами
require 'support/factory_bot'

# Тестовый сценарий для модели Игры
# В идеале - все методы должны быть покрыты тестами,
# в этом классе содержится ключевая логика игры и значит работы сайта.
RSpec.describe Game, type: :model do
  # пользователь для создания игр
  let(:user) { create(:user) }

  # игра с прописанными игровыми вопросами
  let(:game_w_questions) { create(:game_with_questions, user: user) }

  # Группа тестов на работу фабрики создания новых игр
  context 'Game Factory' do
    it 'Game.create_game! new correct game' do
      # генерим 60 вопросов с 4х запасом по полю level,
      # чтобы проверить работу RANDOM при создании игры
      generate_questions(60)

      game = nil
      # создaли игру, обернули в блок, на который накладываем проверки
      expect {
        game = Game.create_game_for_user!(user)
      }.to change(Game, :count).by(1).and( # проверка: Game.count изменился на 1 (создали в базе 1 игру)
        change(GameQuestion, :count).by(15).and( # GameQuestion.count +15
          change(Question, :count).by(0) # Game.count не должен измениться
        )
      )
      # проверяем статус и поля
      expect(game.user).to eq(user)
      expect(game.status).to eq(:in_progress)
      # проверяем корректность массива игровых вопросов
      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end
  
  # тесты на основную игровую логику
  context 'game mechanics' do
    # правильный ответ должен продолжать игру
    it 'answer correct continues game' do
      # текущий уровень игры и статус
      level = game_w_questions.current_level
      question = game_w_questions.current_game_question
      expect(game_w_questions.status).to eq(:in_progress)

      game_w_questions.answer_current_question!(question.correct_answer_key)

      # перешли на след. уровень
      expect(game_w_questions.current_level).to eq(level + 1)
      # ранее текущий вопрос стал предыдущим
      expect(game_w_questions.previous_game_question).to eq(question)
      expect(game_w_questions.current_game_question).not_to eq(question)
      # игра продолжается
      expect(game_w_questions.status).to eq(:in_progress)
      expect(game_w_questions.finished?).to be_falsey
    end
  end

  describe '#take_money!' do
    context 'corect take_money!' do
      it 'take_money! finishes the game' do
        game = game_w_questions.current_game_question

        game_w_questions.answer_current_question!(game.correct_answer_key)

        game_w_questions.take_money!

        prize = game_w_questions.prize

        expect(prize).to be > 0

        expect(game_w_questions.status).to eq(:money)
        expect(user.balance).to eq(prize)
      end
    end
  end

  # Группа тeстoв на метоd .status модели Game

  describe '#status' do
    context 'test .status' do
      before(:each) do
        game_w_questions.finished_at = Time.now
        expect(game_w_questions.finished?).to be_truthy
      end

      it ':money' do
        game_w_questions.take_money!

        expect(game_w_questions.status).to eq(:money)
      end

      it ':won' do
        game_w_questions.current_level = Question::QUESTION_LEVELS.max + 1

        expect(game_w_questions.status).to eq(:won)
      end

      it ':fail' do
        game_w_questions.is_failed = true

        expect(game_w_questions.status).to eq(:fail)
      end

      it ':timeout' do
        game_w_questions.created_at = 45.minutes.ago
        game_w_questions.is_failed = true

        expect(game_w_questions.status).to eq(:timeout)
      end
    end
  end

  # Тeст на метод  current_game_question модели Game
  describe '#current_game_question' do
    context 'correct .current_game_question' do
      it 'return game question unanswered' do
        expect(game_w_questions.current_game_question).to eq(game_w_questions.game_questions.first)
      end
    end
  end

  # Тeст на метод  previous_level модели Game
  describe '#previous_level' do
    context 'correct .previous_level' do
      it 'return previous_level' do
        question = game_w_questions.current_game_question
        game_w_questions.answer_current_question!(question.correct_answer_key)

        expect(game_w_questions.previous_level).to eq(0)
      end
    end
  end

  # Группа тестов answer_current_question

  describe '#answer_current_question!' do
    before { game_w_questions.answer_current_question!(answer_key) }
    
    context 'when answer is correct' do
      let!(:level) { game_w_questions.current_level }
      let!(:answer_key) { game_w_questions.current_game_question.correct_answer_key }

    
      context 'and question is last' do
        let!(:level) { Question::QUESTION_LEVELS.max }
        let!(:game_w_questions) { create(:game_with_questions, user: user, current_level: level) }

        it 'should return level 15' do
          expect(game_w_questions.current_level).to eq(level + 1)
        end

        it 'should assign final prize' do
          expect(game_w_questions.prize).to eq(Game::PRIZES[level])
        end

        it 'should finish game with status won' do
          expect(game_w_questions.status).to eq :won
        end

      end

      context 'and question is not last' do
        it 'should move to next level' do
          expect(game_w_questions.current_level).to eq 1
        end

        it 'should return status :in_progress' do
          expect(game_w_questions.status).to eq :in_progress
        end
  
        it 'should continue game' do
          expect(game_w_questions.finished?).to be_falsey
        end
      end

      context 'and time is over' do
        let!(:game_w_questions) { create(:game_with_questions, user: user, created_at: 45.minutes.ago ) }
  
        it 'should finish game with status timeout' do
          expect(game_w_questions.status).to eq :timeout
        end
      end
    end

    context 'when answer is wrong' do
      let!(:answer_key) { game_w_questions.answer_current_question!("a") }
  
      it 'should finish the game' do
        expect(game_w_questions.finished?).to be_truthy
      end
  
      it 'should finish with status fail' do
        expect(game_w_questions.status).to eq :fail
      end
    end
  end
end
