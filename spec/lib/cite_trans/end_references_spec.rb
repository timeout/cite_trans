require 'cite_trans/end_references'

def make_reference(name, source)
  reference = CiteTrans::Reference::Reference.new
  reference.authors = CiteTrans::Reference::PersonGroup.new
  reference.authors.add_name(name)
  reference.source = source
  reference
end

RSpec.describe CiteTrans::EndReferences do

  describe '#add_reference' do
    before(:each) do
      @kpopper = make_reference({surname: 'Popper', given_names: 'Karl Raimund'}, 
                                'The Open Society and Its Enemies')
      @end_references = CiteTrans::EndReferences.new

      @end_references << make_reference({surname: 'Popper', given_names: 'Frank'}, 
                                        'From Technological to Virtual Art')
      @end_references << make_reference({surname: 'Taut', given_names: 'Bruno'}, 
                                        'Alpine Architektur')
    end

    it 'finds an author with the same surname', broken: true do
      has_same_author = @end_references.detect_same_surname(@kpopper)
      expect(has_same_author).to be_truthy
    end

    it 'has no author with the same surname' do
      dummy_ref = make_reference({}, 'Calling all Cricketers')
      expect(@end_references.detect_same_surname(dummy_ref)).to be_falsey
    end

    it "shouldn't find itself" do
      btaut = make_reference({surname: 'Taut', given_names: 'Bruno'}, 
                                        'Alpine Architektur')
      expect(@end_references.detect_same_surname(btaut)).to be_falsey
    end

    it "detects an author, if the sources are different" do
      btaut = make_reference({surname: 'Taut', given_names: 'Bruno'}, 
                             'Die neue Wohnung. Die Frau als Schöpferin.')
      expect(@end_references.detect_same_surname(btaut)).to be_falsey
    end
  end

  describe '#select_surnames' do
    it 'selects references which share the same surname' do
      CiteTrans.end_references.references.clear
      CiteTrans.end_references << make_reference(
        {surname: 'Causley', given_names: 'Karl'}, 'Do Sheep Dream of Electric Sheep')
      CiteTrans.end_references << make_reference(
        {surname: 'Causley', given_names: 'Dave'}, 'Dune')
      CiteTrans.end_references << make_reference(
        {surname: 'Clark', given_names: 'Christopher'}, 'Dune')
      surnames = CiteTrans.end_references.select_surnames(
        CiteTrans::Reference::PersonGroup.new
        .add_name surname: 'Causley', given_names: 'Karl')
      expect(surnames.size).to eq(2)
    end
  end

  describe '#multiple_sources?' do
    it 'detects an author with multiple references' do
      karl = make_reference(
        {surname: 'Causley', given_names: 'Karl'}, 'Do Sheep Dream of Electric Sheep')
      CiteTrans.end_references.references.clear
      CiteTrans.end_references << karl
      CiteTrans.end_references << make_reference(
        {surname: 'Causley', given_names: 'Karl'}, 'The Moon Is a Harsh Mistress')
      CiteTrans.end_references << make_reference(
        {surname: 'Causley', given_names: 'Dave'}, 'Dune')
      CiteTrans.end_references << make_reference(
        {surname: 'Clark', given_names: 'Christopher'}, 'Dune')

      expect(CiteTrans.end_references.multiple_sources? karl).to be_truthy
    end
  end

end
