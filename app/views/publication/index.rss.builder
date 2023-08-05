xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( 'Publications' )
		xml.description( "Updates whenever there's a new publication." )
		xml.link( publication_list_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @publications.first.start_at.rfc822 )
		xml.tag!( 'atom:link', { :href => publication_list_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'publication', :collection => @publications )
	end
end