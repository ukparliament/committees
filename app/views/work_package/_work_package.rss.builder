xml.item do
	xml.guid( work_package_show_url( :work_package => work_package.system_id ) )
	xml.title( work_package.title )
	xml.link( work_package_show_url( :work_package => work_package.system_id ) )
	xml.pubDate( work_package.open_on.rfc822 )
end