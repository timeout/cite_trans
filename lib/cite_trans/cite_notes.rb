module CiteTrans
  class CitationNotes
    def initialize(chapters)
      @chapters = chapters
      @citations = Array.new
    end

    def citations
      @chapters.each do |chapter|
        chapter.fragments.each do |text_fragment|
          if text_fragment.class == JPTSExtractor::ArticlePart::InlineText::Citation
            @citations << text_fragment
          end
        end
      end
      @citations
    end
  end
end

