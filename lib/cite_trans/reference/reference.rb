module CiteTrans
  module Reference
    class Reference
      include Comparable

      attr_accessor :authors, :year, :title, :source, :first_page,
        :last_page, :volume, :index, :publisher

      # this is a pragmatic compromise, I hope
      def <=> (other)
        return nil unless other.is_a? Reference

        if self.authors?
          self_term = authors
        elsif self.source?
          self_term = source
        elsif self.title?
          self_term = title
        else
          return nil
        end

        if other.authors?
          other_term = other.authors
        elsif other.source?
          other_term = other.source
        elsif other.title?
          other_term = other.title
        else
          return nil
        end

        if self_term.is_a? PersonGroup and
            other_term.is_a? PersonGroup
          author_compare = self_term <=> other_term
          return author_compare unless author_compare.zero?

          year_compare = self.year <=> other.year
          return year_compare unless year_compare.zero?

          return self.source <=> other.source
        end

        if self_term.is_a? String and 
            other_term.is_a? PersonGroup
          return compare_string_with_authors(self_term, other_term)
        end

        if self_term.is_a? PersonGroup and 
            other_term.is_a? String
          return compare_string_with_authors(other_term, self_term)
        end
      end

      def authors?
        self.authors.nil? ? false : self.authors.empty? ? false : true
      end

      def author_count
        self.authors.size if authors?
      end

      def year?
        not self.year.nil?
      end

      def title?
        not self.title.nil?
      end

      def source?
        not self.source.nil?
      end

      def volume?
        not self.volume.nil?
      end

      def first_page?
        not self.first_page.nil?
      end

      def last_page?
        not self.last_page.nil?
      end

      private
      def compare_string_with_authors(string, authors)
        string <=> authors.first[:surname]
      end
    end
  end
end
