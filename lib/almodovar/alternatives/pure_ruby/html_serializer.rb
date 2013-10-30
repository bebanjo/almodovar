$: << File.join(File.dirname(__FILE__), '../..')
require 'coderay'
require 'kramdown'
require 'resource_presenter'
require 'resource_presenter/html_serializer'

module Almodovar
  module Alternatives
    module PureRuby


      class HtmlSerializer < Almodovar::ResourcePresenter::HtmlSerializer

        def highlight(representation, format)
          CodeRay.scan(representation, format).html
        end

        def markdown_render(text)
          Kramdown::Document.new(text).to_html
        end
      end

    end
  end
end
