$: << File.join(File.dirname(__FILE__), '../..')
require 'pygments.rb'
require 'github/markdown'
require 'resource_presenter'
require 'resource_presenter/html_serializer'

module Almodovar
  module Alternatives
    module Native


      class HtmlSerializer < Almodovar::ResourcePresenter::HtmlSerializer

        def highlight(representation, format)
          Pygments.highlight(representation, :lexer => format)
        end

        def markdown_render(text)
          GitHub::Markdown.render text
        end
      end

    end
  end
end