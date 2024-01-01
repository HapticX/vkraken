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
