<?xml version="1.0" encoding="UTF-8"?><!--
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
--><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <xsl:key name="flow-name" match="fo:flow | fo:static-content" use="@flow-name"/>
    <xsl:key name="index-key" match="*[exists(@index-key)]" use="@index-key"/>
    <xsl:key name="marker-class-name" match="fo:marker" use="@marker-class-name"/>
    <xsl:key name="master-name" match="fo:simple-page-master | fo:page-sequence-master |       axf:spread-page-master" use="@master-name"/>
    <xsl:key name="region-name" match="fo:region-before | fo:region-after |       fo:region-start | fo:region-end |       fo:region-body | axf:spread-region" use="@region-name"/>

    <?DSDL_INCLUDE_START abstract.sch?><pattern id="abstract">

  <!-- <color> | inherit -->
  <rule abstract="true" id="color">
    <let name="context" value="."/>
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>="<value-of select="."/>" should be Color or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))"><value-of select="name()"/>="<value-of select="."/>" token should be 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>="" should be Color, or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()"/>="<value-of select="."/>"</report>
  </rule>

  <!-- <color> | transparent | inherit -->
  <rule abstract="true" id="color-transparent">
    <let name="context" value="."/>
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()"/>="<value-of select="."/>" token should be 'transparent' or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>="" should be Color, 'transparent', or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()"/>="<value-of select="."/>"</report>
    <!-- <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('fuschia', 'fucshia')" sqf:fix="color-fuchsia-fix"><value-of select="name()" />="<value-of select="."/>" should be 'fuchsia'.</report> -->
    <!-- <sqf:fix id="color-fuchsia-fix"> -->
    <!--     <sqf:param name="context" abstract="true" /> -->
    <!--     <sqf:description> -->
    <!--         <sqf:title>Change @<!-\- <value-of select="name($context)" /> -\-> to 'fuchsia'</sqf:title> -->
    <!-- 	</sqf:description> -->
    <!-- 	<sqf:replace node-type="attribute" target="color" select="'fuchsia'"/> -->
    <!-- </sqf:fix> -->
  </rule>

  <!-- <color> | transparent | inherit -->
  <!-- <rule abstract="true" id="color-transparent2"> -->
  <!--   <let name="expression" value="ahf:parser-runner(.)"/> -->
  <!--   <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()" />="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert> -->
  <!--   <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'transparent' or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report> -->
  <!--   <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be Color, 'transparent', or 'inherit'.</report> -->
  <!--   <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report> -->
  <!--   <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('fuschia', 'fucshia')" sqf:fix="color-fuchsia-fix"><value-of select="name()" />="<value-of select="."/>" should be 'fuchsia'.</report> -->
  <!--   <sqf:fix id="color-fuchsia-fix"> -->
  <!--       <sqf:param name="context" abstract="true" /> -->
  <!--       <sqf:description> -->
  <!--           <sqf:title>Change @<!-\- <value-of select="name($context)" /> -\-> to 'fuchsia'</sqf:title> -->
  <!-- 	</sqf:description> -->
  <!-- 	<sqf:replace node-type="attribute" target="color" select="'fuchsia'"/> -->
  <!--   </sqf:fix> -->
  <!-- </rule> -->

  <!-- border-style -->
  <!-- <border-style> | inherit -->
  <!-- http://www.w3.org/TR/xsl11/#border-top-style -->
  <rule abstract="true" id="border-style">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>="<value-of select="."/>" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', 'inherit'))"><value-of select="name()"/>="<value-of select="."/>" token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>="" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()"/>="<value-of select="."/>"</report>
  </rule>

   <!-- border-width -->
   <!-- <border-width> | inherit -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width" /> -->
   <rule abstract="true" id="border-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="name()"/>="<value-of select="."/>" should be 'thin', 'medium', 'thick', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))"><value-of select="name()"/>="<value-of select="."/>" token should be 'thin', 'medium', 'thick', or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>="" should be 'thin', 'medium', 'thick', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()"/>="<value-of select="."/>"</report>
   </rule>

</pattern><?DSDL_INCLUDE_END abstract.sch?>
    <?DSDL_INCLUDE_START fo-fo.sch?><pattern xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document" id="fo-fo">

  <!-- FOs -->

  <rule context="fo:basic-link | fo:bookmark">
    <!-- https://www.w3.org/TR/xsl/#fo_basic-link -->
    <!-- https://www.w3.org/TR/xsl11/#fo_bookmark -->
    <assert test="exists(@internal-destination | @external-destination)" role="Warning">An '<value-of select="name()"/>' should have an 'internal-destination' or 'external-destination' property.</assert>
    <report test="exists(@internal-destination) and exists(@external-destination)" role="Warning">An '<value-of select="name()"/>' should not have both 'internal-destination' and 'external-destination' properties.  The FO processor may report an error or may use 'internal-destination'.</report>
  </rule>

  <rule context="fo:change-bar-begin">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-begin -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = following::fo:change-bar-end/@change-bar-class)" role="Warning">An '<value-of select="name()"/>' that does not form a matching pair with an 'fo:change-bar-end' will assume a matching 'change-bar-end' at the end of the document.</report>
  </rule>

  <rule context="fo:change-bar-end">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-end -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = preceding::fo:change-bar-begin/@change-bar-class)" role="Warning">An '<value-of select="name()"/>' that does not form a matching pair with an 'fo:change-bar-begin' will be ignored.</report>
  </rule>

  <rule context="fo:float">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="exists(ancestor::fo:float) or exists(ancestor::fo:footnote)">An '<value-of select="name()"/>' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
  </rule>

  <rule context="fo:footnote">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">An '<value-of select="name()"/>' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
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
      <sqf:add node-type="attribute" target="provisional-distance-between-starts"/>
    </sqf:fix>
    <assert test="exists((., ancestor::*)/@provisional-label-separation)" role="Warning" sqf:fix="list-block-pls-fix">fo:list-block with no 'provisional-label-separation' and no inherited value will use 6pt.</assert>
    <sqf:fix id="list-block-pls-fix">
      <sqf:description>
        <sqf:title>Add 'provisional-label-separation'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="provisional-label-separation"/>
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
    <assert test="exists(ancestor::fo:table-header) or                   exists(ancestor::fo:table-footer) or                   (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>

  <rule context="fo:root">
    <!-- https://www.w3.org/TR/xsl/#fo_root -->
    <assert id="fo_root-001" test="exists(descendant::fo:page-sequence)">There must be at least one fo:page-sequence descendant of fo:root.</assert>
  </rule>

  <rule context="fo:table-cell">
    <report test="empty(*) and normalize-space() ne ''" role="Warning" sqf:fix="table-cell-empty-fix">fo:table-cell should contain block-level FOs.</report>
    <sqf:fix id="table-cell-empty-fix">
      <let name="text" value="."/>
      <sqf:description>
        <sqf:title>Add 'fo:block' around text</sqf:title>
      </sqf:description>
      <sqf:delete match="node()"/>
      <sqf:add node-type="element" target="fo:block">
	<value-of select="."/>
      </sqf:add>
    </sqf:fix>
  </rule>

  <!-- Properties -->

  <rule context="fo:*/@character | fo:*/@grouping-separator">
    <assert test="string-length(.) = 1" id="character_grouping-separator"><value-of select="name()"/>="<value-of select="."/>" should be a single character.</assert>
  </rule>

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and                   (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or                    $expression/@is-zero = 'yes' or                    exists($expression/@value) and not($expression/@value castable as xs:integer))" id="column-count" role="Warning" sqf:fix="column-count-fix"><value-of select="name()"/>="<value-of select="."/>" should be a positive integer.  A non-positive or non-integer value will be rounded to the nearest integer value greater than or equal to 1.</report>
    <sqf:fix id="column-count-fix">
      <sqf:description>
        <sqf:title>Change the @column-count value</sqf:title>
      </sqf:description>
      <sqf:replace node-type="attribute" target="column-count" select="max((1, round(.)))"/>
    </sqf:fix>
  </rule>

  <rule context="fo:*/@column-width[exists(../@number-columns-spanned)]">
    <let name="number-columns-spanned" value="ahf:parser-runner(../@number-columns-spanned)"/>
    <report test="local-name($number-columns-spanned) = 'Number' and                   (exists($number-columns-spanned/@value) and      number($number-columns-spanned/@value) &gt;= 1.5)" id="column-width" role="Warning"><value-of select="name()"/> is ignored with 'number-columns-spanned' is present and has a value greater than 1.</report>
  </rule>

  <rule context="fo:*/@flow-map-reference">
    <!-- https://www.w3.org/TR/xsl11/#flow-map-reference -->
    <report test="empty(/fo:root/fo:layout-master-set/fo:flow-map/@flow-map-name[. eq current()])">flow-map-reference="<value-of select="."/>" does not match any fo:flow-map name.</report>
  </rule>

  <rule context="fo:*/@flow-name">
    <!-- https://www.w3.org/TR/xsl11/#flow-name -->
    <assert test="count(../../*/@flow-name[. eq current()]) = 1">flow-name="<value-of select="."/>" must be unique within its fo:page-sequence.</assert>
    <report test="not(. = ('xsl-region-body',          'xsl-region-start',          'xsl-region-end',          'xsl-region-before',          'xsl-region-after',          'xsl-footnote-separator',          'xsl-before-float-separator')) and               empty(key('region-name', .)) and               empty(/fo:root/fo:layout-master-set/fo:flow-map[@flow-map-name = current()/ancestor::fo:page-sequence[1]/@flow-map-reference]/fo:flow-assignment/fo:flow-source-list/fo:flow-name-specifier/@flow-name-reference[. eq current()])" role="Warning">flow-name="<value-of select="."/>" does not match any named or reserved region-name or a flow-name-reference.</report>
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
    <assert test="string-length(.) = 1 or . eq 'inherit'" id="hyphenation-character"><value-of select="name()"/>="<value-of select="."/>" should be a single character or 'inherit'.</assert>
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
    <!-- Error in XSL 1.1 spec, but Antenna House Formatter not
         complaining. -->
    <assert test="count(../../fo:marker[@marker-class-name eq current()]) = 1" role="Warning">marker-class-name="<value-of select="."/>" should be unique among fo:marker with the same parent.</assert>
  </rule>

  <rule context="fo:*/@master-name">
    <!-- https://www.w3.org/TR/xsl11/#master-name -->
    <assert test="count(key('master-name', .)) = 1" role="Warning">master-name="<value-of select="."/>" should be unique.</assert>
  </rule>

  <rule context="fo:*/@master-reference">
    <!-- https://www.w3.org/TR/xsl11/#master-reference -->
    <assert test="exists(key('master-name', .))" role="Warning">master-reference="<value-of select="."/>" should refer to a master-name that exists within the document.</assert>
    <report test="count(key('master-name', .)) &gt; 1" role="Warning">master-reference="<value-of select="."/>" refers to multiple master-name within the document.</report>
  </rule>

  <rule context="fo:*/@overflow">
    <!-- https://www.w3.org/TR/xsl11/#overflow -->
    <report test=". eq 'repeat' and ../@absolute-position = ('absolute', 'fixed')" role="Warning">overflow="<value-of select="."/>" on an absolutely-positioned area will be treated as 'auto'.</report>
  </rule>

  <rule context="fo:index-key-reference/@ref-index-key">
    <!-- https://www.w3.org/TR/xsl11/#ref-index-key -->
    <let name="index-key-reference" value="."/>
    <report test="empty(key('index-key', .))" role="Warning">ref-index-key="<value-of select="."/>" does not match any index-key values.</report>
    <report test="exists(key('index-key', .)) and (some $index-hit in key('index-key', .) satisfies $index-hit &gt;&gt; $index-key-reference)" role="Warning">ref-index-key="<value-of select="."/>" occurs before a matching index-key value.</report>
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
      <assert test="exists(key('marker-class-name', .))" role="Warning"><value-of select="local-name()"/>="<value-of select="."/>" does not refer to an existing fo:marker.</assert>
   </rule>

  <rule context="fo:*/@span">
    <!-- https://www.w3.org/TR/xsl11/#span -->
    <report test="exists(ancestor::fo:static-content)" sqf:fix="span_fix" role="warning">@span has effect only on areas returned by an fo:flow.</report>
    <sqf:fix id="span_fix">
      <sqf:description>
        <sqf:title>Delete @span</sqf:title>
      </sqf:description>
      <sqf:delete/>
    </sqf:fix>
  </rule>

</pattern><?DSDL_INCLUDE_END fo-fo.sch?>
    <?DSDL_INCLUDE_START fo-property.sch?><pattern xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" id="fo-property">
   <xsl:include href="file:/E:/Projects/oxygen/focheck-internal/focheck/xsl/parser-runner.xsl"/>

   <!-- absolute-position -->
   <!-- auto | absolute | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#absolute-position -->
   <rule context="fo:*/@absolute-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">absolute-position="<value-of select="."/>" should be 'auto', 'absolute', 'fixed', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'absolute', 'fixed', 'inherit'))">absolute-position="<value-of select="."/>". Allowed keywords are 'auto', 'absolute', 'fixed', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">absolute-position="" should be 'auto', 'absolute', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: absolute-position="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- active-state -->
   <!-- link | visited | active | hover | focus -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#active-state -->
   <rule context="fo:*/@active-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">active-state="<value-of select="."/>" should be 'link', 'visited', 'active', 'hover', or 'focus'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'visited', 'active', 'hover', 'focus'))">active-state="<value-of select="."/>". Allowed keywords are 'link', 'visited', 'active', 'hover', and 'focus'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">active-state="" should be 'link', 'visited', 'active', 'hover', or 'focus'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: active-state="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- alignment-adjust -->
   <!-- auto | baseline | before-edge | text-before-edge | middle | central | after-edge | text-after-edge | ideographic | alphabetic | hanging | mathematical | <percentage> | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#alignment-adjust -->
   <rule context="fo:*/@alignment-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">alignment-adjust="<value-of select="."/>" should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit', Percent, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">alignment-adjust="<value-of select="."/>". Allowed keywords are 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">alignment-adjust="" should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit', Percent, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: alignment-adjust="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- alignment-baseline -->
   <!-- auto | baseline | before-edge | text-before-edge | middle | central | after-edge | text-after-edge | ideographic | alphabetic | hanging | mathematical | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#alignment-baseline -->
   <rule context="fo:*/@alignment-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">alignment-baseline="<value-of select="."/>" should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">alignment-baseline="<value-of select="."/>". Allowed keywords are 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">alignment-baseline="" should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: alignment-baseline="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- allowed-height-scale -->
   <!-- [ any | <percentage> ]* | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#allowed-height-scale -->
   <rule context="fo:*/@allowed-height-scale">
      <report test=". eq ''" role="Warning">allowed-height-scale="" should be '[ any | &lt;percentage&gt; ]* | inherit'.</report>
   </rule>

   <!-- allowed-width-scale -->
   <!-- [ any | <percentage> ]* | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#allowed-width-scale -->
   <rule context="fo:*/@allowed-width-scale">
      <report test=". eq ''" role="Warning">allowed-width-scale="" should be '[ any | &lt;percentage&gt; ]* | inherit'.</report>
   </rule>

   <!-- auto-restore -->
   <!-- true | false -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#auto-restore -->
   <rule context="fo:*/@auto-restore">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">auto-restore="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">auto-restore="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">auto-restore="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: auto-restore="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- background -->
   <!-- [<background-color> || <background-image> || <background-repeat> || <background-attachment> || <background-position> ]] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#background -->
   <rule context="fo:*/@background">
      <report test=". eq ''" role="Warning">background="" should be '[&lt;background-color&gt; || &lt;background-image&gt; || &lt;background-repeat&gt; || &lt;background-attachment&gt; || &lt;background-position&gt; ]] | inherit'.</report>
   </rule>

   <!-- background-attachment -->
   <!-- scroll | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-attachment -->
   <rule context="fo:*/@background-attachment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-attachment="<value-of select="."/>" should be 'scroll', 'fixed', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('scroll', 'fixed', 'inherit'))">background-attachment="<value-of select="."/>". Allowed keywords are 'scroll', 'fixed', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-attachment="" should be 'scroll', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-attachment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- background-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-color -->
   <rule context="fo:*/@background-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))">background-color="<value-of select="."/>". Allowed keywords are 'transparent' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color, 'transparent', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- background-image -->
   <!-- <uri-specification> | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-image -->
   <rule context="fo:*/@background-image">
      <report test=". eq ''" role="Warning">background-image="" should be '&lt;uri-specification&gt; | none | inherit'.</report>
   </rule>

   <!-- background-position -->
   <!-- [ [<percentage> | <length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#background-position -->
   <rule context="fo:*/@background-position">
      <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
   </rule>

   <!-- background-position-horizontal -->
   <!-- <percentage> | <length> | left | center | right | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-position-horizontal -->
   <rule context="fo:*/@background-position-horizontal">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">background-position-horizontal="<value-of select="."/>" should be Percent, Length, 'left', 'center', 'right', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal="<value-of select="."/>". Allowed keywords are 'left', 'center', 'right', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal="" should be Percent, Length, 'left', 'center', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-horizontal="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- background-position-vertical -->
   <!-- <percentage> | <length> | top | center | bottom | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-position-vertical -->
   <rule context="fo:*/@background-position-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">background-position-vertical="<value-of select="."/>" should be Percent, Length, 'top', 'center', 'bottom', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical="<value-of select="."/>". Allowed keywords are 'top', 'center', 'bottom', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical="" should be Percent, Length, 'top', 'center', 'bottom', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-vertical="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- background-repeat -->
   <!-- repeat | repeat-x | repeat-y | no-repeat | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-repeat -->
   <rule context="fo:*/@background-repeat">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat="<value-of select="."/>". Allowed keywords are 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', and 'paginate'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- baseline-shift -->
   <!-- baseline | sub | super | <percentage> | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#baseline-shift -->
   <rule context="fo:*/@baseline-shift">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">baseline-shift="<value-of select="."/>" should be 'baseline', 'sub', 'super', 'inherit', Percent, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('baseline', 'sub', 'super', 'inherit'))">baseline-shift="<value-of select="."/>". Allowed keywords are 'baseline', 'sub', 'super', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">baseline-shift="" should be 'baseline', 'sub', 'super', 'inherit', Percent, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: baseline-shift="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- blank-or-not-blank -->
   <!-- blank | not-blank | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#blank-or-not-blank -->
   <rule context="fo:*/@blank-or-not-blank">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">blank-or-not-blank="<value-of select="."/>" should be 'blank', 'not-blank', 'any', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('blank', 'not-blank', 'any', 'inherit'))">blank-or-not-blank="<value-of select="."/>". Allowed keywords are 'blank', 'not-blank', 'any', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">blank-or-not-blank="" should be 'blank', 'not-blank', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: blank-or-not-blank="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- block-progression-dimension -->
   <!-- auto | <length> | <percentage> | <length-range> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#block-progression-dimension -->
   <rule context="fo:*/@block-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">block-progression-dimension="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">block-progression-dimension="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">block-progression-dimension="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: block-progression-dimension="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border -->
   <!-- [ <border-width> || <border-style> || [ <color> | transparent ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border -->
   <rule context="fo:*/@border">
      <report test=". eq ''" role="Warning">border="" should be '[ &lt;border-width&gt; || &lt;border-style&gt; || [ &lt;color&gt; | transparent ] ] | inherit'.</report>
   </rule>

   <!-- border-after-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-color -->
   <rule context="fo:*/@border-after-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-after-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-precedence -->
   <rule context="fo:*/@border-after-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-after-precedence="<value-of select="."/>" should be 'force', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-after-precedence="<value-of select="."/>". Allowed keywords are 'force' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-after-precedence="" should be 'force', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-after-precedence="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-after-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-style -->
   <rule context="fo:*/@border-after-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-after-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-width -->
   <rule context="fo:*/@border-after-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-before-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-color -->
   <rule context="fo:*/@border-before-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-before-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-precedence -->
   <rule context="fo:*/@border-before-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-before-precedence="<value-of select="."/>" should be 'force', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-before-precedence="<value-of select="."/>". Allowed keywords are 'force' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-before-precedence="" should be 'force', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-before-precedence="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-before-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-style -->
   <rule context="fo:*/@border-before-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-before-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-width -->
   <rule context="fo:*/@border-before-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-bottom -->
   <!-- [ <border-width> || <border-style> || [ <color> | transparent ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom -->
   <rule context="fo:*/@border-bottom">
      <report test=". eq ''" role="Warning">border-bottom="" should be '[ &lt;border-width&gt; || &lt;border-style&gt; || [ &lt;color&gt; | transparent ] ] | inherit'.</report>
   </rule>

   <!-- border-bottom-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom-color -->
   <rule context="fo:*/@border-bottom-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-bottom-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom-style -->
   <rule context="fo:*/@border-bottom-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-bottom-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom-width -->
   <rule context="fo:*/@border-bottom-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-collapse -->
   <!-- collapse | collapse-with-precedence | separate | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-collapse -->
   <rule context="fo:*/@border-collapse">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-collapse="<value-of select="."/>" should be 'collapse', 'collapse-with-precedence', 'separate', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('collapse', 'collapse-with-precedence', 'separate', 'inherit'))">border-collapse="<value-of select="."/>". Allowed keywords are 'collapse', 'collapse-with-precedence', 'separate', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-collapse="" should be 'collapse', 'collapse-with-precedence', 'separate', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-collapse="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-color -->
   <!-- [ <color> | transparent ]{1,4} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-color -->
   <rule context="fo:*/@border-color">
      <report test=". eq ''" role="Warning">border-color="" should be '[ &lt;color&gt; | transparent ]{1,4} | inherit'.</report>
   </rule>

   <!-- border-end-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-color -->
   <rule context="fo:*/@border-end-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-end-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-precedence -->
   <rule context="fo:*/@border-end-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-end-precedence="<value-of select="."/>" should be 'force', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-end-precedence="<value-of select="."/>". Allowed keywords are 'force' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-end-precedence="" should be 'force', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-end-precedence="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-end-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-style -->
   <rule context="fo:*/@border-end-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-end-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-width -->
   <rule context="fo:*/@border-end-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-left -->
   <!-- [ <border-width> || <border-style> || [ <color> | transparent ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-left -->
   <rule context="fo:*/@border-left">
      <report test=". eq ''" role="Warning">border-left="" should be '[ &lt;border-width&gt; || &lt;border-style&gt; || [ &lt;color&gt; | transparent ] ] | inherit'.</report>
   </rule>

   <!-- border-left-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-left-color -->
   <rule context="fo:*/@border-left-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-left-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-left-style -->
   <rule context="fo:*/@border-left-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-left-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-left-width -->
   <rule context="fo:*/@border-left-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-right -->
   <!-- [ <border-width> || <border-style> || [ <color> | transparent ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-right -->
   <rule context="fo:*/@border-right">
      <report test=". eq ''" role="Warning">border-right="" should be '[ &lt;border-width&gt; || &lt;border-style&gt; || [ &lt;color&gt; | transparent ] ] | inherit'.</report>
   </rule>

   <!-- border-right-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-right-color -->
   <rule context="fo:*/@border-right-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-right-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-right-style -->
   <rule context="fo:*/@border-right-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-right-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-right-width -->
   <rule context="fo:*/@border-right-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-separation -->
   <!-- <length-bp-ip-direction> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-separation -->
   <rule context="fo:*/@border-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">border-separation="<value-of select="."/>" should be Length or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">border-separation="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-separation="" should be Length or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-separation="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-spacing -->
   <!-- <length> <length>? | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-spacing -->
   <rule context="fo:*/@border-spacing">
      <report test=". eq ''" role="Warning">border-spacing="" should be '&lt;length&gt; &lt;length&gt;? | inherit'.</report>
   </rule>

   <!-- border-start-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-color -->
   <rule context="fo:*/@border-start-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-start-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-precedence -->
   <rule context="fo:*/@border-start-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-start-precedence="<value-of select="."/>" should be 'force', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-start-precedence="<value-of select="."/>". Allowed keywords are 'force' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-start-precedence="" should be 'force', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-start-precedence="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- border-start-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-style -->
   <rule context="fo:*/@border-start-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-start-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-width -->
   <rule context="fo:*/@border-start-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-style -->
   <!-- <border-style>{1,4} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-style -->
   <rule context="fo:*/@border-style">
      <report test=". eq ''" role="Warning">border-style="" should be '&lt;border-style&gt;{1,4} | inherit'.</report>
   </rule>

   <!-- border-top -->
   <!-- [ <border-width> || <border-style> || [ <color> | transparent ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-top -->
   <rule context="fo:*/@border-top">
      <report test=". eq ''" role="Warning">border-top="" should be '[ &lt;border-width&gt; || &lt;border-style&gt; || [ &lt;color&gt; | transparent ] ] | inherit'.</report>
   </rule>

   <!-- border-top-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-color -->
   <rule context="fo:*/@border-top-color">
      <extends rule="color-transparent"/>
   </rule>

   <!-- border-top-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-style -->
   <rule context="fo:*/@border-top-style">
      <extends rule="border-style"/>
   </rule>

   <!-- border-top-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width -->
   <rule context="fo:*/@border-top-width">
      <extends rule="border-width"/>
   </rule>

   <!-- border-width -->
   <!-- <border-width>{1,4} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#border-width -->
   <rule context="fo:*/@border-width">
      <report test=". eq ''" role="Warning">border-width="" should be '&lt;border-width&gt;{1,4} | inherit'.</report>
   </rule>

   <!-- bottom -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#bottom -->
   <rule context="fo:*/@bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">bottom="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">bottom="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">bottom="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: bottom="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- break-after -->
   <!-- auto | column | page | even-page | odd-page | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#break-after -->
   <rule context="fo:*/@break-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">break-after="<value-of select="."/>" should be 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', or 'odd-document'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', 'odd-document'))">break-after="<value-of select="."/>". Allowed keywords are 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', and 'odd-document'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">break-after="" should be 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', or 'odd-document'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: break-after="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- break-before -->
   <!-- auto | column | page | even-page | odd-page | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#break-before -->
   <rule context="fo:*/@break-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">break-before="<value-of select="."/>" should be 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', or 'odd-document'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', 'odd-document'))">break-before="<value-of select="."/>". Allowed keywords are 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', and 'odd-document'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">break-before="" should be 'auto', 'column', 'page', 'even-page', 'odd-page', 'even-document', or 'odd-document'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: break-before="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- caption-side -->
   <!-- before | after | start | end | top | bottom | left | right | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#caption-side -->
   <rule context="fo:*/@caption-side">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">caption-side="<value-of select="."/>" should be 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', 'inherit'))">caption-side="<value-of select="."/>". Allowed keywords are 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">caption-side="" should be 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: caption-side="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- case-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#case-name -->
   <rule context="fo:*/@case-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">case-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">case-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: case-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- case-title -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#case-title -->
   <rule context="fo:*/@case-title">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">case-title="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">case-title="" should be Literal or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: case-title="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-class -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-class -->
   <rule context="fo:*/@change-bar-class">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-class="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-class="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-class="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-color -->
   <!-- <color> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-color -->
   <rule context="fo:*/@change-bar-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EMPTY', 'ERROR', 'Object')">change-bar-color="<value-of select="."/>" should be Color.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-color="" should be Color.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-color="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-offset -->
   <!-- <length> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-offset -->
   <rule context="fo:*/@change-bar-offset">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">change-bar-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-offset="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-offset="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-placement -->
   <!-- start | end | left | right | inside | outside | alternate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-placement -->
   <rule context="fo:*/@change-bar-placement">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-placement="<value-of select="."/>" should be 'start', 'end', 'left', 'right', 'inside', 'outside', or 'alternate'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'alternate'))">change-bar-placement="<value-of select="."/>". Allowed keywords are 'start', 'end', 'left', 'right', 'inside', 'outside', and 'alternate'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-placement="" should be 'start', 'end', 'left', 'right', 'inside', 'outside', or 'alternate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-placement="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-style -->
   <!-- <border-style> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-style -->
   <rule context="fo:*/@change-bar-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-style="<value-of select="."/>" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', or 'outset'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset'))">change-bar-style="<value-of select="."/>". Allowed keywords are 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', and 'outset'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-style="" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', or 'outset'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-style="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- change-bar-width -->
   <!-- <border-width> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-width -->
   <rule context="fo:*/@change-bar-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">change-bar-width="<value-of select="."/>" should be 'thin', 'medium', 'thick', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick'))">change-bar-width="<value-of select="."/>". Allowed keywords are 'thin', 'medium', and 'thick'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-width="" should be 'thin', 'medium', 'thick', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- character -->
   <!-- <character> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#character -->
   <rule context="fo:*/@character">
      <report test=". eq ''" role="Warning">character="" should be '&lt;character&gt;'.</report>
   </rule>

   <!-- clear -->
   <!-- start | end | left | right | inside | outside | both | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#clear -->
   <rule context="fo:*/@clear">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">clear="<value-of select="."/>" should be 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', 'inherit'))">clear="<value-of select="."/>". Allowed keywords are 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">clear="" should be 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: clear="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- clip -->
   <!-- <shape> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#clip -->
   <rule context="fo:*/@clip">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Function', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">clip="<value-of select="."/>" should be Function, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">clip="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">clip="" should be Function, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: clip="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- color -->
   <!-- <color> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color -->
   <rule context="fo:*/@color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">color="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))">color="<value-of select="."/>". Allowed keywords are 'transparent' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">color="" should be Color, 'transparent', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: color="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- color-profile-name -->
   <!-- <name> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color-profile-name -->
   <rule context="fo:*/@color-profile-name">
      <report test=". eq ''" role="Warning">color-profile-name="" should be '&lt;name&gt; | inherit'.</report>
   </rule>

   <!-- column-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-count -->
   <rule context="fo:*/@column-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">column-count="<value-of select="."/>" should be Number or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">column-count="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-count="" should be Number or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-count="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- column-gap -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-gap -->
   <rule context="fo:*/@column-gap">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">column-gap="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">column-gap="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-gap="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-gap="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- column-number -->
   <!-- <number> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-number -->
   <rule context="fo:*/@column-number">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EMPTY', 'ERROR', 'Object')">column-number="<value-of select="."/>" should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-number="" should be Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-number="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- column-width -->
   <!-- <length> | <percentage> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-width -->
   <rule context="fo:*/@column-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">column-width="<value-of select="."/>" should be Length or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-width="" should be Length or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- content-height -->
   <!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-height -->
   <rule context="fo:*/@content-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">content-height="<value-of select="."/>" should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height="<value-of select="."/>". Allowed keywords are 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height="" should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: content-height="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- content-type -->
   <!-- <string> | auto -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-type -->
   <rule context="fo:*/@content-type">
      <report test=". eq ''" role="Warning">content-type="" should be '&lt;string&gt; | auto'.</report>
   </rule>

   <!-- content-width -->
   <!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-width -->
   <rule context="fo:*/@content-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">content-width="<value-of select="."/>" should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width="<value-of select="."/>". Allowed keywords are 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width="" should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: content-width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- country -->
   <!-- none | <country> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#country -->
   <rule context="fo:*/@country">
      <report test=". eq ''" role="Warning">country="" should be 'none | &lt;country&gt; | inherit'.</report>
   </rule>

   <!-- cue -->
   <!-- <cue-before> || <cue-after> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#cue -->
   <rule context="fo:*/@cue">
      <report test=". eq ''" role="Warning">cue="" should be '&lt;cue-before&gt; || &lt;cue-after&gt; | inherit'.</report>
   </rule>

   <!-- destination-placement-offset -->
   <!-- <length> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#destination-placement-offset -->
   <rule context="fo:*/@destination-placement-offset">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">destination-placement-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">destination-placement-offset="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: destination-placement-offset="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- direction -->
   <!-- ltr | rtl | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#direction -->
   <rule context="fo:*/@direction">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">direction="<value-of select="."/>" should be 'ltr', 'rtl', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ltr', 'rtl', 'inherit'))">direction="<value-of select="."/>". Allowed keywords are 'ltr', 'rtl', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">direction="" should be 'ltr', 'rtl', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: direction="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- display-align -->
   <!-- auto | before | center | after | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#display-align -->
   <rule context="fo:*/@display-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">display-align="<value-of select="."/>" should be 'auto', 'before', 'center', 'after', or 'justify'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'before', 'center', 'after', 'justify'))">display-align="<value-of select="."/>". Allowed keywords are 'auto', 'before', 'center', 'after', and 'justify'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">display-align="" should be 'auto', 'before', 'center', 'after', or 'justify'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: display-align="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- dominant-baseline -->
   <!-- auto | use-script | no-change | reset-size | ideographic | alphabetic | hanging | mathematical | central | middle | text-after-edge | text-before-edge | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#dominant-baseline -->
   <rule context="fo:*/@dominant-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">dominant-baseline="<value-of select="."/>" should be 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', 'inherit'))">dominant-baseline="<value-of select="."/>". Allowed keywords are 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">dominant-baseline="" should be 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: dominant-baseline="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- empty-cells -->
   <!-- show | hide | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#empty-cells -->
   <rule context="fo:*/@empty-cells">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">empty-cells="<value-of select="."/>" should be 'show', 'hide', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide', 'inherit'))">empty-cells="<value-of select="."/>". Allowed keywords are 'show', 'hide', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">empty-cells="" should be 'show', 'hide', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: empty-cells="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- end-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#end-indent -->
   <rule context="fo:*/@end-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">end-indent="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">end-indent="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">end-indent="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: end-indent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- ends-row -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#ends-row -->
   <rule context="fo:*/@ends-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">ends-row="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">ends-row="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">ends-row="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: ends-row="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- extent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#extent -->
   <rule context="fo:*/@extent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">extent="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">extent="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">extent="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: extent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- external-destination -->
   <!-- empty string | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#external-destination -->
   <rule context="fo:*/@external-destination"/>

   <!-- float -->
   <!-- before | start | end | left | right | inside | outside | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#float -->
   <rule context="fo:*/@float">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">float="<value-of select="."/>" should be 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', 'inherit'))">float="<value-of select="."/>". Allowed keywords are 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">float="" should be 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: float="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- flow-map-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#flow-map-name -->
   <rule context="fo:*/@flow-map-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">flow-map-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">flow-map-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-map-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- flow-map-reference -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#flow-map-reference -->
   <rule context="fo:*/@flow-map-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">flow-map-reference="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">flow-map-reference="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-map-reference="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- flow-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#flow-name -->
   <rule context="fo:*/@flow-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">flow-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">flow-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- flow-name-reference -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#flow-name-reference -->
   <rule context="fo:*/@flow-name-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">flow-name-reference="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">flow-name-reference="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-name-reference="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font -->
   <!-- [ [ <font-style> || <font-variant> || <font-weight> ]? <font-size> [ / <line-height>]? <font-family> ] | caption | icon | menu | message-box | small-caption | status-bar | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#font -->
   <rule context="fo:*/@font">
      <report test=". eq ''" role="Warning">font="" should be '[ [ &lt;font-style&gt; || &lt;font-variant&gt; || &lt;font-weight&gt; ]? &lt;font-size&gt; [ / &lt;line-height&gt;]? &lt;font-family&gt; ] | caption | icon | menu | message-box | small-caption | status-bar | inherit'.</report>
   </rule>

   <!-- font-family -->
   <!-- [[ <family-name> | <generic-family> ],]* [<family-name> | <generic-family>] | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-family -->
   <rule context="fo:*/@font-family">
      <report test=". eq ''" role="Warning">font-family="" should be '[[ &lt;family-name&gt; | &lt;generic-family&gt; ],]* [&lt;family-name&gt; | &lt;generic-family&gt;] | inherit'.</report>
   </rule>

   <!-- font-selection-strategy -->
   <!-- auto | character-by-character | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-selection-strategy -->
   <rule context="fo:*/@font-selection-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-selection-strategy="<value-of select="."/>" should be 'auto', 'character-by-character', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'character-by-character', 'inherit'))">font-selection-strategy="<value-of select="."/>". Allowed keywords are 'auto', 'character-by-character', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-selection-strategy="" should be 'auto', 'character-by-character', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-selection-strategy="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font-size -->
   <!-- <absolute-size> | <relative-size> | <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-size -->
   <rule context="fo:*/@font-size">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">font-size="<value-of select="."/>" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit'))">font-size="<value-of select="."/>". Allowed keywords are 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-size="" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-size="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font-size-adjust -->
   <!-- <number> | none | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-size-adjust -->
   <rule context="fo:*/@font-size-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-size-adjust="<value-of select="."/>" should be Number, 'none', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">font-size-adjust="<value-of select="."/>". Allowed keywords are 'none' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-size-adjust="" should be Number, 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-size-adjust="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font-stretch -->
   <!-- normal | wider | narrower | ultra-condensed | extra-condensed | condensed | semi-condensed | semi-expanded | expanded | extra-expanded | ultra-expanded | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-stretch -->
   <rule context="fo:*/@font-stretch">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Number', 'EMPTY', 'ERROR', 'Object')">font-stretch="<value-of select="."/>" should be 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit', Percent, or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit'))">font-stretch="<value-of select="."/>". Allowed keywords are 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-stretch="" should be 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit', Percent, or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-stretch="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font-style -->
   <!-- normal | italic | oblique | backslant | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-style -->
   <rule context="fo:*/@font-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-style="<value-of select="."/>" should be 'normal', 'italic', 'oblique', 'backslant', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'italic', 'oblique', 'backslant', 'inherit'))">font-style="<value-of select="."/>". Allowed keywords are 'normal', 'italic', 'oblique', 'backslant', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-style="" should be 'normal', 'italic', 'oblique', 'backslant', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-style="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- font-variant -->
   <!-- normal | small-caps | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-variant -->
   <rule context="fo:*/@font-variant">
      <report test=". eq ''" role="Warning">font-variant="" should be 'normal | small-caps | inherit'.</report>
   </rule>

   <!-- font-weight -->
   <!-- normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-weight -->
   <rule context="fo:*/@font-weight">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">font-weight="<value-of select="."/>" should be 'normal', 'bold', 'bolder', 'lighter', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'bold', 'bolder', 'lighter', 'inherit'))">font-weight="<value-of select="."/>". Allowed keywords are 'normal', 'bold', 'bolder', 'lighter', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-weight="" should be 'normal', 'bold', 'bolder', 'lighter', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-weight="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- force-page-count -->
   <!-- auto | even | odd | end-on-even | end-on-odd | no-force | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#force-page-count -->
   <rule context="fo:*/@force-page-count">
      <report test=". eq ''" role="Warning">force-page-count="" should be 'auto | even | odd | end-on-even | end-on-odd | no-force | inherit'.</report>
   </rule>

   <!-- format -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#format -->
   <rule context="fo:*/@format">
      <report test=". eq ''" role="Warning">format="" should be '&lt;string&gt;'.</report>
   </rule>

   <!-- glyph-orientation-horizontal -->
   <!-- <angle> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#glyph-orientation-horizontal -->
   <rule context="fo:*/@glyph-orientation-horizontal">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">glyph-orientation-horizontal="<value-of select="."/>" should be Literal or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">glyph-orientation-horizontal="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">glyph-orientation-horizontal="" should be Literal or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: glyph-orientation-horizontal="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- glyph-orientation-vertical -->
   <!-- auto | <angle> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#glyph-orientation-vertical -->
   <rule context="fo:*/@glyph-orientation-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'EMPTY', 'ERROR', 'Object')">glyph-orientation-vertical="<value-of select="."/>" should be 'auto', 'inherit', or Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">glyph-orientation-vertical="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">glyph-orientation-vertical="" should be 'auto', 'inherit', or Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: glyph-orientation-vertical="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- grouping-separator -->
   <!-- <character> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#grouping-separator -->
   <rule context="fo:*/@grouping-separator">
      <report test=". eq ''" role="Warning">grouping-separator="" should be '&lt;character&gt;'.</report>
   </rule>

   <!-- grouping-size -->
   <!-- <number> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#grouping-size -->
   <rule context="fo:*/@grouping-size">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EMPTY', 'ERROR', 'Object')">grouping-size="<value-of select="."/>" should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">grouping-size="" should be Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: grouping-size="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- height -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#height -->
   <rule context="fo:*/@height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">height="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">height="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">height="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: height="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- hyphenate -->
   <!-- false | true | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenate -->
   <rule context="fo:*/@hyphenate">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenate="<value-of select="."/>" should be 'none', 'false', 'true', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'false', 'true', 'inherit'))">hyphenate="<value-of select="."/>". Allowed keywords are 'none', 'false', 'true', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenate="" should be 'none', 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenate="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- hyphenation-character -->
   <!-- <character> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-character -->
   <rule context="fo:*/@hyphenation-character">
      <report test=". eq ''" role="Warning">hyphenation-character="" should be '&lt;character&gt; | inherit'.</report>
   </rule>

   <!-- hyphenation-keep -->
   <!-- auto | column | page | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-keep -->
   <rule context="fo:*/@hyphenation-keep">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-keep="<value-of select="."/>" should be 'auto', 'column', 'page', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'inherit'))">hyphenation-keep="<value-of select="."/>". Allowed keywords are 'auto', 'column', 'page', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-keep="" should be 'auto', 'column', 'page', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-keep="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- hyphenation-ladder-count -->
   <!-- no-limit | <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-ladder-count -->
   <rule context="fo:*/@hyphenation-ladder-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">hyphenation-ladder-count="<value-of select="."/>" should be 'no-limit', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">hyphenation-ladder-count="<value-of select="."/>". Allowed keywords are 'no-limit' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-ladder-count="" should be 'no-limit', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-ladder-count="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- hyphenation-push-character-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-push-character-count -->
   <rule context="fo:*/@hyphenation-push-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-push-character-count="<value-of select="."/>" should be Number or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">hyphenation-push-character-count="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-push-character-count="" should be Number or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-push-character-count="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- hyphenation-remain-character-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-remain-character-count -->
   <rule context="fo:*/@hyphenation-remain-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-remain-character-count="<value-of select="."/>" should be Number or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">hyphenation-remain-character-count="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-remain-character-count="" should be Number or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-remain-character-count="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- id -->
   <!-- <id> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#id -->
   <rule context="fo:*/@id">
      <report test=". eq ''" role="Warning">id="" should be '&lt;id&gt;'.</report>
   </rule>

   <!-- index-class -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#index-class -->
   <rule context="fo:*/@index-class">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">index-class="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: index-class="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- index-key -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#index-key -->
   <rule context="fo:*/@index-key">
      <report test=". eq ''" role="Warning">index-key="" should be '&lt;string&gt;'.</report>
   </rule>

   <!-- indicate-destination -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#indicate-destination -->
   <rule context="fo:*/@indicate-destination">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">indicate-destination="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">indicate-destination="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">indicate-destination="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: indicate-destination="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- initial-page-number -->
   <!-- auto | auto-odd | auto-even | <number> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#initial-page-number -->
   <rule context="fo:*/@initial-page-number">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">initial-page-number="<value-of select="."/>" should be 'auto', 'auto-odd', 'auto-even', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'auto-odd', 'auto-even', 'inherit'))">initial-page-number="<value-of select="."/>". Allowed keywords are 'auto', 'auto-odd', 'auto-even', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">initial-page-number="" should be 'auto', 'auto-odd', 'auto-even', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: initial-page-number="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- inline-progression-dimension -->
   <!-- auto | <length> | <percentage> | <length-range> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#inline-progression-dimension -->
   <rule context="fo:*/@inline-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">inline-progression-dimension="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">inline-progression-dimension="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">inline-progression-dimension="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: inline-progression-dimension="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- internal-destination -->
   <!-- empty string | <idref> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#internal-destination -->
   <rule context="fo:*/@internal-destination"/>

   <!-- intrinsic-scale-value -->
   <!-- <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#intrinsic-scale-value -->
   <rule context="fo:*/@intrinsic-scale-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">intrinsic-scale-value="<value-of select="."/>" should be Percent or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">intrinsic-scale-value="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">intrinsic-scale-value="" should be Percent or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: intrinsic-scale-value="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- intrusion-displace -->
   <!-- auto | none | line | indent | block | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#intrusion-displace -->
   <rule context="fo:*/@intrusion-displace">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">intrusion-displace="<value-of select="."/>" should be 'auto', 'none', 'line', 'indent', 'block', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'none', 'line', 'indent', 'block', 'inherit'))">intrusion-displace="<value-of select="."/>". Allowed keywords are 'auto', 'none', 'line', 'indent', 'block', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">intrusion-displace="" should be 'auto', 'none', 'line', 'indent', 'block', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: intrusion-displace="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- keep-together -->
   <!-- <keep> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-together -->
   <rule context="fo:*/@keep-together">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-together="<value-of select="."/>" should be 'auto', 'always', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-together="<value-of select="."/>". Allowed keywords are 'auto', 'always', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-together="" should be 'auto', 'always', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-together="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- keep-with-next -->
   <!-- <keep> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-with-next -->
   <rule context="fo:*/@keep-with-next">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-with-next="<value-of select="."/>" should be 'auto', 'always', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-with-next="<value-of select="."/>". Allowed keywords are 'auto', 'always', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-with-next="" should be 'auto', 'always', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-with-next="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- keep-with-previous -->
   <!-- <keep> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-with-previous -->
   <rule context="fo:*/@keep-with-previous">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-with-previous="<value-of select="."/>" should be 'auto', 'always', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-with-previous="<value-of select="."/>". Allowed keywords are 'auto', 'always', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-with-previous="" should be 'auto', 'always', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-with-previous="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- language -->
   <!-- none | <language> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#language -->
   <rule context="fo:*/@language">
      <report test=". eq ''" role="Warning">language="" should be 'none | &lt;language&gt; | inherit'.</report>
   </rule>

   <!-- last-line-end-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#last-line-end-indent -->
   <rule context="fo:*/@last-line-end-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">last-line-end-indent="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">last-line-end-indent="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">last-line-end-indent="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: last-line-end-indent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- leader-alignment -->
   <!-- none | reference-area | page | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-alignment -->
   <rule context="fo:*/@leader-alignment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">leader-alignment="<value-of select="."/>" should be 'none', 'reference-area', 'page', 'start', 'center', or 'end'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'reference-area', 'page', 'start', 'center', 'end'))">leader-alignment="<value-of select="."/>". Allowed keywords are 'none', 'reference-area', 'page', 'start', 'center', and 'end'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-alignment="" should be 'none', 'reference-area', 'page', 'start', 'center', or 'end'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-alignment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- leader-length -->
   <!-- <length-range> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-length -->
   <rule context="fo:*/@leader-length">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">leader-length="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">leader-length="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-length="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-length="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- leader-pattern -->
   <!-- space | rule | dots | use-content | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-pattern -->
   <rule context="fo:*/@leader-pattern">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">leader-pattern="<value-of select="."/>" should be 'space', 'rule', 'dots', 'use-content', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('space', 'rule', 'dots', 'use-content', 'inherit'))">leader-pattern="<value-of select="."/>". Allowed keywords are 'space', 'rule', 'dots', 'use-content', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-pattern="" should be 'space', 'rule', 'dots', 'use-content', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-pattern="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- leader-pattern-width -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-pattern-width -->
   <rule context="fo:*/@leader-pattern-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">leader-pattern-width="<value-of select="."/>" should be 'use-font-metrics', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">leader-pattern-width="<value-of select="."/>". Allowed keywords are 'use-font-metrics' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-pattern-width="" should be 'use-font-metrics', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-pattern-width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- left -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#left -->
   <rule context="fo:*/@left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">left="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">left="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">left="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: left="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- letter-spacing -->
   <!-- normal | <length> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#letter-spacing -->
   <rule context="fo:*/@letter-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">letter-spacing="<value-of select="."/>" should be 'normal', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">letter-spacing="<value-of select="."/>". Allowed keywords are 'normal' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">letter-spacing="" should be 'normal', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: letter-spacing="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- letter-value -->
   <!-- auto | alphabetic | traditional -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#letter-value -->
   <rule context="fo:*/@letter-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">letter-value="<value-of select="."/>" should be 'auto', 'alphabetic', or 'traditional'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'alphabetic', 'traditional'))">letter-value="<value-of select="."/>". Allowed keywords are 'auto', 'alphabetic', and 'traditional'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">letter-value="" should be 'auto', 'alphabetic', or 'traditional'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: letter-value="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- line-height -->
   <!-- normal | <length> | <number> | <percentage> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-height -->
   <rule context="fo:*/@line-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'EMPTY', 'ERROR', 'Object')">line-height="<value-of select="."/>" should be 'normal', 'inherit', Length, Number, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">line-height="<value-of select="."/>". Allowed keywords are 'normal' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-height="" should be 'normal', 'inherit', Length, Number, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-height="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- line-height-shift-adjustment -->
   <!-- consider-shifts | disregard-shifts | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-height-shift-adjustment -->
   <rule context="fo:*/@line-height-shift-adjustment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">line-height-shift-adjustment="<value-of select="."/>" should be 'consider-shifts', 'disregard-shifts', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('consider-shifts', 'disregard-shifts', 'inherit'))">line-height-shift-adjustment="<value-of select="."/>". Allowed keywords are 'consider-shifts', 'disregard-shifts', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-height-shift-adjustment="" should be 'consider-shifts', 'disregard-shifts', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-height-shift-adjustment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- line-stacking-strategy -->
   <!-- line-height | font-height | max-height | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-stacking-strategy -->
   <rule context="fo:*/@line-stacking-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">line-stacking-strategy="<value-of select="."/>" should be 'line-height', 'font-height', 'max-height', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('line-height', 'font-height', 'max-height', 'inherit'))">line-stacking-strategy="<value-of select="."/>". Allowed keywords are 'line-height', 'font-height', 'max-height', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-stacking-strategy="" should be 'line-height', 'font-height', 'max-height', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-stacking-strategy="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- linefeed-treatment -->
   <!-- ignore | preserve | treat-as-space | treat-as-zero-width-space | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#linefeed-treatment -->
   <rule context="fo:*/@linefeed-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">linefeed-treatment="<value-of select="."/>" should be 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', 'inherit'))">linefeed-treatment="<value-of select="."/>". Allowed keywords are 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">linefeed-treatment="" should be 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: linefeed-treatment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- margin -->
   <!-- <margin-width>{1,4} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#margin -->
   <rule context="fo:*/@margin">
      <report test=". eq ''" role="Warning">margin="" should be '&lt;margin-width&gt;{1,4} | inherit'.</report>
   </rule>

   <!-- margin-bottom -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-bottom -->
   <rule context="fo:*/@margin-bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">margin-bottom="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-bottom="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-bottom="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-bottom="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- margin-left -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-left -->
   <rule context="fo:*/@margin-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">margin-left="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-left="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-left="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-left="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- margin-right -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-right -->
   <rule context="fo:*/@margin-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">margin-right="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-right="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-right="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-right="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- margin-top -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-top -->
   <rule context="fo:*/@margin-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">margin-top="<value-of select="."/>" should be 'auto', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-top="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-top="" should be 'auto', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-top="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- marker-class-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#marker-class-name -->
   <rule context="fo:*/@marker-class-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">marker-class-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">marker-class-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: marker-class-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- master-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#master-name -->
   <rule context="fo:*/@master-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">master-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">master-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: master-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- master-reference -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#master-reference -->
   <rule context="fo:*/@master-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">master-reference="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">master-reference="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: master-reference="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- max-height -->
   <!-- <length> | <percentage> | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#max-height -->
   <rule context="fo:*/@max-height">
      <report test=". eq ''" role="Warning">max-height="" should be '&lt;length&gt; | &lt;percentage&gt; | none | inherit'.</report>
   </rule>

   <!-- max-width -->
   <!-- <length> | <percentage> | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#max-width -->
   <rule context="fo:*/@max-width">
      <report test=". eq ''" role="Warning">max-width="" should be '&lt;length&gt; | &lt;percentage&gt; | none | inherit'.</report>
   </rule>

   <!-- maximum-repeats -->
   <!-- <number> | no-limit | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#maximum-repeats -->
   <rule context="fo:*/@maximum-repeats">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">maximum-repeats="<value-of select="."/>" should be Number, 'no-limit', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">maximum-repeats="<value-of select="."/>". Allowed keywords are 'no-limit' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">maximum-repeats="" should be Number, 'no-limit', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: maximum-repeats="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- media-usage -->
   <!-- auto | paginate | bounded-in-one-dimension | unbounded -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#media-usage -->
   <rule context="fo:*/@media-usage">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">media-usage="<value-of select="."/>" should be 'auto', 'paginate', 'bounded-in-one-dimension', or 'unbounded'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'paginate', 'bounded-in-one-dimension', 'unbounded'))">media-usage="<value-of select="."/>". Allowed keywords are 'auto', 'paginate', 'bounded-in-one-dimension', and 'unbounded'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">media-usage="" should be 'auto', 'paginate', 'bounded-in-one-dimension', or 'unbounded'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: media-usage="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- merge-pages-across-index-key-references -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-pages-across-index-key-references -->
   <rule context="fo:*/@merge-pages-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-pages-across-index-key-references="<value-of select="."/>" should be 'merge' or 'leave-separate'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-pages-across-index-key-references="<value-of select="."/>". Allowed keywords are 'merge' and 'leave-separate'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-pages-across-index-key-references="" should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-pages-across-index-key-references="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- merge-ranges-across-index-key-references -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-ranges-across-index-key-references -->
   <rule context="fo:*/@merge-ranges-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-ranges-across-index-key-references="<value-of select="."/>" should be 'merge' or 'leave-separate'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-ranges-across-index-key-references="<value-of select="."/>". Allowed keywords are 'merge' and 'leave-separate'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-ranges-across-index-key-references="" should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-ranges-across-index-key-references="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- merge-sequential-page-numbers -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-sequential-page-numbers -->
   <rule context="fo:*/@merge-sequential-page-numbers">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-sequential-page-numbers="<value-of select="."/>" should be 'merge' or 'leave-separate'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-sequential-page-numbers="<value-of select="."/>". Allowed keywords are 'merge' and 'leave-separate'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-sequential-page-numbers="" should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-sequential-page-numbers="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- min-height -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#min-height -->
   <rule context="fo:*/@min-height">
      <report test=". eq ''" role="Warning">min-height="" should be '&lt;length&gt; | &lt;percentage&gt; | inherit'.</report>
   </rule>

   <!-- min-width -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#min-width -->
   <rule context="fo:*/@min-width">
      <report test=". eq ''" role="Warning">min-width="" should be '&lt;length&gt; | &lt;percentage&gt; | inherit'.</report>
   </rule>

   <!-- number-columns-repeated -->
   <!-- <number> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#number-columns-repeated -->
   <rule context="fo:*/@number-columns-repeated">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EMPTY', 'ERROR', 'Object')">number-columns-repeated="<value-of select="."/>" should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">number-columns-repeated="" should be Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-columns-repeated="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- number-columns-spanned -->
   <!-- <number> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#number-columns-spanned -->
   <rule context="fo:*/@number-columns-spanned">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EMPTY', 'ERROR', 'Object')">number-columns-spanned="<value-of select="."/>" should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">number-columns-spanned="" should be Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-columns-spanned="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- number-rows-spanned -->
   <!-- <number> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#number-rows-spanned -->
   <rule context="fo:*/@number-rows-spanned">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EMPTY', 'ERROR', 'Object')">number-rows-spanned="<value-of select="."/>" should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">number-rows-spanned="" should be Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-rows-spanned="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- odd-or-even -->
   <!-- odd | even | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#odd-or-even -->
   <rule context="fo:*/@odd-or-even">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">odd-or-even="<value-of select="."/>" should be 'odd', 'even', 'odd-document', 'even-document', or 'any'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('odd', 'even', 'odd-document', 'even-document', 'any'))">odd-or-even="<value-of select="."/>". Allowed keywords are 'odd', 'even', 'odd-document', 'even-document', and 'any'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">odd-or-even="" should be 'odd', 'even', 'odd-document', 'even-document', or 'any'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: odd-or-even="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- orphans -->
   <!-- <integer> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#orphans -->
   <rule context="fo:*/@orphans">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">orphans="<value-of select="."/>" should be Number or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">orphans="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">orphans="" should be Number or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: orphans="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- overflow -->
   <!-- visible | hidden | scroll | error-if-overflow | repeat | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#overflow -->
   <rule context="fo:*/@overflow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">overflow="<value-of select="."/>" should be 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', or 'auto'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', 'auto'))">overflow="<value-of select="."/>". Allowed keywords are 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', and 'auto'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">overflow="" should be 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', or 'auto'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: overflow="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding -->
   <!-- <padding-width>{1,4} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#padding -->
   <rule context="fo:*/@padding">
      <report test=". eq ''" role="Warning">padding="" should be '&lt;padding-width&gt;{1,4} | inherit'.</report>
   </rule>

   <!-- padding-after -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-after -->
   <rule context="fo:*/@padding-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-after="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-after="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-after="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-after="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-before -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-before -->
   <rule context="fo:*/@padding-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-before="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-before="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-before="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-before="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-bottom -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-bottom -->
   <rule context="fo:*/@padding-bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-bottom="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-bottom="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-bottom="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-bottom="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-end -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-end -->
   <rule context="fo:*/@padding-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-end="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-end="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-end="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-end="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-left -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-left -->
   <rule context="fo:*/@padding-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-left="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-left="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-left="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-left="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-right -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-right -->
   <rule context="fo:*/@padding-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-right="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-right="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-right="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-right="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-start -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-start -->
   <rule context="fo:*/@padding-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-start="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-start="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-start="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-start="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- padding-top -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-top -->
   <rule context="fo:*/@padding-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">padding-top="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-top="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-top="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-top="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- page-break-after -->
   <!-- auto | always | avoid | left | right | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#page-break-after -->
   <rule context="fo:*/@page-break-after">
      <report test=". eq ''" role="Warning">page-break-after="" should be 'auto | always | avoid | left | right | inherit'.</report>
   </rule>

   <!-- page-break-before -->
   <!-- auto | always | avoid | left | right | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#page-break-before -->
   <rule context="fo:*/@page-break-before">
      <report test=". eq ''" role="Warning">page-break-before="" should be 'auto | always | avoid | left | right | inherit'.</report>
   </rule>

   <!-- page-break-inside -->
   <!-- avoid | auto | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#page-break-inside -->
   <rule context="fo:*/@page-break-inside">
      <report test=". eq ''" role="Warning">page-break-inside="" should be 'avoid | auto | inherit'.</report>
   </rule>

   <!-- page-citation-strategy -->
   <!-- [ all | normal | non-blank | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-citation-strategy -->
   <rule context="fo:*/@page-citation-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">page-citation-strategy="<value-of select="."/>" should be 'all', 'normal', 'non-blank', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('all', 'normal', 'non-blank', 'inherit'))">page-citation-strategy="<value-of select="."/>". Allowed keywords are 'all', 'normal', 'non-blank', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-citation-strategy="" should be 'all', 'normal', 'non-blank', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-citation-strategy="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- page-height -->
   <!-- auto | indefinite | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-height -->
   <rule context="fo:*/@page-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">page-height="<value-of select="."/>" should be 'auto', 'indefinite', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">page-height="<value-of select="."/>". Allowed keywords are 'auto', 'indefinite', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-height="" should be 'auto', 'indefinite', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-height="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- page-number-treatment -->
   <!-- link | no-link -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-number-treatment -->
   <rule context="fo:*/@page-number-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">page-number-treatment="<value-of select="."/>" should be 'link' or 'no-link'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'no-link'))">page-number-treatment="<value-of select="."/>". Allowed keywords are 'link' and 'no-link'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-number-treatment="" should be 'link' or 'no-link'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-number-treatment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- page-position -->
   <!-- only | first | last | rest | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-position -->
   <rule context="fo:*/@page-position">
      <report test=". eq ''" role="Warning">page-position="" should be 'only | first | last | rest | any | inherit'.</report>
   </rule>

   <!-- page-width -->
   <!-- auto | indefinite | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-width -->
   <rule context="fo:*/@page-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">page-width="<value-of select="."/>" should be 'auto', 'indefinite', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">page-width="<value-of select="."/>". Allowed keywords are 'auto', 'indefinite', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-width="" should be 'auto', 'indefinite', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- pause -->
   <!-- [<time> | <percentage>]{1,2} | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#pause -->
   <rule context="fo:*/@pause">
      <report test=". eq ''" role="Warning">pause="" should be '[&lt;time&gt; | &lt;percentage&gt;]{1,2} | inherit'.</report>
   </rule>

   <!-- position -->
   <!-- static | relative | absolute | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#position -->
   <rule context="fo:*/@position">
      <report test=". eq ''" role="Warning">position="" should be 'static | relative | absolute | fixed | inherit'.</report>
   </rule>

   <!-- precedence -->
   <!-- true | false | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#precedence -->
   <rule context="fo:*/@precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">precedence="<value-of select="."/>" should be 'true', 'false', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">precedence="<value-of select="."/>". Allowed keywords are 'true', 'false', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">precedence="" should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: precedence="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- provisional-distance-between-starts -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#provisional-distance-between-starts -->
   <rule context="fo:*/@provisional-distance-between-starts">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">provisional-distance-between-starts="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">provisional-distance-between-starts="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">provisional-distance-between-starts="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: provisional-distance-between-starts="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- provisional-label-separation -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#provisional-label-separation -->
   <rule context="fo:*/@provisional-label-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">provisional-label-separation="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">provisional-label-separation="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">provisional-label-separation="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: provisional-label-separation="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- ref-id -->
   <!-- <idref> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#ref-id -->
   <rule context="fo:*/@ref-id">
      <report test=". eq ''" role="Warning">ref-id="" should be '&lt;idref&gt; | inherit'.</report>
   </rule>

   <!-- ref-index-key -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#ref-index-key -->
   <rule context="fo:*/@ref-index-key">
      <report test=". eq ''" role="Warning">ref-index-key="" should be '&lt;string&gt;'.</report>
   </rule>

   <!-- reference-orientation -->
   <!-- 0 | 90 | 180 | 270 | -90 | -180 | -270 | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#reference-orientation -->
   <rule context="fo:*/@reference-orientation">
      <report test=". eq ''" role="Warning">reference-orientation="" should be '0 | 90 | 180 | 270 | -90 | -180 | -270 | inherit'.</report>
   </rule>

   <!-- region-name -->
   <!-- xsl-region-body | xsl-region-start | xsl-region-end | xsl-region-before | xsl-region-after | <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#region-name -->
   <rule context="fo:*/@region-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">region-name="<value-of select="."/>" should be 'xsl-region-body', 'xsl-region-start', 'xsl-region-end', 'xsl-region-before', or 'xsl-region-after'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">region-name="" should be 'xsl-region-body', 'xsl-region-start', 'xsl-region-end', 'xsl-region-before', or 'xsl-region-after'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: region-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- region-name-reference -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#region-name-reference -->
   <rule context="fo:*/@region-name-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">region-name-reference="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">region-name-reference="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: region-name-reference="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- relative-align -->
   <!-- before | baseline | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#relative-align -->
   <rule context="fo:*/@relative-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">relative-align="<value-of select="."/>" should be 'before', 'baseline', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'baseline', 'inherit'))">relative-align="<value-of select="."/>". Allowed keywords are 'before', 'baseline', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">relative-align="" should be 'before', 'baseline', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: relative-align="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- relative-position -->
   <!-- static | relative | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#relative-position -->
   <rule context="fo:*/@relative-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">relative-position="<value-of select="."/>" should be 'static', 'relative', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('static', 'relative', 'inherit'))">relative-position="<value-of select="."/>". Allowed keywords are 'static', 'relative', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">relative-position="" should be 'static', 'relative', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: relative-position="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- rendering-intent -->
   <!-- auto | perceptual | relative-colorimetric | saturation | absolute-colorimetric | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#rendering-intent -->
   <rule context="fo:*/@rendering-intent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">rendering-intent="<value-of select="."/>" should be 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', 'inherit'))">rendering-intent="<value-of select="."/>". Allowed keywords are 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rendering-intent="" should be 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rendering-intent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- retrieve-boundary -->
   <!-- page | page-sequence | document -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-boundary -->
   <rule context="fo:*/@retrieve-boundary">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-boundary="<value-of select="."/>" should be 'page', 'page-sequence', or 'document'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('page', 'page-sequence', 'document'))">retrieve-boundary="<value-of select="."/>". Allowed keywords are 'page', 'page-sequence', and 'document'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-boundary="" should be 'page', 'page-sequence', or 'document'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-boundary="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- retrieve-boundary-within-table -->
   <!-- table | table-fragment | page -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-boundary-within-table -->
   <rule context="fo:*/@retrieve-boundary-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-boundary-within-table="<value-of select="."/>" should be 'table', 'table-fragment', or 'page'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('table', 'table-fragment', 'page'))">retrieve-boundary-within-table="<value-of select="."/>". Allowed keywords are 'table', 'table-fragment', and 'page'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-boundary-within-table="" should be 'table', 'table-fragment', or 'page'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-boundary-within-table="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- retrieve-class-name -->
   <!-- <name> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-class-name -->
   <rule context="fo:*/@retrieve-class-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-class-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-class-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-class-name="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- retrieve-position -->
   <!-- first-starting-within-page | first-including-carryover | last-starting-within-page | last-ending-within-page -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-position -->
   <rule context="fo:*/@retrieve-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-position="<value-of select="."/>" should be 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', or 'last-ending-within-page'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', 'last-ending-within-page'))">retrieve-position="<value-of select="."/>". Allowed keywords are 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', and 'last-ending-within-page'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-position="" should be 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', or 'last-ending-within-page'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-position="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- retrieve-position-within-table -->
   <!-- first-starting | first-including-carryover | last-starting | last-ending -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-position-within-table -->
   <rule context="fo:*/@retrieve-position-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-position-within-table="<value-of select="."/>" should be 'first-starting', 'first-including-carryover', 'last-starting', or 'last-ending'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting', 'first-including-carryover', 'last-starting', 'last-ending'))">retrieve-position-within-table="<value-of select="."/>". Allowed keywords are 'first-starting', 'first-including-carryover', 'last-starting', and 'last-ending'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-position-within-table="" should be 'first-starting', 'first-including-carryover', 'last-starting', or 'last-ending'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-position-within-table="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- right -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#right -->
   <rule context="fo:*/@right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">right="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">right="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">right="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: right="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- role -->
   <!-- <string> | <uri-specification> | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#role -->
   <rule context="fo:*/@role">
      <report test=". eq ''" role="Warning">role="" should be '&lt;string&gt; | &lt;uri-specification&gt; | none | inherit'.</report>
   </rule>

   <!-- rule-style -->
   <!-- none | dotted | dashed | solid | double | groove | ridge | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#rule-style -->
   <rule context="fo:*/@rule-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">rule-style="<value-of select="."/>" should be 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inherit'))">rule-style="<value-of select="."/>". Allowed keywords are 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rule-style="" should be 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rule-style="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- rule-thickness -->
   <!-- <length> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#rule-thickness -->
   <rule context="fo:*/@rule-thickness">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">rule-thickness="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rule-thickness="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rule-thickness="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- scale-option -->
   <!-- width | height | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scale-option -->
   <rule context="fo:*/@scale-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scale-option="<value-of select="."/>" should be 'width', 'height', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('width', 'height', 'inherit'))">scale-option="<value-of select="."/>". Allowed keywords are 'width', 'height', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scale-option="" should be 'width', 'height', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scale-option="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- scaling -->
   <!-- uniform | non-uniform | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scaling -->
   <rule context="fo:*/@scaling">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be 'uniform', 'non-uniform', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling="<value-of select="."/>". Allowed keywords are 'uniform', 'non-uniform', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be 'uniform', 'non-uniform', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- scaling-method -->
   <!-- auto | integer-pixels | resample-any-method | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scaling-method -->
   <rule context="fo:*/@scaling-method">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling-method="<value-of select="."/>" should be 'auto', 'integer-pixels', 'resample-any-method', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'integer-pixels', 'resample-any-method', 'inherit'))">scaling-method="<value-of select="."/>". Allowed keywords are 'auto', 'integer-pixels', 'resample-any-method', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling-method="" should be 'auto', 'integer-pixels', 'resample-any-method', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scaling-method="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- score-spaces -->
   <!-- true | false | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#score-spaces -->
   <rule context="fo:*/@score-spaces">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">score-spaces="<value-of select="."/>" should be 'true', 'false', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">score-spaces="<value-of select="."/>". Allowed keywords are 'true', 'false', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">score-spaces="" should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: score-spaces="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- script -->
   <!-- none | auto | <script> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#script -->
   <rule context="fo:*/@script">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'EMPTY', 'ERROR', 'Object')">script="<value-of select="."/>" should be 'none', 'auto', 'inherit', or Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto', 'inherit'))">script="<value-of select="."/>". Allowed keywords are 'none', 'auto', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">script="" should be 'none', 'auto', 'inherit', or Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: script="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- show-destination -->
   <!-- replace | new -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#show-destination -->
   <rule context="fo:*/@show-destination">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">show-destination="<value-of select="."/>" should be 'replace' or 'new'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('replace', 'new'))">show-destination="<value-of select="."/>". Allowed keywords are 'replace' and 'new'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">show-destination="" should be 'replace' or 'new'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: show-destination="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- size -->
   <!-- <length>{1,2} | auto | landscape | portrait | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#size -->
   <rule context="fo:*/@size">
      <report test=". eq ''" role="Warning">size="" should be '&lt;length&gt;{1,2} | auto | landscape | portrait | inherit'.</report>
   </rule>

   <!-- source-document -->
   <!-- <uri-specification> [<uri-specification>]* | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#source-document -->
   <rule context="fo:*/@source-document">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">source-document="<value-of select="."/>" should be URI, 'none', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">source-document="" should be URI, 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: source-document="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- space-after -->
   <!-- <space> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-after -->
   <rule context="fo:*/@space-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">space-after="<value-of select="."/>" should be Length or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-after="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-after="" should be Length or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-after="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- space-before -->
   <!-- <space> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-before -->
   <rule context="fo:*/@space-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">space-before="<value-of select="."/>" should be Length or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-before="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-before="" should be Length or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-before="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- space-end -->
   <!-- <space> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-end -->
   <rule context="fo:*/@space-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">space-end="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-end="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-end="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-end="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- space-start -->
   <!-- <space> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-start -->
   <rule context="fo:*/@space-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">space-start="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-start="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-start="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-start="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- span -->
   <!-- none | all | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#span -->
   <rule context="fo:*/@span">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">span="<value-of select="."/>" should be 'none', 'all', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'all', 'inherit'))">span="<value-of select="."/>". Allowed keywords are 'none', 'all', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">span="" should be 'none', 'all', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: span="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- src -->
   <!-- <uri-specification> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#src -->
   <rule context="fo:*/@src">
      <report test=". eq ''" role="Warning">src="" should be '&lt;uri-specification&gt; | inherit'.</report>
   </rule>

   <!-- start-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#start-indent -->
   <rule context="fo:*/@start-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">start-indent="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">start-indent="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">start-indent="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: start-indent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- starting-state -->
   <!-- show | hide -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#starting-state -->
   <rule context="fo:*/@starting-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">starting-state="<value-of select="."/>" should be 'show' or 'hide'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide'))">starting-state="<value-of select="."/>". Allowed keywords are 'show' and 'hide'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">starting-state="" should be 'show' or 'hide'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: starting-state="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- starts-row -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#starts-row -->
   <rule context="fo:*/@starts-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">starts-row="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">starts-row="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">starts-row="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: starts-row="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- suppress-at-line-break -->
   <!-- auto | suppress | retain | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#suppress-at-line-break -->
   <rule context="fo:*/@suppress-at-line-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">suppress-at-line-break="<value-of select="."/>" should be 'auto', 'suppress', 'retain', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'suppress', 'retain', 'inherit'))">suppress-at-line-break="<value-of select="."/>". Allowed keywords are 'auto', 'suppress', 'retain', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">suppress-at-line-break="" should be 'auto', 'suppress', 'retain', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: suppress-at-line-break="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- switch-to -->
   <!-- xsl-preceding | xsl-following | xsl-any | <name>[ <name>]* -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#switch-to -->
   <rule context="fo:*/@switch-to">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">switch-to="<value-of select="."/>" should be 'xsl-preceding', 'xsl-following', or 'xsl-any'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">switch-to="" should be 'xsl-preceding', 'xsl-following', or 'xsl-any'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: switch-to="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- table-layout -->
   <!-- auto | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-layout -->
   <rule context="fo:*/@table-layout">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-layout="<value-of select="."/>" should be 'auto', 'fixed', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'fixed', 'inherit'))">table-layout="<value-of select="."/>". Allowed keywords are 'auto', 'fixed', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-layout="" should be 'auto', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-layout="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- table-omit-footer-at-break -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-omit-footer-at-break -->
   <rule context="fo:*/@table-omit-footer-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-omit-footer-at-break="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">table-omit-footer-at-break="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-omit-footer-at-break="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-omit-footer-at-break="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- table-omit-header-at-break -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-omit-header-at-break -->
   <rule context="fo:*/@table-omit-header-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-omit-header-at-break="<value-of select="."/>" should be 'true' or 'false'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">table-omit-header-at-break="<value-of select="."/>". Allowed keywords are 'true' and 'false'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-omit-header-at-break="" should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-omit-header-at-break="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- target-presentation-context -->
   <!-- use-target-processing-context | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-presentation-context -->
   <rule context="fo:*/@target-presentation-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-presentation-context="<value-of select="."/>" should be 'use-target-processing-context' or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-presentation-context="" should be 'use-target-processing-context' or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-presentation-context="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- target-processing-context -->
   <!-- document-root | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-processing-context -->
   <rule context="fo:*/@target-processing-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-processing-context="<value-of select="."/>" should be 'document-root' or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-processing-context="" should be 'document-root' or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-processing-context="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- target-stylesheet -->
   <!-- use-normal-stylesheet | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-stylesheet -->
   <rule context="fo:*/@target-stylesheet">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-stylesheet="<value-of select="."/>" should be 'use-normal-stylesheet' or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-stylesheet="" should be 'use-normal-stylesheet' or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-stylesheet="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-align -->
   <!-- start | center | end | justify | inside | outside | left | right | <string> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-align -->
   <rule context="fo:*/@text-align">
      <report test=". eq ''" role="Warning">text-align="" should be 'start | center | end | justify | inside | outside | left | right | &lt;string&gt; | inherit'.</report>
   </rule>

   <!-- text-align-last -->
   <!-- relative | start | center | end | justify | inside | outside | left | right | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-align-last -->
   <rule context="fo:*/@text-align-last">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-align-last="<value-of select="."/>" should be 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', 'inherit'))">text-align-last="<value-of select="."/>". Allowed keywords are 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-align-last="" should be 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-align-last="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-altitude -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-altitude -->
   <rule context="fo:*/@text-altitude">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">text-altitude="<value-of select="."/>" should be 'use-font-metrics', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">text-altitude="<value-of select="."/>". Allowed keywords are 'use-font-metrics' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-altitude="" should be 'use-font-metrics', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-altitude="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-decoration -->
   <!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-decoration -->
   <rule context="fo:*/@text-decoration">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration="<value-of select="."/>" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration="<value-of select="."/>". Allowed keywords are 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration="" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-decoration="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-depth -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-depth -->
   <rule context="fo:*/@text-depth">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">text-depth="<value-of select="."/>" should be 'use-font-metrics', 'inherit', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">text-depth="<value-of select="."/>". Allowed keywords are 'use-font-metrics' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-depth="" should be 'use-font-metrics', 'inherit', Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-depth="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-indent -->
   <rule context="fo:*/@text-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">text-indent="<value-of select="."/>" should be Length, Percent, or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">text-indent="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-indent="" should be Length, Percent, or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-indent="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-shadow -->
   <!-- none | [<color> || <length> <length> <length>? ,]* [<color> || <length> <length> <length>?] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-shadow -->
   <rule context="fo:*/@text-shadow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Color', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">text-shadow="<value-of select="."/>" should be 'none', 'inherit', Color, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">text-shadow="<value-of select="."/>". Allowed keywords are 'none' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-shadow="" should be 'none', 'inherit', Color, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-shadow="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- text-transform -->
   <!-- capitalize | uppercase | lowercase | none | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-transform -->
   <rule context="fo:*/@text-transform">
      <report test=". eq ''" role="Warning">text-transform="" should be 'capitalize | uppercase | lowercase | none | inherit'.</report>
   </rule>

   <!-- top -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#top -->
   <rule context="fo:*/@top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">top="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">top="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">top="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: top="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- treat-as-word-space -->
   <!-- auto | true | false | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#treat-as-word-space -->
   <rule context="fo:*/@treat-as-word-space">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">treat-as-word-space="<value-of select="."/>" should be 'auto', 'true', 'false', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'true', 'false', 'inherit'))">treat-as-word-space="<value-of select="."/>". Allowed keywords are 'auto', 'true', 'false', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">treat-as-word-space="" should be 'auto', 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: treat-as-word-space="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- unicode-bidi -->
   <!-- normal | embed | bidi-override | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#unicode-bidi -->
   <rule context="fo:*/@unicode-bidi">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">unicode-bidi="<value-of select="."/>" should be 'normal', 'embed', 'bidi-override', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'embed', 'bidi-override', 'inherit'))">unicode-bidi="<value-of select="."/>". Allowed keywords are 'normal', 'embed', 'bidi-override', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">unicode-bidi="" should be 'normal', 'embed', 'bidi-override', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: unicode-bidi="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- vertical-align -->
   <!-- baseline | middle | sub | super | text-top | text-bottom | <percentage> | <length> | top | bottom | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#vertical-align -->
   <rule context="fo:*/@vertical-align">
      <report test=". eq ''" role="Warning">vertical-align="" should be 'baseline | middle | sub | super | text-top | text-bottom | &lt;percentage&gt; | &lt;length&gt; | top | bottom | inherit'.</report>
   </rule>

   <!-- visibility -->
   <!-- visible | hidden | collapse | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#visibility -->
   <rule context="fo:*/@visibility">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">visibility="<value-of select="."/>" should be 'visible', 'hidden', 'collapse', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'collapse', 'inherit'))">visibility="<value-of select="."/>". Allowed keywords are 'visible', 'hidden', 'collapse', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">visibility="" should be 'visible', 'hidden', 'collapse', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: visibility="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- white-space -->
   <!-- normal | pre | nowrap | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#white-space -->
   <rule context="fo:*/@white-space">
      <report test=". eq ''" role="Warning">white-space="" should be 'normal | pre | nowrap | inherit'.</report>
   </rule>

   <!-- white-space-collapse -->
   <!-- false | true | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#white-space-collapse -->
   <rule context="fo:*/@white-space-collapse">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">white-space-collapse="<value-of select="."/>" should be 'false', 'true', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">white-space-collapse="<value-of select="."/>". Allowed keywords are 'false', 'true', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">white-space-collapse="" should be 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: white-space-collapse="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- white-space-treatment -->
   <!-- ignore | preserve | ignore-if-before-linefeed | ignore-if-after-linefeed | ignore-if-surrounding-linefeed | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#white-space-treatment -->
   <rule context="fo:*/@white-space-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">white-space-treatment="<value-of select="."/>" should be 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', 'inherit'))">white-space-treatment="<value-of select="."/>". Allowed keywords are 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">white-space-treatment="" should be 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: white-space-treatment="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- widows -->
   <!-- <integer> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#widows -->
   <rule context="fo:*/@widows">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">widows="<value-of select="."/>" should be Number or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">widows="<value-of select="."/>". Allowed keywords are 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">widows="" should be Number or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: widows="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- width -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#width -->
   <rule context="fo:*/@width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">width="<value-of select="."/>" should be Length, Percent, 'auto', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">width="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">width="" should be Length, Percent, 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: width="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- word-spacing -->
   <!-- normal | <length> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#word-spacing -->
   <rule context="fo:*/@word-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">word-spacing="<value-of select="."/>" should be 'normal', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">word-spacing="<value-of select="."/>". Allowed keywords are 'normal' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">word-spacing="" should be 'normal', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: word-spacing="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- wrap-option -->
   <!-- no-wrap | wrap | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#wrap-option -->
   <rule context="fo:*/@wrap-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">wrap-option="<value-of select="."/>" should be 'no-wrap', 'wrap', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-wrap', 'wrap', 'inherit'))">wrap-option="<value-of select="."/>". Allowed keywords are 'no-wrap', 'wrap', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">wrap-option="" should be 'no-wrap', 'wrap', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: wrap-option="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- writing-mode -->
   <!-- lr-tb | rl-tb | tb-rl | tb-lr | bt-lr | bt-rl | lr-bt | rl-bt | lr-alternating-rl-bt | lr-alternating-rl-tb | lr-inverting-rl-bt | lr-inverting-rl-tb | tb-lr-in-lr-pairs | lr | rl | tb | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#writing-mode -->
   <rule context="fo:*/@writing-mode">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">writing-mode="<value-of select="."/>" should be 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', 'inherit'))">writing-mode="<value-of select="."/>". Allowed keywords are 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">writing-mode="" should be 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: writing-mode="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>

   <!-- xml.lang -->
   <!-- <language-country> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: yes -->
   <!-- http://www.w3.org/TR/xsl11/#xml.lang -->
   <rule context="fo:*/@xml.lang">
      <report test=". eq ''" role="Warning">xml.lang="" should be '&lt;language-country&gt; | inherit'.</report>
   </rule>

   <!-- z-index -->
   <!-- auto | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#z-index -->
   <rule context="fo:*/@z-index">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">z-index="<value-of select="."/>" should be 'auto', 'inherit', or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">z-index="<value-of select="."/>". Allowed keywords are 'auto' and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">z-index="" should be 'auto', 'inherit', or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: z-index="<value-of select="."/>":: <value-of select="$expression"/>
      </report>
   </rule>
</pattern><?DSDL_INCLUDE_END fo-property.sch?>
    <?DSDL_INCLUDE_START axf-fo.sch?><pattern id="axf-fo">

  <!-- axf:custom-property -->
  <!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.custom-property -->
  <rule context="axf:custom-property">
    <assert test="empty((../../axf:document-info, ../axf:document-info)[@name eq 'xmp'])" role="Warning"><value-of select="name()"/>" is ignored when axf:document-info with name="xmp" is present.</assert>
    <assert test="normalize-space(@name) ne ''" role="Warning">name="" should not be empty.</assert>
    <assert test="not(normalize-space(@name) = ('Title', 'Author', 'Subject', 'Keywords', 'Creator', 'Producer', 'CreationDate', 'ModDate', 'Trapped'))">name="<value-of select="@name"/>" cannot be used with <value-of select="name()"/>.</assert>
    <assert test="normalize-space(@value) ne ''" role="Warning">value="" should not be empty.</assert>
  </rule>

  <!-- axf:document-info -->
  <!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.document-info -->
  <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1">
    <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="Warning">name="<value-of select="@name"/>" is ignored when axf:document-info with name="xmp" is present.</assert>
  </rule>
  <rule context="axf:document-info[@name = 'title']">
    <assert test="false()" id="axf-3f" sqf:fix="axf-3fix" role="Warning">name="<value-of select="@name"/>" is deprecated.  Please use name="document-title".</assert>
    <sqf:fix id="axf-3fix">
      <sqf:description>
        <sqf:title>Change the 'title' axf:document-info into 'document-title'</sqf:title>
      </sqf:description>
      <sqf:replace match="@name" node-type="attribute" target="name" select="'document-title'"/>
    </sqf:fix>
  </rule>

  <!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#action-link -->
  <rule context="axf:form-field[@field-type = 'button']">
    <assert test="empty(@internal-destination) or exists(@internal-destination) and (empty(@action-type) or @action-type = 'goto')">'action-type' may only be 'goto' with &lt;axf:form-field field-type="button" internal-destiniation="..."&gt;</assert>
    <assert test="empty(@external-destination) or exists(@external-destination) and (empty(@action-type) or @action-type = ('gotor', 'launch', 'uri'))">'action-type' may only be 'gotor', 'launch', or 'uri' with &lt;axf:form-field field-type="button" external-destination="..."&gt;</assert>
    <report test="exists(@internal-destination) and exists(@external-destination)" role="Warning">An '<value-of select="name()"/>' should not have both 'internal-destination' and 'external-destination' properties.  Antenna House Formatter may report an error or may use 'internal-destination'.</report>
  </rule>
</pattern><?DSDL_INCLUDE_END axf-fo.sch?>
    <?DSDL_INCLUDE_START axf-property.sch?><pattern id="axf-property">

	<!-- axf:annotation-color -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.annotation-color -->
	<rule context="fo:*/@axf:annotation-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:annotation-color="<value-of select="."/>" should be Color or 'none'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">annotation-color="" should be Color or 'none'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: annotation-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:annotation-contents -->
	<!-- <contents> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.annotation-contents -->
	<rule context="fo:*/@axf:annotation-contents">
	  <assert test="normalize-space(../@axf:annotation-type) = ('Text', 'FreeText', 'Stamp', 'FileAttachment') or local-name(..) = 'basic-link'" role="Warning"><value-of select="name(.)"/> should be used only when @axf:annotation-type is 'Text', 'FreeText', 'Stamp', or 'FileAnnotation' or on fo:basic-link.</assert>
	</rule>

	<!-- axf:assumed-page-number -->
	<!-- <number> -->
	<!-- Inherited: yes -->
	<rule context="fo:*/@axf:assumed-page-number">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'axf:assumed-page-number should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'assumed-page-number="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-height">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">content-height="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-height="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type="" should be Literal or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-type="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-width -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="local-name()"/>="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))"><value-of select="local-name()"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="local-name()"/>="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="local-name()"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-image -->
	<rule context="fo:*/@axf:background-image">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-image="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">background-image="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-image="" should be URI or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-image="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-position -->
	<!-- [ [<percentage> | <length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-position-horizontal -->
	<rule context="fo:*/@axf:background-position-horizontal">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">background-position-horizontal="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-horizontal="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-position-vertical -->
	<!-- <percentage> | <length> | top | center | bottom -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-position-vertical -->
	<rule context="fo:*/@axf:background-position-vertical">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">background-position-vertical="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'top', 'center', or 'bottom'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-vertical="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-repeat -->
	<!-- repeat | repeat-x | repeat-y | no-repeat | paginate -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>"</report>
	</rule>

	<!-- axf:baseline-block-snap -->
	<!-- none | [auto | before | after | center] || [border-box | margin-box] -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.baseline-block-snap -->
	<rule context="fo:*/@axf:baseline-block-snap">
	  <assert test="exists(../@axf:baseline-grid) and normalize-space(../@axf:baseline-grid) = ('new', 'none')" role="Warning">axf:baseline-block-snap applies only when axf:baseline-grid is 'new' or 'none'.</assert>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:outline-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:outline-color="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:float -->
	<!-- <float-x> || <float-y> || <float-wrap> || <float-reference> || <float-move> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:float">
	  <let name="tokens" value="tokenize(normalize-space(.), '\s+')"/>
	  <assert test="every $token in $tokens satisfies matches($token, '^(after|alternate|auto|auto-move|auto-next|before|bottom|center|column|end|inside|keep|keep-float|left|multicol|next|none|normal|outside|page|right|skip|start|top|wrap)$')">Every token in 'axf:float' should be 'after', 'alternate', 'auto', 'auto-move', 'auto-next', 'before', 'bottom', 'center', 'column', 'end', 'inside', 'keep', 'keep-float', 'left', 'multicol', 'next', 'none', 'normal', 'outside', 'page', 'right', 'skip', 'start', 'top' or 'wrap'.  Value is '<value-of select="."/>'.</assert>
	  <assert test="every $token in $tokens satisfies count($tokens[. eq $token]) = 1">Tokens in 'axf:float' must not be repeated.  Value is '<value-of select="."/>'.</assert>
	</rule>

	<!-- axf:outline-level -->
	<!-- <number> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-level">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'axf:outline-level should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'outline-level="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- axf:background-content-width -->
	<rule context="fo:*/@axf:background-content-height | fo:*/@axf:background-content-width">
	  <report test="true()" role="Warning"><value-of select="name(.)"/> should not be used with Antenna House Formatter V6.6 or later.  Use axf:background-size with Antenna House Formatter V6.6 or later.</report>
	</rule>

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>"</report>
	</rule>

	<!-- axf:break-distance -->
	<!-- always | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.break-distance -->
	<rule context="fo:*/@axf:break-distance">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="local-name()"/>="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('always', 'inherit'))"><value-of select="local-name()"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'always' or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="local-name()"/>="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="local-name()"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:column-rule-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:column-rule-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:column-rule-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:column-rule-color="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:column-rule-length -->
	<!-- <length> | <percentage> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.column-rule-length -->
	<rule context="fo:*/@axf:column-rule-length">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:column-rule-length="<value-of select="."/>" should be Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:column-rule-length="" should be Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:column-rule-length="<value-of select="."/>"</report>
	</rule>

	<!-- axf:field-button-icon -->
	<!-- axf:field-button-icon-down -->
	<!-- axf:field-button-icon-rollover -->
	<!-- <uri-specification> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.field-button-icon -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.field-button-icon-down -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.field-button-icon-rollover -->
	<rule context="fo:*/@axf:field-button-icon |          fo:*/@axf:field-button-icon-down |          fo:*/@axf:field-button-icon-rollover">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EMPTY', 'ERROR', 'Object')">field-button-icon="<value-of select="."/>" should be URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="local-name(.)"/>="" should be URI.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="local-name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:field-font-size -->
	<!-- font-size | auto | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.field-font-size -->
	<rule context="fo:*/@axf:field-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY') or $expression/@value = '0'">axf:field-font-size="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('font-size', 'auto'))">axf:field-font-size="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'font-size' or 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:field-font-size="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:field-font-size="<value-of select="."/>"</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.hyphenation-zone -->
	<rule context="fo:*/@axf:hyphenation-zone">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY') or $expression/@value = '0'">axf:hyphenation-zone="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:hyphenation-zone="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:hyphenation-zone="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:hyphenation-zone="<value-of select="."/>"</report>
	  <report test="local-name($expression) = 'Length' and    (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or    $expression/@is-zero = 'yes')" id="axf.hyphenation-zone" role="Warning" sqf:fix="axf.hyphenation-zone-fix">axf:hyphenation-zone="<value-of select="."/>" should be a positive length.</report>
	  <sqf:fix id="axf.hyphenation-zone-fix">
	    <sqf:description>
              <sqf:title>Change the @axf:hyphenation-zone value to 'none'</sqf:title>
	    </sqf:description>
	    <sqf:replace node-type="attribute" target="axf:hyphenation-zone" select="'none'"/>
	  </sqf:fix>
	</rule>

	<!-- axf:indent-here -->
	<!-- none | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.indent-here -->
	<rule context="fo:*/@axf:indent-here">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY') or $expression/@value = '0'">axf:indent-here="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:indent-here="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:indent-here="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:indent-here="<value-of select="."/>"</report>
	</rule>

	<!-- axf:initial-letters-color -->
	<!-- <color> | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.initial-letters -->
	<rule context="fo:*/@axf:initial-letters-color">
	  <extends rule="color"/>
	</rule>

	<!-- axf:keep-together-within-dimension -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.keep-together-within-dimension -->
	<rule context="fo:*/@axf:keep-together-within-dimension">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY') or $expression/@value = '0'">axf:keep-together-within-dimension="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">axf:keep-together-within-dimension="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:keep-together-within-dimension="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:keep-together-within-dimension="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-background-color -->
	<!-- <color> | transparent -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-background-color -->
	<rule context="fo:*/@axf:line-number-background-color">
	  <extends rule="color-transparent"/>
	</rule>

	<!-- axf:line-number-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-color -->
	<rule context="fo:*/@axf:line-number-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be a Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be a Color or a color name.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-font-size -->
	<!-- <absolute-size> | <relative-size> | <length> | <percentage> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf:line-number-font-size -->
	<rule context="fo:*/@axf:line-number-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:line-number-font-size="<value-of select="."/>" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller'))">axf:line-number-font-size="<value-of select="."/>". Allowed keywords are 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', and 'smaller'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-font-size="" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-font-size="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-initial -->
	<!-- auto | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-initial -->
	<rule context="fo:*/@axf:line-number-initial">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-interval -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-interval -->
	<rule context="fo:*/@axf:line-number-interval">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-offset -->
	<!-- <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-offset -->
	<rule context="fo:*/@axf:line-number-offset">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR') or $expression/@value = '0'">axf:line-number-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-offset="" should be Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-offset="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-start -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-start -->
	<rule context="fo:*/@axf:line-number-start">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-text-decoration -->
	<!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-text-decoration -->
	<rule context="fo:*/@text-decoration">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration="<value-of select="."/>" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration="<value-of select="."/>". Allowed keywords are 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration="" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: text-decoration="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-width -->
	<!-- auto | <width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.line-number-width -->
	<rule context="fo:*/@axf:line-number-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-duration -->
	<!-- intrinsic | infinity | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-duration -->
	<rule context="fo:*/@axf:media-duration">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('intrinsic', 'infinity'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'intrinsic' or 'infinity'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	  <report test="../@axf:media-play-mode = 'once'" role="Warning"><value-of select="name(.)"/> is invalid when axf:media-play-mode="once" is specified.</report>
	</rule>

	<!-- axf:media-play-mode -->
	<!-- once | continuously | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-play-mode -->
	<rule context="fo:*/@axf:media-play-mode">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('once', 'continuously'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'once' or 'continuously'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-skin-color -->
	<!-- auto | <color> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-skin-color -->
	<rule context="fo:*/@axf:media-skin-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:media-skin-color="<value-of select="."/>" should be Color or 'auto'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">media-skin-color="" should be Color or 'auto'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: media-skin-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-volume -->
	<!-- <percentage> | <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-volume -->
	<rule context="fo:*/@axf:media-volume">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">media-volume="<value-of select="."/>" should be Percent, Number, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">media-volume="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be Percent, Number, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: media-volume="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-window-height -->
	<!-- axf:media-window-width -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-window-height -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.media-window-width -->
	<rule context="fo:*/@axf:media-window-height |          fo:*/@axf:media-window-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR') or $expression/@value = '0'"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:page-number-prefix -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.page-number-prefix -->
	<rule context="fo:*/@axf:page-number-prefix">
	  <report test="true()" sqf:fix="axf_page-number-prefix_fix" role="Warning">axf:page-number-prefix: A similar function is provided in XSL 1.1. Please use fo:folio-prefix.</report>
          <sqf:fix id="axf_page-number-prefix_fix">
	    <sqf:description>
              <sqf:title>Change @axf:page-number-prefix into fo:folio-prefix.</sqf:title>
            </sqf:description>
            <sqf:add node-type="element" target="fo:folio-prefix">
	      <value-of select="."/>
	    </sqf:add>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:poster-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.poster-content -->
	<rule context="fo:*/@axf:poster-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type="" should be Literal or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-type="<value-of select="."/>"</report>
	</rule>

	<!-- axf:poster-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.poster-image -->
	<rule context="fo:*/@axf:poster-image">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">poster-image="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto'))">poster-image="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">poster-image="" should be URI or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: poster-image="<value-of select="."/>"</report>
	</rule>

	<!-- axf:revision-bar-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.revision-bar-color -->
	<rule context="fo:*/@axf:revision-bar-color">
	  <report test="true()" sqf:fix="axf_revision-bar-color_fix" role="Warning">axf:revision-bar-color: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-color_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-color.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-offset -->
	<!-- <length> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.revision-bar-offset -->
	<rule context="fo:*/@axf:revision-bar-offset">
	  <report test="true()" sqf:fix="axf_revision-bar-offset_fix" role="Warning">axf:revision-bar-offset: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-offset_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-offset.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-position -->
	<!-- start | end | inside | outside | alternate | both -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.revision-bar-position -->
	<rule context="fo:*/@axf:revision-bar-position">
	  <report test="true()" sqf:fix="axf_revision-bar-position_fix" role="Warning">axf:revision-bar-position: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-position_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-position.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-style -->
	<!-- <border-style> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.revision-bar-style -->
	<rule context="fo:*/@axf:revision-bar-style">
	  <report test="true()" sqf:fix="axf_revision-bar-style_fix" role="Warning">axf:revision-bar-style: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-style_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-style.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-width -->
	<!-- <border-width> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.revision-bar-width -->
	<rule context="fo:*/@axf:revision-bar-width">
	  <report test="true()" sqf:fix="axf_revision-bar-width_fix" role="Warning">axf:revision-bar-width: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-width_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-width.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:suppress-duplicate-page-number -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.suppress-duplicate-page-number -->
	<rule context="fo:*/@axf:suppress-duplicate-page-number">
	  <report test="true()" sqf:fix="axf_suppress-duplicate-page-number_fix" role="Warning">axf:suppress-duplicate-page-number: A similar function is provided in XSL 1.1. Please use merge-*-index-key-references.</report>
          <sqf:fix id="axf_suppress-duplicate-page-number_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:suppress-duplicate-page-number.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:text-justify -->
	<!-- auto | inter-word | inter-character | distribute -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.text-justify -->
	<rule context="fo:*/@axf:text-justify">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY')">axf:text-justify="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inter-word', 'inter-character', 'distribute'))">axf:text-justify="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'inter-word', 'inter-character', or 'distribute'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-justify="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:text-justify="<value-of select="."/>"</report>
	  <report test="local-name($expression) = 'EnumerationToken' and    $expression/@token = 'distribute'" id="axf.text-justify" role="Warning" sqf:fix="axf.text-justify-fix">axf:text-justify="<value-of select="."/>" has been replaced by 'inter-character'.</report>
	  <sqf:fix id="axf.text-justify-fix">
	    <sqf:description>
              <sqf:title>Change the @axf:text-justify value to 'inter-character'</sqf:title>
	    </sqf:description>
	    <sqf:replace node-type="attribute" target="axf:text-justify" select="'inter-character'"/>
	  </sqf:fix>
	</rule>

	<!-- axf:text-line-color -->
	<!-- auto | <color> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.text-line-color -->
	<rule context="fo:*/@axf:text-line-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:text-line-color="<value-of select="."/>" should be Color or 'auto'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-line-color="" should be Color or 'auto'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: text-line-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:text-line-style -->
	<!-- <border-style> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.w3.org/TR/xsl11/#axf:text-line-style -->
	<rule context="fo:*/@axf:text-line-style">
	  <extends rule="border-style"/>
	</rule>

	<!-- axf:text-line-width -->
	<!-- auto | <border-width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.text-line-width -->
	<rule context="fo:*/@axf:text-line-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:text-line-width="<value-of select="."/>" should be 'auto', 'thin', 'medium', 'thick', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'thin', 'medium', 'thick', 'inherit'))">axf:text-line-width="<value-of select="."/>". Allowed keywords are 'auto', 'thin', 'medium', 'thick', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-line-width="" should be 'auto', 'thin', 'medium', 'thick', 'inherit', or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:text-line-width="<value-of select="."/>"</report>
	</rule>

   <!-- color-profile-name -->
   <!-- #CMYK | #Grayscale | #RGB -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color-profile-name -->
   <!-- https://www.docs.antennahouse.com/formatter/ahf-pdf.html#pdfx -->
   <rule context="fo:*/@color-profile-name">
      <let name="expression" value="normalize-space(.)"/>
      <report test="not($expression = ('#CMYK', '#Grayscale', '#RGB'))">color-profile-name="<value-of select="."/>". Allowed keywords are '#CMYK', '#Grayscale', and '#RGB'. Token is '<value-of select="$expression"/>'.</report>
   </rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- https://www.antenna.co.jp/AHF/help/en/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow="<value-of select="."/>" applies only on fo:block-container or fo:inline-container.</report>
	</rule>

</pattern><?DSDL_INCLUDE_END axf-property.sch?>

    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo"/>
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf"/>
    <ns uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf"/>

    <phase id="fo">
        <active pattern="fo-fo"/>
    </phase>
    <phase id="property">
        <active pattern="fo-property"/>
    </phase>
    <phase id="axf">
        <active pattern="axf-fo"/>
    </phase>
    <phase id="axf-prop">
        <active pattern="axf-property"/>
    </phase>
</schema><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->