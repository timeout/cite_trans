require 'cite_trans/styles/mla'
require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'
require 'cite_trans'
require 'cite_trans/text/context'

require 'jpts_extractor'

RSpec.describe CiteTrans::Styles::MLA do

  before(:each) do
    @reference = CiteTrans::Reference::Reference.new
    @reference.authors = CiteTrans::Reference::PersonGroup.new
    @reference.authors.add_name surname: 'Kohane', given_names: 'Peter'
    @reference.year = 2000
    @reference.first_page = 23
    @reference.last_page = 37
    @reference.source = 'James Barnet'

    @no_context = JPTSExtractor::ArticlePart::Text.new
    @no_context.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new("James Barnet is one of Australia's most important colonial architects"))

    @with_context = JPTSExtractor::ArticlePart::Text.new
    @with_context.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new("Kohane has described James Barnet as being an important figure"))

    @with_context_initials = JPTSExtractor::ArticlePart::Text.new
    @with_context_initials.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new("P. Kohane has described James Barnet as being an important figure"))

    CiteTrans.end_references.references.clear
  end


  describe '#initialize' do
    it 'constructs an Styles::APA' do
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference, 
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.reference).to eq(@reference)
      expect(apa.context.to_s).to eq(
        "James Barnet is one of Australia's most important colonial architects")
    end
  end

  describe '#cite (no context)' do
    it 'creates an author page parenthetical note for a single author' do
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane 23-37')
    end

    it 'formats the location' do
      @reference.last_page = 28
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane 23-8')
    end

    it 'creates an author page note for two authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane and Johnson 23-37')
    end

    it 'creates an author page note for three authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      @reference.authors.add_name surname: 'Bingham-Hall', given_names: 'Patrick'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, Johnson and Bingham-Hall 23-37')
    end

    it 'creats an MLA note for four or more authors' do
      @reference.authors.add_name surname: 'Johnson', given_names: 'Chris'
      @reference.authors.add_name surname: 'Bingham-Hall', given_names: 'Patrick'
      @reference.authors.add_name surname: 'Keating', given_names: 'Paul'
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane et al. 23-37')
    end
  end

  describe '#cite (with context)' do
    it 'creates an author page parenthetical note for a single author' do
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation.new(@reference,
                                                               CiteTrans::Text::Context.new(@with_context)))
      expect(apa.cite).to eq('23-37')
    end

    it 'formats the location' do
      @reference.last_page = 28
      CiteTrans.end_references << @reference
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation
        .new(@reference, CiteTrans::Text::Context.new(@with_context)))
      expect(apa.cite).to eq('23-8')
    end
  end

  describe '#cite (multiple authors same surname)' do
    it 'creates an initialed author parenthetical note' do
      other = CiteTrans::Reference::Reference.new
      other.authors = CiteTrans::Reference::PersonGroup.new
      other.authors.add_name surname: 'Kohane', given_names: 'Frank'
      other.year = 2005
      other.first_page = 32
      other.last_page = 39
      other.source = 'The Banana Republic'
      CiteTrans.end_references << @reference
      CiteTrans.end_references << other

      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation
        .new(@reference, CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('P. Kohane 23-37')
    end

    it 'shared surname, used in context' do
      other = CiteTrans::Reference::Reference.new
      other.authors = CiteTrans::Reference::PersonGroup.new
      other.authors.add_name surname: 'Kohane', given_names: 'Frank'
      CiteTrans.end_references << @reference
      CiteTrans.end_references << other

      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation
        .new(@reference, CiteTrans::Text::Context.new(@with_context_initials)))
      expect(apa.cite).to eq('23-37')
    end
  end

  describe '#cite (multiple sources, single author)' do
    it 'adds the source to specify which source' do
      other = CiteTrans::Reference::Reference.new
      other.authors = CiteTrans::Reference::PersonGroup.new
      other.authors.add_name surname: 'Kohane', given_names: 'Peter'
      other.year = 2010
      other.first_page = 32
      other.last_page = 39
      other.source = 'Louis Kahn and the Art of Drawing a Room'

      CiteTrans.end_references << @reference
      CiteTrans.end_references << other

      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation
        .new(@reference, CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane, James Barnet 23-37')
    end
  end

  describe '#cite (volume)' do
    it 'includes the volume information' do
    @reference.volume = 25
    CiteTrans.end_references << @reference
    
      apa = CiteTrans::Styles::MLA.new(CiteTrans::Citation
        .new(@reference, CiteTrans::Text::Context.new(@no_context)))
      expect(apa.cite).to eq('Kohane 25: 23-37')
    end
  end
end
