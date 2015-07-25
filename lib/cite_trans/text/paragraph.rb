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

            if next_fragment(index).text == '-' or next_fragment(index).text == '–'
              insert_notes(fragment, index, buffer, style)
              next
              next
            end

            #TODO
            citation = citation(index, buffer)

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

      def fragment(index)
        @text.fragments[index]
      end

      def next_fragment(index)
        @text.fragments[index + 1]
      end

      def reference_index(fragment)
        int = fragment.text.to_i
        # TODO
        # raise Error unless int > 0
        int - 1
      end

      def insert_notes(fragment, index, buffer, style)
        start_index = reference_index(fragment) + 1
        end_index = reference_index(fragment(index + 2)) - 1

        puts "start_index: #{start_index}"
        puts "end_index: #{end_index}"

        @text.fragments[index + 1].text = (start_index..end_index).map do |reference_number|
          citation = citation(reference_number, buffer)
          reference_number = Styles::MLA.new(citation).cite
        end.join('; ')

        puts "----------------------------------------"
        puts next_fragment(index).text
        puts "buffer: #{buffer.to_s}"
        puts "----------------------------------------"

        @text.fragments[index + 1].text += 'ADASFGASFGAFHSDGHSGH'
        @text.fragments[index + 1] = JPTSExtractor::ArticlePart::InlineText::Citation
          .new(@text.fragments[index + 1])
      end

    end
  end
end
