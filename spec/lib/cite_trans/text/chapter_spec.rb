require 'cite_trans/text/chapter'
require 'cite_trans/reference/reference'
require 'cite_trans'

require 'jpts_extractor'

RSpec.describe CiteTrans::Text::Chapter do

  before(:each) do
    @text = JPTSExtractor::ArticlePart::Text.new
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('"Shortcuts make for long delays", said Gandalf ['))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('1')))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new(']. "Idiot," replied Bilbo ['))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('2')))
    @text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('].'))
  end

  let(:chapter) { CiteTrans::Text::Chapter.new(@text) }

  describe '#initialize' do
    it 'constructs a chapter' do
      chapter 
    end
  end

  describe '#each' do
    it 'enumerates the citations in the chapter' do
      gandalf_ref = CiteTrans::Reference::Reference.new
      gandalf_ref.authors = CiteTrans::Reference::PersonGroup.new
      gandalf_ref.authors.add_name surname: 'Gandalf'

      bilbo_ref = CiteTrans::Reference::Reference.new
      bilbo_ref.authors = CiteTrans::Reference::PersonGroup.new
      bilbo_ref.authors.add_name surname: 'Bilbo'

      CiteTrans.end_references << gandalf_ref
      CiteTrans.end_references << bilbo_ref

      expect(chapter.first.class).to be(CiteTrans::Citation)
      # chapter.each do |citation|
      #   puts "citation: #{citation.reference.authors}, text: #{citation.context.to_s}"
      # end
    end
  end
end
