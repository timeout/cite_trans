require 'cite_trans/citation'

module CiteTrans
  module Styles
    class CitationDecorator

      def initialize(citation)
        @citation = citation
      end

      def reference
        @citation.reference
      end

      def reference= (reference)
        @citation.reference = reference
      end

      def context
        @citation.context
      end

      def context= (text)
        @citation.context = text
      end

      def cite
        @citation.cite
      end
    end
  end
end
