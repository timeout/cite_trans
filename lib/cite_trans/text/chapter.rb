require 'cite_trans/text/context'
require 'cite_trans/errors'

require 'jpts_extractor'

module CiteTrans
  module Text
    class Chapter
      include Enumerable

      def initialize(text)
        @text_stack = Array.new
        text.fragments.each_with_index do |fragment, index|
          if fragment.is_a? JPTSExtractor::ArticlePart::InlineText::Citation
            next_fragment_text = text.fragments[index + 1].text
            if !!(next_fragment_text =~ /\A *\]/)
              text.fragments[index + 1].text = next_fragment_text[1..-1].lstrip
            end

            if @text_stack.last.is_a? CitationFragment
              cite_group = @text_stack.pop
              cite_group.fragments << fragment
              @text_stack << cite_group
            else
              remove_left_bracket
              case next_fragment_text
              when /\A *, *\Z/
                cite_frag = MultiCitation.new fragment
              when /\A *(-|–|—) *\Z/
                cite_frag = RangeCitation.new fragment
              else
                cite_frag = CitationFragment.new fragment
              end
            end
            @text_stack << cite_frag unless cite_frag.nil?
          else
            @text_stack << fragment unless !!(fragment.text =~ /\A *(,|-|—|–) *\Z/)
          end
        end
      end

      def text
        @text ||= JPTSExtractor::ArticlePart::Text.new
      end

      def each(&block)
        @text_stack.each(&block)
      end

      def cite!(style)
        context = JPTSExtractor::ArticlePart::Text.new

        self.each do |fragment|
          if fragment.is_a? CitationFragment
            self.text.add_fragment(fragment.cite!(style, context))
            context.fragments.clear   # start new context
          else
            context.add_fragment fragment
            self.text.add_fragment fragment
          end
        end
        self
      end

      def to_s
        self.text.nil? ? String.new : self.text.to_s 
      end

      private
      def remove_left_bracket
        unless @text_stack.last.nil?
          last_fragment_text = @text_stack.last.text
          if !!(last_fragment_text =~ /\[ *\Z/)
            @text_stack[-1].text = last_fragment_text[0..-2].rstrip
          end
        end
      end
    end

    class CitationFragment
      def initialize(fragment)
        @fragments = Array.new
        @fragments << fragment
      end

      attr_accessor :fragments

      def cite!(style, context)
        case style
        when :mla
          cite_style = Styles::MLA.new(citation(context))
        when :apa
          cite_style = Styles::APA.new(citation(context))
        else
        end
        note = "(#{cite_style.cite})"
        JPTSExtractor::ArticlePart::InlineText::Citation
          .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new(note))
      end

      private
      def index
        index = @fragments.first.text.to_i
        raise EndReferenceIndexError.new("Illegal Index: #{index}") unless index > 0
        index - 1
      end

      def citation(context)
        reference = CiteTrans.end_references[index]
        CiteTrans::Citation.new(reference, Text::Context.new(context))
      end

    end

    class MultiCitation < CitationFragment
      def initialize(fragment)
        super(fragment)
      end

      def cite!(style, context)
        notes = nil
        case style
        when :mla
          notes = self.fragments.map do |fragment|
            cite_style = Styles::MLA.new(citation(context, index(fragment)))
            fragment = cite_style.cite
          end.join('; ')
        when :apa
          notes = self.fragments.map do |fragment|
          end.join('; ')
        else
        end
        notes = "(#{notes})"
        JPTSExtractor::ArticlePart::InlineText::Citation
          .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new(notes))
      end

      private
      def index(fragment)
        index = fragment.text.to_i
        raise EndReferenceIndexError.new("Illegal Index: #{index}") unless index > 0
        index - 1
      end

      def citation(context, index)
        reference = CiteTrans.end_references[index]
        CiteTrans::Citation.new(reference, Text::Context.new(context))
      end
    end

    class RangeCitation < CitationFragment
      def initialize(fragment)
        super(fragment)
      end

      def cite!(style, context)
        range = Range.new(index(fragments.first), index(fragments.last))
        notes = nil
        case style
        when :mla
          notes = range.map do |reference_index|
            cite_style = Styles::MLA.new(citation(context, reference_index))
            reference_index = cite_style.cite
          end.join('; ')
        when :apa
          notes = range.map do |reference_index|
            cite_style = Styles::APA.new(citation(context, reference_index))
            reference_index = cite_style.cite
          end.join('; ')
        else
        end
        notes = "(#{notes})"
        JPTSExtractor::ArticlePart::InlineText::Citation
          .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new(notes))
      end

      private
      def index(fragment)
        index = fragment.text.to_i
        raise EndReferenceIndexError.new("Illegal Index: #{index}") unless index > 0
        index - 1
      end

      def citation(context, index)
        reference = CiteTrans.end_references[index]
        CiteTrans::Citation.new(reference, Text::Context.new(context))
      end
    end
  end
end
