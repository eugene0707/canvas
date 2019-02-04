Web-приложение "Canvas"
================

Базовая docker-композиция для новых приложений RoR.

По-умолчанию, seed 2 пользователей:
- Администратор: admin@example.com / password 
- Обычный пользователь: user@example.com / password


Используется
-----------

- Language - Ruby 2.4.0
- Web framework - Rails 5.1.1
- Web UI - Bootstrap
- Authentication - Devise
- Authorization - Pundit
- JSON API - Grape
- Testing - Rspec + Cabybara
- Testing webdriver - PhantomJS via poltergeist.
- Coding convention - Rubocop
- Autorestart watcher - Guard
- Environment - dotenv
- Log collector - Graylog shipped by Filebeat
- Background jobs - RabbitMQ sneakers
- Client Messaging - AMPQ Websocket via Kaazing Gateway


Порядок запуска
-----------

- скопировать .env.example в .env
- docker-compose up
- Rails app - [localhost:3000](http://localhost:3000)
- Rspec report - [localhost:3000/rspec.html](http://localhost:3000/rspec.html)
- Rubocop report - [localhost:3000/rubocop.html](http://localhost:3000/rubocop.html)
- Mailcatcher - [localhost:1080](http://localhost:1080)
- Errbit - [localhost:2080](http://localhost:2080)
  - Зайти в консоль errbit докера
      docker-compose run errbit rails c
    и создать нового пользователя
      User.create!(email: 'admin@example.com', password: 'admin_password', name: 'admin', username: 'admin', admin: true)
  - Залогиниться в errbit и создать свое приложение.
  - Скопировать project_key в .env AIRBAKE_API_KEY.
  - Запустить rake-задачу для проверки errbit:
      docker-compose run web rake airbrake:test
    В errbit должна появиться ошибка test:error
- если не стартуют производные от canvas_web контейнеры, то в первую очередь:
  - chmod +x ./wait_for
- Graylog - [localhost:9000](http://localhost:9000) (admin/admin)
  

Runtime-отладка
-----------

- [web-console](https://github.com/rails/web-console) - доступна при исполнении view-контекста.
- [binding_of_caller](https://github.com/banister/binding_of_caller) - стек переменных
- [byebug](https://github.com/deivid-rodriguez/byebug) - точки остановки


Использование guard
-----------

Сейчас в композиции помимо Postgres присутсвуют несколько контейнеров rails-приложения (image canvas_web), подключенного к volume /app.
web - web-приложение под управлением Puma
test - контейнер в котором выполняется тестирование rspec
bundle - контейнер в котором выполняется bundle install
все 3 контейнера подключены к volume bundle-cache, который содержит установленые для приложения gems. Данный volume обновляется контейнером bundle

Процессы в контейнерах, производных от canvas_web запускаются с использованием [Guard](https://github.com/guard/guard)
Это обеспечивает автоматический перезапуск процессов в контейнерах в случае изменения определенных ключевых файлов.
Например, в контенере bundler будет выполнен bundle install в случае обновления Gemfile.*. Процессы в остальных контейнерах также будут перезапущены.
Правила и условия перезапуска определены в файле Guadrfile.

Показ нотификаций (notify-osd) 
-----------

Для воспроизведения нотификаций от процессов Guard (запуск rails, статус rspec, rubocop) необходимо запускать композицию с помощью скрипта dcu.
1. sudo apt install inotify-tools
2. chmod +x dcu
3. ./dcu

В составе данного скрипта будет запущен наблюдатель, который будет транслировать текст из файла .guard_result в notify-osd и выполнен docker-compose up.


