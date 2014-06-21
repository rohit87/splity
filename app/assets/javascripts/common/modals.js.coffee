n = namespace('splity1.ui')

class n.Modal

  constructor: (@options) ->
    n.Modal.template ?= TemplateProvider.get "BasicModal"
    @template = n.Modal.template

  show: ->
    @$modal = $(@template.render(@options))
    @$modal.appendTo($('body')).modal({
      keyboard: if @options.canSkip then true else false
      backdrop: if @options.canSkip then true else 'static'
    })
    @bindButtonEvents()

  bindButtonEvents: ->
    for button, index in @options.buttons
      continue unless button.onClick?
      $('.modal-footer .modal-button', @$modal).eq(index).click button.onClick


@runnit = ->
  new splity.ui.Modal({
    title: "Delete Account?"
    content: "This will delete your account!",
    canSkip: true,
    buttons: [
      {
        text: 'Yes, delete everything!',
        onClick: -> 
          alert 'Never gonna give you up!'
        type: 'danger'
      },
      {
        text: 'No freaking way!'
        onClick: ->
          alert "good boy!"
        type: 'info'
        closeModal: true
      }
    ]
  }).show()