# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'
require 'support/factory_bot'

RSpec.feature 'USER browsing user', type: :feature do 
  let(:user_one) { create :user, name: "Яссон" }

  let(:game_one) { create(
    :game, id: 1, user: user_one, created_at: Time.parse('2022.04.07, 16:00'), current_level: 3, prize: 0,
    is_failed: :in_progress)}

  let(:game_two) { create(
    :game, id: 2, user: user_one, created_at: Time.parse('2022.04.07, 16:47'), current_level: 2, prize: 200,
    finished_at: Time.parse('2022.04.07, 16:49'))}

  before(:each) do
    game_one
    game_two
  end

  # Когда пользователь не вошёл в систему
  context "when user logout in" do
    scenario 'successfully game_one' do
      visit '/'

      # Нажимаем на ссылку имени пользователя
      click_link 'Яссон'

      # Переходит на правильный адресс всех игр пользователя
      expect(page).to have_current_path '/users/1'

      # Имя игрока
      expect(page).to have_content 'Яссон'

      # Начало  игры
      expect(page).to have_content '07 апр., 15:00'

      # Игра в процессе
      expect(page).to have_content 'в процессе'

      # Вопрос
      expect(page).to have_content '3'

      expect(page).not_to have_content 'Сменить имя и пароль'
    end
  end

  context 'when user log in' do
    let(:user_two) { create :user, name: "Боря" }

    before(:each) do
      login_as user_two
    end

    scenario 'successfully game_two' do
      visit '/'

      # Нажимаем на ссылку имени пользователя
      click_link user_one.name

      # Переходит на правильный адресс всех игр пользователя
      expect(page).to have_current_path '/users/1'

      # Имя залогинненого пользователя
      expect(page).to have_content 'Боря'

      # Имя игрока
      expect(page).to have_content 'Яссон'

      # Начало игры
      expect(page).to have_content '07 апр., 15:47'

      # Выигрыш
      expect(page).to have_content '200'

      # Игра в закончена и взяты деньги
      expect(page).to have_content 'деньги'

      # Вопрос
      expect(page).to have_content '2'

      expect(page).not_to have_content 'Сменить имя и пароль'

      save_and_open_page
    end
  end
end
