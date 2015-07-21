require 'cite_trans/styles/citation_decorator'

module CiteTrans
  module Styles
    class APA < CitationDecorator

      def initialize(citation)
        super(citation)
      end

      def cite
        if self.context.contains_author? self.author
          "#{self.reference.year}"
        else
          "#{self.author}, #{self.reference.year}"
        end
      end

      def author
        if CiteTrans.end_references.detect_same_surname reference
          # include initials in author string
          self.reference.authors.surnames
            .zip(self.reference.authors.initials).each do |name|
            name.join('., ')
          end.join(', ') + '.'
        else
          authors = self.reference.authors
          case authors.size
          when 0
          when 1..2
            surnames = authors.each.map { |name| name[:surname]}
            surnames.join(' & ')
          when 3..5
            tmp_authors = authors.dup

            first_author = tmp_authors.people.shift
            tmp_authors.sort!
            tmp_authors.push_front(first_author)
            postfix = tmp_authors.people[-2..-1].map { |name| name[:surname] }.join(' & ')
            prefix = tmp_authors.people[0..-3].map { |name| name[:surname] }.join(', ')
            "#{prefix}, #{postfix}"
          else
            "#{authors.first[:surname]} et al."
          end
        end
      end

    end
  end
end
