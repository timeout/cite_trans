module CiteTrans
  module Text
    class Text

      def initialize(contents)
        @contents = contents
      end

      attr_reader :leading, :following

      def cite(citation)
        set_mark! citation.pos
        citation.leading = self.leading
        citation.following = self.following
      end

      def set_mark! (pos)
        @leading = @contents.slice(0, pos)
        @following = @contents.slice(pos..-1) 
      end
    end
  end
end
