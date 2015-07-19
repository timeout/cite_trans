module CiteTrans
  class EndReferences

    def references
      @references ||= Array.new
    end

    def add_reference(reference)
      self.references << reference
    end

    alias_method :<<, :add_reference

    def size
      self.references.nil? ? 0 : self.references.size
    end

    def detect_same_author(other_reference)
      return false if other_reference.authors.nil?
      
      self.references.each do |reference|
        return false if reference.authors.size != other_reference.authors.size
        reference.authors.zip(other_reference.authors).each do |author_pair|
          self_author = author_pair.first
          other_author = author_pair.last
          return true if self_author[:surname] == other_author[:surname]
        end unless reference == other_reference
      end unless self.references.nil?
      false
    end
  end
end
