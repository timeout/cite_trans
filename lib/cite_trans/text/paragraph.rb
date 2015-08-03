require 'cite_trans/text/context'
require 'cite_trans/errors'
require 'cite_trans/text/expand'

require 'jpts_extractor'

module CiteTrans
  module Text
    class Paragraph

      def initialize(text)
        @cited_text = nil
        @text = Array.new
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
            @text << citations
            citations = nil
            @text << fragment
          else
            @text << fragment
          end
        end
      end

      attr_reader :cited_text

      def left_square_bracket?
        !!(@text.last.text =~ /\[ *\Z/)
      end

      def remove_left_square_bracket
        pos = (@text.last.text =~ /\[ *\Z/)
        @text[-1].text = @text.last.text[0..(pos - 1)].rstrip
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
        @cited_text = JPTSExtractor::ArticlePart::Text.new
        @text.each do |entry|
          if entry.is_a? Array
            self.cited_text.add_fragment(cite(entry, style, context))
            context.fragments.clear
          else
            context.add_fragment entry
            self.cited_text.add_fragment entry
          end
        end
        self
      end

      def to_s
        self.cited_text.nil? ? String.new : self.cited_text.to_s 
      end

      def cite(cite_array, style, context)
        index = self.expand(cite_array)
        text_frags = index.map do |ref_index|
          reference = CiteTrans.end_references[ref_index]
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
