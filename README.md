
| Concepto                | Bloquea        | Seguro | Velocidad | Uso ideal                        | Debilidades                                                                                          |
| ----------------------- | -------------- | ------ | --------- | -------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **FOR UPDATE**          | Sí             | Muy    | Media     | Cuando necesitas lógica compleja | Bloquea filas, puede generar esperas si hay mucha concurrencia                                       |
| **Tabla de secuencias** | Sí pero mínimo | Muy    | Alta      | Generar números secuenciales     | Puede generar micro-bloqueos en alta concurrencia; requiere fila por grupo si hay varias condiciones |
| **Atomic counters**     | Mínimo         | Muy    | Muy alta  | Solo incrementar contadores      | No permite lógica condicional compleja; solo incrementos simples                                     |


| Concepto                | Aplicación a comprobantes                                                                                                                                                                                                                                                | Estimado |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| **FOR UPDATE**          | Se elimina el mutex y se aplica el bloqueo directamente desde el método correspondiente. No se modifican los tests existentes. Se realiza la prueba de concurrencia con Cucumber. Se realiza el test para logs.                                                          | 16 horas |
| **Tabla de secuencias** | Se elimina el mutex y se implementa una tabla de secuencias, creando 10 secuencias por cada tipo. Se ajusta el código para usar estas secuencias. No se modifican los tests existentes. Se realiza la prueba de concurrencia con Cucumber. Se realiza el test para logs. | 40 horas |
| **Atomic counters**     | Se elimina el mutex y se crean 10 secuencias por cada tipo. Se ajusta el código para usar estas secuencias. No se modifican los tests existentes. Se realiza la prueba de concurrencia con Cucumber. Se realiza el test para logs.                                       | 40 horas |


bin/rails db:environment:set RAILS_ENV=development
bin/rails db:drop
bin/rails db:create
bin/rails db:migrate
bin/rails db:migrate:redo VERSION=20251120170304
bin/rails db:seed
