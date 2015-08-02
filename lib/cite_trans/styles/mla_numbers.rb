
module CiteTrans
  module Styles
    class MLANumbers
      def initialize(first, last)
        @first, @last = first, last
      end

      attr_reader :first, :last

      def format
        str = String.new
        self.each do |digit|
          str += digit[1].to_s if digit.last > digit.first or digit.last.zero?
        end
        str.empty? ? "#{self.first}-#{self.last}" : "#{self.first}-#{str.reverse!}"
      end

      def [](index)
        arr = [ self.first, self.last ]
        arr = arr.map do |number|
          str = number.to_s
          number = str[-index, 1].to_i
        end
        arr
      end

      def each
        return nil unless self.first.to_s.length == self.last.to_s.length
        length = self.first.to_s.length
        (1..length).each do |index|
          yield self[index]
        end
      end

    end
  end
end
