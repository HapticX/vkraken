import
  asyncdispatch,
  strutils,
  json,
  jsony,
  ../core/core


proc getHints*(x: SearchMethods, q: string, offset: int = 0, limit: int = 100,
               filters: seq[string] = @[], fields: seq[string] = @[],
               search_global: bool = false): Future[seq[SearchHint]] {.async.} =
  ## Метод позволяет получить результаты быстрого поиска по произвольной подстроке.
  ##
  ## ## Parameters
  ## - `q` -- Текст запроса, результаты которого нужно получить.
  ##   Макс. длина = 9000.
  ## - `offset` -- Смещение для выборки определённого подмножества результатов.
  ## - `limit` -- Ограничение на количество возвращаемых результатов.
  ## - `filters` -- Перечисленные через запятую типы данных, которые необходимо вернуть. Возможные значения:
  ##   - `"friends"` – друзья пользователя;
  ##   - `"idols"` – подписки пользователя;
  ##   - `"publics"` – публичные страницы, на которые подписан пользователь;
  ##   - `"groups"` – группы пользователя;
  ##   - `"events"` – встречи пользователя;
  ##   - `"correspondents"` – люди, с которыми пользователь имеет переписку;
  ##   - `"mutual_friends"` – люди, у которых есть общие друзья с текущим пользователем
  ##   (этот фильтр позволяет получить не всех пользователей, имеющих общих друзей).
  ##   По умолчанию возвращаются все.
  ## - `fields` -- Дополнительные поля профилей и сообществ для получения.
  ## - `search_global` -- `1` — к результатам поиска добавляются результаты глобального поиска по всем пользователям и группам.
  ##
  ## ## Result
  ## После успешного выполнения возвращает массив объектов, каждый из которых содержит стандартные поля
  ## `type`, `section`, `description` и соответствующий объект с набором дополнительных полей.
  ##
  ## - `type` (integer) -- Тип объекта. Возможные значения:
  ##   - `"group"` -- Данные о сообществе. Объект, который содержит поля:
  ##     - `id` (integer) — идентификатор сообщества;
  ##     - `name` (string) — название сообщества;
  ##     - `screen_name` (string) — короткий адрес;
  ##     - `is_closed` (integer) — информация о том, является ли группа или встреча закрытой
  ##       (0 — открытая, 1 — закрытая, 2 — частная);
  ##     - `is_admin` (integer, [0,1]) — информация о том, является ли текущий пользователь администратором
  ##       сообщества (1 — является, 0 — не является);
  ##     - `is_member` (integer, [0,1]) — информация о том, является ли текущий пользователь участником
  ##       сообщества (1 — является, 0 — не является);
  ##     - `type` (string) — тип сообщества. Возможные значения:
  ##       - `"group"` — группа;
  ##       - `"page"` — публичная страница;
  ##       - `"event"` — встреча.
  ##     - `photo` (string) — URL квадратной фотографии сообщества с размером 50х50px;
  ##     - `photo_medium` (string) — URL квадратной фотографии сообщества с размером 100х100px;
  ##     - `photo_big` (string) — URL фотографии сообщества в максимальном доступном размере.
  ##   - `profile` (для type = profile) -- Данные о профиле. Объект, который содержит поля:
  ##     - `id` (integer) — идентификатор пользователя;
  ##     - `first_name` (string) — имя пользователя;
  ##     - `last_name` (string) — фамилия пользователя.
  ## - `section` (string) -- Тип объекта. Возможные значения для сообществ:
  ##   - `"groups"` — группы;
  ##   - `"events"` — мероприятия;
  ##   - `"publics"` — публичные страницы;
  ##   Возможные значения для профилей:
  ##   - `"correspondents"` — собеседники по переписке;
  ##   - `"people"` — популярные пользователи;
  ##   - `"friends"` — друзья;
  ##   - `"mutual_friends"` — пользователи, имеющие общих друзей с текущим.
  ## - `description` (string) -- Описание объекта (для сообществ — тип и число участников,
  ##   например, `Group`, `269`, `136` members, для профилей друзей или пользователями,
  ##   которые не являются возможными друзьями — название университета или город,
  ##   для профиля текущего пользователя — That's you, для профилей возможных друзей
  ##   — N mutual friends).
  ## - `global` (integer, [1]) -- Поле возвращается, если объект был найден в глобальном поиске,
  ##   всегда содержит 1.
  ## 
  var arguments = %*{
    "q": q,
    "offset": offset,
    "limit": limit,
    "fields": fields.join(","),
    "filters": filters.join(","),
    "search_global": search_global.int,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("search.getHints", arguments)
  result = @[]
  for i in response["items"]:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(SearchHint))
