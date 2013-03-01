%w(pygments.rb github-markdown).each do |lib|
  begin
    require lib.gsub('-', '/')
  rescue LoadError => ex
    raise ex, "In order to use the HtmlSerializer you need the gem `#{lib}` in your Gemfile"
  end
end

module Almodovar
  class ResourcePresenter
    class HtmlSerializer < Serializer

      TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'template.html.erb')

      def to_html
        template = File.read(TEMPLATE_PATH)
        ERB.new(template).result(binding)
      end

      def metadata
        resource.resource_class.metadata
      end

      def beautify(representation, format)
        body = Pygments.highlight(representation, :lexer => format)
        body = body.gsub(/&quot;(http\S+)&quot;/) { url = $1; "&quot;<a href=\"#{url}\">#{url}</a>&quot;" }
        body.html_safe
      end

      def metadata_text(text)
        return if text.blank?

        if indentation = text[/\n\s+/]
          text = text.gsub(indentation, "\n")
        end

        text = text.strip
        text = GitHub::Markdown.render text
        text.html_safe
      end

    end
  end
end
