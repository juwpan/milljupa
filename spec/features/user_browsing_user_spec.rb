# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'
require 'support/factory_bot'

RSpec.feature 'USER browsing user', type: :feature do 
  let(:user) { create :user, name: "Яссон" }

  let(:game_1) { create(
    :game, id: 1, user: user, created_at: Time.parse('2022.04.07, 16:00'), current_level: 3, prize: 0,
    is_failed: :in_progress)}

  let(:game_2) { create(
    :game, id: 2, user: user, created_at: Time.parse('2022.04.07, 16:47'), current_level: 2, prize: 200,
    finished_at: Time.parse('2022.04.07, 16:49'))}

  before(:each) do
    game_1
    game_2
  end

  # Когда пользователь не вошёл в систему
  context "when user logout in" do
    scenario 'successfully game_1' do
      visit '/'

      # Нажимаем на ссылку имени пользователя
      click_link user.name

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
    end
  end

  context 'when user log in' do
    before(:each) do
      login_as user
    end

    scenario 'successfully game_2' do
      visit '/'

      # Нажимаем на ссылку имени пользователя
      click_link user.name

      # Переходит на правильный адресс всех игр пользователя
      expect(page).to have_current_path '/users/1'

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
    end
  end
end
