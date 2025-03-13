xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( "#{@committee.name} - publications" )
		xml.description( "Updates whenever a there's a new publication." )
		xml.link( committee_publications_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @publications.any? ? @publications.first.start_at.rfc822 : Date.today.rfc822 )
		xml.tag!( 'atom:link', { :href => committee_publications_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'publication/publication', :collection => @publications )
	end
end