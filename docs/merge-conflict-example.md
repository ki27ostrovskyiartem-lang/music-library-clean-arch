# Приклад конфлікту злиття

Файл: `config/app_config.json`.
Гілки: `feature/infrastructure-layer` і `develop` (у develop раніше злито `feature/config-paths`).

Обидві гілки змінили рядки з `appName`, `storage` і `dataFile`. Після `git merge origin/develop` Git позначив конфлікт:

```
{
<<<<<<< HEAD
  "appName": "Music Library",
  "storage": "json",
  "dataFile": "storage/tracks.json"
=======
  "appName": "Music Library CLI",
  "storage": "memory",
  "dataFile": "data/tracks.json"
>>>>>>> origin/develop
}

```

Рішення: з develop взято `appName` та `dataFile` (`data/tracks.json`), з гілки infrastructure взято `storage: json`. Результат:

```json
{
  "appName": "Music Library CLI",
  "storage": "json",
  "dataFile": "data/tracks.json"
}
```

Після розв'язання виконано `git add config/app_config.json` і `git commit`.
