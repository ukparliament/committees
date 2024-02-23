xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( @page_title )
		xml.description( "Updates whenever a new transcript is published." )
		xml.link( position_oral_evidence_transcripts_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @position.oral_evidence_transcripts.first.published_on.rfc822 )
		xml.tag!( 'atom:link', { :href => position_oral_evidence_transcripts_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'oral_evidence_transcript/oral_evidence_transcript', :collection => @oral_evidence_transcripts )
	end
end