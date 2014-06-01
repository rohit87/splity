module StaticAssets
  module Javascripts

    def dump_to_js(global_object, global_name=global_object)
      @global_javascript_variables ||= []
      @global_javascript_variables << "window['#{global_name}'] = #{global_object.to_json}".html_safe
      return "DO NOT CONCAT THIS"
    end

    def initialize_javascripts
      @global_javascript_variables = []
    end

    def finalize_javascripts
      return if !@global_javascript_variables.present?
      "<script type='text/javascript'>\n\t#{@global_javascript_variables.join(";\n\t")}\n</script>".html_safe
    end

  end
end