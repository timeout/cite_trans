module CiteTrans
  module Reference
    class PersonGroup
      include Enumerable
      include Comparable

      attr_reader :people

      def add_name(name)
        @people ||= Array.new
        people << name
        self
      end

      def <=>(other)
        return nil unless other.is_a? PersonGroup
        return nil if self.people.nil? or other.people.nil?

        compare_authors = self.people.zip(other.people)
        compare_authors.each do |author_compare|
          surname = author_compare.first.nil? ? "" : author_compare.first[:surname]
          other_surname = author_compare.last.nil? ? "" : author_compare.last[:surname]
          given_names = author_compare.first.nil? ? "" : author_compare.first[:given_names]
          other_given_names = author_compare.last.nil? ? "" : author_compare.last[:given_names]

          if surname < other_surname
            return -1
          end

          if surname == other_surname
            if given_names < other_given_names
              return -1
            end
            if given_names > other_given_names
              return 1
            end
          end

          if surname > other_surname
            return 1
          end
        end

        if self.size < other.size
          return -1
        end
        return 0
      end

      def include?(surname)
        result = self.people.find{ |name| name[:surname] == surname } unless self.people.nil?
        not result.nil?
      end

      def empty?
        self.people.nil? or self.people.empty?
      end

      def size
        people.size
      end

      def each(&block)
        self.people.each(&block)
      end

      def push_front(name)
        @people ||= Array.new
        people.unshift(name)
        self
      end

      def pop_back
        @people.pop
      end

      def sort!
        self.people.sort_by! { |name| name[:surname] }
      end

      def to_s
        self.map { |name| "#{name[:surname]}, #{name[:given_names]}"}
          .join(', ')
      end

      def surnames
        self.people.select { |person| !!person[:surname] }
          .map { |name| "#{name[:surname]}" }
      end

      def given_names
        self.people.select { |person| !!person[:given_names] }
          .map { |name| "#{name[:given_names]}" }
      end

      def initials
        self.map do |name|
          given_names = name[:given_names]
          given_names_arry = given_names.split
          given_names_arry.map { |part| part.upcase[0, 1] }.join('.')
        end
      end

      private
      attr_writer :people
    end
  end
end
