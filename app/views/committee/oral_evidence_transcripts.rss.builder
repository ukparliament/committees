xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( "#{@committee.name} - oral evidence transcripts" )
		xml.description( "Updates whenever a new transcript is published." )
		xml.link( committee_oral_evidence_transcripts_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @oral_evidence_transcripts.any? ? @oral_evidence_transcripts.first.published_on.rfc822 : Date.today.rfc822 )
		xml.tag!( 'atom:link', { :href => committee_oral_evidence_transcripts_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'oral_evidence_transcript/oral_evidence_transcript', :collection => @oral_evidence_transcripts )
	end
end