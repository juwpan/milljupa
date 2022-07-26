# Кто хочет стать миллионером?!

Игра для детей от 12 до 159 лет.

Учебное приложение курса по Ruby on Rails от «Хорошего программиста». В продакшене настроено на работу с Heroku.

© http://goodprogrammer.ru

<div>
  <a href="https://rubyonrails.org">
    <img src="https://img.shields.io/badge/Rails-7.0.3-ff0000?logo=RubyonRails&logoColor=white&?style=for-the-badge"
    alt="Rails badge" />
  </a>
  <a href="https://rubyonrails.org">
    <img src="https://img.shields.io/badge/Ruby-3.0.2-ff0000?logo=Ruby&logoColor=white&?style=for-the-badge"
    alt="Rails badge" />
  </a>
</div>

#### "Миллионер" - описание.....

Как играть:


---
### Важно!
1. В вашей ситеме должен быть установлен менеджер пакетов Yarn или Npm.
2. Запуск команд производится в консоли вашей опреционой системы.

---
### Пошаговое руководство запуска приложения.

### Скачать репозиторий:

Перейдите в папку, в которую вы хотите скачать исходный код Ruby on Rails, и запустите:

```
$ git clone https://github.com/juwpan/milljupa.git

```
```
$ cd milljupa
```

### Установка зависимостей

```
yarn install
```
```
bundle install
```
### Запуск миграции

```
bundle exec rails db:create
```
```
bundle exec rails db:migrate
```

### Установка стилей
```
yarn build:css
```
```
yarn build
```

### Создание ключей

```
EDITOR=<ваш редактор> rails credentials:edit
```

Будет созданы файлы **master.key** и **credentials.yml.enc**

### Пропишите в файл *credentials.yml.enc* свои переменные окружения

```
EDITOR=<ваш редактор> rails credentials:edit
```
### Запуск приложения

```
rails s
```
---

### Запуск тестов

```
bundle exec rspec
```
---
