describe 'CacheProvider', ->
  it 'should exist', ->
    expect(CacheProvider).toBeDefined()

  it 'should have a "getCache" function', ->
    expect(CacheProvider.getCache).toEqual jasmine.any Function

  it 'should throw an exception if and only if a getCache is called with a non-string', ->
    thrower = (o) ->
      () ->
        CacheProvider.getCache o
    expect(thrower {}).toThrow()
    expect(thrower []).toThrow() 
    expect(thrower 1).toThrow()
    expect(thrower false).toThrow()
    expect(thrower true).toThrow()
    expect(thrower true).toThrow()
    expect(thrower uuid()).not.toThrow()

  it 'should return an ApplicationCache', ->
    cache = CacheProvider.getCache()
    expect(cache).toEqual jasmine.any ApplicationCache

  it 'should return a cache with the correct uuid', ->
    guid = uuid()
    cache = CacheProvider.getCache(guid)
    expect(cache.uuid).toEqual guid

  it 'should set the cache uuid by default', ->
    cache = CacheProvider.getCache()
    expect(cache.uuid).toEqual jasmine.any String
    
  it 'should return the same cache for same uuid', ->
    guid = uuid()
    cache = CacheProvider.getCache guid
    cache2 = CacheProvider.getCache guid
    expect(cache).toEqual cache2

  it 'should return a different cache for different uuids', ->
    expect(CacheProvider.getCache uuid()).not.toEqual CacheProvider.getCache uuid()

  it 'should have a "deleteCache" function', ->
    expect(CacheProvider.deleteCache).toEqual jasmine.any Function

  it 'should throw an exception if and only if deleteCache is called with non-string', ->
    thrower = (o) -> () -> CacheProvider.deleteCache o
    expect(thrower {}).toThrow()
    expect(thrower []).toThrow() 
    expect(thrower 1).toThrow()
    expect(thrower false).toThrow()
    expect(thrower true).toThrow()
    expect(thrower CacheProvider.getCache().uuid).not.toThrow()

  it 'should throw an exception if a non-existent uuid is passed to deleteCache', ->
    thrower = ->
      CacheProvider.deleteCache uuid()
    expect(thrower).toThrow()

  it 'should return true if an existing uuid is passed', ->
    cache = CacheProvider.getCache()
    expect(CacheProvider.deleteCache cache.uuid).toEqual true
    guid = uuid()
    cache = CacheProvider.getCache guid
    expect(CacheProvider.deleteCache guid).toEqual true

  it 'should delete a cache when its uuid is passed', ->
    guid = uuid()
    cache = CacheProvider.getCache guid
    CacheProvider.deleteCache guid
    expect( -> CacheProvider.deleteCache guid).toThrow()

  describe 'ApplicationCache', ->

    cache = null

    beforeEach ->
      cache = CacheProvider.getCache()

    afterEach ->
      CacheProvider.deleteCache cache.uuid

    it 'should have a function "get"', ->
      expect(cache.get).toEqual jasmine.any(Function)

    it 'should have a function "set"', ->
      expect(cache.set).toEqual jasmine.any(Function)

    it 'should have a function "clear"', ->
      expect(cache.clear).toEqual jasmine.any(Function)

    it 'should have a function "hasKey"', ->
      expect(cache.hasKey).toEqual jasmine.any(Function)

    it 'should return null for non-existent keys', ->
      expect(cache.get(uuid())).toBeNull()

    it 'should throw an exception when calling "get" with an undefined key', ->
      expect( -> cache.get undefined).toThrow()

    it 'should throw an exception when calling "get" with a null key', ->
      expect( -> cache.get null).toThrow()

    it 'should throw an exception when calling "get" with a non-string key', ->
      thrower = (o) -> () -> cache.get o
      expect(thrower {}).toThrow()
      expect(thrower []).toThrow() 
      expect(thrower 1).toThrow()
      expect(thrower false).toThrow()
      expect(thrower true).toThrow()
      expect(thrower true).toThrow()
      expect(thrower "").not.toThrow()
    
    it 'should throw an exception if a non-string key is passed to "set"', ->
      thrower = (o) -> () -> cache.set o, uuid()
      _get = cache.get
      cache.get = ->
      expect(thrower {}).toThrow()
      expect(thrower []).toThrow() 
      expect(thrower 1).toThrow()
      expect(thrower false).toThrow()
      expect(thrower true).toThrow()
      expect(thrower true).toThrow()
      expect(thrower "").not.toThrow()
      cache.get = _get

    it 'should throw an exception if a non-string value is passed to "set"', ->
      thrower = (o) -> () -> cache.set uuid(), o
      _get = cache.get
      cache.get = ->
      expect(thrower {}).toThrow()
      expect(thrower []).toThrow() 
      expect(thrower 1).toThrow()
      expect(thrower false).toThrow()
      expect(thrower true).toThrow()
      expect(thrower true).toThrow()
      expect(thrower "").not.toThrow()
      cache.get = _get

    it 'should return the same value that was set', ->
      key = uuid()
      for x in [1..25]
        value = uuid()
        cache.set key, value
        expect(cache.get key).toEqual value

    it 'should update the value when calling set with same key again', ->
      key = uuid()
      for x in [1..25]
        value = uuid()
        cache.set key, value
        cache.set key, uuid()
        expect(cache.get key).not.toEqual value
    
    it 'should return false if nothing was overwritten when calling "set"', ->
      expect(cache.set uuid(), uuid()).toBeFalsy()

    it 'should return true if existing value was overwritten when calling "set"', ->
      key = uuid()
      cache.set key, uuid()
      expect(cache.set key, uuid()).toBeTruthy()
    
    it 'should return false for non-existent keys when calling "hasKey"', ->
      expect(cache.hasKey uuid()).toBeFalsy()

    it 'should return true for existing keys when calling "hasKey"', ->
      key = uuid()
      cache.set key, uuid()
      expect(cache.hasKey key).toBeTruthy()

    it 'should return true for keys regardless of being overwritten when calling "hasKey"', ->
      key = uuid()
      for x in [1..10]
        cache.set key, uuid()
      expect(cache.hasKey key).toBeTruthy()

    it 'should clear all keys after calling "clear"', ->
      key = uuid()
      for x in [1..10]
        cache.set key, uuid()
      cache.clear()
      expect(cache.get key).toBeNull()