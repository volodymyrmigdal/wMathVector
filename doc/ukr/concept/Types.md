## Вектор

Впорядкована сукупність скалярів.

Під вектором в даному модулі розуміється впорядкована сукупність скалярів. Вектор не є об'єктом, а абстракцією.

### Формати задання вектора

Вектор може бути заданий через

- через масив( Array )
- через типізований буфер ( BufferTyped )
- через адаптер ( VectorAdapter )

Для використання вектора в масиві або буфері використовуйте неймспейс `_.avector`. Для використання вектора заданого адаптером використовуйте неймспейс `_.vectorAdapter`.

## Вектор адаптер

Вектор адаптер - це реалізація абстрактного інтерфейса, різновид посилання, що задає спосіб інтерпретації даних, як вектора.

Адаптер це спеціальний об'єкт, який потрібний для того щоб зробити алгоритми більш абстрактними і використовувати один і той же код для дуже різних форматів задання вектора. Інтерфейс адаптера має багато реалізацій.

[Повернутись до змісту](../README.md#Концепції)