<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015-2019 Antenna House, Inc.

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
<pattern id="fo-fo"
	 xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document">

  <!-- FOs -->

  <rule context="fo:basic-link | fo:bookmark">
    <!-- https://www.w3.org/TR/xsl/#fo_basic-link -->
    <!-- https://www.w3.org/TR/xsl11/#fo_bookmark -->
    <report test="exists(@internal-destination) and exists(@external-destination)" role="Warning">An '<value-of select="name()" />' should not have both 'internal-destination' and 'external-destination' properties.  The FO processor may report an error or may use 'internal-destination'.</report>
  </rule>

  <rule context="fo:change-bar-begin">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-begin -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = following::fo:change-bar-end/@change-bar-class)" role="Warning">An '<value-of select="name()" />' that does not form a matching pair with an 'fo:change-bar-end' will assume a matching 'change-bar-end' at the end of the document.</report>
  </rule>

  <rule context="fo:change-bar-end">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-end -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = preceding::fo:change-bar-begin/@change-bar-class)" role="Warning">An '<value-of select="name()" />' that does not form a matching pair with an 'fo:change-bar-begin' will be ignored.</report>
  </rule>

  <rule context="fo:float">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="exists(ancestor::fo:float) or exists(ancestor::fo:footnote)">An '<value-of select="name()" />' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
  </rule>

  <rule context="fo:footnote">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">An '<value-of select="name()" />' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
    <!-- https://www.w3.org/TR/xsl/#fo_footnote -->
    <!--
    <assert
	test="ancestor::fo:flow/@flow-name eq 'xsl-region-body' or
	      (not(ancestor::fo:flow/@flow-name = ('xsl-region-after', 'xsl-region-before', 'xsl-region-end', 'xsl-region-start')) and
	       ancestor::fo:flow/@flow-name eq /fo:root/fo:layout-master-set/fo:simple-page-master[@master-name eq current()/ancestor::fo:page-sequence/@master-reference]/fo:region-body/@region-name)">An 'fo:footnote' must be a descendant of a flow that is assigned to one or more region-body regions.</assert>
    -->
    <report test="exists(ancestor::fo:block-container[@absolute-position = ('absolute', 'fixed')])" role="Warning">An 'fo:footnote' that is a descendant of an 'fo:block-container' that generates an absolutely positioned area will be placed as normal block-level areas.</report>
    <report test="exists(descendant::fo:block-container[@absolute-position = ('absolute', 'fixed')])">An 'fo:footnote' is not permitted to have as a descendant an 'fo:block-container' that generates an absolutely positioned area.</report>
    <report test="exists(descendant::fo:*[local-name() = ('float', 'footnote', 'marker')])">An 'fo:footnote' is not permitted to have an 'fo:float', 'fo:footnote', or 'fo:marker' as a descendant.</report>
  </rule>

  <rule context="fo:list-block">
    <assert test="exists((., ancestor::*)/@provisional-distance-between-starts)" role="Warning" sqf:fix="list-block-pdbs-fix">fo:list-block with no 'provisional-distance-between-starts' and no inherited value will use 24pt.</assert>
    <sqf:fix id="list-block-pdbs-fix">
      <sqf:description>
        <sqf:title>Add 'provisional-distance-between-starts'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="provisional-distance-between-starts" />
    </sqf:fix>
    <assert test="exists((., ancestor::*)/@provisional-label-separation)" role="Warning" sqf:fix="list-block-pls-fix">fo:list-block with no 'provisional-label-separation' and no inherited value will use 6pt.</assert>
    <sqf:fix id="list-block-pls-fix">
      <sqf:description>
        <sqf:title>Add 'provisional-label-separation'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="provisional-label-separation" />
    </sqf:fix>
  </rule>

  <rule context="fo:list-item-body[empty(@start-indent)]">
    <report test="true()" id="list-item-body-start-indent" role="Warning" sqf:fix="list-item-body-start-indent-fix">fo:list-item-body with no 'start-indent' will use inherited 'start-indent' value.</report>
    <sqf:fix id="list-item-body-start-indent-fix">
      <sqf:description>
        <sqf:title>Add 'start-indent="body-start()"'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="start-indent" select="'body-start()'"/>
    </sqf:fix>
  </rule>

  <rule context="fo:list-item-label[empty(@end-indent)]">
    <report test="true()" id="list-item-label-end-indent" role="Warning" sqf:fix="list-item-label-end-indent-fix">fo:list-item-label with no 'end-indent' will use inherited 'end-indent' value.</report>
    <sqf:fix id="list-item-label-end-indent-fix">
      <sqf:description>
        <sqf:title>Add 'end-indent="label-end()"'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="end-indent" select="'label-end()'"/>
    </sqf:fix>
  </rule>

  <rule context="fo:marker">
    <!-- https://www.w3.org/TR/xsl/#fo_marker -->
    <assert test="exists(ancestor::fo:flow)">An fo:marker is only permitted as the descendant of an fo:flow.</assert>
    <assert test="empty(ancestor::fo:marker)">An fo:marker is not permitted as a descendant of an fo:marker.</assert>
    <assert test="empty(ancestor::fo:retrieve-marker)">An fo:marker is not permitted as a descendant of an fo:retrieve-marker.</assert>
    <assert test="empty(ancestor::fo:retrieve-table-marker)">An fo:marker is not permitted as a descendant of an fo:retrieve-table-marker.</assert>
  </rule>

  <rule context="fo:retrieve-marker">
    <!-- https://www.w3.org/TR/xsl/#fo_retrieve-marker -->
    <assert test="exists(ancestor::fo:static-content)">An fo:retrieve-marker is only permitted as the descendant of an fo:static-content.</assert>
  </rule>

  <rule context="fo:retrieve-table-marker">
    <!-- https://www.w3.org/TR/xsl/#fo_retrieve-table-marker -->
    <assert test="exists(ancestor::fo:table-header) or
                  exists(ancestor::fo:table-footer) or
                  (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>

  <rule context="fo:root">
    <!-- https://www.w3.org/TR/xsl/#fo_root -->
    <assert id="fo_root-001"
	    test="exists(descendant::fo:page-sequence)">There must be at least one fo:page-sequence descendant of fo:root.</assert>
  </rule>

  <rule context="fo:table-cell">
    <report test="empty(*) and normalize-space() ne ''" role="Warning" sqf:fix="table-cell-empty-fix">fo:table-cell should contain block-level FOs.</report>
    <sqf:fix id="table-cell-empty-fix">
      <let name="text" value="." />
      <sqf:description>
        <sqf:title>Add 'fo:block' around text</sqf:title>
      </sqf:description>
      <sqf:delete match="node()" />
      <sqf:add node-type="element" target="fo:block">
	<value-of select="." />
      </sqf:add>
    </sqf:fix>
  </rule>

  <!-- Properties -->

  <rule context="fo:*/@character | fo:*/@grouping-separator">
    <assert test="string-length(.) = 1" id="character_grouping-separator"><value-of select="name()" />="<value-of select="."/>" should be a single character.</assert>
  </rule>

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and
                  (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or
                   $expression/@is-zero = 'yes' or
                   exists($expression/@value) and not($expression/@value castable as xs:integer))" id="column-count" role="Warning" sqf:fix="column-count-fix"><value-of select="name()"/>="<value-of select="."/>" should be a positive integer.  A non-positive or non-integer value will be rounded to the nearest integer value greater than or equal to 1.</report>
    <sqf:fix id="column-count-fix">
      <sqf:description>
        <sqf:title>Change the @column-count value</sqf:title>
      </sqf:description>
      <sqf:replace node-type="attribute" target="column-count" select="max((1, round(.)))"/>
    </sqf:fix>
  </rule>

  <rule context="fo:*/@column-width[exists(../@number-columns-spanned)]">
    <let name="number-columns-spanned"
	 value="ahf:parser-runner(../@number-columns-spanned)"/>
    <report test="local-name($number-columns-spanned) = 'Number' and
                  (exists($number-columns-spanned/@value) and
		   number($number-columns-spanned/@value) >= 1.5)" id="column-width" role="Warning"><value-of select="name()" /> is ignored with 'number-columns-spanned' is present and has a value greater than 1.</report>
  </rule>

  <rule context="fo:*/@flow-map-reference">
    <!-- https://www.w3.org/TR/xsl11/#flow-map-reference -->
    <report test="empty(/fo:root/fo:layout-master-set/fo:flow-map/@flow-map-name[. eq current()])">flow-map-reference="<value-of select="."/>" does not match any fo:flow-map name.</report>
  </rule>

  <rule context="fo:*/@flow-name">
    <!-- https://www.w3.org/TR/xsl11/#flow-name -->
    <assert test="count(../../*/@flow-name[. eq current()]) = 1">flow-name="<value-of select="."/>" must be unique within its fo:page-sequence.</assert>
    <report
	test="not(. = ('xsl-region-body',
		       'xsl-region-start',
		       'xsl-region-end',
		       'xsl-region-before',
		       'xsl-region-after',
		       'xsl-footnote-separator',
		       'xsl-before-float-separator')) and
              empty(key('region-name', .)) and
              empty(/fo:root/fo:layout-master-set/fo:flow-map[@flow-map-name = current()/ancestor::fo:page-sequence[1]/@flow-map-reference]/fo:flow-assignment/fo:flow-source-list/fo:flow-name-specifier/@flow-name-reference[. eq current()])" role="Warning">flow-name="<value-of select="."/>" does not match any named or reserved region-name or a flow-name-reference.</report>
  </rule>

  <rule context="fo:*/@flow-name-reference">
    <!-- https://www.w3.org/TR/xsl11/#flow-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]) = 1">flow-name-reference="<value-of select="., ancestor::fo-flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]"/>" must be unique within its fo:flow-map.</assert>
    <!-- https://www.w3.org/TR/xsl11/#fo_flow-source-list -->
    <!-- These flows must be either all fo:flow formatting objects or
         all fo:static-content formatting objects. -->
    <assert test="count(distinct-values(for $fo in key('flow-name', .)[ancestor::fo:page-sequence/@flow-map-reference = current()/ancestor::fo:flow-map/@flow-map-name] return local-name($fo))) = 1" role="Warning">flow-name-reference="<value-of select="."/>" should only be used with all fo:flow or all fo:static-content.</assert>
  </rule>

  <rule context="fo:*/@hyphenation-character">
    <assert test="string-length(.) = 1 or . eq 'inherit'" id="hyphenation-character"><value-of select="name()" />="<value-of select="."/>" should be a single character or 'inherit'.</assert>
  </rule>

  <rule context="fo:*/@language">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <!-- What would be generated if we could... -->
    <!-- https://www.w3.org/TR/xsl11/#language -->
    <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">language="<value-of select="."/>" should be an EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit') or string-length($expression/@token) = 2 or string-length($expression/@token) = 3)">language="<value-of select="."/>" should be a 3-letter code conforming to a ISO639-2 terminology or bibliographic code or a 2-letter code conforming to a ISO639 2-letter code or 'none' or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: 'language="<value-of select="."/>"'</report>
    <!-- https://www.w3.org/TR/xsl11/#d0e4626 -->
    <!-- Warnings aren't needed (#21) -->
    <!--
    <report test="$expression instance of element(EnumerationToken) and string-length($expression/@token) = 2" id="language_2-letter" role="Warning">language="<value-of select="." />" uses a 2-letter code.  A 2-letter code in conformance with ISO639 will be converted to the corresponding 3-letter ISO639-2 terminology code.</report>
    <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('mul', 'none')" id="language_und" role="Warning">language="<value-of select="." />" will be converted to 'und'.</report>
    -->
  </rule>

  <rule context="fo:marker/@marker-class-name">
    <!-- https://www.w3.org/TR/xsl/#fo_marker -->
    <!-- Error in XSL 1.1 spec, but AH Formatter not complaining. -->
    <assert test="count(../../fo:marker[@marker-class-name eq current()]) = 1" role="Warning">marker-class-name="<value-of select="." />" should be unique among fo:marker with the same parent.</assert>
  </rule>

  <rule context="fo:*/@master-name">
    <!-- https://www.w3.org/TR/xsl11/#master-name -->
    <assert test="count(key('master-name', .)) = 1" role="Warning">master-name="<value-of select="."/>" should be unique.</assert>
  </rule>

  <rule context="fo:*/@master-reference">
    <!-- https://www.w3.org/TR/xsl11/#master-reference -->
    <assert test="exists(key('master-name', .))" role="Warning">master-reference="<value-of select="."/>" should refer to a master-name that exists within the document.</assert>
    <report test="count(key('master-name', .)) > 1" role="Warning">master-reference="<value-of select="."/>" refers to multiple master-name within the document.</report>
  </rule>

  <rule context="fo:*/@overflow">
    <!-- https://www.w3.org/TR/xsl11/#overflow -->
    <report test=". eq 'repeat' and ../@absolute-position = ('absolute', 'fixed')" role="Warning">overflow="<value-of select="."/>" on an absolutely-positioned area will be treated as 'auto'.</report>
  </rule>

  <rule context="fo:index-key-reference/@ref-index-key">
    <!-- https://www.w3.org/TR/xsl11/#ref-index-key -->
    <let name="index-key-reference" value="." />
    <report
	test="empty(key('index-key', .))" role="Warning">ref-index-key="<value-of select="."/>" does not match any index-key values.</report>
    <report
	test="exists(key('index-key', .)) and (some $index-hit in key('index-key', .) satisfies $index-hit >> $index-key-reference)" role="Warning">ref-index-key="<value-of select="."/>" occurs before a matching index-key value.</report>
  </rule>

  <rule context="fo:*/@region-name">
    <!-- https://www.w3.org/TR/xsl11/#region-name -->
    <assert test="count(distinct-values(for $fo in key('region-name', .) return local-name($fo))) = 1" role="Warning">region-name="<value-of select="."/>" should only be used with regions of the same class.</assert>
    <assert test="not(. eq 'xsl-region-body') or local-name(..) eq 'region-body'">region-name="<value-of select="."/>" should only be used with fo:region-body.</assert>
    <assert test="not(. eq 'xsl-region-start') or local-name(..) eq 'region-start'">region-name="<value-of select="."/>" should only be used with fo:region-start.</assert>
    <assert test="not(. eq 'xsl-region-end') or local-name(..) eq 'region-end'">region-name="<value-of select="."/>" should only be used with fo:region-end.</assert>
    <assert test="not(. eq 'xsl-region-before') or local-name(..) eq 'region-before'">region-name="<value-of select="."/>" should only be used with fo:region-before.</assert>
    <assert test="not(. eq 'xsl-region-after') or local-name(..) eq 'region-after'">region-name="<value-of select="."/>" should only be used with fo:region-after.</assert>
  </rule>

  <rule context="fo:*/@region-name-reference">
    <!-- https://www.w3.org/TR/xsl11/#region-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:region-name-specifier/@region-name-reference[. eq current()]) = 1">region-name-reference="<value-of select="."/>" must be unique within its fo:flow-map.</assert>
  </rule>

   <!-- retrieve-class-name -->
   <rule context="fo:*/@retrieve-class-name">
      <assert test="exists(key('marker-class-name', .))" role="Warning"><value-of select="local-name()" />="<value-of select="."/>" does not refer to an existing fo:marker.</assert>
   </rule>

  <rule context="fo:*/@span">
    <!-- https://www.w3.org/TR/xsl11/#span -->
    <report test="exists(ancestor::fo:static-content)" sqf:fix="span_fix" role="warning">@span has effect only on areas returned by an fo:flow.</report>
    <sqf:fix id="span_fix">
      <sqf:description>
        <sqf:title>Delete @span</sqf:title>
      </sqf:description>
      <sqf:delete />
    </sqf:fix>
  </rule>

</pattern>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
