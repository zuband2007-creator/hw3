Проект состоит из двух основных контейнеров:
- генератор создаёт CSV-файл с данными книжного магазина;
- аналитик читает CSV-файл и создаёт HTML-отчёт.
Оба контейнера работают с локальной папкой `data/`, которая подключается
к ним с помощью bind mount.

## Требования
- Bash;
- Docker;
- Python 3 для команды локальной генерации данных.

## Основной запуск
Сначала нужно разрешить запуск главного скрипта:
```bash
chmod +x run.sh
```

Затем собрать и запустить генератор:
```bash
./run.sh build_generator
./run.sh run_generator
```

После этого собрать и запустить аналитик:
```bash
./run.sh build_reporter
./run.sh run_reporter
```

В локальной папке `data/` появятся два файла:
- `data/data.csv`;
- `data/report.html`.

## Дополнительные команды
```bash
./run.sh create_local_data
./run.sh structure
./run.sh inside_generator
./run.sh inside_reporter
./run.sh clear_data
```