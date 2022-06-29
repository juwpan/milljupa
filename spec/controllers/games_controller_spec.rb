# (c) goodprogrammer.ru

require 'rails_helper'
require 'support/my_spec_helper' # наш собственный класс с вспомогательными методами

# Тестовый сценарий для игрового контроллера
# Самые важные здесь тесты:
#   1. на авторизацию (чтобы к чужим юзерам не утекли не их данные)
#   2. на четкое выполнение самых важных сценариев (требований) приложения
#   3. на передачу граничных/неправильных данных в попытке сломать контроллер
#
RSpec.describe GamesController, type: :controller do
  # обычный пользователь
  let(:user) { FactoryBot.create(:user) }
  # админ
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  # игра с прописанными игровыми вопросами
  let(:game_w_questions) { FactoryBot.create(:game_with_questions, user: user) }

  describe '#show' do
    context 'Guest' do
      before { get :show, params: { id: game_w_questions.id }}

      it 'status 302' do
        expect(response.status).to eq(302)
      end

      it 'reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'error' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'Usual user' do
      before(:each) { sign_in user }

      it 'user sees his game' do
        get :show, params: { id: game_w_questions.id }

        game = assigns(:game)

        expect(game.finished?).to be_falsey
        expect(game.user).to eq(user)

        expect(response.status).to eq(200)
        expect(response).to render_template('show')
      end

      it '#show alien game' do
        # создаем новую игру, юзер не прописан, будет создан фабрикой новый
        alien_game = FactoryBot.create(:game_with_questions)
      
        # пробуем зайти на эту игру текущим залогиненным user
        get :show, params: { id: alien_game.id }
      
        expect(response.status).to eq(302) # статус не 200 ОК
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('controllers.games.not_your_game'))
      end
    end
  end

  describe '#create' do
    context 'Guest' do
      before { get :create, params: { id: game_w_questions.id }}

      it 'status 302' do
        expect(response.status).to eq(302)
      end

      it 'reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'error' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context "Usual user" do
      before(:each) { sign_in user }
      let(:game) { assigns(:game) }

      it 'creates game' do
        # сперва накидаем вопросов, из чего собирать новую игру
        generate_questions(15)

        post :create
        
        # проверяем состояние этой игры
        expect(game.finished?).to be_falsey
        expect(game.user).to eq(user)

        # и редирект на страницу этой игры
        expect(response).to redirect_to(game_path(game))
        expect(flash[:notice]).to be
      end

      it 'try to create second game' do
        # убедились что есть игра в работе
        expect(game_w_questions.finished?).to be_falsey
      
        # отправляем запрос на создание, убеждаемся что новых Game не создалось
        expect { post :create }.to change(Game, :count).by(0)
      
        expect(game).to be_nil
      
        # и редирект на страницу старой игры
        expect(response).to redirect_to(game_path(game_w_questions))
        expect(flash[:alert]).to eq(I18n.t('controllers.games.game_not_finished'))
      end
    end

  end

  # юзер отвечает на игру корректно - игра продолжается
  describe '#answer' do
    context 'Guest' do
      before { get :answer, params: { id: game_w_questions.id }}

      it 'status 302' do
        expect(response.status).to eq(302)
      end

      it 'reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'error' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'Usual user' do
      before(:each) { sign_in user }
      let(:game) { assigns(:game) }

      it 'answers correct' do
        # передаем параметр params[:letter]
        put :answer, params: { id: game_w_questions.id, letter: game_w_questions.current_game_question.correct_answer_key }
        
        expect(game.finished?).to be_falsey
        expect(game.current_level).to be > 0
        expect(response).to redirect_to(game_path(game))
        expect(flash.empty?).to be_truthy # удачный ответ не заполняет flash
      end

      it 'incorrect answer' do
        put :answer, params: { id: game_w_questions.id, letter: 'a' }

        expect(game.finished?).to be_truthy
        expect(game.current_level).to be 0
        expect(response).to redirect_to user_path(user)     
        expect(flash[:alert]).to be
      end
    end
  end

  describe '#help' do
    context 'Usual user' do
      before (:each) { sign_in user }
      let(:game) { assigns(:game) }

      # тест на отработку "помощи зала"
      it 'uses audience help' do
        # сперва проверяем что в подсказках текущего вопроса пусто
        expect(game_w_questions.current_game_question.help_hash[:audience_help]).not_to be
        expect(game_w_questions.audience_help_used).to be_falsey

        # фигачим запрос в контроллен с нужным типом
        put :help, params: { id: game_w_questions.id, help_type: :audience_help }

        # проверяем, что игра не закончилась, что флажок установился, и подсказка записалась
        expect(game.finished?).to be_falsey
        expect(game.audience_help_used).to be_truthy
        expect(game.current_game_question.help_hash[:audience_help]).to be
        expect(game.current_game_question.help_hash[:audience_help].keys).to contain_exactly('a', 'b', 'c', 'd')
        expect(response).to redirect_to(game_path(game))
      end

      it 'hint 50/50 can be used' do
        expect(game_w_questions.current_game_question.help_hash[:fifty_fifty]).not_to be
        expect(game_w_questions.fifty_fifty_used).to be_falsey

        put :help, params: { id: game_w_questions.id, help_type: :fifty_fifty}

        expect(game.finished?).to be_falsey
        expect(game.fifty_fifty_used).to be_truthy
        expect(game.current_game_question.help_hash[:fifty_fifty]).to be

        variants = game.current_game_question.help_hash[:fifty_fifty]

        expect(variants).to include('d')
        expect(variants.size).to eq(2)
        expect(response).to redirect_to(game_path(game))
      end

      # it 'friend_call' do
      #   expect(game_w_questions.current_game_question.help_hash[:friend_call]).not_to be
      #   expect(game_w_questions.friend_call_used).to be_falsey

      #   put :help, params: { id: game_w_questions.id, help_type: :friend_call}
      
      #   expect(game.finished?).to be_falsey
      #   expect(game.friend_call_used).to be_truthy
      #   expect(game.current_game_question.help_hash[:friend_call]).to be
        
      #   variants = game.current_game_question.help_hash[:friend_call]
      #   expect(variants.keys).to eq('a')
        
      #   # expect(response).to redirect_to(game_path(game))
      # end
    end
  end

  describe '#take_money'

    context 'Guest' do
      before { get :take_money, params: { id: game_w_questions.id }}

      it 'status 302' do
        expect(response.status).to eq(302)
      end

      it 'reditect log_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'error' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'User usual' do
      before (:each) { sign_in user }
      let(:game) { assigns(:game) }

      it 'take money' do
        game_w_questions.update_attribute(:current_level, 2)

        put :take_money, params: { id: game_w_questions.id }
        game = assigns(:game)

        expect(game.finished?).to be_truthy
        expect(game.prize).to eq(200)
      
        user.reload
        expect(user.balance).to eq(200)

        expect(response).to redirect_to(user_path(user))
        expect(flash[:warning]).to be
      end 
  end
end
