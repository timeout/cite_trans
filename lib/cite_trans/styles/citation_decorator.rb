require 'cite_trans/citation'

module CiteTrans
  module Styles
    class CitationDecorator

      def initialize(reference)
        @citation = Citation.new(reference)
      end

      def reference
        @citation.reference
      end

      def reference= (reference)
        @citation.reference = reference
      end

      def cite(context)
        @citation.cite(context)
      end
    end
  end
end
