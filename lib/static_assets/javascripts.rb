module StaticAssets
  module Javascripts

    def dump_to_js(global_object, global_name=global_object)
      @global_javascript_variables << "window['#{global_name}'] = #{global_object.to_json}".html_safe
      return "DO NOT CONCAT THIS"
    end

    def initialize_javascripts
      @global_javascript_variables = []
      @requested_javascript_modules = []
    end

    def request_javascript_module(module_name)
      @requested_javascript_modules << module_name unless @requested_javascript_modules.include? module_name
    end

    def dump_page_specific_javascripts
      tags = []
      if GlobalConstants::JavascriptsProvided[params[:controller]] == params[:action]
        tags << javascript_include_tag("#{params[:controller]}/#{params[:action]}")
      end
      if @requested_javascript_modules.present?
        @requested_javascript_modules.each do |js|
          tags << javascript_include_tag("modules/#{js}")
        end
      end
      if @global_javascript_variables.present?
        tags << "<script type='text/javascript'>\n\t#{@global_javascript_variables.join(";\n\t")}\n</script>".html_safe
      end
      return tags.join "\n"
    end
  end
end