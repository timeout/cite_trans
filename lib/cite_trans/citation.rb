require 'cite_trans/errors'

module CiteTrans
  class Citation

    def initialize(reference, context)
      @reference, @context = reference, context
    end

    attr_accessor :reference, :context

    def cite; end

  end
end
