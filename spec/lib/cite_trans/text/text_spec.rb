require 'cite_trans/text/text'

RSpec.describe CiteTrans::Text::Text, broken: true do
  let(:contents) { 

    'A variety of psychological and social factors influence the
    likelihood of smoking among adolescents: patters of rebelliousness
    and impulsiveness, indications of low self-esteem or poor
    achievement, modeled behaviour among peers or family members. Young
    also noted that attempts to ameliorate these behaviours were not
    always successful.' 
  
  }

  let (:text) { CiteTrans::Text::Text.new(contents) }

  describe "#initialize" do
    it 'constructs a text object' do
      text
    end
  end

  it 'splits the contents at position: pos' do
    text.set_mark! 0
    expect(text.leading).to eq("")
    expect(text.following).to eq(contents)
  end

  it 'splits the contents at position: pos' do
    text.set_mark! 1
    expect(text.leading).to eq('A')
    expect(text.following).to eq(contents.slice(1..-1))
  end

  it 'splits the contents at position: pos' do
    text.set_mark! 9
    expect(text.leading).to eq('A variety')
    expect(text.following).to eq(contents.slice(9..-1))
  end

  it 'is cited' do
    ref = instance_double("CiteTrans::Reference")
    cite = CiteTrans::Citation.new(9, ref)
    text.cite(cite)
  end
end
