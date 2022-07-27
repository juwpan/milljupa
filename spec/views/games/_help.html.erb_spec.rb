require 'rails_helper'
require 'support/factory_bot'

RSpec.describe 'games/help', type: :view do
  describe '#_helt.html' do
    # Перед началом теста подготовим объекты
    let(:game) { build_stubbed(:game) }
    let(:help_hash) { {friend_call: 'Сережа считает, что это вариант D'} }

    # Проверяем, что выводятся кнопки подсказок
    it 'renders help variant' do
      render_partial({}, game)

      expect(rendered).to match '50/50'
      expect(rendered).to match 'telephone'
      expect(rendered).to match 'people'
    end

    # Проверяем, что выводится текст подсказки «Звонок другу»
    it 'renders help info text' do
      render_partial(help_hash, game)

      expect(rendered).to match 'Сережа считает, что это вариант D'
    end

    # Проверяем, что если была использована подсказка 50/50, то такая кнопка не выводится
    it 'does not render used help variant' do
      game.fifty_fifty_used = true

      render_partial(help_hash, game)

      expect(rendered).not_to match '50/50'
    end
  end

  private

  # Метод, который рендерит фрагмент с нужными объектами
  def render_partial(help_hash, game)
    render partial: 'games/help', object: help_hash, locals: {game: game}
  end
end