xml.item do
	xml.guid( oral_evidence_transcript.preferred_link )
	xml.title( oral_evidence_transcript.published_on )
	xml.link( oral_evidence_transcript.preferred_link )
	xml.pubDate( oral_evidence_transcript.published_on.rfc822 )
	#xml.description( link.description )
end