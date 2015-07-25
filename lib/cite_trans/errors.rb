module CiteTrans
  module Errors

    class Error < StandardError; end

    class NoTextError < Error; end

    class EndReferenceIndexError < Error; end
  end
end
