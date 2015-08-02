require 'cite_trans/text/paragraph'
require 'cite_trans/styles'
require 'cite_trans'

require 'jpts_extractor'
require 'pathname'

RSpec.describe CiteTrans::Text::Paragraph do
  let(:no_citation_path) {Pathname.new 'spec/fixture/paragraph_no_citation.xml'}
  let(:citation_frag_path) {Pathname.new 'spec/fixture/paragraph_citation_fragment.xml'}
  let(:citation_mult_path) {Pathname.new 'spec/fixture/paragraph_multiple_citation.xml'}
  let(:citation_range_path) {Pathname.new 'spec/fixture/paragraph_range_citation.xml'}
  let(:citation_mixed) {Pathname.new 'spec/fixture/paragraph_mixed.xml'}

  describe '#initialize' do
    it 'constructs a paragraph' do
      article = JPTSExtractor.extract no_citation_path.open
      CiteTrans.index_references(article.back.ref_list)
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            paragraph.each do |fragment| 
              expect(fragment.is_a? CiteTrans::Text::CitationFragment)
                .to be_falsey
            end
          end
        end
      end
    end

    it 'constructs a paragraph' do
      article = JPTSExtractor.extract citation_frag_path.open
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            count = paragraph.count {|fragment| fragment.is_a? CiteTrans::Text::CitationFragment}
            expect(count).to eq(1)
          end
        end
      end
    end

    it 'constructs a paragraph' do
      article = JPTSExtractor.extract citation_mult_path.open
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            count = paragraph.count {|fragment| fragment.is_a? CiteTrans::Text::MultiCitation}
            expect(count).to eq(1)
          end
        end
      end
    end

    it 'constructs a paragraph' do
      article = JPTSExtractor.extract citation_range_path.open
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            count = paragraph.count {|fragment| fragment.is_a? CiteTrans::Text::RangeCitation}
            expect(count).to eq(2)
          end
        end
      end
    end
  end

  describe '#cite!' do
    it 'cites a single citation' do
      article = JPTSExtractor.extract citation_frag_path.open
      CiteTrans.index_references(article.back.ref_list)
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            puts paragraph.cite!(CiteTrans::MLA).to_s
          end
        end
      end
    end

    it 'cites a multiple citation' do
      article = JPTSExtractor.extract citation_mult_path.open
      CiteTrans.index_references(article.back.ref_list)
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            puts paragraph.cite!(CiteTrans::MLA).to_s
          end
        end
      end
    end

    it 'cites a range citation' do
      article = JPTSExtractor.extract citation_range_path.open
      CiteTrans.index_references(article.back.ref_list)
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            puts paragraph.cite!(CiteTrans::MLA).to_s
          end
        end
      end
    end

    it 'cites a mixed citation' do
      article = JPTSExtractor.extract citation_mixed.open
      CiteTrans.index_references(article.back.ref_list)
      article.body.sections.each do |section|
        section.each(section) do |block|
          if block.is_a? JPTSExtractor::ArticlePart::Text
            paragraph = CiteTrans::Text::Paragraph.new(block)
            puts paragraph.cite!(CiteTrans::APA).to_s
          end
        end
      end
    end

  end
end
