n = namespace 'splity.models'

n.User = Appacitive.Object.extend 'user', {

  constructor: (attrs) ->
    attrs.profilePictureUrl = "https://graph.facebook.com/#{attrs.__id}/picture"
    Appacitive.Object.call this, attrs

  activities: ->
    query = @getConnectedObjects { relation: 'user_activity' }
    query.fetch()

  getFriends: ->
    query = @getConnectedObjects { relation: 'friendship', label: 'user1' }
    query.fetch()

  addFriend: (user) ->
    n.Friendship.create @get('__id'), user.get('__id')

}, {

  all: ->
    query = this.findAllQuery { }
    query.fetch()

  activitiesFor: (id) ->
    new n.User { __id: id }
      .activities()

  findByEmail: (email) ->
    query = n.User.findAllQuery {
      filter: Appacitive.Filter.Property('email').equalTo(email)
    }
    query.fetch()
}

# Appacitive.Users.login "biswarup", "password"

# console.log n.User.activitiesFor Appacitive.Users.currentUser().get '__id'