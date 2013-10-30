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
        body = highlight(representation, format)
        body = body.gsub(/&quot;(http\S+)&quot;/) { url = $1; "&quot;<a href=\"#{url}\">#{url}</a>&quot;" }
        body.html_safe
      end

      def metadata_text(text)
        return if text.blank?

        if indentation = text[/\n\s+/]
          text = text.gsub(indentation, "\n")
        end

        text = text.strip
        text = markdown_render(text)
        text.html_safe
      end

      protected

      def highlight(representation, format)
        raise "This method should be implemented by subclasses"
      end

      def markdown_render(text)
        raise "This method should be implemented by subclasses"
      end

    end
  end
end
