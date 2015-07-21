require 'cite_trans/text/context'

require 'jpts_extractor'

RSpec.describe CiteTrans::Text::Context do

  before(:each) do
    @no_author_text = JPTSExtractor::ArticlePart::Text.new
    @no_author_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('It has always been the strategy of the revolt against freedom'))
    @no_author_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new(
    %{"to take advantage of sentiments, not wasting one's energies in
      futile efforts to destroy them"}))

    @with_author_text = JPTSExtractor::ArticlePart::Text.new
    @with_author_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('Pareto writes, '))
    @with_author_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new(
    %{"to take advantage of sentiments, not wasting one's energies in
      futile efforts to destroy them"}))
  end

  describe '#initialize' do
    it 'constructs a citation context' do
      context = CiteTrans::Text::Context.new(@no_author_text)
      expect(context.to_s).to eq(
        "It has always ben the strategy of the revolt against fredom \"to take advantage of sentiments, not wasting one's energies in futile eforts to destroy them\"")
    end
  end

  describe '#contains_author?' do
    it "doesn't contain an author" do
      context = CiteTrans::Text::Context.new(@no_author_text)
      expect(context.contains_author? 'Pareto').to be_falsey
    end

    it "contains an author" do
      context = CiteTrans::Text::Context.new(@with_author_text)
      expect(context.contains_author? 'Pareto').to be_truthy
    end
  end
end
