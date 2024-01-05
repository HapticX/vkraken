import
  strformat,
  strutils,
  terminal,
  macros,
  jsony,
  json,
  ./exceptions


type
  ErrorObject* = object
    error_code*: int
    error_msg*: string
  VkResponse* = object
    response*: JsonNode
    error*: ErrorObject
  ReportType* {.pure.} = enum
    rPorn = "porn",
    rSpam = "spam",
    rInsult = "insult",
    rAdvertisement = "adverisement"
  SearchUserSort* {.pure, size: sizeof(int8).} = enum
    RegDate,
    Popularity
  Gender* {.pure, size: sizeof(int8).} = enum
    Female,
    Male,
    AnyGender
  SearchHintType* {.pure.} = enum
    Group = "group",
    Profile = "profile"
  MaritalStatus* {.pure, size: sizeof(int8).} = enum
    NotMatter = 0,
    NotMarried = 1,
    Dating = 2,
    Engaged = 3,
    Married = 4,
    Difficult = 5,
    ActiveSearch = 6,
    InLove = 7,
    CivilMarriage = 8
  Platform* {.pure, size: sizeof(int).} = enum
    MobileVersion = 1,
    Iphone = 2,
    Ipad = 3,
    Android = 4,
    WindowsPhone = 5,
    Windows10 = 6,
    FullVersion = 7
  OccupationType* {.pure.} = enum
    Work = "work",
    School = "school",
    University = "university"
  Political* {.pure, size: sizeof(int).} = enum
    Communist = 1,
    Socialist = 2,
    Moderate = 3,
    Liberal = 4,
    Conservative = 5,
    Monorchical = 6,
    Ultraconservative = 7,
    Indifferent = 8,
    Libertarian = 9
  PeopleMain* {.pure, size: sizeof(int).} = enum
    IntelligenceAndCreativity = 1,
    KiddnessAndHonesty = 2,
    BeautyAndHealth = 3,
    PowerAndWealth = 4,
    CourageAndPerseverance = 5,
    HumorAndLoveOfLife = 6
  LifeMain* {.pure, size: sizeof(int).} = enum
    Family = 1,
    Money = 2,
    Recreation = 3,
    Research = 4,
    Improving = 5,
    SelfDevelopment = 6,
    Beauty = 7,
    Influence = 8
  RelativeType* {.pure.} = enum
    Child = "child",
    Sibling = "sibling",
    Parent = "parent",
    GrandParent = "grandparent",
    GrandChild = "grandchild"
  ButtonColor* {.pure.} = enum
    Primary = "primary",
    Secondary = "secondary",
    Negative = "negative",
    Positive = "positive"
  TemplateType* {.pure.} = enum
    Carousel
  CarouselElementActionType* {.pure.} = enum
    OpenLink,
    OpenPhoto
  ContentSourceType* {.pure.} = enum
    Message,
    Url
  WhoCanWiki* {.pure.} = enum
    All,
    Members,
    Admins
  OrderStatus* {.pure, size: sizeof(int8).} = enum
    NewOrder = 0,
    Agreed = 1,
    Assembled = 2,
    Delivered = 3,
    Completed = 4,
    Canceled = 5,
    Removed = 6
  Career* = object
    group_id*: int
    company*: string
    country_id*: int
    city_id*: int
    city_name*: string
    `from`*: int
    until*: int
    position*: string
  City* = object
    id*: int
    title*: string
  Contacts* = object
    mobile_phone*: string
    home_phone*: string
  Contact* = object
    user_id*: int
    desc*: string
    phone*: string
    email*: string
  UserCounters* = object
    albums*: int
    videos*: int
    audios*: int
    photos*: int
    notes*: int
    friends*: int
    gifts*: int
    groups*: int
    online_friends*: int
    mutual_friends*: int
    user_videos*: int
    user_photos*: int
    followers*: int
    pages*: int
    subscriptions*: int
  CommunityCounters* = object
    albums*: int
    videos*: int
    audios*: int
    photos*: int
    docs*: int
    topics*: int
  Country* = object
    id*: int
    title*: string
  Rect* = object
    x*: float
    y*: float
    x2*: float
    y2*: float
  PhotoSize* = object
    `type`*: string
    url*: string
    width*: int
    heigth*: int
  Photo* = object
    id*: int
    album_id*: int
    owner_id*: int
    user_id*: int
    text*: string
    date*: int
    sizes*: seq[PhotoSize]
    width*: int
    height*: int
  CropPhoto* = object
    photo*: Photo
    crop*: Rect
    rect*: Rect
  Education* = object
    university*: int
    university_name*: string
    faculty*: int
    faculty_name*: string
    graduation*: int
  Seen* = object
    time*: int
    platform*: Platform
  Military* = object
    unit*: string
    unit_id*: int
    country_id*: int
    `from`*: int
    until*: int
  Occupation* = object
    `type`*: OccupationType
    id*: int
    name*: string
  Personal* = object
    political*: Political
    langs*: seq[string]
    religion*: string
    inspired_by*: string
    people_main*: PeopleMain
    life_main*: LifeMain
    smoking*: int
    alcohol*: int
  Relative* = object
    id*: int
    name*: string
    `type`*: RelativeType
  SearchHintGroup* = object
    id*: int
    name*: string
    is_closed*: int
    is_admin*: int
    is_member*: int
    `type`*: string
    photo*: string
    photo_medium*: string
    photo_big*: string
  SearchHintProfile* = object
    id*: int
    first_name*: string
    last_name*: string
  SearchHint* = object
    case `type`*: SearchHintType
    of SearchHintType.Group:
      group*: SearchHintGroup
    of SearchHintType.Profile:
      profile*: SearchHintProfile
    section*: string
    description*: string
    global*: int
  School = object
    id*: int
    country*: int
    city*: int
    name*: string
    year_from*: int
    year_to*: int
    year_graduated*: int
    class*: string
    speciality*: string
    `type`*: int
    type_str*: string
  University* = object
    id*: int
    country*: int
    city*: int
    name*: string
    faculty*: int
    faculty_name*: string
    chair*: int
    chair_name*: string
    graduation*: int
    education_form*: string
    education_status*: string
  BanInfo* = object
    end_date*: int
    comment*: string
  CoverImage* = object
    url*: string
    width*: int
    height*: int
  Cover* = object
    enabled*: int
    images*: seq[CoverImage]
  Link* = object
    id*: int
    url*: string
    name*: string
    desc*: string
    photo_50*: string
    photo_100*: string
  Wallet* = object
    id*: int
    name*: string
  Market* = object
    enabled*: int
    `type`: string
    price_min*: int
    price_max*: int
    main_album_id*: int
    contact_id*: int
    currency*: Wallet
    currency_text*: string
  Place* = object
    id*: int
    title*: string
    latitude*: float
    longitude*: float
    `type`*: string
    country*: int
    city*: int
    address*: string
    updated*: int
    checkins*: int
    icon*: int
    created*: int
  CommentsPermission* = object
    count*: int
    can_post*: int
    groups_can_post*: bool
    can_close*: bool
    can_open*: bool
  Copyright* = object
    id*: int
    link*: string
    name*: string
    `type`*: string
  LikesInfo* = object
    count*: int
    user_likes*: int
    can_like*: int
    can_publish*: int
  RepostsInfo* = object
    count*: int
    user_reposted*: int
  ViewsInfo* = object
    count*: int
  AttachmentType* {.pure.} = enum
    atPhoto = "photo"
  Attachment* = object
    case `type`*: AttachmentType
    of atPhoto:
      photo*: Photo
  Geo* = object
    `type`*: string
    coordinates*: string
    place*: Place
  Coordinates* = object
    latitude*: int
    longitude*: int
  GeoMessage* = object
    `type`*: string
    coordinates*: Coordinates
    place*: Place
    showmap*: int
  VkDonut* = object
    is_donut*: bool
    paid_duration*: int
    placeholder*: JsonNode
    can_publish_free_copy*: bool
    edit_mode*: string
  VkDonutComment* = object
    is_don*: bool
    placeholder*: string
  KeyboardAction* = object
    payload*: string
    label*: string
    hash*: string
    app_id*: int
    owner_id*: int
    link*: string
    `type`*: string
  KeyboardButton* = object
    action*: KeyboardAction
    color*: ButtonColor
  Keyboard* = object
    one_time*: bool
    inline*: bool
    buttons*: seq[KeyboardButton]
  CarouselElementAction* = object
    case `type`*: CarouselElementActionType
    of OpenLink:
      link*: string
    of OpenPhoto:
      discard
  CarouselElement* = object
    title*: string  ## Заголовок, максимум 80 символов.
    description*: string  ## Подзаголовок, максимум 80 символов.
    photo_id*: string  ## ID изображения, которое надо прикрепить.
                       ## Пропорции изображения: 13/8;
                       ## Минимальный размер: 221х136;
                       ## Загрузка изображений для карусели происходит также,
                       ## как и загрузка изображений ботами в сообщениях.
    action*: CarouselElementAction
    buttons*: seq[KeyboardButton]  ## Один элемент карусели может содержать не больше 3-х кнопок.
  Template* = object
    case `type`*: TemplateType
    of TemplateType.Carousel:
      elements*: seq[CarouselElement]
  ForwardBotMessage* = object
    owner_id*: int
    peer_id*: int
    conversation_message_ids*: seq[int]
    message_ids*: seq[int]
    is_reply: bool
  ContentSource* = object
    case `type`*: ContentSourceType
    of ContentSourceType.Message:
      owner_id*: int
      peer_id*: int
      conversation_message_id*: int
    of ContentSourceType.Url:
      url*: string
  MessageActionPhoto* = object
    photo_50*: string
    photo_100*: string
    photo_200*: string
  MessageAction* = object
    `type`*: string
    member_id*: int
    text*: string
    email*: string
    photo*: MessageActionPhoto
  Peer* = object
    id*: int  ## идентификатор назначения
    `type`*: string  ## тип. Возможные значения: user, chat, group, email
    local_id*: int  ## локальный идентификатор назначения. Для чатов — id - 2000000000, для сообществ — -id, для email — -(id+2000000000).
  PushSettings* = object  ## Настройки оповещений.
    disabled_until*: int  ## указывает, до какого времени оповещения для чата отключены. -1 — отключены навсегда (бессрочно).
    disabled_forever*: bool
    no_sound*: bool  ## указывает, включен ли звук оповещений (1 — включен, 0 — отключен)
  CanWrite* = object
    allowed*: bool  ## true, если пользователь может писать в диалог;
    reason*: int  ## код ошибки для allowed = false. Возможные значения:
                  ## - 18 — пользователь заблокирован или удален;
                  ## - 900 — нельзя отправить сообщение пользователю, который в чёрном списке;
                  ## - 901 — пользователь запретил сообщения от сообщества;
                  ## - 902 — пользователь запретил присылать ему сообщения с помощью настроек приватности;
                  ## - 915 — в сообществе отключены сообщения;
                  ## - 916 — в сообществе заблокированы сообщения;
                  ## - 917 — нет доступа к чату;
                  ## - 918 — нет доступа к e-mail;
                  ## - 203 — нет доступа к сообществу.
  ChatPhoto* = object
    photo_50*: string
    photo_100*: string
    photo_200*: string
    photo_base*: string
  User* = object
    id*: int
    first_name*: string
    last_name*: string
    deactivated*: string
    is_closed*: bool
    can_access_closed*: bool
    about*: string
    activities*: string
    bdate*: string
    blacklisted*: int
    blacklisted_by_me*: int
    books*: string
    can_post*: int
    can_see_all_posts*: int
    can_see_audio*: int
    can_send_friend_request*: int
    can_write_privite_message*: int
    career*: Career
    city*: City
    common_count*: int
    contacts*: Contacts
    counters*: UserCounters
    country*: Country
    crop_photo*: CropPhoto
    domain*: string
    education*: Education
    followers_count*: int
    friend_status*: int
    games*: string
    has_mobile*: int
    has_photo*: int
    home_town*: string
    interests*: string
    is_favorite*: int
    is_friend*: int
    is_hidden_from_feed*: int
    is_no_index*: int
    last_seen*: Seen
    lists*: string
    maiden_name*: string
    military*: Military
    movies*: string
    music*: string
    nickname*: string
    occupation*: Occupation
    online*: int
    personal*: Personal
    photo_50*: string
    photo_100*: string
    photo_200*: string
    photo_200_orig*: string
    photo_400_orig*: string
    photo_400*: string
    photo_id*: int
    photo_max*: string
    photo_max_orig*: string
    quotes*: string
    relatives*: seq[Relative]
    relation*: int
    schools*: seq[School]
    screen_name*: string
    sex*: int
    site*: string
    status*: string
    timezone*: int
    trending*: int
    tv*: string
    universities*: seq[University]
    verified*: int
    wall_default*: string
  Community* = object
    id*: int
    name*: string
    screen_name*: string
    is_closed*: int
    deactivated*: string
    is_admin*: int
    admin_level*: int
    is_member*: int
    is_advertiser*: int
    invited_by*: int
    `type`*: string
    photo_50*: string
    photo_100*: string
    photo_200*: string
    activity*: string
    age_limits*: string
    ban_info*: BanInfo
    can_create_topic*: int
    can_message*: int
    can_post*: int
    can_suggest*: int
    can_see_all_posts*: int
    can_upload_doc*: int
    can_upload_video*: int
    can_upload_story*: int
    city*: City
    contacts*: seq[Contact]
    counters*: CommunityCounters
    country*: Country
    cover*: Cover
    crop_photo*: CropPhoto
    description*: string
    fixed_post*: int
    has_photo*: int
    is_favorite*: int
    is_hidden_from_feed*: int
    is_message_blocked*: int
    links*: seq[Link]
    main_album_id: int
    main_section*: int
    market*: Market
    member_status*: int
    members_count*: int
    place*: Place
    public_date_label*: string
    site*: string
    start_date*: int
    finish_date*: int
    status*: string
    trending*: int
    verified*: int
    wall*: int
    wiki_page*: string
  WallPostRef* = ref WallPost
  WallPost* = object
    id*: int
    owner_id*: int
    from_id*: int
    created_by*: int
    date*: int
    text*: int
    reply_owner_id*: int
    reply_post_id*: int
    friends_only*: int
    comments*: CommentsPermission
    copyright*: Copyright
    likes*: LikesInfo
    resposts*: RepostsInfo
    views*: ViewsInfo
    post_type*: string
    post_source*: string
    attachments*: seq[Attachment]
    geo*: Geo
    signer_id*: int
    copy_history*: seq[WallPostRef]
    can_pin*: int
    can_delete*: int
    can_edit*: int
    is_pinned*: int
    marked_as_ads*: int
    is_favorite*: bool
    donut*: VkDonut
    postponed_id*: int
  WallCommentRef* = ref WallComment
  WallCommentThread* = object
    count*: int
    items*: seq[WallCommentRef]
    can_post*: bool
    show_reply_button*: bool
    groups_can_post*: bool
  WallComment* = object
    id*: int
    from_id*: int
    date*: int
    text*: int
    donut*: VkDonutComment
    reply_to_user*: int
    reply_to_comment*: int
    attachments*: seq[Attachment]
    parents_stack*: seq[int]
    thread*: WallCommentThread
  MessageRef* = ref Message
  Message* = object
    id*: int
    date*: int
    peer_id*: int
    from_id*: int
    text*: string
    `ref`*: string
    ref_source*: string
    attachments*: seq[Attachment]
    important*: bool
    geo*: GeoMessage
    payload*: string
    keyboard*: Keyboard
    fwd_messages*: seq[MessageRef]
    reply_message*: MessageRef
    action*: MessageAction
    admin_author_id*: int
    conversation_message_id*: int
    is_cropped*: bool
    members_count*: int
    update_time*: int
    was_listened*: bool
    pinned_at*: int
    message_tag*: string
    is_mentioned_user*: bool
  PinnedMessage* = object
    id*: int  ## Идентификатор сообщения.
              ## Содержит 0, если у текущего пользователя нет этого сообщения в истории
              ## (например, оно было отправлено в мультичат до того, как пользователя пригласили).
    date*: int  ## Время отправки сообщения в Unixtime.
    from_id*: int  ## Идентификатор отправителя.
    text*: string  ## Текст сообщения.
    attachments*: seq[Attachment]  ## Медиавложения сообщения (фотографии, ссылки и т.п.).
    geo*: GeoMessage  ## Информация о местоположении
    fwd_messages*: seq[MessageRef]  ## Массив пересланных сообщений (если есть).
                                    ## Максимальное количество элементов — 100.
                                    ## Максимальная глубина вложенности для пересланных сообщений — 45,
                                    ## общее максимальное количество в цепочке с учетом вложенности — 500.
  ChatSettings* = object
    members_count*: int  ## число участников
    title*: string  ## название
    pinned_message*: PinnedMessage  ## объект закреплённого сообщения, если есть
    state*: string  ## статус текущего пользователя. Возможные значения:
                    ## - in — состоит в чате;
                    ## - kicked — исключён из чата;
                    ## - left — покинул чат.
    photo*: ChatPhoto  ## изображение-обложка чата
    active_ids*: seq[int]  ## идентификаторы последних пользователей, писавших в чат
    is_group_channel*: bool  ## информация о том, является ли беседа каналом сообщества.
  Conversation* = object  ## Объект описывает беседу с пользователем, сообществом или групповой чат
    peer*: Peer  ## Информация о собеседнике
    in_read*: int  ## Идентификатор последнего прочтенного входящего сообщения.
    out_read*: int  ## Идентификатор последнего прочтенного исходящего сообщения.
    unread_count*: int  ## Число непрочитанных сообщений.
    important*: bool  ## true, если диалог помечен как важный (только для сообщений сообществ).
    unanswered*: bool  ## true, если диалог помечен как неотвеченный (только для сообщений сообществ).
    push_settings*: PushSettings  ## Настройки Push-уведомлений.
    can_write*: CanWrite  ## Информация о том, может ли пользователь писать в диалог
    chat_settings*: ChatSettings  ## Настройки чата.
  Chat* = object  ## Объект, описывающий чат, содержит следующие поля:
    id*: int  ## Идентификатор беседы.
    `type`*: string  ## Тип диалога.
    title*: string  ## Название беседы.
    admin_id*: int  ## Идентификатор пользователя, который является создателем беседы.
    users*: seq[int]  ## Список идентификаторов (integer) участников беседы.
    push_settings*: PushSettings  ## Настройки оповещений для диалога.
    photo_50*: string  ## URL изображения-обложки чата шириной 50 px (если доступно).
    photo_100*: string  ## URL изображения-обложки чата шириной 100 px (если доступно).
    photo_200*: string  ## URL изображения-обложки чата шириной 200 px (если доступно).
    photo_base*: string  ## URL изображения-обложки чата шириной 400 px (если доступно). Добавив GET-параметр cs=<size>x<size>, где size=50|100|200 можно получить изображение соответствующего размера.
    left*: int  ## Флаг, указывающий, что пользователь покинул беседу. Всегда содержит 1.
    kicked*: int  ## Флаг, указывающий, что пользователь был исключен из беседы. Всегда содержит 1.
  Note* = object  ## Объект, описывающий заметку, содержит следующие поля:
    id*: int  ## Идентификатор заметки.
    owner_id*: int  ## Идентификатор владельца заметки.
    title*: string  ## Заголовок заметки.
    text*: string  ## Текст заметки.
    date*: int  ## Дата создания заметки в формате Unixtime.
    comments*: int  ## Количество комментариев.
    read_comments*: int  ## Количество прочитанных комментариев (только при запросе информации о заметке текущего пользователя).
    view_url*: string  ## URL страницы для отображения заметки.
    privacy_view*: string  ## Настройки приватности комментирования заметки
    can_comment*: int  ## Есть ли возможность оставлять комментарии
    text_wiki*: string  ## Тэги ссылок на wiki
  ChatUpdate* = object
    message_id*: int  ## идентификатор отправленного системного сообщения
    chat*: Chat  ## объект мультидиалога.
  CreatedChat* = object
    chat_id*: int
    peer_ids*: seq[int]
  LongPollServer* = object
    key*: string
    server*: string
    ts*: string
  WikiPage* = object
    id*: int
    group_id*: int
    creator_id*: int
    title*: string
    current_user_can_edit*: int
    current_user_can_edit_access*: int
    who_can_view*: WhoCanWiki
    who_can_edit*: WhoCanWiki
    edited*: int
    created*: int
    editor_id*: int
    views*: int
    parent*: string
    parent2*: string
    source*: string
    html*: string
    view_url*: string
  Price* = object
    amount*: string
    currency*: Wallet
    old_amount*: string
    text*: string
  Dimensions* = object
    width*: int
    height*: int
    length*: int
  CategorySection* = object
    id*: int
    name*: string
  Category* = object
    id*: int
    name*: string
    section*: CategorySection
  RejectInfo* = object
    title*: string
    description*: string
    buttons*: JsonNode
    moderation_status*: int
    info_link*: string
    white_to_support_link*: string
  Product* = object
    id*: int
    owner_id*: int
    title*: string
    description*: string
    price*: Price
    dimensions*: Dimensions
    weight*: int
    category*: Category
    thumb_photo*: string
    date*: int
    availability*: int
    is_favorite*: bool
    sku*: string
    reject_info*: RejectInfo
    photos*: seq[Photo]
    can_comment*: int
    can_repost*: int
    likes*: LikesInfo
    url*: string
    button_title*: string
  ProductSelection* = object
    id*: int
    owner_id*: int
    title*: string
    is_main*: bool
    is_hidden*: bool
    photo*: Photo
    count*: int
  PropertyValue* = object
    variant_id*: int
    variant_name*: string
    property_name*: string
  Delivery* = object
    address*: string
    `type`*: string
    track_number*: string
    track_link*: string
    delivery_point*: JsonNode
  Recipient* = object
    name*: string
    phone*: string
    display_text*: string
  Order* = object
    id*: int
    group_id*: int
    user_id*: int
    date*: int
    variants_grouping_id*: int
    is_main_variant*: bool
    property_values*: seq[PropertyValue]
    cart_quantity*: int
    status*: OrderStatus
    total_price*: Price
    display_order_id*: string
    comment*: string
    preview_order_items*: seq[Product]
    delivery*: Delivery
    recipient*: Recipient


# ---=== Constructors ===--- #

proc initKeyboard*(one_time, inline: bool, buttons: seq[KeyboardButton] = @[]): Keyboard =
  Keyboard(one_time: one_time, inline: inline, buttons: buttons)


macro buildKeyboard*(one_time, inline: static[bool], body: untyped) =
  ## Builds keyboard
  ## 
  ## ## Example
  ## 
  ## ```nim
  ## buildKeyboard true, true:
  ##   line:  # line of buttons
  ##     text:  # type of button. Can be "text", "open_link", "open_app", "location", "vkpay" or "callback"
  ##       label = "Button text here"
  ##       payload = "Hello!"
  ##       color = ButtonColor.Primary
  ## ```
  ## 
  var
    lineCount = 0
    btns = newCall("@", newNimNode(nnkBracket))
  for s in body:
    if s.kind in nnkCallKinds and s[0] == ident"line" and s[1].kind == nnkStmtList:
      var buttonsCount = 0
      # Check button lines
      if lineCount > 10:
        echo fmt"Lines of buttons more then 10!"
        echo lineInfo(s)
        raise newException(VkException, fmt"Lines of buttons more then 10!")
      # Iterate over buttons
      for btn in s[1]:
        if btn.kind in nnkCallKinds and btn[0].kind == nnkIdent and btn[1].kind == nnkStmtList:
          var
            actionData = newNimNode(nnkObjConstr).add(ident"KeyboardAction")
            btnData = newNimNode(nnkObjConstr).add(ident"KeyboardButton")
            clr = newDotExpr(ident"ButtonColor", ident"Primary")
          for btnField in btn[1]:
            if btnField.kind == nnkAsgn:
              # keyboard button action
              if btnField[0] == ident"color":
                clr = btnField[1]
              else:
                actionData.add(newNimNode(nnkExprColonExpr).add(
                  btnField[0],
                  btnField[1]
                ))
          if buttonsCount > 5:
            echo fmt"Buttons more then 5 in one line!"
            echo lineInfo(btn)
            raise newException(VkException, fmt"Buttons more then 5 in one line!")
          if ($btn[0]).toLower() in ["text", "open_link", "open_app", "location", "vkpay", "callback"]:
            # Button type
            btnData.add(newNimNode(nnkExprColonExpr).add(
              newNimNode(nnkAccQuoted).add(ident"type"), newLit($btn[0])
            ))
            # Button action
            btnData.add(newNimNode(nnkExprColonExpr).add(ident"action", actionData))
            # Button color
            btnData.add(newNimNode(nnkExprColonExpr).add(ident"color", clr))
            btns[1].add(btnData)
            inc buttonsCount
            continue
        echo fmt"Invalid type of button:"
        echo lineInfo(btn)
        raise newException(VkException, fmt"Invalid type of button:")
      # increase line counter
      inc lineCount
  result = newNimNode(nnkObjConstr).add(
    ident"Keyboard",
    newNimNode(nnkExprColonExpr).add(ident"one_time", newLit(one_time)),
    newNimNode(nnkExprColonExpr).add(ident"inline", newLit(inline)),
    newNimNode(nnkExprColonExpr).add(ident"buttons", btns),
  )
  echo result.toStrLit


macro buildKeyboard*(body: untyped): untyped =
  newCall("buildKeyboard", newLit(false), newLit(false), body)


# ---=== Hooks ===--- #

proc enumHook*(s: string, v: var SearchHintType) =
  v = case s:
  of "group": SearchHintType.Group
  of "profile": SearchHintType.Profile
  else: SearchHintType.Profile

proc enumHook*(s: string, v: var ContentSourceType) =
  v = case s:
  of "message": ContentSourceType.Message
  of "url": ContentSourceType.Url
  else: ContentSourceType.Url


proc enumHook*(s: string, v: var TemplateType) =
  v = case s:
  of "carousel": TemplateType.Carousel
  else: TemplateType.Carousel


proc enumHook*(s: string, v: var RelativeType) =
  v = case s:
  of "child":
    RelativeType.Child
  of "sibling":
    RelativeType.Sibling
  of "parent":
    RelativeType.Parent
  of "grandparent":
    RelativeType.GrandParent
  of "grandchild":
    RelativeType.GrandChild
  else: RelativeType.Parent


proc enumHook*(s: string, v: var CarouselElementActionType) =
  v = case s:
  of "open_link": CarouselElementActionType.OpenLink
  of "open_photo": CarouselElementActionType.OpenPhoto
  else: CarouselElementActionType.OpenLink


proc enumHook*(s: string, v: var Gender) =
  v = case s:
  of "0": Gender.AnyGender
  of "1": Gender.Female
  of "2": Gender.Male
  else: Gender.AnyGender


proc enumHook*(s: string, v: var Platform) =
  v = case s:
  of "1": MobileVersion
  of "2": Iphone
  of "3": Ipad
  of "4": Android
  of "5": WindowsPhone
  of "6": Windows10
  of "7": FullVersion
  else: FullVersion


proc enumHook*(s: string, v: var ButtonColor) =
  v = case s:
  of "primary":
    ButtonColor.Primary
  of "secondary":
    ButtonColor.Secondary
  of "negative":
    ButtonColor.Negative
  of "positive":
    ButtonColor.Positive
  else: ButtonColor.Primary

proc enumHook*(s: string, v: var ReportType) =
  v = case s:
  of "porn":
    ReportType.rPorn
  of "spam":
    ReportType.rSpam
  of "insult":
    ReportType.rInsult
  of "adverisement":
    ReportType.rAdvertisement
  else: ReportType.rPorn

proc enumHook*(s: string, v: var SearchUserSort) =
  v = case s:
  of "1":
    SearchUserSort.RegDate
  of "0":
    SearchUserSort.Popularity
  else: SearchUserSort.RegDate

proc enumHook*(s: string, v: var MaritalStatus) =
  v = case s:
  of "0":
    MaritalStatus.NotMatter
  of "1":
    MaritalStatus.NotMarried
  of "2":
    MaritalStatus.Dating
  of "3":
    MaritalStatus.Engaged
  of "4":
    MaritalStatus.Married
  of "5":
    MaritalStatus.Difficult
  of "6":
    MaritalStatus.ActiveSearch
  of "7":
    MaritalStatus.InLove
  of "8":
    MaritalStatus.CivilMarriage
  else: MaritalStatus.NotMatter

proc enumHook*(s: string, v: var OccupationType) =
  v = case s:
  of "work":
    OccupationType.Work
  of "school":
    OccupationType.School
  of "university":
    OccupationType.University
  else: OccupationType.Work

proc enumHook*(s: string, v: var Political) =
  v = case s:
  of "1":
    Political.Communist
  of "2":
    Political.Socialist
  of "3":
    Political.Moderate
  of "4":
    Political.Liberal
  of "5":
    Political.Conservative
  of "6":
    Political.Monorchical
  of "7":
    Political.Ultraconservative
  of "8":
    Political.Indifferent
  of "9":
    Political.Libertarian
  else: Political.Communist

proc enumHook*(s: string, v: var PeopleMain) =
  v = case s:
  of "1":
    PeopleMain.IntelligenceAndCreativity
  of "2":
    PeopleMain.KiddnessAndHonesty
  of "3":
    PeopleMain.BeautyAndHealth
  of "4":
    PeopleMain.PowerAndWealth
  of "5":
    PeopleMain.CourageAndPerseverance
  of "6":
    PeopleMain.HumorAndLoveOfLife
  else: PeopleMain.IntelligenceAndCreativity

proc enumHook*(s: string, v: var LifeMain) =
  v = case s:
  of "1":
    LifeMain.Family
  of "2":
    LifeMain.Money
  of "3":
    LifeMain.Recreation
  of "4":
    LifeMain.Research
  of "5":
    LifeMain.Improving
  of "6":
    LifeMain.SelfDevelopment
  of "7":
    LifeMain.Beauty
  of "8":
    LifeMain.Influence
  else: LifeMain.Family

proc enumHook*(s: string, v: var OrderStatus) =
  v = case s:
  of "0":
    OrderStatus.NewOrder
  of "1":
    OrderStatus.Agreed
  of "2":
    OrderStatus.Assembled
  of "3":
    OrderStatus.Delivered
  of "4":
    OrderStatus.Completed
  of "5":
    OrderStatus.Canceled
  of "6":
    OrderStatus.Removed
  else: OrderStatus.NewOrder

proc enumHook*(s: string, v: var WhoCanWiki) =
  v = case s:
  of "2":
    WhoCanWiki.All
  of "1":
    WhoCanWiki.Members
  of "0":
    WhoCanWiki.Admins
  else: WhoCanWiki.Admins
