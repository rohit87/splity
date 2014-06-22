n = namespace 'splity.models'

n.User = Appacitive.Object.extend 'user', {

  constructor: (attrs) ->
    attrs.profilePictureUrl = "https://secure.gravatar.com/avatar/sdf89es98f9f"
    Appacitive.Object.call this, attrs

  activities: ->
    query = @getConnectedObjects { relation: 'user_activity' }
    query.fetch()

}, {

  all: ->
    query = this.findAllQuery { }
    query.fetch()

  activitiesFor: (id) ->
    new n.User { __id: id }
      .activities()
}

# Appacitive.Users.login "biswarup", "password"

# console.log n.User.activitiesFor Appacitive.Users.currentUser().get '__id'