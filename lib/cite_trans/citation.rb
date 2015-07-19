require 'cite_trans/errors'

module CiteTrans
  class Citation

    def initialize(reference, context)
      @referene, @context = reference, context
    end

    attr_reader :reference, :context

  end
end
