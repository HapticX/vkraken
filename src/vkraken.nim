## # VKraken
## 
## > VK API for Nim 🔥
## 
## Welcome to API Reference
## 
## 
## ## API Reference 📕
## 
## ### Core
## - [api](vkraken/core/api.html): working with VK API
## - [exceptions](vkraken/exceptions.html): list of all exceptions
## - [objects](vkraken/core/objects.html): list of all objects
## 
## ### Methods
## - [messages](vkraken/methods/messages)
## - [users](vkraken/methods/users)
## - [search](vkraken/methods/search)
## 

when not defined(ssl):
  {.error: "You should enable ssl! Compile with -d:ssl please.".}

import
  asyncdispatch,
  vkraken/core/core,
  vkraken/methods/methods


export
  asyncdispatch,
  core,
  methods
