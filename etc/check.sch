<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"  >

  <sch:title>Tester Program for SVRL</sch:title>
  
  <sch:p>This schema tests an SVRL document that has been created by
  validating another document using some Schematron schema using the
  iso_svrl.xsl stylesheet. If there were any failed assertions or
  successful reports, the document succeeds. If you validate this 
  using the iso_schematron_terminator.xsl stylesheet and some XSLT
  engines, then you can use this to generate status messages for
  use in batch files etc. </sch:p>
  
  <sch:ns prefix="svrl" uri="http://purl.oclc.org/dsdl/svrl" />
  
  <sch:pattern  id="P1"> 
     <sch:rule context="svrl:failed-assert | svrl:successful-report">
	<sch:report test="true()"
		><sch:value-of select="preceding::svrl:active-pattern[1]/@document"/>: <sch:value-of select="svrl:text"/></sch:report>
     </sch:rule>
     
  </sch:pattern>
  
</sch:schema>
