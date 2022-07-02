require 'rails_helper'
require 'support/factory_bot'

RSpec.describe 'users/show', type: :view do

  describe '#show.html' do
    context 'when user log in' do   
      let(:user) { create(:user, name:'Вова') }
      let(:game) { build_stubbed(
        :game, id: 15, created_at: Time.parse('2016.10.09, 13:00'), current_level: 10, prize: 1000
      )}

      before(:each) do
        assign(:user, user)
        sign_in user

        allow(game).to receive(:status).and_return(:in_progress)
        render partial: 'users/game', object: game

        render
      end

      it 'renders player names' do
        expect(rendered).to match 'Вова'
      end

      it 'user sees the button' do
        expect(rendered).to match 'Сменить имя и пароль'
      end

      it 'renders game id' do
        expect(rendered).to match '15'
      end
  
      it 'renders game start time' do
        expect(rendered).to match '09 окт., 12:00'
      end
  
      it 'renders game current question' do
        expect(rendered).to match '10'
      end
  
      it 'renders game status' do
        expect(rendered).to match 'в процессе'
      end
  
      it 'renders game prize' do
        expect(rendered).to match '1 000 ₽'
      end
    end

    context 'when the user logged out' do
      let(:user) { create(:user, name:'Федот') }

      before(:each) do
        assign(:user, user)
        render
      end

      it 'user does not see button' do
        expect(rendered).not_to match 'Сменить имя и пароль'
      end
    end
  end
end
