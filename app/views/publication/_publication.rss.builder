xml.item do
	xml.guid( publication_show_url( :publication => publication.system_id ) )
	xml.title( publication.description )
	xml.link( publication_show_url( :publication => publication.system_id ) )
	xml.pubDate( publication.start_at.rfc822 )
end