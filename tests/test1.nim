import
  vkraken,
  ./config


let
  bot = initVk(VK_GROUP_TOKEN)
  user = initVk(VK_USER_TOKEN)


echo "users get ..."
for user in waitFor bot.users.get(@[1, 2, 556962840]):
  echo user.first_name, " ", user.last_name
echo "users search ..."
for user in waitFor user.users.search("Фомин Никита", count = 1):
  echo "[", user.id, "] ", user.first_name, " ", user.last_name


echo "search hints ..."
for obj in waitFor user.search.getHints("Никита", limit = 5):
  if obj.`type` == SearchHintType.Group:
    echo "GROUP [", $obj.group.id, "] ", obj.group.name
  else:
    echo "USER [", $obj.profile.id, "] ", obj.profile.first_name, " ", obj.profile.last_name


# ---=== `~` macro ===--- #
echo "get by ID"
echo (waitFor user~users.get(user_ids = "556962840"))[0]["first_name"]


echo "create chat ..."
let chat = waitFor user.messages.createChat(@[], "VKrakenTest")
echo "chat [", chat.chat_id, "]"
