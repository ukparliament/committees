xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( "#{@work_package.title} - #{@publication_type.name}" )
		xml.description( "Updates whenever a there's a new #{@publication_type.name}." )
		xml.link( work_package_publication_type_show_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-uk' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @publications.any? ? @publications.first.start_at.rfc822 : Date.today.rfc822 )
		xml.tag!( 'atom:link', { :href => work_package_publication_type_show_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'publication/publication', :collection => @publications )
	end
end