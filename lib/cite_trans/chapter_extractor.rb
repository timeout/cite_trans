module CiteTrans
  class ChapterExtractor
    def initialize
      @chapters = Array.new
    end

    attr_reader :chapters

    def format(section)
      section.each do |subsection|
        case subsection
        when JPTSExtractor::ArticlePart::Section
          subsection.format(self)
        when JPTSExtractor::ArticlePart::Text
          @chapters << subsection

          # puts "========== paragraph ==========\n"
          # fragments = subsection.fragments
          # fragments.each do |frag|
          #   if frag.class == JPTSExtractor::ArticlePart::InlineText::Citation
          #     puts "citation: #{frag.text}"
          #   else
          #     puts "text: #{frag.text}"
          #   end
          # end
          # puts "#{subsection.to_s}\n\n"
        end
        self
      end
    end
  end
end

