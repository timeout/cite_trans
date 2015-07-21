require 'cite_trans/styles/apa'
require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'
require 'cite_trans'
require 'cite_trans/text/context'

require 'jpts_extractor'

RSpec.describe CiteTrans::Styles::APA do

  before(:each) do
    @reference = CiteTrans::Reference::Reference.new
    @reference.authors = CiteTrans::Reference::PersonGroup.new
    @reference.authors.add_name surname: 'Kohane', given_names: 'Peter'
    @reference.year = 2000
    @reference.source = 'James Barnet'

    @no_context = JPTSExtractor::ArticlePart::Text.new
    @no_context.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new("James Barnet is one of Australia's most important colonial architects"))

    @with_context = JPTSExtractor::ArticlePart::Text.new
    @with_context.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new("Kohane has described James Barnet as being an important figure"))

    CiteTrans.end_references.references.clear
  end


  describe '#initialize' do
    it 'constructs an Styles::APA' do
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference, 
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.reference).to eq(@reference)
      expect(apa.context.to_s).to eq(
        "James Barnet is one of Australia's most important colonial architects")
    end
  end

  describe '#cite' do
    it 'creates an author year parenthetical note for a single author' do
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, 2000')
    end

    it 'creates an author year parenthitical note for a single author with context' do
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference, 
                                       CiteTrans::Text::Context.new(@with_context)))
      expect(apa.cite).to eq('2000')
    end

    it 'initialises the author when there are two authors with the same surname' do 
      another_kohane = CiteTrans::Reference::Reference.new
      another_kohane.authors = CiteTrans::Reference::PersonGroup.new
      another_kohane.authors.add_name surname: 'Kohane', given_names: 'Daniel'
      another_kohane.year = 2010
      another_kohane.source = 'Biocompatibility and drug delivery systems.'

      CiteTrans.end_references << @reference
      CiteTrans.end_references << another_kohane

      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, P., 2000')
    end

    it 'cites a work by two authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane & Johnson, 2000')
    end

    it 'cites a work by three authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      @reference.authors.add_name surname: 'Bingham-Hall', given_names: 'Patrick'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, Bingham-Hall & Johnson, 2000')
    end

    it 'cites a work by five authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      @reference.authors.add_name surname: 'Bingham-Hall', given_names: 'Patrick'
      @reference.authors.add_name surname: 'Keating', given_names: 'Paul'
      @reference.authors.add_name surname: 'Mueller', given_names: 'Jeff'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, Bingham-Hall, Johnson, Keating & Mueller, 2000')
    end

    it 'cites a work by more than five authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      @reference.authors.add_name surname: 'Bingham-Hall', given_names: 'Patrick'
      @reference.authors.add_name surname: 'Keating', given_names: 'Paul'
      @reference.authors.add_name surname: 'Mueller', given_names: 'Jeff'
      @reference.authors.add_name surname: 'Marcello', given_names: 'Flavia'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::APA.new(CiteTrans::Citation.new(@reference,
                                       CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane et al., 2000')
    end
  end

end
