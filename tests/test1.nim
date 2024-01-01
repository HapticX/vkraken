import
  vkraken,
  ./config


let
  bot = initVk(VK_GROUP_TOKEN)
  user = initVk(VK_USER_TOKEN)


echo "get ..."
for user in waitFor bot.users.get(@[1, 2, 556962840]):
  echo user.first_name, " ", user.last_name

echo "search ..."
for user in waitFor user.users.search("Фомин Никита", count = 1):
  echo "[", user.id, "] ", user.first_name, " ", user.last_name

echo "get by ID"
echo (waitFor user~users.get(user_ids = "556962840"))[0]["first_name"]
