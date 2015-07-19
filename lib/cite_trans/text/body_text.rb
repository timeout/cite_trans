require 'cite_trans/chapter_extractor'

module CiteTrans
  module Text
    class BodyText
      include Enumerable

      def initialize(article)
        chap_extractor = ChapterExtractor.new
        chap_extractor.format(article.body.sections)
        @chapters = chap_extractor.chapters
      end

      def each(&block)
        @chapters.each(&block)
      end

      def size
        @chapters.size
      end

      alias_method :number_of_chapters, :size

      def to_s
        text_contents = String.new
        @chapters.each do |chapter|
          text_contents += chapter.to_s
        end
        text_contents
      end
    end
  end
end
