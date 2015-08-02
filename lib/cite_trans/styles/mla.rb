require 'cite_trans/styles/citation_decorator'
require 'cite_trans/styles/mla_numbers'

module CiteTrans
  module Styles
    class MLA < CitationDecorator

      def initialize(citation)
        super(citation)
      end

      def cite
        if self.context.contains_author? self.author
          self.location? ? "#{self.location}" : String.new
        elsif CiteTrans.end_references.multiple_sources? self.reference
          prefix = "#{self.author}, #{self.source}"
          self.location? ? "#{prefix} #{self.location}" : "#{prefix}"
        else
          self.location? ? "#{self.author} #{self.location}" : "#{self.author}"
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
          end unless authors.nil?
        end
      end

      def source
        'James Barnet'
      end

      def location?
        not self.reference.first_page.nil?
      end

      def location
        if self.reference.volume?
          "#{self.reference.volume}: #{self.pages}"
        else
          "#{self.pages}"
        end
      end

      def pages
        first_page = self.reference.first_page
        last_page = self.reference.last_page
        pages = MLANumbers.new( normalize_integer(first_page), 
                               normalize_integer(last_page))
        pages.format
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
