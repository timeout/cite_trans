require 'cite_trans/styles/citation_decorator'

module CiteTrans
  module Styles
    class MLA < CitationDecorator

      def initialize(citation)
        super(citation)
      end

      def cite
        if self.context.contains_author? self.author
          "#{self.location}"
        elsif CiteTrans.end_references.multiple_sources? self.reference
          "#{self.author}, #{self.source} #{self.location}"
        else
          "#{self.author} #{self.location}"
        end
      end

      def author
        if CiteTrans.end_references.detect_same_surname reference
          # include initials in author string
          self.reference.authors.initials
            .zip(self.reference.authors.surnames).each do |name|
            name.join(', ')
          end.join('. ')
        else
          authors = self.reference.authors
          case authors.size
          when 0
          when 1..2
            surnames = authors.each.map { |name| name[:surname]}
            surnames.join(' and ')
          when 3
            prefix = authors.people[0..-3].map { |name| name[:surname] }.join(', ')
            postfix = authors.people[-2..-1].map { |name| name[:surname] }.join(' and ')
            "#{prefix}, #{postfix}"
          else
            "#{authors.first[:surname]} et al."
          end
        end
      end

      def source
        'James Barnet'
      end

      def location
        first_page = self.reference.first_page
        last_page = self.reference.last_page

        fpage_i = normalize_integer(first_page)
        lpage_i = normalize_integer(last_page)

        diff = lpage_i - fpage_i

        overhang_length = integer_size(diff)
        output = String.new
        if overhang_length < integer_size(lpage_i)
          output = lpage_i.to_s.slice(overhang_length..-1)
        else
          output = lpage_i.to_s
        end

        if self.reference.volume?
          "#{self.reference.volume}: #{first_page}-#{output}"
        else
          "#{first_page}-#{output}"
        end
      end

      private
      def normalize_integer(number)
        (number.is_a? Numeric) ? number : number.to_i
      end

      def integer_size(number)
        number.to_s.length
      end
    end
  end
end
