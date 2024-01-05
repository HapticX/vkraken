import
  asyncdispatch,
  httpclient,
  strformat,
  strutils,
  macros,
  ../core/core,
  ../methods/methods


proc fetchServer(self: VkClient, server, key, ts, url: string): Future[JsonNode] {.async.} =
  var response = parseJson(await newAsyncHttpClient().getContent(url))
  if response.hasKey("failed"):
    let failed = response["failed"].getInt
    let newUrl =
      case failed
      of 1:
        let ts = response["ts"].getInt
        fmt"{server}?act=a_check&key={key}&ts={ts}&wait=25"
      else:
        let
          longPollServer = await self.groups.getLongPollServer(self.group_id)
          server = longPollServer.server
          key = longPollServer.key
          ts = longPollServer.ts
        fmt"{server}?act=a_check&key={key}&ts={ts}&wait=25"
    response = await self.fetchServer(server, key, ts, url)
  return response


iterator listen*(self: VkClient): JsonNode =
  var
    longPollServer = waitFor self.groups.getLongPollServer(self.group_id)
    server = longPollServer.server
    key = longPollServer.key
    ts = longPollServer.ts
    url = fmt"{server}?act=a_check&key={key}&ts={ts}&wait=25"
  while true:
    let upd = waitFor self.fetchServer(server, key, ts, url)
    ts = upd["ts"].getStr
    url = fmt"{server}?act=a_check&key={key}&ts={ts}&wait=25"
    for update in upd["updates"]:
      yield update


proc run*(self: VkClient, raw: bool = false) {.async.} =
  for event in self.listen():
    for handler in self.handlers:
      if handler.update_type == event["type"].getStr:
        await handler.cb(event)


macro `@`*(self: VkClient, event, body: untyped): untyped =
  ## Provides convenient handling longpoll events.
  ##
  ## ## Usage with lambda
  ## ```
  ## vk.events[event_name] =
  ##   proc(eent: JsonNode) =
  ##     body
  ## ```
  ##
  ## ## Usage with this macro
  ## ```
  ## vk@message_new(event):
  ##   echo event
  ## ```
  if event.kind == nnkCall:
    let
      arg = event[1]
      event_name = $event[0]
    result = quote do:
      if (
        let event = VkBotHandler(update_type: `event_name`, cb: proc(`arg`: JsonNode) {.async.} = `body`)
        event
      ) notin `self`.handlers:
        `self`.handlers.add(event)
