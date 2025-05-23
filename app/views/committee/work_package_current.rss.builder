xml.rss( :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' ) do
	xml.channel do
		xml.title( @committee.name + ' - work packages' )
		xml.description( "Updates whenever a new work package is established." )
		xml.link( committee_work_package_current_url )
		xml.copyright( 'https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/' )
		xml.language( 'en-gb' )
		xml.managingEditor( 'somervillea@parliament.uk (Anya Somerville)' )
		xml.pubDate( @current_work_packages.any? ? @current_work_packages.first.open_on.rfc822 : Date.today.rfc822 )
		xml.tag!( 'atom:link', { :href => committee_work_package_current_url( :format => 'rss' ), :rel => 'self', :type => 'application/rss+xml' } )
		xml << render( :partial => 'work_package/work_package', :collection => @current_work_packages ) unless @current_work_packages.empty?
	end
end