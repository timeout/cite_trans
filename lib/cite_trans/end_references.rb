
module CiteTrans
  def self.end_references
    @@end_references ||= Reference::ReferenceList.new
  end

  def self.end_references= (reference_list)
    @@end_references = reference_list
  end
end

