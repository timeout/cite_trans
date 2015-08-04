require 'cite_trans/reference/person_group'

module CiteTrans
  module Reference
    class ReferenceList

      def references
        @references ||= Array.new
      end

      def references?
        not self.references.nil?
      end

      def clear!
        self.references.clear
      end

      def add_reference(reference)
        self.references << reference
      end

      alias_method :<<, :add_reference

      def size
        self.references.nil? ? 0 : self.references.size
      end

      def [](index)
        raise IndexError.new unless index <= self.size
        @references[index]
      end

      def detect_same_surname(other_reference)
        return false if other_reference.nil? or other_reference.authors.nil?

        filter = select_surnames(other_reference.authors)
        filter.each do |reference|
          return true if reference.authors.given_names != other_reference.authors.given_names
        end
        false
      end

      def multiple_sources?(other_reference)
        return false if other_reference.nil? or other_reference.authors.nil?
        filter = select_surnames(other_reference.authors)
        sources = filter.select do |reference|
          (reference.authors.given_names == other_reference.authors.given_names) and
            reference != other_reference
        end
        not sources.empty?
      end

      def select_surnames(author_names)
        self.references.select do |reference|
          reference.authors.surnames == author_names.surnames unless reference.authors.nil?
        end
      end

    end
  end
end
