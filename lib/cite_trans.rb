require 'cite_trans/reference/reference_list'
require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'
require 'cite_trans/text/context'
require 'cite_trans/text/paragraph'
require 'cite_trans/end_references'

require 'jpts_extractor'
# require 'builder'

module CiteTrans
  def self.translate!(io, style)
    article = JPTSExtractor.extract(io)
    return article if style == :vancouver

    CiteTrans.end_references.clear!
    CiteTrans.index_references(article)

     article.body.sections.map do |section|
      section.map!(section) do |block|
        if block.is_a? JPTSExtractor::ArticlePart::Text
          paragraph = Text::Paragraph.new(block)
          paragraph.cite! style
          block = paragraph.text
        else
          block = block
        end
      end
    end
    article
  end

  def self.index_references(article)
    CiteTrans.end_references = index(article)
  end

  def self.index(article)
    article_reference_list = article.back.ref_list
    list = Reference::ReferenceList.new
    article_reference_list.each_with_index do |ref, index|
      authors = Reference::PersonGroup.new
      ref.author_names.each do |author|
        authors.add_name({ 
          surname: author.surname, 
          given_names: author.given_names 
        })
      end unless ref.author_names.nil?

      # TODO: incomplete
      # adapter, because this may have to radically change?
      #
      # create a reference
      reference = Reference::Reference.new
      reference.index = index 
      reference.authors = authors unless authors.empty?
      reference.year = ref.year if ref.year?
      reference.title = ref.article_title if ref.article_title? #!
      reference.source = ref.source if ref.source?
      reference.first_page = ref.fpage if ref.fpage?
      reference.last_page = ref.lpage if ref.lpage?
      reference.volume = ref.volume if ref.volume?
      reference.publisher = ref.publisher_name if ref.publisher_name?

      list << reference
    end
    list
  end
end

require 'cite_trans/styles/mla'
require 'cite_trans/styles/apa'

