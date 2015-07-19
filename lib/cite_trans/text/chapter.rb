module CiteTrans
  module Text
    class Chapter
      include Enumerable

      def initialize(text)
        @text = text
      end

      def each
        buffer = Array.new
        @text.fragments.each do |frag|
          if frag.is_a? JPTSExtractor::ArticlePart::InlineText::Citation
            yield Citation.new(frag, buffer)
          end
          buffer << frag
        end
      end
    end
  end
end
