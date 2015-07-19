require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'

RSpec.describe CiteTrans::Reference do

  let(:reference) { CiteTrans::Reference::Reference.new }
  let(:person_group) { CiteTrans::Reference::PersonGroup.new }
  let(:year) { '2000' }
  let(:title) { 'My Important Research Topic' }
  let(:source) { 'Taking Care of Business' }
  let(:volume) { '4th' }
  let(:first_page) { 'ix' }
  let(:last_page) { '12' }

  describe 'reference attributes' do
    it 'can access authors' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      reference.authors = person_group
      expect(reference.authors).to eq person_group
    end

    it 'has authors?' do
      expect(reference.authors?).to be_falsey
      reference.authors = person_group
      expect(reference.authors?).to be_falsey
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      expect(reference.authors?).to be_truthy
    end

    it 'can access the year of publication' do
      reference.year = year
      expect(reference.year).to eq year
    end

    it 'has a year?' do
      expect(reference.year?).to be_falsey
      reference.year = year
      expect(reference.year?).to be_truthy
    end

    it 'can access the source title' do
      reference.title = title
      expect(reference.title).to eq title
    end

    it 'has a source title?' do
      expect(reference.title?).to be_falsey
      reference.title = title
      expect(reference.title?).to be_truthy
    end

    it 'can access a source' do
      reference.source = source
      expect(reference.source).to eq source
    end

    it 'has a source?' do
      expect(reference.source?).to be_falsey
      reference.source = source
      expect(reference.source?).to be_truthy
    end

    it 'can access the volume' do
      reference.volume = volume
      expect(reference.volume).to eq volume
    end

    it 'has a volume?' do
      expect(reference.volume?).to be_falsey
      reference.volume = volume
      expect(reference.volume?).to be_truthy
    end

    it 'can access the first page' do
      reference.first_page = first_page
      expect(reference.first_page).to eq first_page
    end

    it 'has a first_page?' do
      expect(reference.first_page?).to be_falsey
      reference.first_page = first_page
      expect(reference.first_page?).to be_truthy
    end

    it 'can access the last page' do
      reference.last_page = last_page
      expect(reference.last_page).to eq last_page
    end

    it 'has a last_page?' do
      expect(reference.last_page?).to be_falsey
      reference.last_page = last_page
      expect(reference.last_page?).to be_truthy
    end
  end

  describe "#<=>" do
    let(:other_reference) { CiteTrans::Reference::Reference.new }

    it 'compares a reference by year, if the authors are the same' do
      authors = person_group.add_name({surname: 'Bradman', given_names: 'Donald'})
      reference.authors = authors
      reference.year = 1999
      # expect(reference <=> other_reference).to eq(0)
      other_reference.authors = authors
      other_reference.year = 2001
      expect(reference <=> other_reference).to eq(-1)
    end

    it 'compares a reference by year, if the authors are the same' do
      authors = person_group.add_name({surname: 'Bradman', given_names: 'Donald'})
      reference.authors = authors
      reference.year = '1999a'
      other_reference.authors = authors
      other_reference.year = '1999b'
      expect(reference <=> other_reference).to eq(-1)
    end

    it 'compares a referencce by source, if the authors and the year are the same' do
      authors = person_group.add_name({surname: 'Waugh', given_names: 'Steven Rodger'})
      reference.authors = authors
      reference.year = 2010
      reference.source = 'Out of my comfort zone'
      other_reference.authors = authors
      other_reference.year = reference.year
      other_reference.source = 'Captains Diary'
      expect(reference <=> other_reference).to eq(1)
    end

    it 'returns 0 when we compare the same reference' do
      reference.authors = person_group
      reference.authors.add_name({surname: 'Smith', given_names: 'Steven'})
      reference.year = year
      reference.volume = volume
      reference.first_page = first_page
      reference.last_page = last_page
      reference.title = title
      reference.source = source

      duplicate = reference.dup

      expect(reference <=> duplicate).to eq(0)
    end

    it 'compares a reference title if it has no author' do
      reference.source = "Cricketers' Almanack"
      reference.year = 2011
      other_reference.authors = person_group.add_name(
        {surname: 'Bradman', given_names: 'Donald'})
      other_reference.year = 2013
      expect(reference <=> other_reference).to eq(1)
    end
  end
end
