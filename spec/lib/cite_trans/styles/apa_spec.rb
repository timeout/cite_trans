require 'cite_trans/styles/apa'

RSpec.describe CiteTrans::Styles::APA, broken: true do

  it 'formats a citation' do
    # reference = instance_double("CiteTrans::Reference::Reference")
    # expect(reference).to receive(:authors)
    # cite = instance_double("CiteTrans::Citation")
    # expect(cite).to receive(:author_in_leading?)
    # expect(cite).to receive(:reference) { reference }
    # apa = CiteTrans::Styles::APA.new(10, reference)
    # apa.format(cite)
  end

  # two authors:
  # in text: author1 and author2
  # in parentheses: author1 & author2
  describe '#format_authors' do

    let(:ref) { CiteTrans::Reference::Reference.new }
    let(:authors) { CiteTrans::Reference::PersonGroup.new }

    it 'formats 1 author' do
      authors.add_name surname: 'Holland', given_names: 'WG'
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref) 
      expect(apa.format_authors).to eq('Holland')
    end

    it 'formats 2 authors' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref) 
      expect(apa.format_authors).to eq('Holland & Lewis')
    end

    it 'formats 3 authors' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
        .add_name(surname: 'Chappell', given_names: 'GS')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref)
      expect(apa.format_authors).to eq('Holland, Chappell & Lewis')
    end

    it 'formats 5 authors' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
        .add_name(surname: 'Chappell', given_names: 'GS')
        .add_name(surname: 'Keating', given_names: 'PJ')
        .add_name(surname: 'Kennedy', given_names: 'JF')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref)
      expect(apa.format_authors).to eq('Holland, Chappell, Keating, Kennedy & Lewis')
    end

    it 'formats 6 authors' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
        .add_name(surname: 'Chappell', given_names: 'GS')
        .add_name(surname: 'Keating', given_names: 'PJ')
        .add_name(surname: 'Kennedy', given_names: 'JF')
        .add_name(surname: 'McGrath', given_names: 'GD')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref)
      expect(apa.format_authors).to eq('Holland et al.')
    end

    it 'formats authors to match in text usage' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
        .add_name(surname: 'Chappell', given_names: 'GS')
        .add_name(surname: 'Keating', given_names: 'PJ')
        .add_name(surname: 'Kennedy', given_names: 'JF')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref)
      expect(apa.format_authors_text).to eq('Holland, Chappell, Keating, Kennedy and Lewis')
    end

    it 'formats 6 authors to match in text usage' do
      authors.add_name(surname: 'Holland', given_names: 'WG')
        .add_name(surname: 'Lewis', given_names: 'CS')
        .add_name(surname: 'Chappell', given_names: 'GS')
        .add_name(surname: 'Keating', given_names: 'PJ')
        .add_name(surname: 'Kennedy', given_names: 'JF')
        .add_name(surname: 'McGrath', given_names: 'GD')
      ref.authors = authors
      apa = CiteTrans::Styles::APA.new(0, ref)
      expect(apa.format_authors_text).to eq('Holland et al.')
    end
  end

  describe '#parentheses_note' do
    let(:ref) { CiteTrans::Reference::Reference.new }
    let(:authors) { CiteTrans::Reference::PersonGroup.new }
    let(:contents_no_author) {
      %{A variety of psychological and social factors influence the
       likelihood of smoking among adolescents: patters of rebelliousness
       and impulsiveness, indications of low self-esteem or poor
       achievement, modeled behaviour among peers or family members. Young
       also noted that attempts to ameliorate these behaviours were not
       always successful.}
    }

    let(:pos_no_author) {
      %{A variety of psychological and social factors influence the 
       likelihood of smoking among adolescents: patters of rebelliousness
       and impulsiveness, indications of low self-esteem or poor
       achievement, modeled behaviour among peers or family members.}.length
    }

    let(:contents_with_author) {
      %{A variety of psychological and social factors influence the
      likelihood of smoking among adolescents. Young cited patters of
      rebelliousness and impulsiveness, indications of low self-esteem
      or poor achievement, modeled behaviour among peers or family
      members. Young also noted that attempts to ameliorate these
      behaviours were not always successful.}
    }
    let(:pos_with_author) {
      %{A variety of psychological and social factors influence the
      likelihood of smoking among adolescents. Young cited}.length
    }

    it 'generates a parentheses note with author' do
      authors.add_name(surname: 'Young', given_names: 'TK')
      ref.authors = authors
      ref.year = '2005'
      apa = CiteTrans::Styles::APA.new(pos_no_author, ref)
      text = CiteTrans::Text::Text.new(contents_no_author)
      text.cite(apa)
      expect(apa.parentheses_note).to eq('Young, 2005')
    end

    it 'generates a parentheses not without an author' do
      authors.add_name(surname: 'Young', given_names: 'TK')
      ref.authors = authors
      ref.year = '2005'
      apa = CiteTrans::Styles::APA.new(pos_with_author, ref)
      text = CiteTrans::Text::Text.new(contents_with_author)
      text.cite(apa)
      expect(apa.parentheses_note).to eq('2005')
    end
  end
end
