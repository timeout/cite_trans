require 'cite_trans/errors'

module CiteTrans
  class Citation

    def initialize(reference)
      @reference = reference
    end

    attr_accessor :reference

    def cite(context) 
      raise NotImplementedError.new
    end

  end
end
