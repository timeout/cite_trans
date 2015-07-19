require 'cite_trans/text/body_text.rb'

require 'jpts_extractor'
require 'pathname'

RSpec.describe CiteTrans::Text::BodyText do

  let(:path) { Pathname.new('spec/fixture/0129366.xml') }
  let(:article) {
    JPTSExtractor.extract(path.open)}
  let(:body_text) { CiteTrans::Text::BodyText.new(article) }

  describe '#initialize' do
    it 'initializes the text body with an article' do
      body_text 
    end
  end

  describe '#each' do
    it 'enumerates the chapters in the text body' do
      expect(body_text.first.class).to be(JPTSExtractor::ArticlePart::Text)
    end
  end

  describe '#size' do
    it 'returns the number of chapters' do
      expect(body_text.size).to be(21)
    end
  end

  describe '#to_s' do
    it 'builds a string representation' do
      # puts body_text.to_s
    end
  end
end
