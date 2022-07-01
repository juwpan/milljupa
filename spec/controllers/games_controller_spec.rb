# (c) goodprogrammer.ru

require 'rails_helper'
require 'support/my_spec_helper' # наш собственный класс с вспомогательными методами
require 'support/factory_bot'

# Тестовый сценарий для игрового контроллера
# Самые важные здесь тесты:
#   1. на авторизацию (чтобы к чужим юзерам не утекли не их данные)
#   2. на четкое выполнение самых важных сценариев (требований) приложения
#   3. на передачу граничных/неправильных данных в попытке сломать контроллер
#
RSpec.describe GamesController, type: :controller do
  # обычный пользователь
  let(:user) { create(:user) }
  # админ
  let(:admin) { create(:user, is_admin: true) }
  # игра с прописанными игровыми вопросами
  let(:game_w_questions) { create(:game_with_questions, user: user) }

  describe '#show' do
    context 'when Guest' do
      before { get :show, params: { id: game_w_questions.id }}

      it 'return status 302' do
        expect(response.status).to eq(302)
      end

      it 'return reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'return flash alert' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'when user authorized' do
      before { sign_in user }
      before { get :show, params: { id: game_w_questions.id }}
      let!(:game) { assigns(:game) }

      it 'return game continues' do
        expect(game.finished?).to be false
      end

      it 'return user game' do
        expect(game.user).to eq(user)
      end

      it 'return status 200' do
        expect(response.status).to eq(200)
      end

      it 'return user sees his game' do
        expect(response).to render_template('show')
      end

      context "when someone else's game" do
        let(:alien_game) { create(:game_with_questions) }
        before { get :show, params: { id: alien_game.id }}
    
        it 'return status 302' do
          expect(response.status).to eq(302) # статус не 200 ОК
        end

        it 'return root_path' do
          expect(response).to redirect_to(root_path)
        end

        it 'return flash alert' do
          expect(flash[:alert]).to eq(I18n.t('controllers.games.not_your_game'))
        end
      end
    end
  end

  describe '#create' do
    context 'when Guest' do
      before { get :create, params: { id: game_w_questions.id }}

      it 'return status 302' do
        expect(response.status).to eq(302)
      end

      it 'return reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'return flash alert' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
    
    context 'when user is logged in and create new game' do
      before(:each) do
        sign_in user
        generate_questions(15)
        post :create
      end
      let!(:game) { assigns(:game) }

      it 'return game continues' do
        expect(game.finished?).to be false
      end

      it 'return user game' do
        expect(game.user).to eq(user)
      end

      it 'return redirect_to game_path(game)' do
        expect(response).to redirect_to(game_path(game))
      end

      it 'return flash notice' do
        expect(flash[:notice]).to be
      end
    end
  end

  describe '#answer' do
    context 'when Guest' do
      before { get :answer, params: { id: game_w_questions.id }}

      it 'return status 302' do
        expect(response.status).to eq(302)
      end

      it 'return reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'return flash alert' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'when user is logged in and answer correct' do
      before { sign_in user }
      before { put :answer, params: { id: game_w_questions.id, letter: game_w_questions.current_game_question.correct_answer_key }}
      let!(:game) { assigns(:game) }

      it 'return game continues' do
        expect(game.finished?).to be false
      end

      it 'return user game' do
        expect(game.user).to eq(user)
      end

      it 'return current_level > 0' do
        expect(game.current_level).to be > 0
      end

      it 'return redirect_to game_path(game)' do
        expect(response).to redirect_to(game_path(game))
      end

      it 'return answers correct' do
        expect(flash.empty?).to be_truthy
      end
    end
      
    context 'when user is logged in and answer incorect' do
      before { sign_in user }
      let(:game) { assigns(:game) }

      before { put :answer, params: { id: game_w_questions.id, letter: 'a' }}
      
      it 'return game over' do
        expect(game.finished?).to be_truthy
      end

      it 'return level = 0' do
        expect(game.current_level).to be 0
      end

      it 'return page user_path(user)' do
        expect(response).to redirect_to user_path(user) 
      end
      
      it 'return flash alert' do
        expect(flash[:alert]).to be
      end
    end
  end

  describe '#help' do
    before (:each) { sign_in user }
    let(:game) { assigns(:game) }

    # тест на отработку "помощи зала"
    it 'uses audience help' do
      # сперва проверяем что в подсказках текущего вопроса пусто
      expect(game_w_questions.current_game_question.help_hash[:audience_help]).not_to be
      expect(game_w_questions.audience_help_used).to be false

      # фигачим запрос в контроллен с нужным типом
      put :help, params: { id: game_w_questions.id, help_type: :audience_help }

      # проверяем, что игра не закончилась, что флажок установился, и подсказка записалась
      expect(game.finished?).to be false
      expect(game.audience_help_used).to be_truthy
      expect(game.current_game_question.help_hash[:audience_help]).to be
      expect(game.current_game_question.help_hash[:audience_help].keys).to contain_exactly('a', 'b', 'c', 'd')
      expect(response).to redirect_to(game_path(game))
    end

    it 'hint 50/50 can be used' do
      expect(game_w_questions.current_game_question.help_hash[:fifty_fifty]).not_to be
      expect(game_w_questions.fifty_fifty_used).to be false

      put :help, params: { id: game_w_questions.id, help_type: :fifty_fifty}

      expect(game.finished?).to be false
      expect(game.fifty_fifty_used).to be_truthy
      expect(game.current_game_question.help_hash[:fifty_fifty]).to be

      variants = game.current_game_question.help_hash[:fifty_fifty]

      expect(variants).to include('d')
      expect(variants.size).to eq(2)
      expect(response).to redirect_to(game_path(game))
    end
  end

  describe '#take_money' do
    context 'when Guest' do
      before { get :take_money, params: { id: game_w_questions.id }}

      it 'return status 302' do
        expect(response.status).to eq(302)
      end

      it 'return reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'return flash alert' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'when user log in and take money' do
      before (:each) do 
        sign_in user 
        game_w_questions.update_attribute(:current_level, 2)
        put :take_money, params: { id: game_w_questions.id }
      end
      let(:game) { assigns(:game) }
      
      it 'return game finish' do
        expect(game.finished?).to be_truthy
      end

      it 'return game prize' do
        expect(game.prize).to eq(200)
      end
      
      it 'return user balance' do
        user.reload
        expect(user.balance).to eq(200)
      end

      it 'return page user_path(user)' do
        expect(response).to redirect_to(user_path(user))
      end

      it 'return warning flash' do
        expect(flash[:warning]).to be
      end
    end 
  end
end
