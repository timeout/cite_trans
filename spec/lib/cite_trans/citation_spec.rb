require 'cite_trans/citation'

RSpec.describe CiteTrans::Citation do

  let(:pos) { 10 }
  let(:ref) { CiteTrans::Reference::Reference.new }
  let(:author) { CiteTrans::Reference::PersonGroup.new }

  describe '#initialize' do
    it 'is constructed by a position and a reference' do
      author.add_name surname: 'Holland', given_names: 'WG'
      ref.authors = author
      CiteTrans::Citation.new(pos, ref)
    end

    it 'reads the pos' do
      ref.authors = author.add_name surname: 'Holland', given_names: 'WG'
      citation = CiteTrans::Citation.new(pos, ref)
      expect(citation.pos).to eq pos
    end

    it 'reads the reference' do
      ref.authors = author.add_name surname: 'Holland', given_names: 'WG'
      citation = CiteTrans::Citation.new(pos, ref)
      expect(citation.reference).to eq ref
    end
  end

  it 'finds no authors in the leading context' do
  end
end
