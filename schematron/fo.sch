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

  <!-- FOs -->

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

  <rule context="fo:retrieve-marker">
    <!-- http://www.w3.org/TR/xsl/#fo_retrieve-marker -->
    <assert test="exists(ancestor::fo:static-content)">An fo:retrieve-marker is only permitted as the descendant of an fo:static-content.</assert>
  </rule>

  <rule context="fo:retrieve-table-marker">
    <!-- http://www.w3.org/TR/xsl/#fo_retrieve-table-marker -->
    <assert test="exists(ancestor::fo:table-header) or
                  exists(ancestor::fo:table-footer) or
                  (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>

  <rule context="fo:root">
    <!-- http://www.w3.org/TR/xsl/#fo_root -->
    <assert id="fo_root-001"
	    test="exists(descendant::fo:page-sequence)">There must be at least one fo:page-sequence descendant of fo:root.</assert>
  </rule>

  <!-- Properties -->

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and
                  (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or
                   $expression/@is-zero = 'yes' or
                   exists($expression/@value) and not($expression/@value castable as xs:integer))" id="column-count" role="Warning"><value-of select="local-name()" />="<value-of select="."/>" should be a positive integer.  A non-positive or non-integer value will be rounded to the nearest integer value greater than or equal to 1.</report>
  </rule>

  <rule context="fo:*/@column-width">
    <let name="number-columns-spanned"
	 value="ahf:parser-runner(../@number-columns-spanned)"/>
    <report test="exists(../@number-columns-spanned) and
		  local-name($number-columns-spanned) = 'Number' and
                  (exists($number-columns-spanned/@value) and
		   number($number-columns-spanned/@value) >= 1.5)" id="column-width" role="Warning"><value-of select="local-name()" /> is ignored with 'number-columns-spanned' is present and has a value greater than 1.</report>
  </rule>

  <rule context="fo:*/@flow-name">
    <!-- http://www.w3.org/TR/xsl11/#flow-name -->
    <assert test="count(../../*/@flow-name[. eq current()]) = 1">flow-name="<value-of select="."/>" must be unique within its fo:page-sequence.</assert>
    <report test="not(. = ('xsl-region-body', 'xsl-region-start', 'xsl-region-end', 'xsl-region-before', 'xsl-region-after')) and empty(key('region-name', .))" role="Warning">flow-name="<value-of select="."/>" does not match any named or default region name.</report>
  </rule>

  <rule context="fo:*/@language">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <!-- What would be generated if we could... -->
    <!-- http://www.w3.org/TR/xsl11/#language -->
    <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">language="<value-of select="."/>" should be an EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit') or string-length($expression/@token) = 2 or string-length($expression/@token) = 3)">language="<value-of select="."/>" should be a 3-letter code conforming to a ISO639-2 terminology or bibliographic code or a 2-letter code conforming to a ISO639 2-letter code or 'none' or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: 'language="<value-of select="."/>"'</report>
    <!-- http://www.w3.org/TR/xsl11/#d0e4626 -->
    <report test="$expression instance of element(EnumerationToken) and string-length($expression/@token) = 2" id="language_2-letter" role="Warning">language="<value-of select="." />" uses a 2-letter code.  A 2-letter code in conformance with ISO639 will be converted to the corresponding 3-letter ISO639-2 terminology code.</report>
    <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('mul', 'none')" id="language_und" role="Warning">language="<value-of select="." />" will be converted to 'und'.</report>
  </rule>

  <rule context="fo:*/@master-name">
    <!-- http://www.w3.org/TR/xsl11/#master-name -->
    <assert test="count(key('master-name', .)) = 1" role="Warning">master-name="<value-of select="."/>" should be unique.</assert>
  </rule>

  <rule context="fo:*/@master-reference">
    <!-- http://www.w3.org/TR/xsl11/#master-reference -->
    <assert test="exists(key('master-name', .))" role="Warning">master-reference="<value-of select="."/>" should refer to a master-name that exists within the document.</assert>
  </rule>

  <rule context="fo:*/@region-name">
    <!-- http://www.w3.org/TR/xsl11/#region-name -->
    <assert test="count(distinct-values(for $fo in key('region-name', .) return local-name($fo))) = 1" role="Warning">region-name="<value-of select="."/>" should only be used with regions of the same class.</assert>
  </rule>

</pattern>
