require 'rails_helper'
require 'support/factory_bot'

RSpec.describe 'users/show', type: :view do

  describe '#show.html' do
    before(:each) do
      assign(:user, create(:user, name: 'Вафлей', balance: 2000))

      render
    end

    # Этот сценарий проверяет, что шаблон выводит имя игрока
    it 'renders player names' do
      expect(rendered).to match 'Вафлей'
    end

    # # Этот сценарий проверяет, что юзеры в нужном порядке
    # it 'renders player names in right order' do
    #   expect(rendered).to match /Вадик.*Миша/m
    # end
  end
end