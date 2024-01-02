import
  asyncdispatch,
  strutils,
  json,
  jsony,
  ../core/core


proc addChatUser*(x: MessagesMethods, chat_id: int, user_id: int,
                  visible_messages_count: int = 200): Future[int] {.async.} =
  ## Добавляет нового пользователя в мультидиалог.
  ##
  ## Метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ##
  ## Требуются права доступа: messages.
  ##
  ## ## Arguments
  ## - `chat_id` -- Идентификатор беседы. (Обязательный параметр)
  ## - `user_id` -- Идентификатор пользователя, которого необходимо включить в беседу. (Обязательный параметр)
  ## - `visible_messages_count` -- Количество видимых сообщений в чате. (Обязательный параметр)
  ##
  ## ## Result
  ## После успешного выполнения возвращает `1`.
  ##
  ## ## Error Codes
  ## - `103`: Out of limits
  ## - `925`: You are not an admin of this chat
  ## - `932`: Your community can't interact with this peer
  ## - `936`: Contact not found
  ## - `939`: Message request already sent
  ## - `945`: Chat was disabled
  ## - `946`: Chat not supported
  ## - `947`: Can't add user to chat, because the user has no access to the group
  ## - `967`: This user can't be added to the work chat, as they aren't an employee.
  ## - `981`: Cannot add this user due to privacy settings
  ## - `982`: Cannot add users to chat temporarily
  ## 
  var arguments = %*{
    "user_id": user_id,
    "chat_id": chat_id,
    "visible_messages_count": visible_messages_count
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.addChatUser", arguments)
  return response.getInt


proc allowMessagesFromGroup*(x: MessagesMethods, group_id: int, key: string): Future[int] {.async.} =
  ## Разрешает отправку сообщений от сообщества текущему пользователю.
  ##
  ## Этот метод можно вызвать с ключом доступа пользователя,
  ## полученным в Standalone-приложении через Implicit Flow.
  ##
  ## Требуются права доступа: messages.
  ##
  ## ## Arguments
  ## - `group_id` -- Идентификатор сообщества. (Обязательный параметр)
  ## - `key` -- Произвольная строка для идентификации пользователя.
  ##   Значение будет возвращено в событии message_allow Callback API.
  ##   Макс. длина = 256
  ##
  ## ## Result
  ## После успешного выполнения возвращает `1`.
  ##
  ## ## Error Codes
  ## - 943 -- Cannot use this intent
  ## 
  var arguments = %*{
    "group_id": group_id,
    "key": key,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.allowMessagesFromGroup", arguments)
  return response.getInt



proc createChat*(x: MessagesMethods, user_ids: seq[int], title: string,
                 group_id: int = 0): Future[CreatedChat] {.async.} =
  ## Создает чат с несколькими участниками.
  ##
  ## Метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Метод также можно вызвать с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ## Parameters
  ## - `user_ids` -- Идентификаторы пользователей, которые будут участвовать в чате. Используйте запятую в качестве разделителя.
  ##   Указанные пользователи должны находиться в списке друзей текущего пользователя.
  ## - `title` -- Название чата.
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ##
  ## Обратите внимание, что при создании чата с токеном сообщества, чат не будет отображаться в интерфейсе сообщества.
  ## Кроме того, в таком чате нельзя пригласить участников при создании.
  ## Добавить их можно позже с помощью API-метода `messages.getInviteLink`.
  ##
  ## ## Result
  ## После успешного выполнения возвращает идентификатор созданного чата (`chat_id`).
  ## 
  var arguments = %*{
    "user_ids": user_ids.join(","),
    "title": title,
    "group_id": group_id,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.createChat", arguments)
  var j: string
  j.toUgly(response)
  return j.fromJson(CreatedChat)



proc delete*(x: MessagesMethods, message_ids: seq[int], spam: bool = false,
             reason: int = 0, group_id: int = 0, delete_for_all: bool = false,
             peer_id: int, cmids: seq[int] = @[]): Future[int] {.async.} =
  ## Удаляет сообщение.
  ##
  ## Метод доступен при использовании ключа доступа пользователя, полученного в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ## Метод также доступен при использовании ключа доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ## Parameters
  ## - `message_ids` -- Список идентификаторов сообщений, разделённых через запятую.
  ## - `spam` -- Пометить сообщения как спам (доступен только с ключом доступа пользователя).
  ## - `reason` -- Идентификатор причины блокировки (integer).
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ## - `delete_for_all` -- `1` — если сообщение нужно удалить для получателей (если с момента отправки сообщения прошло не более 24 часов).
  ## - `peer_id` -- Идентификатор беседы, из которого необходимо удалить сообщения по cmids.
  ##   Для пользователя: `id пользователя`.
  ##   Для групповой беседы: `2000000000 + id беседы`.
  ##   Для сообщества: `-id сообщества`.
  ## - `cmids` -- Идентификаторы сообщения в беседе, разделённые через запятую.
  ##
  ## ## Result
  ## После успешного выполнения возвращает `1` для каждого удалённого сообщения.
  ##
  ## ## Error Codes
  ## 924 - Can't delete this message for everybody
  ## 
  var arguments = %*{
    "message_ids": message_ids.join(","),
    "spam": spam.int,
    "reason": reason,
    "group_id": group_id,
    "delete_for_all": delete_for_all.int,
    "peer_id": peer_id,
    "cmids": cmids.join(","),
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.delete", arguments)
  return response.getInt


proc deleteChatPhoto*(x: MessagesMethods, chat_id: int, group_id: int = 0): Future[ChatUpdate] {.async.} =
  ## Удаляет фотографию мультидиалога.
  ##
  ## Этот метод может быть вызван с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Этот метод может быть вызван с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ## Arguments
  ## - `chat_id` -- Идентификатор беседы. (Обязательный параметр)
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ##
  ## ## Result
  ## После успешного выполнения возвращает объект, содержащий следующие поля:
  ## - `message_id` — идентификатор отправленного системного сообщения;
  ## - `chat` — объект мультидиалога.
  ##
  ## ## Error Codes
  ## - 925: You are not an admin of this chat.
  ## - 945: Chat was disabled.
  ## 
  var arguments = %*{
    "chat_id": chat_id,
    "group_id": group_id
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.deleteChatPhoto", arguments)
  var j: string
  j.toUgly(response)
  return j.fromJson(ChatUpdate)


proc deleteConversation*(x: MessagesMethods, user_id: int = 0, peer_id: int = 0,
                         offset: int = 0, count: int = 0, group_id: int = 0): Future[JsonNode] {.async.} =
  ## Удаляет беседу.
  ##
  ## Этот метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Этот метод можно вызвать с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ## Arguments
  ## - `user_id` -- Идентификатор пользователя. Если требуется очистить историю беседы, используйте `peer_id`.
  ## - `peer_id` -- Идентификатор назначения.
  ##   Для групповой беседы: `2000000000 + id беседы`.
  ##   Для сообщества: `-id сообщества`.
  ##   *Разрешён с версии 5.38*
  ## - `offset` -- Начиная с какого сообщения нужно удалить переписку (по умолчанию удаляются все сообщения начиная с первого).
  ##   *Запрещён с версии 5.100*
  ## - `count` -- Сколько сообщений нужно удалить.
  ##   Обратите внимание, что на метод наложено ограничение, за один вызов нельзя удалить больше `10000` сообщений,
  ##   поэтому если сообщений в переписке больше — метод нужно вызывать несколько раз.
  ##   *Запрещён с версии 5.100*
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ##
  ## ## Result
  ## После успешного выполнения возвращает поле `last_deleted_id`,
  ## содержащее идентификатор последнего удалённого сообщения в переписке.
  ## 
  var arguments = %*{
    "user_id": user_id,
    "peer_id": peer_id,
    "offset": offset,
    "count": count,
    "group_id": group_id,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.deleteConversation", arguments)
  return response


proc deleteReaction*(x: MessagesMethods, peer_id: int, cmid: int): Future[JsonNode] {.async.} =
  ## Удаляет ранее поставленную реакцию на сообщение в беседе.
  ##
  ## Этот метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Этот метод можно вызвать с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ## Parameters
  ## - `peer_id` -- Идентификатор беседы:
  ##   - `user_id` — для личных чатов.
  ##   - `group_id` — для чатов с сообществом.
  ##   - `2 000 000 000 + id_чата` — для чатов.
  ##   Обязательный параметр.
  ## - `cmid` -- Порядковый номер сообщения в чате (conversation_message_id).
  ##   Обязательный параметр.
  ## 
  var arguments = %*{
    "peer_id": peer_id,
    "cmid": cmid,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.deleteReaction", arguments)
  return response


proc denyMessagesFromGroup*(x: MessagesMethods, group_id: int): Future[JsonNode] {.async.} =
  ## Запрещает отправку сообщений от сообщества текущему пользователю.
  ##
  ## ## Arguments
  ## - `group_id` -- Идентификатор сообщества. (Обязательный параметр)
  ##
  ## ## Permissions
  ## Требуются права доступа: messages.
  ##
  ## ## Result
  ## После успешного выполнения возвращает 1.
  ## 
  var arguments = %*{
    "group_id": group_id,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.denyMessagesFromGroup", arguments)
  return response
