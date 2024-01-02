import
  asyncdispatch,
  strutils,
  json,
  jsony,
  ../core/core


proc get*(x: UsersMethods, user_ids: seq[int],
          fields: seq[string] = @[], name_case: string = "nom"
         ): Future[seq[User]] {.async.} =
  ## Получает информацию о пользователях VK.
  ##
  ## ## Arguments
  ## - `user_ids` -- Перечисленные через запятую идентификаторы пользователей или их короткие имена (screen_name).
  ##               По умолчанию — идентификатор текущего пользователя.
  ## - `fields` -- Список дополнительных полей профилей, которые необходимо вернуть.
  ##   Доступные значения:
  ##   - activities,
  ##   - about,
  ##   - blacklisted,
  ##   - blacklisted_by_me,
  ##   - books,
  ##   - bdate,
  ##   - can_be_invited_group,
  ##   - can_post,
  ##   - can_see_all_posts,
  ##   - can_see_audio,
  ##   - can_send_friend_request,
  ##   - can_write_private_message,
  ##   - career,
  ##   - common_count,
  ##   - connections,
  ##   - contacts,
  ##   - city,
  ##   - country,
  ##   - crop_photo,
  ##   - domain,
  ##   - education,
  ##   - exports,
  ##   - followers_count,
  ##   - friend_status,
  ##   - has_photo,
  ##   - has_mobile,
  ##   - home_town,
  ##   - photo_100,
  ##   - photo_200,
  ##   - photo_200_orig,
  ##   - photo_400_orig,
  ##   - photo_50,
  ##   - sex,
  ##   - site,
  ##   - schools,
  ##   - screen_name,
  ##   - status,
  ##   - verified,
  ##   - games,
  ##   - interests,
  ##   - is_favorite,
  ##   - is_friend,
  ##   - is_hidden_from_feed,
  ##   - last_seen,
  ##   - maiden_name,
  ##   - military,
  ##   - movies,
  ##   - music,
  ##   - nickname,
  ##   - occupation,
  ##   - online,
  ##   - personal,
  ##   - photo_id,
  ##   - photo_max,
  ##   - photo_max_orig,
  ##   - quotes,
  ##   - relation,
  ##   - relatives,
  ##   - timezone,
  ##   - tv,
  ##   - universities.
  ## - `name_case` -- Падеж для склонения имени и фамилии пользователя. Возможные значения:
  ##                  - именительный – nom,
  ##                  - родительный – gen,
  ##                  - дательный – dat,
  ##                  - винительный – acc,
  ##                  - творительный – ins,
  ##                  - предложный – abl.
  ##                  По умолчанию nom.
  ##
  ## ## Result
  ## После успешного выполнения возвращает массив объектов пользователей.
  ## Поля `counters`, `military` будут возвращены только в случае, если передан ровно один `user_id`.
  let response = await x.vk.callVkMethod("users.get", %*{
    "fields": fields.join(","),
    "user_ids": user_ids.join(","),
    "name_case": name_case
  })
  result = @[]
  for i in response:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(User))


proc getFollowers*(x: UsersMethods, user_id: int, offset: int = 0, count: int = 100,
                   fields: seq[string] = @[], name_case: string = "nom"): Future[seq[User]] {.async.} =
  ## Получает информацию о подписчиках пользователя VK.
  ##
  ## ## Arguments
  ## - `user_id` -- Идентификатор пользователя.
  ## - `offset` -- Смещение, необходимое для выборки определенного подмножества подписчиков.
  ## - `count` -- Количество подписчиков, информацию о которых нужно получить.
  ## - `fields` -- Список дополнительных полей профилей, которые необходимо вернуть.
  ##   Доступные значения:
  ##   - `"about"`,
  ##   - `"activities"`,
  ##   - `"bdate"`,
  ##   - `"blacklisted"`,
  ##   - `"blacklisted_by_me"`,
  ##   - `"books"`,
  ##   - `"can_post"`,
  ##   - `"can_see_all_posts"`,
  ##   - `"can_see_audio"`,
  ##   - `"can_send_friend_request"`,
  ##   - `"can_write_private_message"`,
  ##   - `"career"`,
  ##   - `"city"`,
  ##   - `"common_count"`,
  ##   - `"connections"`,
  ##   - `"contacts"`,
  ##   - `"country"`,
  ##   - `"crop_photo"`,
  ##   - `"domain"`,
  ##   - `"education"`,
  ##   - `"exports"`,
  ##   - `"followers_count"`,
  ##   - `"friend_status"`,
  ##   - `"games"`,
  ##   - `"has_mobile"`,
  ##   - `"has_photo"`,
  ##   - `"home_town"`,
  ##   - `"interests"`,
  ##   - `"is_favorite"`,
  ##   - `"is_friend"`,
  ##   - `"is_hidden_from_feed"`,
  ##   - `"last_seen"`,
  ##   - `"lists"`,
  ##   - `"maiden_name"`,
  ##   - `"military"`,
  ##   - `"movies"`,
  ##   - `"music"`,
  ##   - `"nickname"`,
  ##   - `"occupation"`,
  ##   - `"online"`,
  ##   - `"personal"`,
  ##   - `"photo_100"`,
  ##   - `"photo_200"`,
  ##   - `"photo_200_orig"`,
  ##   - `"photo_400_orig"`,
  ##   - `"photo_50"`,
  ##   - `"photo_id"`,
  ##   - `"photo_max"`,
  ##   - `"photo_max_orig"`,
  ##   - `"quotes"`,
  ##   - `"relation"`,
  ##   - `"relatives"`,
  ##   - `"schools"`,
  ##   - `"screen_name"`,
  ##   - `"sex"`,
  ##   - `"site"`,
  ##   - `"status"`,
  ##   - `"timezone"`,
  ##   - `"tv"`,
  ##   - `"universities"`,
  ##   - `"verified"`,
  ##   - `"wall_comments"`.
  ## - `name_case` -- Падеж для склонения имени и фамилии пользователя. Возможные значения:
  ##   - именительный – `"nom"`,
  ##   - родительный – `"gen"`,
  ##   - дательный – `"dat"`,
  ##   - винительный – `"acc"`,
  ##   - творительный – `"ins"`,
  ##   - предложный – `"abl"`.
  ##   По умолчанию `"nom"`.
  ##
  ## ## Result
  ## После успешного выполнения возвращает объект, содержащий число результатов в поле count и массив объектов user в поле items.
  ## Идентификаторы пользователей в списке отсортированы в порядке убывания времени их добавления.
  let response = await x.vk.callVkMethod("users.getFollowers", %*{
    "fields": fields.join(","),
    "user_id": user_id,
    "offset": offset,
    "count": count,
    "name_case": name_case,
  })
  result = @[]
  for i in response:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(User))


proc getSubscriptions*(x: UsersMethods, user_id: int, extended: bool = false,
                      offset: int = 0, count: int = 100,
                      fields: seq[string] = @[]): Future[seq[User]] {.async.} =
  ## Получает список подписок пользователя VK.
  ##
  ## ## Arguments
  ## - `user_id` -- Идентификатор пользователя, подписки которого необходимо получить.
  ## - `extended` -- `true` – возвращает объединенный список, содержащий объекты group и user вместе. 
  ##   `false` – возвращает список идентификаторов групп и пользователей отдельно (по умолчанию).
  ## - `offset` -- Смещение необходимое для выборки определенного подмножества подписок. 
  ##    Этот параметр используется только если передан `extended=true`.
  ## - `count` -- Количество подписок, которые необходимо вернуть. 
  ##   Этот параметр используется только если передан `extended=true`.
  ## - `fields` -- Список дополнительных полей для объектов `user` и `group`, которые необходимо вернуть.
  ##
  ## ## Result
  ## После успешного выполнения возвращает объекты `users` и `groups`, 
  ## каждый из которых содержит поле `count` — количество результатов и `items` — список идентификаторов 
  ## пользователей или публичных страниц, на которые подписан текущий пользователь (из раздела «Интересные страницы»).
  ##
  ## Если был задан параметр `extended=1`, возвращает объединенный массив объектов `group` и `user` 
  ## в поле `items`, а также общее число результатов в поле `count`.
  let response = await x.vk.callVkMethod("users.getSubscriptions", %*{
    "fields": fields.join(","),
    "extended": extended.int,
    "user_id": user_id,
    "offset": offset,
    "count": count,
  })
  result = @[]
  for i in response:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(User))


proc report*(x: UsersMethods, user_id: int, `type`: ReportType, comment: string = ""): Future[seq[User]] {.async.} =
  ## Подает жалобу на пользователя VK.
  ##
  ## ## Arguments
  ## - `user_id` -- Идентификатор пользователя, на которого нужно подать жалобу. (Обязательный параметр)
  ## - `type` -- Тип жалобы, может принимать следующие значения:
  ##   - `rPorn` — порнография;
  ##   - `rSpam` — рассылка спама;
  ##   - `rInsult` — оскорбительное поведение;
  ##   - `rAdvertisement` — рекламная страница, засоряющая поиск. (Обязательный параметр)
  ## - `comment` -- Комментарий к жалобе на пользователя.
  ##
  ## ## Result
  ## После успешного выполнения возвращает 1.
  let response = await x.vk.callVkMethod("users.report", %*{
    "user_id": user_id,
    "type": $`type`,
    "comment": comment,
  })
  result = @[]
  for i in response:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(User))


proc search*(x: UsersMethods, q: string, sort: SearchUserSort = SearchUserSort.Popularity,
             offset: int = 0, count: int = 100, fields: seq[string] = @[],
             city: int = 0, city_id: int = 0, country: int = 0,
             country_id: int = 0, hometown: string = "",
             university_country: int = 0, university: int = 0,
             university_year: int = 0, university_faculty: int = 0,
             university_chair: int = 0, sex: Gender = Gender.AnyGender,
             status: MaritalStatus = MaritalStatus.NotMatter,
             age_from: int = 0, age_to: int = 0, birth_day: int = 0,
             birth_month: int = 0, birth_year: int = 0,
             online: bool = false, has_photo: bool = false,
             school_country: int = 0, school_city: int = 0,
             school_class: int = 0, school: int = 0,
             school_year: int = 0, religion: string = "",
             company: string = "", position: string = "",
             group_id: int = 0, from_list: seq[string] = @[],
             screen_ref: string = ""): Future[seq[User]] {.async.} =
  ## Осуществляет поиск пользователей VK.
  ##
  ## ## Arguments
  ## - `q` -- Строка поискового запроса. Например, Вася Бабич.
  ## - `sort` -- Сортировка результатов. Возможные значения:
  ##   - `RegDate` — по дате регистрации,
  ##   - `Popularity` — по популярности.
  ## - `offset` -- Смещение относительно первого найденного пользователя для выборки определенного подмножества.
  ## - `count` -- Количество возвращаемых пользователей.
  ##   Обратите внимание, даже при использовании параметра offset для получения информации доступны только первые 1000 результатов.
  ## - `fields` -- Список дополнительных полей профилей, которые необходимо вернуть. См. подробное описание.
  ##   Доступные значения:
  ##   - `"about"`,
  ##   - `"activities"`,
  ##   - `"bdate"`,
  ##   - `"blacklisted"`,
  ##   - `"blacklisted_by_me"`,
  ##   - `"books"`,
  ##   - `"can_post"`,
  ##   - `"can_see_all_posts"`,
  ##   - `"can_see_audio"`,
  ##   - `"can_send_friend_request"`,
  ##   - `"can_write_private_message"`,
  ##   - `"career"`,
  ##   - `"city"`,
  ##   - `"common_count"`,
  ##   - `"connections"`,
  ##   - `"contacts"`,
  ##   - `"country"`,
  ##   - `"crop_photo"`,
  ##   - `"domain"`,
  ##   - `"education"`,
  ##   - `"exports"`,
  ##   - `"followers_count"`,
  ##   - `"friend_status"`,
  ##   - `"games"`,
  ##   - `"has_mobile"`,
  ##   - `"has_photo"`,
  ##   - `"home_town"`,
  ##   - `"interests"`,
  ##   - `"is_favorite"`,
  ##   - `"is_friend"`,
  ##   - `"is_hidden_from_feed"`,
  ##   - `"last_seen"`,
  ##   - `"lists"`,
  ##   - `"maiden_name"`,
  ##   - `"military"`,
  ##   - `"movies"`,
  ##   - `"music"`,
  ##   - `"nickname"`,
  ##   - `"occupation"`,
  ##   - `"online"`,
  ##   - `"personal"`,
  ##   - `"photo_100"`,
  ##   - `"photo_200"`,
  ##   - `"photo_200_orig"`,
  ##   - `"photo_400_orig"`,
  ##   - `"photo_50"`,
  ##   - `"photo_id"`,
  ##   - `"photo_max"`,
  ##   - `"photo_max_orig"`,
  ##   - `"quotes"`,
  ##   - `"relation"`,
  ##   - `"relatives"`,
  ##   - `"schools"`,
  ##   - `"screen_name"`,
  ##   - `"sex"`,
  ##   - `"site"`,
  ##   - `"status"`,
  ##   - `"timezone"`,
  ##   - `"tv"`,
  ##   - `"universities"`,
  ##   - `"verified"`,
  ##   - `"wall_comments"`.
  ## - `city` -- Идентификатор города.
  ## - `city_id` -- Идентификатор города для обратной совместимости. Используйте `city`.
  ## - `country` -- Идентификатор страны.
  ## - `country_id` -- Идентификатор страны для обратной совместимости. Используйте `country`.
  ## - `hometown` -- Название города строкой.
  ## - `university_country` -- Идентификатор страны, в которой пользователи закончили ВУЗ.
  ## - `university` -- Идентификатор ВУЗа.
  ## - `university_year` -- Год окончания ВУЗа.
  ## - `university_faculty` -- Идентификатор факультета.
  ## - `university_chair` -- Идентификатор кафедры.
  ## - `sex` -- Пол. Возможные значения:
  ##   - `Female` — женщина,
  ##   - `Male` — мужчина,
  ##   - `AnyGender` — любой (по умолчанию).
  ## - `status` -- Семейное положение. Возможные значения:
  ##   - `NotMarried` — не женат (не замужем),
  ##   - `Dating` — встречается,
  ##   - `Engaged` — помолвлен(-а),
  ##   - `Married` — женат (замужем),
  ##   - `Difficult` — всё сложно,
  ##   - `ActiveSearch` — в активном поиске,
  ##   - `InLove` — влюблен(-а),
  ##   - `CivilMarriage` — в гражданском браке.
  ## - `age_from` -- Возраст, от.
  ## - `age_to` -- Возраст, до.
  ## - `birth_day` -- День рождения.
  ## - `birth_month` -- Месяц рождения.
  ## - `birth_year` -- Год рождения.
  ## - `online` -- Учитывать ли статус «онлайн». Возможные значения:
  ##   - `true` — искать только пользователей онлайн,
  ##   - `false` — искать по всем пользователям.
  ## - `has_photo` -- Учитывать ли наличие фото. Возможные значения:
  ##   - `true` — искать только пользователей с фотографией,
  ##   - `false` — искать по всем пользователям.
  ## - `school_country` -- Идентификатор страны, в которой пользователи закончили школу.
  ## - `school_city` -- Идентификатор города, в котором пользователи закончили школу.
  ## - `school_class` -- Буква класса.
  ## - `school` -- Идентификатор школы, которую закончили пользователи.
  ## - `school_year` -- Год окончания школы.
  ## - `religion` -- Религиозные взгляды.
  ## - `company` -- Название компании, в которой работают пользователи.
  ## - `position` -- Название должности.
  ## - `group_id` -- Идентификатор группы, среди пользователей которой необходимо проводить поиск.
  ## - `from_list` -- Разделы среди которых нужно осуществить поиск, перечисленные через запятую. Возможные значения:
  ##   - `"friends"` — искать среди друзей,
  ##   - `"subscriptions"` — искать среди друзей и подписок пользователя.
  ## - `screen_ref` -- Реферер, откуда был вызван метод.
  ##
  ## ## Result
  ## После успешного выполнения возвращает объект, содержащий число
  var arguments = %*{
    "q": q,
    "sort": if sort == Popularity: 0 else: 1,
    "offset": offset,
    "count": count,
    "fields": fields.join(","),
    "city": city,
    "city_id": city_id,
    "country": country,
    "country_id": country_id,
    "hometown": hometown,
    "university_country": university_country,
    "university": university,
    "university_year": university_year,
    "university_faculty": university_faculty,
    "university_chair": university_chair,
    "sex": case sex
      of Gender.Female: 1
      of Gender.Male: 2
      of Gender.AnyGender: 0,
    "status": case status
      of MaritalStatus.NotMarried: 1
      of MaritalStatus.Dating: 2
      of MaritalStatus.Engaged: 3
      of MaritalStatus.Married: 4
      of MaritalStatus.Difficult: 5
      of MaritalStatus.ActiveSearch: 6
      of MaritalStatus.InLove: 7
      of MaritalStatus.CivilMarriage: 8
      of MaritalStatus.NotMatter: 0,
    "age_from": age_from,
    "age_to": age_to,
    "birth_day": birth_day,
    "birth_month": birth_month,
    "birth_year": birth_year,
    "online": online.int,
    "has_photo": has_photo.int,
    "school_country": school_country,
    "school_city": school_city,
    "school_class": school_class,
    "school": school,
    "school_year": school_year,
    "religion": religion,
    "company": company,
    "position": position,
    "group_id": group_id,
    "from_list": from_list.join(","),
    "screen_ref": screen_ref,
  }
  removeEmptyArgs()
  let response = await x.vk.callVkMethod("users.search", arguments)
  result = @[]
  for i in response["items"]:
    var j: string
    j.toUgly(i)
    result.add(j.fromJson(User))
