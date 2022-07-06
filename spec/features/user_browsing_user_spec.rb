# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'
require 'support/factory_bot'

RSpec.feature 'USER browsing user', type: :feature do 
  let(:user_one) { create :user, name: "Яссон" }

  let!(:game_one) do
    create(
      :game,
      user: user_one,
      created_at: Time.parse('2022.08.09, 16:00'),
      current_level: 678,
      prize: 0,
      is_failed: :in_progress
    )
  end

  let!(:game_two) do 
    create(
      :game,
      user: user_one,
      created_at: Time.parse('2022.04.07, 16:47'),
      current_level: 11,
      prize: 826,
      finished_at: Time.parse('2022.04.07, 16:49'),
    )
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
      expect(page).to have_content '09 авг., 15:00'

      # Игра в процессе
      expect(page).to have_content 'в процессе'

      # Вопрос №678
      expect(page).to have_content '678'

      # Не отображает ссылку
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
      expect(page).to have_content '826'

      # Игра в закончена и взяты деньги
      expect(page).to have_content 'деньги'

      # Вопрос
      expect(page).to have_content '11'

      expect(page).not_to have_content 'Сменить имя и пароль'
    end
  end
end
