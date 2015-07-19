require 'cite_trans/citation'

module CiteTrans
  module Styles
    class APA < Citation

      def initialize(pos, ref)
        super(pos, ref)
        @inline_text = String.new
      end

      def format
        format_authors(self.reference.authors) unless self.author_in_leading?
      end

      def author_in_leading?
        raise CiteTrans::NoTextError
          .new('This citation has no context.') unless leading
        !!(/#{self.format_authors_text}/ =~ leading)
      end

      # TODO: authors have the same surname
      def format_authors
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

      def format_authors_text
        res = self.format_authors
        res.gsub(' & ', ' and ')
      end

      def parentheses_note
        note = String.new
        unless author_in_leading?
          note += "#{format_authors}, "
        end
        note += reference.year
      end
    end
  end
end
