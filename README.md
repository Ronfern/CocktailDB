# CocktailDB

## Общая информация

Вывести список коктейлей который получим из API. Также нужно учитывать фильтр.

## Drinks

Список доступных коктейлей, разделенных по категориям.

### Заголовок:

Заголовок в котором будет указана категория, например: Ordinary Drink

### Элемент Коктейля:

Содержит фотографию и название напитка. Действия по нажатию нет.

### Запрос:

Используем запрос ниже чтобы получить нужный список коктейлей

```
https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary Drink

Query Params (Обычные параметры который уже встроены в ссылку выше c=Ordinary Drink)
key: c
value: НазваниеКоктейля (Например: Ordinary Drink)
```

### Пагинация:

Используете пагинацию для последовательной загрузки элементов.

1. Загружается первый список коктейлей. 
2. При достижении пользователем конца списка будет загружен следующий список коктейлей.
3. Если списки закончились обработать этот кейс в коде.

### Задача:

- Сделать запрос на сервер и получить нужный список коктейлей
- Вывести полученный список коктейлей
    - Показываем заголовок. Например: Ordinary Drink
    - Показываем все полученные элементы

## Filters

Фильтр в котором мы можем выбрать категории которые хотим отобразить на главном экране.

### Элемент Фильтра:

Отображает checkbox и название фильтра

### Запрос:

Используем запрос ниже чтобы получить нужные фильтры

```
https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list

Query Params (Обычные параметры который уже встроены в ссылку выше c=list)
key: c
value: list
```

### Задача:

- Сделать запрос на сервер и получить нужные фильтры
- Вывести эти фильтры в список (По умолчанию все фильтры должны быть выбраны)
