require 'cite_trans/chapter_extractor'
require 'cite_trans/cite_notes'
require 'cite_trans/end_references'

require 'cite_trans/reference/reference'
require 'cite_trans/reference/person_group'

require 'jpts_extractor'

module CiteTrans
  def self.translate!(io)
    article = JPTSExtractor.extract(io)
    root_section = article.body.sections
   

    chap_extract = ChapterExtractor.new
    chap_extract.format(root_section)

    chap_extract.chapters.each do |chapter|
      puts "#{chapter.to_s}\n"
    end

    # get in text citations 
    cite_notes = CitationNotes.new(chap_extract.chapters)
    notes = cite_notes.citations
    notes.each_with_index do |note, index|
      puts "#{index + 1}: #{note.text}"
    end

    end_references = index_references(article.back.ref_list)

  end

  private
  def self.index_references(article_reference_list)
    end_references = EndReferences.new

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
    end_references
  end
end

# CiteTrans.translate! File.open('/home/joe/documents/corpora/0127478/tei/0127478.xml')
CiteTrans.translate! File.open('/home/joe/documents/corpora/0129366/tei/0129366.xml')
# CiteTrans.translate! File.open('dummy_article.xml')
