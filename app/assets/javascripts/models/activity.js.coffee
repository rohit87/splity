n = namespace 'splity.models'

n.Activity = Appacitive.Object.extend 'activity', {

  constructor: (attrs) ->
    # attrs.formatted_total_amount = "#{currency} #{amount}"
    Appacitive.Object.call this, attrs

}, {

  all: ->
    query = this.findAllQuery { }
    query.fetch()

}