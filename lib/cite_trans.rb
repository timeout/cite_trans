require 'cite_trans/end_references'
require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'
require 'cite_trans/text/context'
require 'cite_trans/text/chapter'

require 'jpts_extractor'
# require 'builder'

module CiteTrans
  def self.translate!(io, style)
    article = JPTSExtractor.extract(io)
    return article if style == :vancouver

    index_references(article.back.ref_list)

     article.body.sections.map do |section|
      section.map!(section) do |block|
        if block.is_a? JPTSExtractor::ArticlePart::Text
          chapter = Text::Chapter.new(block)
          chapter.cite! style
          block = chapter.text
        else
          block = block
        end
      end
    end
    article
  end

  def self.end_references
    @@end_references ||= EndReferences.new
  end

  private
  def self.index_references(article_reference_list)
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

      end_references << reference
    end
  end
end

require 'cite_trans/styles/mla'
require 'cite_trans/styles/apa'

