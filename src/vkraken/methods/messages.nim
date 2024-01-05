import
  asyncdispatch,
  strutils,
  random,
  json,
  jsony,
  ../core/core


randomize()


proc addChatUser*(x: MessagesMethods, chat_id: int, user_id: int,
                  visible_messages_count: int = 200): Future[int] {.async.} =
  ## Добавляет нового пользователя в мультидиалог.
  ##
  ## Метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ##
  ## Требуются права доступа: messages.
  ##
  ## ### Arguments
  ## - `chat_id` -- Идентификатор беседы. (Обязательный параметр)
  ## - `user_id` -- Идентификатор пользователя, которого необходимо включить в беседу. (Обязательный параметр)
  ## - `visible_messages_count` -- Количество видимых сообщений в чате. (Обязательный параметр)
  ##
  ## ### Result
  ## После успешного выполнения возвращает `1`.
  ##
  ## ### Error Codes
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
  arguments.removeEmptyArgs()
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
  ## ### Arguments
  ## - `group_id` -- Идентификатор сообщества. (Обязательный параметр)
  ## - `key` -- Произвольная строка для идентификации пользователя.
  ##   Значение будет возвращено в событии message_allow Callback API.
  ##   Макс. длина = 256
  ##
  ## ### Result
  ## После успешного выполнения возвращает `1`.
  ##
  ## ### Error Codes
  ## - 943 -- Cannot use this intent
  ## 
  var arguments = %*{
    "group_id": group_id,
    "key": key,
  }
  arguments.removeEmptyArgs()
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
  ## ### Parameters
  ## - `user_ids` -- Идентификаторы пользователей, которые будут участвовать в чате. Используйте запятую в качестве разделителя.
  ##   Указанные пользователи должны находиться в списке друзей текущего пользователя.
  ## - `title` -- Название чата.
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ##
  ## Обратите внимание, что при создании чата с токеном сообщества, чат не будет отображаться в интерфейсе сообщества.
  ## Кроме того, в таком чате нельзя пригласить участников при создании.
  ## Добавить их можно позже с помощью API-метода `messages.getInviteLink`.
  ##
  ## ### Result
  ## После успешного выполнения возвращает идентификатор созданного чата (`chat_id`).
  ## 
  var arguments = %*{
    "user_ids": user_ids.join(","),
    "title": title,
    "group_id": group_id,
  }
  arguments.removeEmptyArgs()
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
  ## ### Parameters
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
  ## ### Result
  ## После успешного выполнения возвращает `1` для каждого удалённого сообщения.
  ##
  ## ### Error Codes
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
  arguments.removeEmptyArgs()
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
  ## ### Arguments
  ## - `chat_id` -- Идентификатор беседы. (Обязательный параметр)
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ##
  ## ### Result
  ## После успешного выполнения возвращает объект, содержащий следующие поля:
  ## - `message_id` — идентификатор отправленного системного сообщения;
  ## - `chat` — объект мультидиалога.
  ##
  ## ### Error Codes
  ## - 925: You are not an admin of this chat.
  ## - 945: Chat was disabled.
  ## 
  var arguments = %*{
    "chat_id": chat_id,
    "group_id": group_id
  }
  arguments.removeEmptyArgs()
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
  ## ### Arguments
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
  ## ### Result
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
  arguments.removeEmptyArgs()
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
  ## ### Parameters
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
  arguments.removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.deleteReaction", arguments)
  return response


proc denyMessagesFromGroup*(x: MessagesMethods, group_id: int): Future[JsonNode] {.async.} =
  ## Запрещает отправку сообщений от сообщества текущему пользователю.
  ##
  ## ### Arguments
  ## - `group_id` -- Идентификатор сообщества. (Обязательный параметр)
  ##
  ## ### Permissions
  ## Требуются права доступа: messages.
  ##
  ## ### Result
  ## После успешного выполнения возвращает 1.
  ## 
  var arguments = %*{
    "group_id": group_id,
  }
  arguments.removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.denyMessagesFromGroup", arguments)
  return response


proc edit*(x: MessagesMethods, peer_id: int, message: string = "",
           lat: int = 0, long: int = 0, attachment: seq[string] = @[],
           keep_forward_messages: bool = false, keep_snippets: bool = false,
           group_id: int = 0, dont_parse_links: bool = false,
           disable_mentions: bool = false, message_id: int = 0,
           conversation_message_id: int = 0, `template`: Template = Template(),
           keyboard: Keyboard = Keyboard()): Future[int] {.async.} =
  ## Редактирует сообщение VK.
  ##
  ## Метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Метод можно вызвать с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ### Parameters
  ## - `peer_id` -- Идентификатор назначения.
  ##   - Для пользователя: `id пользователя`.
  ##   - Для групповой беседы: `2000000000 + id беседы`.
  ##   - Для сообщества: `-id сообщества`.
  ##   (Обязательный параметр)
  ## - `message` -- Текст сообщения. Обязательный параметр, если не задан параметр attachment.
  ##   Макс. длина = `9000`.
  ## - `lat` -- Географическая широта (от `-90` до `90`).
  ## - `long` -- Географическая долгота (от `-180` до `180`).
  ## - `attachment` -- Медиавложения к личному сообщению, перечисленные через запятую.
  ##   Каждое прикрепление представлено в формате: `"<type><owner_id>_<media_id>"`
  ##   - `<type>` — тип медиавложения: `"photo"`, `"video"`, `"audio"`, `"doc"`, `"wall"`, `"market"`.
  ##   - `<owner_id>` — идентификатор владельца медиавложения (отрицательный, если объект в сообществе).
  ##   - `<media_id>` — идентификатор медиавложения.
  ##   Параметр является обязательным, если не задан параметр message.
  ## - `keep_forward_messages` -- `1`, чтобы сохранить прикреплённые пересланные сообщения (checkbox).
  ## - `keep_snippets` -- `1`, чтобы сохранить прикреплённые внешние ссылки (сниппеты) (checkbox).
  ## - `group_id` -- Идентификатор сообщества (для сообщений сообщества с ключом доступа пользователя).
  ## - `dont_parse_links` -- `1` — не создавать сниппет ссылки из сообщения (checkbox).
  ## - `disable_mentions` -- `1` — отключить уведомление об упоминании в сообщении (checkbox).
  ## - `message_id` -- Идентификатор сообщения (positive).
  ## - `conversation_message_id` -- Идентификатор сообщения в беседе (positive).
  ## - `template` -- Объект, описывающий шаблоны сообщений (text).
  ## - `keyboard` -- Объект, описывающий клавиатуру бота (text).
  ##
  ## ### Result
  ## После успешного выполнения возвращает `1`.
  ##
  ## ### Error Codes
  ## - `901`: Can't send messages for users without permission
  ## - `909`: Can't edit this message, because it's too old
  ## - `910`: Can't sent this message, because it's too big
  ## - `911`: Keyboard format is invalid
  ## - `912`: This is a chat bot feature, change this status in settings
  ## - `914`: Message is too long
  ## - `917`: You don't have access to this chat
  ## - `920`: Can't edit this kind of message
  ## - `940`: Too many posts in messages
  ## - `946`: Chat not supported
  ## - `949`: Can't edit pinned message yet
  ## 
  var arguments = %*{
    "peer_id": peer_id,
    "message": message,
    "lat": lat,
    "long": long,
    "attachment": attachment.join(","),
    "keep_forward_messages": keep_forward_messages,
    "keep_snippets": keep_snippets.int,
    "group_id": group_id,
    "dont_parse_links": dont_parse_links.int,
    "disable_mentions": disable_mentions.int,
    "message_id": message_id,
    "conversation_message_id": conversation_message_id,
  }
  if keyboard.buttons.len != 0:
    arguments["keyboard"] = % keyboard.toJson()
  if `template`.`type` == TemplateType.Carousel and `template`.elements.len > 0:
    arguments["template"] = % `template`.toJson()
  arguments.removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.edit", arguments)
  return response.getInt


proc send*(x: MessagesMethods, random_id: int = rand(100_000),
           user_id: int = 0, peer_id: int = 0, peer_ids: seq[int] = @[],
           domain: string = "", chat_id: int = 0, user_ids: seq[int] = @[],
           message: string = "", guid: int = 0, lat: int = 0, long: int = 0,
           attachment: seq[string] = @[], reply_to: int = 0, forward_messages: seq[int] = @[],
           forward: ForwardBotMessage = ForwardBotMessage(), sticker_id: int = 0,
           group_id: int = 0, keyboard: Keyboard = Keyboard(),
           `template`: Template = Template(), payload: string = "",
           content_source: ContentSource = ContentSource(),
           dont_parse_links: bool = false, disable_mentions: bool = false,
           intent: string = "", subscribe_id: int = 0): Future[int] {.async.} =
  ## Отправляет сообщение пользователю или в беседу VK.
  ##
  ## Этот метод можно вызвать с ключом доступа пользователя, полученным в Standalone-приложении через Implicit Flow.
  ## Требуются права доступа: messages.
  ##
  ## Этот метод можно вызвать с ключом доступа сообщества.
  ## Требуются права доступа: messages.
  ##
  ## ### Arguments
  ## - `user_id` -- Обязательный параметр. Идентификатор пользователя, которому отправляется сообщение.
  ## - `random_id` -- Обязательный параметр. Уникальный (в привязке к идентификатору приложения и идентификатору отправителя) идентификатор, предназначенный для предотвращения повторной отправки одного и того же сообщения. Сохраняется вместе с сообщением и доступен в истории сообщений. Возможные значения:
  ##   - `0` — проверка на уникальность не нужна.
  ##   - Любое другое число в пределах `int32` — проверка на уникальность нужна.
  ##   Переданный в запросе random_id используется для проверки уникальности сообщений в заданном диалоге за последний час (но не более `100` последних сообщений).
  ##   *Разрешён с версии 5.45*
  ## - `peer_id` -- Необязательный параметр. Идентификатор получателя сообщения:
  ##   - Для пользователя — `ИДЕНТИФИКАТОР_ПОЛЬЗОВАТЕЛЯ`.
  ##   - Для групповой беседы — `2000000000 + ИДЕНТИФИКАТОР_БЕСЕДЫ`.
  ##   - Для сообщества — `-ИДЕНТИФИКАТОР_СООБЩЕСТВА`.
  ##   *Разрешён с версии 5.38*
  ## - `peer_ids` -- Необязательный параметр. Идентификаторы получателей сообщения, перечисленные через запятую. Максимальное количество идентификаторов — `100`.
  ##   Примечание. Доступно только для ключа доступа сообщества.
  ##   *Разрешён с версии 5.81*
  ## - `domain` -- Необязательный параметр. Короткий адрес пользователя. Пример: `persik_ryzhiy`.
  ## - `chat_id` -- Необязательный параметр. Идентификатор беседы, в которую отправляется сообщение.
  ## - `user_ids` -- Необязательный параметр. Идентификаторы получателей сообщения, перечисленные через запятую. Максимальное количество идентификаторов — `100`.
  ##   Примечание. Доступно только для ключа доступа сообщества.
  ##   *Запрещён с версии 5.138*
  ## - `message` -- Необязательный параметр. Текст личного сообщения. Максимальное количество символов — `4096`. Обязательный параметр, если не задан параметр attachment.
  ## - `guid` -- Необязательный параметр. Уникальный идентификатор, предназначенный для предотвращения повторной отправки одного и того же сообщения.
  ## - `lat` -- Необязательный параметр. Географическая широта в градусах. Диапазон значений: от `-90` до `90`.
  ## - `long` -- Необязательный параметр. Географическая долгота в градусах. Диапазон значений: от `-180` до `180`.
  ## - `attachment` -- Необязательный параметр. Объект или несколько объектов, приложенных к записи. Обязательный параметр, если не задан параметр message.
  ##   К записи можно приложить медиа или ссылку на внешнюю страницу. Если объектов несколько, укажите их через запятую ,.
  ##   Формат описания медиавложения: `"{type}{owner_id}_{media_id}"`, где:
  ##   - type — тип медиавложения:
  ##     - `"photo"` — фотография.
  ##     - `"video"` — видеозапись.
  ##     - `"audio"` — аудиозапись.
  ##     - `"doc"` — файл.
  ##     - `"wall"` — запись на стене.
  ##     - `"market"` — товар.
  ##     - `"poll"` — опрос.
  ##     - `"question"` — вопрос.
  ##     - `"owner_id"` — идентификатор владельца медиавложения. Идентификатор сообщества должен начинаться со знака -.
  ##     - `"media_id"` — идентификатор медиавложения.
  ##   Если прикрепляется медиавложение, которое принадлежит другому пользователю, добавьте к формату описания медиавложения ключ доступа: `"{type}{owner_id}_{media_id}_{access_key}"`.
  ## - `reply_to` -- Необязательный параметр. Идентификатор сообщения, на которое требуется ответить.
  ##   *Разрешён с версии 5.92*
  ## - `forward_messages` -- Необязательный параметр. Идентификаторы пересылаемых сообщений, перечисленные через запятую. Пересылаемые сообщения отправителя будут отображаться в теле сообщения у получателя.
  ##   Ограничения:
  ##   - Не более `100` значений на верхнем уровне.
  ##   - Максимальный уровень вложенности — `45`.
  ##   - Максимальное количество пересылаемых сообщений — `500`.
  ## - `forward` -- Необязательный параметр. JSON-объект со следующими полями:
  ##   - owner_id — владелец сообщений. Укажите это поле, если вы хотите переслать сообщения из сообщества в личный диалог.
  ##   - peer_id — идентификатор места, из которого необходимо переслать сообщения.
  ##   - conversation_message_ids — массив conversation_message_id сообщений, которые необходимо переслать. В параметр можно передать сообщения, которые:
  ##     - Находятся в личном диалоге с ботом.
  ##     - Являются исходящими сообщениями бота.
  ##     - Написаны после того, как бот вступил в беседу и появился доступ к сообщениям.
  ##   - message_ids — массив идентификаторов сообщений.
  ##   - is_reply — ответ на сообщения. Укажите это поле, если вы хотите ответить на сообщения в том чате, в котором находятся сообщения. При этом в `conversation_message_ids` или `message_ids` должен находиться только один элемент.
  ## - `sticker_id` -- Необязательный параметр. Идентификатор стикера.
  ## - `group_id` -- Необязательный параметр. Идентификатор сообщества для сообщений сообщества с ключом доступа пользователя.
  ## - `keyboard` -- Необязательный параметр. Объект, описывающий клавиатуру бота.
  ## - `template` -- Необязательный параметр. Объект, описывающий шаблон сообщения.
  ## - `payload` -- Необязательный параметр. Полезные данные.
  ## - `content_source` -- Необязательный параметр. Объект в формате JSON, описывающий источник пользовательского контента для чат-ботов.
  ## - `dont_parse_links` -- Необязательный параметр. Информация о том, создать ли сниппет ссылки из сообщения. Возможные значения:
  ##   - `1` — не создавать сниппет ссылки из сообщения.
  ##   - `0` — создать сниппет ссылки из сообщения.
  ## - `disable_mentions` -- Необязательный параметр. Информация о том, отключить ли уведомление об упоминании в сообщении. Возможные значения:
  ##   - `1` — отключить уведомление об упоминании в сообщении.
  ##   - `0` — не отключать уведомление об упоминании в сообщении.
  ## - `intent` -- Необязательный параметр. Строка, описывающая интенты.
  ## - `subscribe_id` -- Необязательный параметр. Число, которое будет использоваться для работы с интентами в будущем.
  ##
  ## ### Result
  ## Метод возвращает идентификатор отправленного сообщения. Если передан параметр peer_ids, метод возвращает массив объектов. Поля объекта:
  ##
  ## | Поле                     | Тип     | Описание |
  ## | :--:                     | :---:   | -------- |
  ## | peer_id                  | integer | Идентификатор назначения. |
  ## | message_id               | integer | Идентификатор сообщения. |
  ## | conversation_message_id  | integer | Идентификатор сообщения в диалоге. |
  ## | error                    | string  | Сообщение об ошибке, если сообщение не было доставлено получателю. |
  ##
  ## Пример ответа:
  ##
  ## ```json
  ## {
  ##   "response": 5
  ## }
  ## ```
  ##
  ## Коды ошибок
  ## - `104`: Not found
  ## - `900`: Can't send messages for users from blacklist
  ## - `901`: Can't send messages for users without permission
  ## - `902`: Can't send messages to this user due to their privacy settings
  ## - `911`: Keyboard format is invalid
  ## - `912`: This is a chat bot feature, change this status in settings
  ## - `913`: Too many forwarded messages
  ## - `914`: Message is too long
  ## - `917`: You don't have access to this chat
  ## - `921`: Can't forward these messages
  ## - `922`: You left this chat
  ## - `925`: You are not admin of this chat
  ## - `936`: Contact not found
  ## - `940`: Too many posts in messages
  ## - `943`: Cannot use this intent
  ## - `944`: Limits overflow for this intent
  ## - `945`: Chat was disabled
  ## - `946`: Chat not supported
  ## - `950`: Can't send message, reply timed out
  ## - `962`: You can't access donut chat without subscription
  ## - `969`: Message cannot be forwarded
  ## - `979`: App action is restricted for conversations with communities
  ## - `983`: You are restricted to write to a chat
  ## - `984`: You has spam restriction
  ## - `1012`: Writing is disabled for this chat
  ## 
  var arguments = %*{
    "random_id": random_id,
    "user_id": user_id,
    "peer_id": peer_id,
    "peer_ids": peer_ids.join(","),
    "domain": domain,
    "chat_id": chat_id,
    "user_ids": user_ids.join(","),
    "message": message,
    "guid": guid,
    "lat": lat,
    "long": long,
    "attachment": attachment.join(","),
    "reply_to": reply_to,
    "forward_messages": forward_messages.join(","),
    "sticker_id": sticker_id,
    "group_id": group_id,
    "payload": payload,
    "dont_parse_links": dont_parse_links.int,
    "disable_mentions": disable_mentions.int,
    "intent": intent,
    "subscribe_id": subscribe_id,
  }
  if keyboard.buttons.len != 0:
    arguments["keyboard"] = % keyboard.toJson()
  if `template`.`type` == TemplateType.Carousel and `template`.elements.len > 0:
    arguments["template"] = % `template`.toJson()
  if content_source.owner_id != 0 or content_source.peer_id != 0:
    arguments["content_source"] = % content_source.toJson()
  if forward.owner_id != 0 or forward.peer_id != 0:
    arguments["forward"] = % forward.toJson()
  arguments.removeEmptyArgs()
  let response = await x.vk.callVkMethod("messages.send", arguments)
  return response.getInt
