# Як використовувати адаптер

Використання адаптерів зі скаляром та множиною векторів.

### Використання скаляра аргументом рутини

Векторизація скаляру - створення вектору необхідної довжини та заповнення значенням скаляру.

```js
var a1 = [ 1, 1 ];
var v1 = _.vectorAdapter.from( a1 );
_.vectorAdapter.add( v1, 3 );
console.log( 'v1.toStr(): ', v1.toStr() );
/* log : "v1.toStr():  4.000 4.000" */
```

Виклик `_.vectorAdapter.add( v1, 3 )` перетворить скаляр `3` у вектор із довжиною вектору `v1` та заповнить його значенням скаляру.
В результаті отримаємо вектор `[ 3, 3 ]`, який буде додано до вектору `v1`. Такий метод виключає необхідність ручного створення векторів із однаковим вмістом.

### Операції з множиною векторів

```javascript
var v1 = _.vectorAdapter.from( [ 1, 1, 1 ] );
var v2 = _.vectorAdapter.from( [ 1, 1, 1 ] );
var v3 = _.vectorAdapter.from( [ 1, 1, 1 ] );
var result = _.vectorAdapter.add( v1, v2, v3 );
console.log( 'result.toStr(): ', result.toStr() );
/* log : "result.toStr():  3.000 3.000 3.000" */
```

Змінна `result` містить вектор із результатом додавання трьох векторів: `v1`, `v2`, `v3`.

### Попередження помилкових даних

```js
var a1 = [ 1, 1 ];
var a2 = [ 1, 1, 1 ];
var v1 = _.vectorAdapter.from( a1 );
var v2 = _.vectorAdapter.from( a2 );
_.vectorAdapter.add( v1, v2 );
```
Виклик `_.vectorAdapter.add( v1, v2 )` завершиться із помилкою тому, що всі вектори повинні мати однакову довжину.

Методи `sub`, `mul`, `div` працюють за аналогічним із `add` принципом, відмінністю є лише операція,яку вони виконують із вектором.
