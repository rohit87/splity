n = namespace 'splity.models'

n.Friendship = Appacitive.Connection.extend 'friendship', {

  }, {

    create: (user1, user2) ->
      u1 = new n.User { __id: user1 }
      u2 = new n.User { __id: user2 }
      f1 = new n.Friendship {
        endpoints: [{
          object: u1
          label: 'user1'
        }, {
          object: u2,
          label: 'user2'
        }]
      }
      f2 = new n.Friendship {
        endpoints: [{
          object: u1
          label: 'user2'
        }, {
          object: u2,
          label: 'user1'
        }]
      }
      deferred = new jQuery.Deferred()

      f1.save {
        success: ->
          f2.save {
            success: ->
              deferred.resolve([f1, f2])
            error: (status) ->
              deferred.reject status.message
          }
        error: (status) ->
          deferred.reject status.message
      }

      deferred.promise()
  }