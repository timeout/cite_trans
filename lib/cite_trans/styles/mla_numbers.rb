
module CiteTrans
  module Styles
    class MLANumbers
      def initialize(first, last)
        @first, @last = first, last
      end

      attr_reader :first, :last

      def format
        if self.last.nil? or self.last.zero?
          return "#{self.first}"
        end

        str = nil
        self.each do |digit|
          if digit.last > digit.first or str
            str ||= String.new
            str += digit.last.to_s
          end
        end
        str.nil? ? "#{self.first}-#{self.last}" : "#{self.first}-#{str}"
      end

      def [](index)
        arr = [ self.first, self.last ]
        arr = arr.map do | number |
          str = number.to_s
          number = str[index, 1].to_i
        end
        arr
      end

      def each
        return nil unless self.first.to_s.length == self.last.to_s.length
        length = self.first.to_s.length - 1
        (0..length).each do |index|
          yield self[index]
        end
      end
    end
  end
end
