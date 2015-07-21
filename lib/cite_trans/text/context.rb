require 'jpts_extractor'

module CiteTrans
  module Text
    class Context
       def initialize(text)
         @text = text
       end

       def contains_author?(author)
         @text.fragments.detect { |frag| !!(frag.text =~ /#{author}/) }
       end

       def to_s
         @text.to_s.gsub("\n", ' ').squeeze
       end
    end
  end
end
