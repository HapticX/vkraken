import
  vkraken,
  ./config


var
  bot = initVk(VK_GROUP_TOKEN, group_id = 221243174)
  user = initVk(VK_USER_TOKEN)


bot@message_new(ev):
  echo ev


waitFor bot.run()
