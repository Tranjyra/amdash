# AM-DASH — Дашбоард группы автоматизации

Веб-приложение для ведения отчетности по выполненным работам инженерами автоматизации с возможностью загрузки фото-отчетов, структуры патч-панели.

Основной язык - Ruby, фреймворк - Rails, база данных - MySQL, так же используется redis для работы WebSocket каналов и асинхронных Job'ов

Для запуска нужен ruby версии 2.6.1 и Rails версии 5.2.3

Так же должен быть настроен конфиг MySQL по пути `/etc/mysql/my.cnf`

Добавить параметр 
```bash
[mysqld]
sql-mode=""
```

Перед первым запуском выполнить
```bash
bundle install
```

Если все установилось нормально делаем
```bash
rails db:create && rails db:seed
```


Запуск сервера коммандой (обязательно с обычными правами не из под su или sudo)
```bash
rails s -b 0.0.0.0 -p 8000 -d
```

Для переброса с порта 8000 на порт 80 выполнить (для ubuntu/debian)
```bash
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8000
```

Основной рабочий экземпляр приложения расположен по адресу http://am-dash.gloria-jeans.ru и доступен только внутри локальной сети Gloria-Jeans, для авторизации используются доменные учетные данные (имя пользователя передается без префикса [`GJ\`]), так же можно использовать почту `user@gloria-jeans.ru`
#   a m d a s h  
 