require 'rails_helper'
require 'support/factory_bot'

RSpec.describe 'users/show', type: :view do

  describe '#show.html' do
    before(:each) do
      assign(:user, create(:user, name: 'Вафлей', balance: 5000))

      render
    end

    # Этот сценарий проверяет, что шаблон выводит имя игрока
    it 'renders player names' do
      expect(rendered).to match 'Вафлей'
    end

    # it { should have_selector('a', title: "Сменить имя и пароль", href: edit_user_registration_path(user)) }
    # # Этот сценарий проверяет, что шаблон выводит баланс
    # it 'renders displays the Change username and Password button' do
    #   expect(rendered).to match 'Сменить имя и пароль'
    # end

    # # Этот сценарий проверяет, что юзеры в нужном порядке
    # it 'renders player names in right order' do
    #   expect(rendered).to match /Вадик.*Миша/m
    # end
  end
end