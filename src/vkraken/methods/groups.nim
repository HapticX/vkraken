import
  asyncdispatch,
  strutils,
  json,
  jsony,
  ../core/core


proc getLongPollServer*(x: GroupsMethods, group_id: int): Future[LongPollServer] {.async.} =
  ## Возвращает данные для подключения к Bots Longpoll API.
  ##
  ## Этот метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ##
  ## Требуются права доступа: `groups`.
  ##
  ## Этот метод можно вызвать с ключом доступа сообщества.
  ##
  ## ### Parameters
  ## - `group_id` -- Идентификатор сообщества.
  ##   Обязательный параметр.
  ##   Обратите внимание. При получении ключа доступа сообщества в параметре scope укажите право доступа manage.
  ##   Ключи доступа сообщества, не включающие этот scope, использовать для вызова метода не получится.
  ##
  ## ### Result
  ## Возвращает объект, который содержит следующие поля:
  ## - `key` (string) — ключ;
  ## - `server` (string) — URL сервера;
  ## - `ts` (string) — timestamp.
  ## 
  let response = await x.vk.callVkMethod("groups.getLongPollServer", %*{"group_id": group_id})
  var j: string
  j.toUgly(response)
  return j.fromJson(LongPollServer)
