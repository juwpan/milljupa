FactoryBot.define do
  # фабрика, создающая юзеров
  factory :user do
    # генерим рандомное имя
    name { "Жора_#{rand(999)}" }

    # email должен быть уникален - при каждом вызове фабрики n будет увеличен поэтому все юзеры
    # будут иметь разные адреса: someguy_1@example.com, someguy_2@example.com, someguy_3@example.com ...
    sequence(:email) { |n| "someguy_#{n}@example.com" }

    # всегда создается с флажком false, ничего не генерим
    is_admin { false }

    # всегда нулевой
    balance { 0 }

    # коллбэк - после фазы :build записываем поля паролей, иначе Devise не позволит :create юзера
    after(:build) { |u| u.password_confirmation = u.password = "1" }
  end
end