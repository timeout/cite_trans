require 'cite_trans/text/context'
require 'cite_trans/errors'
require 'cite_trans/text/expand'

require 'jpts_extractor'

module CiteTrans
  module Text
    class Paragraph

      def initialize(text)
        @text = nil
        @text_fragments = Array.new
        citations = nil
        flag = false
        text.fragments.each_with_index do |fragment, index|
          if fragment.is_a? JPTSExtractor::ArticlePart::InlineText::Citation
            flag = true
            remove_left_square_bracket if left_square_bracket?
          end
          if (right_square_bracket? fragment) and flag
            fragment.text = remove_right_square_bracket fragment
            flag = false
          end

          if flag
            citations ||= Array.new
            citations << fragment
          elsif citations
            @text_fragments << citations
            citations = nil
            @text_fragments << fragment
          else
            @text_fragments << fragment
          end
        end
      end

      attr_reader :text

      def left_square_bracket?
        !!(@text_fragments.last.text =~ /\[ *\Z/)
      end

      def remove_left_square_bracket
        pos = (@text_fragments.last.text =~ /\[ *\Z/)
        @text_fragments[-1].text = @text_fragments.last.text[0..(pos - 1)].rstrip
      end

      def right_square_bracket?(fragment)
        !!(fragment.text =~ /\A *\]/)
      end

      def remove_right_square_bracket(fragment)
        pos = (fragment.text =~ /\A *\]/)
        fragment.text[(pos + 1)..-1].lstrip
      end

      def expand(cite_array)
        index = cite_array.map do |in_cite| 
          char = in_cite.text
          in_cite = !!(char =~ /[[:digit:]]/) ? char.to_i : char
        end
        expand = Expand.new(index)
        expand.blow_up
      end

      def cite!(style)
        context = JPTSExtractor::ArticlePart::Text.new
        @text = JPTSExtractor::ArticlePart::Text.new
        @text_fragments.each do |entry|
          if entry.is_a? Array
            self.text.add_fragment(cite(entry, style, context))
            context.fragments.clear
          else
            context.add_fragment entry
            self.text.add_fragment entry
          end
        end
        self
      end

      def to_s
        self.text.nil? ? String.new : self.text.to_s 
      end

      def cite(cite_array, style, context)
        index = self.expand(cite_array)
        puts ">>>>>>>>>>>>>>> cite_array: #{cite_array}"
        puts ">>>>>>>>>>>>>>> index: #{index}"
        text_frags = index.map do |ref_index|
          reference = CiteTrans.end_references[ref_index - 1]
          citation = Citation.new(reference, Text::Context.new(context))
          case style
          when :apa
            style_cite = Styles::APA.new(citation)
          when :mla
            style_cite = Styles::MLA.new(citation)
          end
          ref_index = style_cite.cite
        end
        citation_note = "(#{text_frags.join('; ')})"
        cite_frag = JPTSExtractor::ArticlePart::InlineText::InlineText.new(citation_note)
        JPTSExtractor::ArticlePart::InlineText::Citation.new(cite_frag)
      end
    end
  end
end
