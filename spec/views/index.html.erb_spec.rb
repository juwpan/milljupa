require 'rails_helper'
require 'support/factory_bot'

RSpec.describe 'users/index', type: :view do

  describe '#index.html' do
    before(:each) do
      # Перед каждым шагом мы пропишем в переменную @users пару пользователей, 
      # имитируя действие контроллера, который эти данные будет брать из базы
      # Обратите внимание, что мы объекты в базу не кладем, т.к. пишем FactoryBot.build_stubbed
      assign(:users, [
        build_stubbed(:user, name: 'Вадик', balance: 5000),
        build_stubbed(:user, name: 'Миша', balance: 3000),
      ])
  
      render
    end

    # Этот сценарий проверяет, что шаблон выводит имена игроков
    it 'renders player names' do
      expect(rendered).to match 'Вадик'
      expect(rendered).to match 'Миша'
    end

    # Этот сценарий проверяет, что шаблон выводит баланс
    it 'renders player balances' do
      expect(rendered).to match '5 000 ₽'
      expect(rendered).to match '3 000 ₽'
    end

    # Этот сценарий проверяет, что юзеры в нужном порядке
    it 'renders player names in right order' do
      expect(rendered).to match /Вадик.*Миша/m
    end
  end
end