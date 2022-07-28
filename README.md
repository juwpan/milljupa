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

# Кто хочет стать миллионером?!

Игра для детей от 12 до 159 лет.

Учебное приложение курса по Ruby on Rails от «Хорошего программиста». В продакшене настроено на работу с Heroku.

© http://goodprogrammer.ru

#### "Кто хочет стать миллионером?!" - Игра где каждый каждый участник с помощью своей эрудиции может заработать 1 миллион рублей.

**Правила игры:**

- Для того чтобы заработать 1 миллион, участнику необходимо ответить на 15 вопросов разной стоимости и разного уровня сложности.
- Каждый вопрос имеет 4 варианта ответа, из которых только один является верным. Каждый вопрос имеет конкретную стоимость

**Денежное дерево:**

| Номер вопроса | Стоимость  |
| ------------- |:----------:|
|   **15**      | **1000000**|
|     14        | 500000     |
|     13        | 250000     |
|     12        | 125000     |
|     11        | 64000      |
|   **10**      | **32000**  |
|     9         | 16000      |
|     8         | 8000       |
|     7         | 4000       |
|     6         | 2000       |
|   **5**       | **1000**   |
|     4         | 500        |
|     3         | 300        |
|     2         | 200        |
|     1         | 100        |

- В помощь участнику даётся четыре подсказки. Ими можно пользоваться на любом вопросе и в любой последовательности, но только один раз каждой из подсказок за всю 
игру.

**Подсказски**

- «50:50» — Компьютер убирает два неверных варианта ответа.
- «Звонок другу» — В течении 30 секунд игрок может спросить ответ у одного из своих друзей.
- «Помощь зала» — с помощью специального пульта каждый из гостей в студии выбирает вариант ответа, который считает верным, после чего игроку предоставляется краткая статистика по результатам зрительского голосования.


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
bundle exec rails db:migrate
```
```
bundle exec rails db:seed
```

### Установка стилей
```
yarn build:css
```
```
yarn build
```

### Запуск приложения

```
rails s
```
---

### Запуск тестов

```
bundle exec rails db:create
```

```
bundle exec rspec
```
---

### Добавление новых вопросов и ответов

1. Создаём пользователя

2. Даём права администратора своему пользователю

```
User.last.toggle!(:is_admin)
```
3.Логинимся другим пользователем и играем.
