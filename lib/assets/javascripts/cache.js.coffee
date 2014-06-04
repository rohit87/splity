class OnlyStringsSupportedError extends Error
    constructor: () ->
      @message = "Only strings can be set in the cache!"

class OnlyStringsAreCacheIndentifiers extends Error
  constructor: () ->
    @message = "CacheIdentifiers are mandatory and can only be strings!"

class OnlyStringsAreCacheKeys extends Error
  constructor: () ->
    @message = "Only strings are permitted as keys!"

class NonExistentUUIDError extends Error
  constructor: () ->
    @message = "Could not locate cache with given UUID!"

class ApplicationCache

  constructor: (@uuid) ->
    @store = {}

  get: (key) ->
    throw OnlyStringsAreCacheKeys if typeof key isnt "string"
    if @store[key]? then return @store[key] else return null

  set: (key, value) ->
    throw OnlyStringsAreCacheKeys if typeof key isnt "string"
    throw new OnlyStringsSupportedError unless typeof value is "string"
    existing = @get(key)?
    @store[key] = value
    existing

  clear: () ->
    @store = {}

  hasKey: (key) ->
    @store[key]?


class LocalStorageCache extends ApplicationCache

  localStorageKey = (uuid) ->
    "biswarup_cache_#{uuid}"

  constructor: (@uuid) ->
    super(@uuid)
    fromMemory = window.localStorage.getItem localStorageKey(@uuid)
    return unless fromMemory?
    @store = JSON.parse fromMemory

  set: (key, value) ->
    super(key, value)
    window.localStorage.setItem localStorageKey(@uuid), JSON.stringify @store


class CacheProvider

  _store = {}

  @getCache: (uuid) ->
    throw new OnlyStringsAreCacheIndentifiers if uuid? and typeof uuid isnt "string"
    uuid = window.uuid() unless uuid?
    return _store[uuid] if _store[uuid]?
    # if window.localStorage? then cache = new LocalStorageCache uuid else cache = new ApplicationCache uuid
    cache = new ApplicationCache uuid
    _store[uuid] = cache

  @deleteCache: (uuid) ->
    throw new OnlyStringsAreCacheIndentifiers if typeof uuid isnt "string"
    throw new NonExistentUUIDError unless _store[uuid]?
    _store[uuid] = null
    true


window.CacheProvider = { 
  getCache: CacheProvider.getCache
  deleteCache: CacheProvider.deleteCache
}

window.ApplicationCache = ApplicationCache
window.LocalStorageCache = LocalStorageCache