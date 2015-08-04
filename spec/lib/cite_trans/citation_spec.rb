require 'cite_trans/citation'

require 'jpts_extractor'

RSpec.describe CiteTrans::Citation do

  let(:text) { JPTSExtractor::ArticlePart::Text.new }
  let(:ref) { CiteTrans::Reference::Reference.new }
  let(:author) { CiteTrans::Reference::PersonGroup.new }

  describe '#initialize' do
    it 'is constructed by a reference and a text context' do
      author.add_name surname: 'Holland', given_names: 'WG'
      ref.authors = author
      text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new('This is the text context'))
      CiteTrans::Citation.new(ref)
    end

    it 'reads the reference' do
      author.add_name surname: 'Holland', given_names: 'WG'
      ref.authors = author
      text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new('This is the text context'))
      citation = CiteTrans::Citation.new(ref)
      expect(citation.reference.authors.include? 'Holland').to be_truthy
    end
  end

  it 'finds no authors in the leading context' do
  end
end
