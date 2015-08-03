module CiteTrans
  module Text
    class Expand

      def initialize(array)
        @array = array
      end

      attr_reader :array

      def blow_up
        while self.contains_range?
          index = self.range_symbol_index
          replace = expand_range(self.array.at(index - 1), self.array.at(index + 1))
          self.array[index] = replace
          self.array.delete_at(index - 1)
          self.array.delete_at(index)
          self.array.flatten!
        end
        self.array.delete(', ')
        self.array
      end

      def contains_range?
        self.array.include? '-' or self.array.include? '–' or self.array.include? '—'
      end

      def expand_range(start, finish)
        Array(start..finish)
      end

      def range_symbol_index
        self.array.each_with_index { |entry, index| return index if ['-','–','—'].include? entry }
      end

    end
  end
end
