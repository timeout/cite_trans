require 'cite_trans/text/context'

require 'jpts_extractor'

module CiteTrans
  module Text
    class Chapter
      include Enumerable

      def initialize(text)
        @text = JPTSExtractor::ArticlePart::Text.new
        @text.add_fragment JPTSExtractor::ArticlePart::InlineText::InlineText.new
        @text.fragments.concat text.fragments
        @text.add_fragment JPTSExtractor::ArticlePart::InlineText::InlineText.new
      end

      def text
        @text.fragments.shift
        @text.fragments.pop
        @text
      end

      def each
        @text.fragments.each do |fragment|
          yield fragment
        end
      end

      def cite!(style)
        buffer = JPTSExtractor::ArticlePart::Text.new
        self.each_with_index do |fragment, index|
          if fragment.is_a? JPTSExtractor::ArticlePart::InlineText::Citation

            ref_index = fragment.text.to_i - 1

            next_fragment = @text.fragments[index + 1]

            if next_fragment.text == '-' or next_fragment.text == '–'

              end_index = @text.fragments[index + 2].text.to_i - 1

              citations = ((ref_index + 1)..(end_index - 1)).map do |ind|
                citation = citation(ind, buffer)
                ind = Styles::MLA.new(citation).cite
              end
              next_fragment.text = citations.join('; ') + ';'
              next_fragment = JPTSExtractor::ArticlePart::InlineText::Citation.new(fragment)
            end

            #TODO
            citation = citation(ref_index, buffer)

            # TODO
            if style == :mla
              cite_style = Styles::MLA.new(citation)
            end

            # parentheses
            before = buffer.fragments.last
            if before.text[-1,1] == '['
              before.text[-1,1] = '('
              buffer.fragments.last.text = before.text
            end

            # after
            if @text.fragments[index + 1].text[0,1] == ']'
              @text.fragments[index + 1].text[0,1] = ')'
            end
            fragment.text = cite_style.cite

          end
          buffer << fragment
        end
        @text = buffer
        puts self.to_s
        self
      end

      def to_s
        self.text.to_s
      end

      private
      def citation(index, buffer)
        reference = CiteTrans.end_references[index]
        context = Text::Context.new(buffer)
        Citation.new(reference, context)
      end

    end
  end
end
