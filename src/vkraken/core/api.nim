import
  asyncdispatch,
  httpclient,
  macros,
  json,
  uri,
  jsony,
  ./exceptions,
  ./objects

when defined(vkrakenDebug):
  import terminal

export
  json


const
  VkApiCom* = "api.vk.com/"
  VkApiRu* = "api.vk.ru/"


type
  VkClient* = object
    token*: string
    lang*: string
    version*: string
    client: AsyncHttpClient
  # just some syntax sugar ~
  MethodsRoot* = object of RootObj
    vk*: VkClient
  MessagesMethods* = object of MethodsRoot  # object for search methods
  UsersMethods* = object of MethodsRoot  # object for users methods
  SearchMethods* = object of MethodsRoot  # object for search methods


proc initVk*(accessToken: string, version: float = 5.199, lang: string = ""): VkClient =
  VkClient(
    token: accessToken, lang: lang, version: $version,
    client: newAsyncHttpClient(headers = {
      "Authorization": "Bearer " & accessToken
    }.newHttpHeaders)
  )


proc callVkMethod*(self: VkClient, name: string, arguments: JsonNode): Future[JsonNode] {.async.} =
  ## Call VK method via GET
  # Build URL
  var
    url = "https://" & VkApiCom & "method/" & name & "?"
    args = "v=" & self.version
  # add arguments to URL
  for arg, value in arguments.pairs:
    if value.kind == JString:
      args &= "&" & arg & "=" & value.getStr.encodeUrl()
    else:
      args &= "&" & arg & "=" & $value
  url &= args
  # send request
  let response = fromJson(await self.client.getContent(url), VkResponse)
  if response.response.isNil:
    case response.error.error_code
    of 1:
      raise newException(UnknownException, response.error.error_msg)
    of 2:
      raise newException(AppDisabledException, response.error.error_msg)
    of 3:
      raise newException(UnknownMethodException, response.error.error_msg)
    of 4:
      raise newException(WrongSignException, response.error.error_msg)
    of 5:
      raise newException(WrongAuthException, response.error.error_msg)
    of 6:
      raise newException(TooManyRequestsException, response.error.error_msg)
    of 7:
      raise newException(NotAvailableException, response.error.error_msg)
    of 8:
      raise newException(WrongRequestException, response.error.error_msg)
    of 9:
      raise newException(SimilarActionsException, response.error.error_msg)
    of 10:
      raise newException(ServerErrorException, response.error.error_msg)
    of 11:
      raise newException(TestModeErrorException, response.error.error_msg)
    of 14:
      raise newException(CaptchaRequiredException, response.error.error_msg)
    of 15:
      raise newException(AccessDeniedException, response.error.error_msg)
    of 16:
      raise newException(HTTPSRequiredException, response.error.error_msg)
    of 17:
      raise newException(UserValidationException, response.error.error_msg)
    of 18:
      raise newException(PageBlockedException, response.error.error_msg)
    of 20:
      raise newException(ForbiddenActionException, response.error.error_msg)
    of 21:
      raise newException(StandaloneOnlyException, response.error.error_msg)
    of 23:
      raise newException(MethodDisabledException, response.error.error_msg)
    of 24:
      raise newException(UserConfirmationRequiredException, response.error.error_msg)
    of 27:
      raise newException(InvalidCommunityTokenException, response.error.error_msg)
    of 28:
      raise newException(InvalidAppTokenException, response.error.error_msg)
    of 29:
      raise newException(MethodCallLimitExceededException, response.error.error_msg)
    of 30:
      raise newException(PrivateProfileException, response.error.error_msg)
    of 100:
      raise newException(MissingParameterException, response.error.error_msg)
    of 101:
      raise newException(InvalidAppIDException, response.error.error_msg)
    of 113:
      raise newException(InvalidUserIDException, response.error.error_msg)
    of 150:
      raise newException(InvalidTimestampException, response.error.error_msg)
    of 200:
      raise newException(AlbumAccessDeniedException, response.error.error_msg)
    of 201:
      raise newException(AudioAccessDeniedException, response.error.error_msg)
    of 203:
      raise newException(GroupAccessDeniedException, response.error.error_msg)
    of 300:
      raise newException(AlbumOverflowException, response.error.error_msg)
    of 500:
      raise newException(ForbiddenActionPaymentException, response.error.error_msg)
    of 600:
      raise newException(AdAccountAccessException, response.error.error_msg)
    of 603:
      raise newException(AdAccountErrorException, response.error.error_msg)
    of 103:
      raise newException(OutOfLimitsException, response.error.error_msg)
    of 925:
      raise newException(NotChatAdminException, response.error.error_msg)
    of 932:
      raise newException(CommunityInteractionLimitException, response.error.error_msg)
    of 936:
      raise newException(ContactNotFoundException, response.error.error_msg)
    of 939:
      raise newException(MessageRequestSentException, response.error.error_msg)
    of 945:
      raise newException(DisabledChatException, response.error.error_msg)
    of 946:
      raise newException(UnsupportedChatException, response.error.error_msg)
    of 947:
      raise newException(UserAccessDeniedException, response.error.error_msg)
    of 967:
      raise newException(NotEmployeeException, response.error.error_msg)
    of 981:
      raise newException(PrivacySettingsException, response.error.error_msg)
    of 982:
      raise newException(TemporaryChatAdditionException, response.error.error_msg)
    else:
      raise newException(VkException, $response.error)
  when defined(vkrakenDebug):
    styledEcho fgYellow, "New request:"
    styledEcho fgYellow, "  URL: ", styleUnderscore, styleBright, fgBlue, url
    styledEcho fgYellow, "  Response:"
    styledEcho styleBright, fgYellow, "  ", $response
  return response.response


template methods(funcname, obj: untyped): untyped =
  proc `funcname`*(self: VkClient): `obj` = `obj`(vk: self)


methods(messages, MessagesMethods)
methods(users, UsersMethods)
methods(search, SearchMethods)


macro `~`*(self: VkClient, call: untyped): untyped =
  result = newCall(
    "callVkMethod",
    self,
    newLit($call[0].toStrLit),
    newCall("%*", newNimNode(nnkTableConstr))
  )
  for arg in call[1..^1]:
    result[^1][1].add(newColonExpr(
      newLit($arg[0]),
      arg[1]
    ))


proc removeEmptyArgs*(arguments: JsonNode) =
  for k, v in arguments:
    if v.kind == JString and v.getStr == "":
      arguments.delete(k)
    elif v.kind == JInt and v.getInt == 0:
      arguments.delete(k)
    elif v.kind == JArray and v.len == 0:
      arguments.delete(k)
