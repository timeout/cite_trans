require 'cite_trans/text/chapter'

require 'jpts_extractor'

RSpec.describe CiteTrans::Text::Chapter do

  before(:each) do
    @text = JPTSExtractor::ArticlePart::Text.new
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('"Shortcuts make for long delays", said Gandalf'))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('1')))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('. "Idiot," replied Bilbo'))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('2')))
  end

  let(:chapter) { CiteTrans::Text::Chapter.new(@text) }

  describe '#initialize' do
    it 'constructs a chapter' do
      chapter 
    end
  end

  describe '#each' do
    it 'enumerates the citations in the chapter' do
      expect(chapter.first.class).to be(CiteTrans::Citation)
      chapter.each do |citation|
        puts "citation: #{citation.pos.text}, text: #{citation.reference}"
      end
    end
  end
end
