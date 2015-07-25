require 'cite_trans/text/chapter'
require 'cite_trans/reference/reference'
require 'cite_trans'
require 'cite_trans/styles'

require 'jpts_extractor'

RSpec.describe CiteTrans::Text::Chapter do

  def text
    text = JPTSExtractor::ArticlePart::Text.new
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('"Shortcuts make for long delays", said Gandalf ['))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('1')))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new(']. "Idiot," replied Bilbo ['))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('2')))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new(', '))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('3')))
    text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
      .new('].'))
  end

  def make_reference(author, source, fpage= 0, lpage= 0)
      reference = CiteTrans::Reference::Reference.new
      reference.authors = CiteTrans::Reference::PersonGroup.new
      reference.authors.add_name author
      reference.source = source
      reference.first_page = fpage
      reference.last_page = lpage
      reference
  end

  let(:chapter) { CiteTrans::Text::Chapter.new(text) }

  describe '#initialize' do
    it 'constructs a chapter' do
      chapter 
    end
  end

  describe '#each' do
    it 'enumerates the citations in the chapter', broken: true do
      gandalf_ref = make_reference({surname: 'Gandalf', given_names: 'The Gray'},
                                   'Wizardry for Dummies')
      bilbo_ref = make_reference({surname: 'Baggins', given_names: 'Bilbo'},
                                 'Tasty Snacks for Subterranean Hipsters')
      sam_ref = make_reference({surname: 'Gamgee', given_names: 'Sam'},
                                 'Homebrewing for Hobbits')

      CiteTrans.end_references << gandalf_ref
      CiteTrans.end_references << bilbo_ref
      CiteTrans.end_references << sam_ref

      citations = chapter.flat_map

      citation = citations.next
      expect(citation[1].text).to eq("1")
      expect(citation.last.to_s).to eq "\"Shortcuts make for long delays\", said Gandalf ["

      citation = citations.next
      expect(citation[1].text).to eq("2")
      expect(citation.last.to_s).to eq "\"Shortcuts make for long delays\", said Gandalf [ ]. \"Idiot,\" replied Bilbo ["

      citation = citations.next
      expect(citation[1].text).to eq("3")
      expect(citation.last.to_s).to eq "\"Shortcuts make for long delays\", said Gandalf [ ]. \"Idiot,\" replied Bilbo [ , "
    end

    it 'translates a citation', broken: true do
      CiteTrans.end_references.references.clear
      gandalf_ref = make_reference({surname: 'Gandalf', given_names: 'The Gray'},
                                   'Wizardry for Dummies')
      bilbo_ref = make_reference({surname: 'Baggins', given_names: 'Bilbo'},
                                 'Tasty Snacks for Subterranean Hipsters')
      CiteTrans.end_references << gandalf_ref
      CiteTrans.end_references << bilbo_ref

      citation = chapter.first
      end_reference_index = (citation[1].text.to_i - 1)
      expect(CiteTrans.end_references[end_reference_index]).to eq(gandalf_ref)
      citation[1].text = 'Gandalf, TG., 1935'

      expect(chapter.first[1].text).to eq 'Gandalf, TG., 1935'
    end

    it 'translates a citation, with the citation being the first fragment' do
      some_text = JPTSExtractor::ArticlePart::Text.new
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
        .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new("1")))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::ItalicText
        .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('"Wow",')))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new(" said Gandalf."))

      chapt = CiteTrans::Text::Chapter.new(some_text)
      chapt.each do |before, cite, after|
        if cite.is_a? JPTSExtractor::ArticlePart::InlineText::Citation
          expect(before.text).to be_empty
          expect(cite.text).to eq("1")
          expect(after.nil?).to be_falsey
        end
      end
    end
  end

  describe '#cite!' do
    it 'doesnt effect a paragraph in which there are no citations' do
      some_text = JPTSExtractor::ArticlePart::Text.new
      # some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
      #   .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new("1")))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new("He looked at the place where his beard used to be:"))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::ItalicText
        .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('"Wow",')))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new("said Gandalf."))

      chapt = CiteTrans::Text::Chapter.new(some_text)
      expect(chapt.cite!(CiteTrans::MLA).to_s).to eq(
        'He looked at the place where his beard used to be: "Wow", said Gandalf.')
    end

    it 'cites in mla' do
      CiteTrans.end_references.references.clear
      expect(CiteTrans.end_references.size).to eq(0)

      gandalf_ref = make_reference({surname: 'Gandalf', given_names: 'The Gray'},
                                   'Wizardry for Dummies', 23, 27)

      expect(gandalf_ref.authors.first[:surname]).to eq('Gandalf')
      expect(gandalf_ref.authors.first[:given_names]).to eq('The Gray')

      bilbo_ref = make_reference({surname: 'Baggins', given_names: 'Bilbo'},
                                 'Tasty Snacks for Subterranean Hipsters')
      CiteTrans.end_references << gandalf_ref
      CiteTrans.end_references << bilbo_ref

      some_text = JPTSExtractor::ArticlePart::Text.new
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new("He looked at the place where his beard used to be:"))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::ItalicText
        .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new('"Wow",')))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new("said Gandalf ["))
       some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::Citation
         .new(JPTSExtractor::ArticlePart::InlineText::InlineText.new("1")))
      some_text.add_fragment(JPTSExtractor::ArticlePart::InlineText::InlineText
        .new("]."))

      chapt = CiteTrans::Text::Chapter.new(some_text)
      expect(chapt.cite!(CiteTrans::MLA).to_s).to eq(
        'He looked at the place where his beard used to be: "Wow", said Gandalf ( 23-7 ).')
    end
  end
end
