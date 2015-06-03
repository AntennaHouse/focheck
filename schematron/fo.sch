<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015 Antenna House, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
-->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
	 id="fo-fo">

  <rule context="fo:float">
    <!-- http://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="exists(ancestor::fo:float) or exists(ancestor::fo:footnote)">An '<value-of select="local-name()" />' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
  </rule>

  <rule context="fo:footnote">
    <!-- http://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">An '<value-of select="local-name()" />' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
    <!-- http://www.w3.org/TR/xsl/#fo_footnote -->
    <!--
    <assert
	test="ancestor::fo:flow/@flow-name eq 'xsl-region-body' or
	      (not(ancestor::fo:flow/@flow-name = ('xsl-region-after', 'xsl-region-before', 'xsl-region-end', 'xsl-region-start')) and
	       ancestor::fo:flow/@flow-name eq /fo:root/fo:layout-master-set/fo:simple-page-master[@master-name eq current()/ancestor::fo:page-sequence/@master-reference]/fo:region-body/@region-name)">An 'fo:footnote' must be a descendant of a flow that is assigned to one or more region-body regions.</assert>
    -->
    <report test="exists(ancestor::fo:block-container[@absolute-position = ('absolute', 'fixed')])">An 'fo:footnote' is not permitted as a descendant of an 'fo:block-container' that generates an absolutely positioned area.</report>
    <report test="exists(descendant::fo:block-container[@absolute-position = ('absolute', 'fixed')])">An 'fo:footnote' is not permitted to have as a descendant an 'fo:block-container' that generates an absolutely positioned area.</report>
    <report test="exists(descendant::fo:*[local-name() = ('float', 'footnote', 'marker')])">An 'fo:footnote' is not permitted to have an 'fo:float', 'fo:footnote', or 'fo:marker' as a descendant.</report>
  </rule>

  <rule context="fo:retrieve-table-marker">
    <assert test="exists(ancestor::fo:table-header) or
                  exists(ancestor::fo:table-footer) or
                  (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and
                  (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or
                   $expression/@is-zero = 'yes' or
                   exists($expression/@value) and not($expression/@value castable as xs:integer))" role="column-count">Warning: '<value-of select="local-name()" />' should be a positive integer.  The FO formatter will round a non-positive or non-integer value to the nearest integer value greater than or equal to 1.</report>
  </rule>

  <rule context="fo:*/@column-width">
    <let name="number-columns-spanned"
	 value="ahf:parser-runner(../@number-columns-spanned)"/>
    <report test="exists(../@number-columns-spanned) and
		  local-name($number-columns-spanned) = 'Number' and
                  (exists($number-columns-spanned/@value) and
		   number($number-columns-spanned/@value) >= 1.5)" role="column-width">Warning: @<value-of select="local-name()" /> is ignored with @number-columns-spanned is present and has a value greater than 1.</report>
  </rule>

</pattern>
