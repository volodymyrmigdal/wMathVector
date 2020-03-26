# Векторні операції 

Здійснення математичних операцій над векторами та обгортками до векторів.

### Що таке вектор

У математиці вектор - індексована сукупність чисел або інших математичних обєктів( х1,х2,...xn ), що дозволяють виконувати над вектором різні математичні операції. Зручність вектору полягає в можливості оперувати великою кількістю чисел як одним обєктом. Зазвичай, в програмуванні, під вектором розуміють динамічний одномірний масив.

### Способи обробки векторів

Модуль має два способи роботи з векторами даних. 
Перший з них дозволяє виконувати математичні операції безпосередньо на векторах в вигляді масивів та отримувати результат в вигляді масиву. Він реалізований через використання неймспесу `wTools.avector`.
Другий спосіб полягає в використанні обгортки до вектору, результат виконання операцій з обгортками - обгортка. Обгортки не містять безпосередньо даних, а лише метадані такі, як наприклад, початок, кінець вектору в масиві, лінк на масив із даними. Доступ до інтерфейсу для роботи із обгортками векторів здійснюється через неймспейс `wTools.vectorAdapter`.

### Додавання векторів з використанням обгорток і без

Додавання без перетворення

```js
var vector1 = [ 1, 2, 3 ];
var vector2 = [ 4, 5, 6 ];

_.avector.add( vector1, vector2 );

console.log( vector1 ); // log [ 5, 7, 9 ]
console.log( vector2 ); // log [ 4, 5, 6 ]
```

В коді приведеному вище і далі через `_` позначено модуль `wTools`. 
Приведений код показує, що з допомогою неймспеса `avector` було проведено операцію додавання над двома векторами. Рутина `add` склала вектори і записала результат у перший, що завжди є вектором призначення ( `dst` ).

Додавання через створення обгортки

```js
var vector1 = [ 1, 2, 3 ];
var vector2 = [ 4, 5, 6 ];
var vectorA1 = _.vectorAdapter.from( vector1 );
var vectorA2 = _.vectorAdapter.from( vector2 );

console.log( vectorA1 ); // log VectorAdapterFromLong {_vectorBuffer: Array(3)}
console.log( vectorA1.toStr() ); // log "1.000, 2.000, 3.000"
console.log( vectorA2.toStr() ); // log "4.000, 5.000, 6.000"

vectorA1.add( vectorA2 );

console.log( vectorA1.toStr() ); // log "5.000, 7.000, 9.000"
console.log( vectorA2.toStr() ); // log "4.000, 5.000, 6.000"

console.log( vector1 ); // log [ 5, 7, 9 ]
console.log( vector2 ); // log [ 4, 5, 6 ]
```

Приведений код показує, що до векторів `vector1` i `vector2` створено обгортки `vectorA1` i `vectorA2`. Обгортка не показує вміст вектору, тому використано метод `toStr()`, котрий виводить дані. Створена обгортка має методи, що маніпулюють з вектором, використано метод `add` як і в `avector`. Після проведення додавання змінилась як вміст обгортки `vectroA1` так і оригінальний вектор.

### Множення на скаляр 

```js
var vector1 = [ 1, 2, 3 ];
var vectorA1 = _.vectorAdapter.from( vector1 );

_.avector.mul( vector1, 2 );

console.log( vector1 ); // log [ 2, 4, 6 ]

vectorA1.mul( 3 );

console.log( vectorA1.toStr() ); // log "6.000, 12.000, 18.000"
```

Обгортка не створює копії вектору, а має посилання на оригінальний вектор, тому результуючий вектор має значення в 6 разів більше від початкового.

### Результуючий вектор в новому контейнері

Щоб результат операції був записаний в новий вектор і при цьому не відбулось змін в оригінальних в параметр `dst` повинен бути переданий `null`. 

Для неймспесу `avector` `null` має передаватись в рутину першим, а далі повинні йти інші аргументи.

```js
var vector = [ 1, 2, 3 ];
var newVector = _.avector.add( null, vector, [ 2, 3, 4 ] );

console.log( newVector ); // log [ 3, 5, 7 ]
console.log( newVector === vector ); // log false
```

В неймспесі `vectorAdapter` інстанс має методи, в яких перший аргумент - `dst` є даними цього інстансу. Тому щоб створити нову обгортку можна використати безпосердньо рутину в неймспейсі. Першим аргументом передається `null`.

```js
var vectorA = _.vectorAdapter.from( [ 1, 2, 3 ] );
var newVectorA = _.vectorAdapter.add( null, vectorA, [ 2, 3, 4 ] );

console.log( newVectorA.toStr() ); // log "3.000, 5.000, 7.000"
console.log( newVectorA === vectorA ); // log false
```

### Переваги створення обгорток

#### Масиви з різними довжинами

Векторні операції мають власні правила, серед яких одне із найважливіших є однаковий розмір векторів. Наведений приклад додавання мав два співрозмірних вектори, а що, якщо потрібно провести векторні операції з над певними ділянками масиву, чи з масивами різної довжини? В цьому випадку використання обгортки має переваги оскільки надає інтерфейс для роботи з частинами вектору.

```js
var vector1 = [ 1, 2, 3, 4, 5, 6, 7 ];
var vector2 = [ 4, 5, 6, 7 ];
var vectorA1 = _.vectorAdapter.from( vector1, 2, 3 );
var vectorA2 = _.vectorAdapter.from( vector2, 1, 3 );

console.log( vectorA1.toStr() ); // log "3.000, 4.000, 5.000"
console.log( vectorA2.toStr() ); // log "5.000, 6.000, 7.000"

vectorA2.sub( vectorA1 );

console.log( vectorA1.toStr() ); // log "3.000, 4.000, 5.000"
console.log( vectorA2.toStr() ); // log "2.000, 2.000, 2.000"

console.log( vector1 ); // log [ 1, 2, 3, 4, 5, 6, 7 ]
console.log( vector2 ); // log [ 4, 2, 2, 2 ]
```

Для того, щоб створити вектор певної довжини в рутину `from` передається 3 параметри - масив, початковий індекс і довжина вектору.
Після виконання віднімання змінилась лише частина оригінального масиву `vector2`. При цьому інші дані не змінились.

#### Використання параметру `stride` для вибору елементів

Вибірку з оригінального масиву можна робити з певним кроком. Для цього використовується параметр `stride`.

```js
var vector1 = [ 1, 2, 3, 4, 5, 6, 7 ];
var vector2 = [ 4, 5, 6, 7 ];
var vectorA1 = _.vectorAdapter.fromLongWithStride( vector1, 4 );
var vectorA2 = _.vectorAdapter.fromLongWithStride( vector2, 2 );

console.log( vectorA1.toStr() ); // log "1.000, 5.000"
console.log( vectorA2.toStr() ); // log "4.000, 6.000"

vectorA2.sub( vectorA1 );

console.log( vectorA1.toStr() ); // log "1.000, 4.000"
console.log( vectorA2.toStr() ); // log "3.000, 1.000"

console.log( vector1 ); // log [ 1, 2, 3, 4, 5, 6, 7 ]
console.log( vector2 ); // log [ 3, 5, 1, 7 ]
```

З допомогою рутини `fromLongWithStride` створено вектори що мають елементи з визначеним у другому параметрі ( `stride` ) кроком. Початковий елемент має індекс `0`. Якщо потрібно створити вектор визначеної довжини з певною черговістю використовується рутина `fromLongLrangeAndStride`. Рутина приймає наступні параметри - оригінальний масив, початковий індекс, довжину вектора і крок.

```js
var vector = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ];
var vectorA1 = _.vectorAdapter.fromLongLrangeAndStride( vector, 1, 4, 2 );

console.log( vectorA1.toStr() ); // log "1.000, 3.000, 5.000, 7.000"
```

#### Виконання дій з різними типами векторів 

Рутини неймспейсу `vectorAdapter` здатні працювати як з обгортками так і безпосередньо з векторами. 

#### Створення нових векторів 

`vectorAdapter` має рутину `toLong` котра створює копію даних обгортки у вигляді вектору. 

```js
var vector = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ];
var vectorA1 = _.vectorAdapter.fromLongLrangeAndStride( vector, 1, 4, 2 );
var newVector = vectorA1.toLong();

console.log( newVector ); // log [ 1, 3, 5, 7 ]
```

### Підсумок 

- Модуль має 2 неймспеси - `avector` i `vectorAdapter`.
- Рутини неймспесу `avector` працюють з векторами у вигляді `long`-контейнерів.
- Рутини неймспесу `vectorAdapter` створюють обгортки до векторів.
- Обгортки векторів не містять безпосередньо вектора, а лише метадані - лінк до оригінального вектору, початок вектору, довжину, тощо.
- Результат операцій поміщається в вектор, що виступає вектором призначення - `dst`. 
- Для рутин неймспесу `avector` `dst` - перший аргумент. Для неймспесу `vectorAdapter` - безпосередньо обгортка з даними.
- Обгортки до векторів надають зручний інтерфейс для роботи з векторами. Інтерфейс дозволяє корегувати довжину вектору, змінювати черговість елементів, копіювати дані в новий вектор та інше.

[Повернутись до змісту](../README.md#Туторіали)
