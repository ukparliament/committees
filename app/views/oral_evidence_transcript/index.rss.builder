xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( 'Oral evidence transcripts' )
		xml.description( "Updates whenever a new transcript is published." )
		xml.link( oral_evidence_transcript_list_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @all_oral_evidence_transcripts.any? ? @all_oral_evidence_transcripts.first.published_on.rfc822 : Date.today.rfc822 )
		xml.tag!( 'atom:link', { :href => oral_evidence_transcript_list_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'oral_evidence_transcript/oral_evidence_transcript', :collection => @all_oral_evidence_transcripts )
	end
end