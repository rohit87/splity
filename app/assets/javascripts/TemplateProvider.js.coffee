class Template

  constructor: (@compiled) ->

  render: (view, partials) ->
    @compiled view, partials if @compiled?

class TemplateProvider

  _compiledTemplates = {}

  constructor: () ->

  get: (templateName) ->
    unless _compiledTemplates[templateName]?
      $template = $("#tmpl#{templateName}")
      _compiledTemplates[templateName] = new Template Mustache.compile $template.html()
      $template.remove()
    _compiledTemplates[templateName]

@TemplateProvider = new TemplateProvider