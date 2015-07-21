require 'cite_trans/text/context'

require 'jpts_extractor'

module CiteTrans
  module Text
    class Chapter
      include Enumerable

      def initialize(text)
        @text = text
      end

      def each
        buffer = JPTSExtractor::ArticlePart::Text.new

        @text.fragments.each do |frag|
          if frag.is_a? JPTSExtractor::ArticlePart::InlineText::Citation
            reference = CiteTrans.end_references[frag.text.to_i - 1]
            yield Citation.new(reference, Context.new(buffer))
          end
          buffer << frag
        end
      end
    end
  end
end
