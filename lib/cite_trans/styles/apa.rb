require 'cite_trans/styles/citation_decorator'

module CiteTrans
  module Styles
    class APA < CitationDecorator

      def initialize(reference)
        super(reference)
      end

      def cite(context)
        if self.author.nil?
          "#{self.publisher}, #{self.reference.year}"
        elsif context.contains_author? self.author
          "#{self.reference.year}"
        else
          "#{self.author}, #{self.reference.year}"
        end
      end

      def publisher
        publisher_name = self.reference.publisher
        if publisher_name.nil? 
          "#{BAD CITATION}"
        else
          split_name = publisher_name.split
          if split_name.size > 1
            split_name.map! {|word| word.capitalize[0,1]}
            name = split_name.join('.') 
            "#{name}"
          else
            "#{publisher_name}"
          end
        end
      end

      def author(reference_list = CiteTrans.end_references)
        if reference_list.detect_same_surname reference
          # include initials in author string
          self.reference.authors.surnames
            .zip(self.reference.authors.initials).each do |name|
            name.join('., ')
          end.join(', ') + '.'
        else
          authors = self.reference.authors
          if authors.nil?
            nil
          else
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
end
