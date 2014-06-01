$ ->

  friends = JSON.parse($('#jsonFriends').html())
  participants = JSON.parse($('#jsonParticipants').html())
  me = JSON.parse($('#jsonCurrentUser').html())
  $container = $ "#participantsContainer"
  
  window.view = new CreateActivityForm $("#divCreateActivityView"), friends, participants, me



  
class CreateActivityForm extends BaseView

  constructor: (@container, @friends, @participants, @currentUser) ->
    @participantsContainer = $('#participantsContainer', @container)

    @currentUser.paid = true
    @currentUser.cannotRemove = true
    @participants.push @currentUser

    @inputAmount = $('#inputAmount', @container)
    @amount = @inputAmount.val()

    @dutch = $('#optionsRadios1', @container).is ':checked'
    @collection = new ParticipantCollection @participantsContainer, @participants, @
    @friendCollection = new BaseCollection @friends
    
    @initializeUI()
    @bindEvents()

    window.onunload = () ->
      "Yo, you have not saved your activity yet, are you sure you want to leave?"

  initializeUI: () ->
    $('#inputFriends').chosen({
      inherit_select_classes: true
    })
    $('#inputDate').datepicker({
      todayBtn: "linked"
      format: 'd-MM-yyyy'
      autoclose: true
      todayHighlight: true
    }).datepicker('setDate', new Date)

  events: {
    'change #inputFriends': 'onAddRemoveParticipant',
    'change [name=optionsRadios]': 'onDutchToggle',
    'click #btnCreateActivity': 'onSubmit'
  }

  addParticipant: (participant) ->
    return null if @collection.get participant.id
    @collection.add new Participant participant, @collection

  removeParticipant: (participantId) ->
    return null if not @collection.get participantId
    @collection.remove participantId

  onAddRemoveParticipant: (jQ, data) ->
    data.selected = ~~data.selected
    data.deselected = ~~data.deselected
    friend = @friendCollection.get data.selected or data.deselected
    return unless friend?
    if data.selected isnt 0 then @addParticipant friend
    if data.deselected isnt 0 then @removeParticipant friend.id
    @

  onDutchToggle: () ->
    console.log 'Coming Soon!'

  onSubmit: () ->
    $('#txtParticipants').val(@.serialize())
    @container.find('form').get(0).submit()

  setTotalAmount: (amount) ->
    @inputAmount.val amount

  serialize: () ->
    participants = []
    for participant in @collection.participants
      p = {
        user_id: participant.data.id
      }
      if participant.data.paid
        p.amount_paid = participant.data.amount
      if participant.data.amountOwed? and participant.data.amountOwed.amount > 0
        p.amount_owed = participant.data.amountOwed.amount
        p.amount_owed_to = participant.data.amountOwed.to
      participants.push p
    JSON.stringify participants



class ParticipantCollection

  constructor: (@container, @initial_participants, @form) ->
    @dutch = @form.dutch
    @initialize()

  initialize: () ->
    @participants = []
    for participant in @initial_participants
      @add new Participant participant, this # for i in [1..1]

  add: (participant) ->
    @participants.push participant
    participant.renderTo _newContainerFor participant
    @container.append participant.container
    @redistribute()
    return participant

  delete: (participant) ->
    @participants = @participants.filter (p) =>
      p isnt participant

  remove: (participantId) ->
    p = @get participantId
    @delete p
    p.container.remove()
    @redistribute()
    @

  get: (participantId) ->
    (@participants.filter (p) =>
      p.data.id is participantId)[0]

  setTotalAmount: (amount) ->
    participant.setAmount(amount / @participants.length) for participant in @participants

  getTotalAmount: () ->
    amounts = (~~participant.data.amount for participant in @participants)
    amount = amounts.reduce (reduction, item) ->
      reduction + item
    @form.setTotalAmount amount
    amount

  redistribute: () ->
    totalAmount = @getTotalAmount()
    amountPerHead = totalAmount / @participants.length
    peopleWhoHaveToPay = (participant for participant in @participants when participant.data.paid isnt true or participant.data.amount < amountPerHead)
    peopleWhoDoNotHaveToPay = (participant for participant in @participants when participant not in peopleWhoHaveToPay)
    amountCollected = 0

    for participant in @participants when participant not in peopleWhoHaveToPay
      participant.setAmountOwed null
      participant.data.amountReimbursed = 0

    # simple greedy algo
    for participant in peopleWhoHaveToPay
      amountToPay = amountPerHead - participant.data.amount
      paymentReceiver = (receiver for receiver in peopleWhoDoNotHaveToPay when receiver.data.amountReimbursed isnt (receiver.data.amount - amountPerHead))
      if paymentReceiver.length isnt 0
        paymentReceiver[0].data.amountReimbursed += amountToPay
        amountCollected += amountToPay
        participant.setAmountOwed amountToPay, paymentReceiver[0].data.id, paymentReceiver[0].data.name
    @
  # Private Methods
  _newContainerFor = (participant) ->
      $("<tr id='participantContainer_#{participant.data.id}'></tr>")



class Participant extends BaseView

  constructor: (@data, @collection, @template = "Participant") ->
    @container = null
    @data.dutch = @collection.dutch
    @data.amountEditable = (not @data.dutch) or @data.paid
    @data.amount = 0
    @data.amountReimbursed = 0

  events: {
    'click .remove-participant': 'onRemoveClick'

    'change .participant-amount': 'onAmountChange'
    'keyup .participant-amount': 'onAmountChange'
    'paste .participant-amount': 'onAmountChange'
  }

  onRemoveClick: () ->
    @collection.remove @data.id

  onAmountChange: () ->
    amount = @inputAmount.val()
    @data.amount = amount
    @collection.redistribute()

  setAmount: (amount) ->
    @data.amount = amount
    @updateAmount(amount)

  updateAmount: (amount, name) ->
    @inputAmount.get(0).value = amount
    @amountOwed.get(0).value = ""

  setAmountOwed: (amount, id, name) ->
    if amount?
      @data.amountOwed = { amount: amount, to: id }
    else
      @data.amountOwed = null
    @amountOwed.get(0).innerHTML = "#{amount} &mdash;> #{name}" if amount isnt null
    @amountOwed.get(0).innerHTML = "#{@data.name} does not need to pay" if amount is null

  setAmountFieldMode: (editMode) ->
    if editMode is on
      @inputAmount.removeAttr('readonly').attr('placeholder', "Enter amount paid by #{@data.name}")
    if editMode is off
      @inputAmount.attr('readonly', 'readonly').attr('placeholder', "#{@data.name} did not pay anything.")

  cacheUIControls: () ->
    @inputAmount ?= $ "#txtAmount_#{@data.id}", @container
    @amountOwed ?= $ "#lblAmountOwed_#{@data.id}", @container

  renderTo: ($container) ->
    @container = $container if $container?
    @container.html TemplateProvider.get(@template).render @data
    @state = $.extend {}, @data
    @cacheUIControls()
    $('input[type=checkbox]', @container).bootstrapSwitch({
      onText: "Paid"
      offText: "Nope"
      size: 'mini'
      onColor: 'success'
    }).bind 'switchChange', (e, data) =>
      console.log "changing paid to #{data.value}"
      @inputAmount.blur()
      @data.paid = data.value
      @setAmountFieldMode data.value
      setTimeout (() => @inputAmount.focus()), 0
    @bindEvents()