<?xml version="1.0" encoding="UTF-8"?><!--
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
--><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <xsl:key name="flow-name" match="fo:flow | fo:static-content" use="@flow-name"/>
    <xsl:key name="master-name" match="fo:simple-page-master | fo:page-sequence-master" use="@master-name"/>
    <xsl:key name="region-name" match="fo:region-before | fo:region-after |       fo:region-start | fo:region-end |       fo:region-body" use="@region-name"/>

    <?DSDL_INCLUDE_START fo.sch?><pattern xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document" id="fo-fo">

  <!-- FOs -->

  <rule context="fo:float">
    <!-- http://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="exists(ancestor::fo:float) or exists(ancestor::fo:footnote)">An '<value-of select="local-name()"/>' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
  </rule>

  <rule context="fo:footnote">
    <!-- http://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">An '<value-of select="local-name()"/>' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</report>
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
    <assert test="exists(ancestor::fo:table-header) or                   exists(ancestor::fo:table-footer) or                   (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>

  <rule context="fo:root">
    <!-- http://www.w3.org/TR/xsl/#fo_root -->
    <assert id="fo_root-001" test="exists(descendant::fo:page-sequence)">There must be at least one fo:page-sequence descendant of fo:root.</assert>
  </rule>

  <!-- Properties -->

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and                   (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or                    $expression/@is-zero = 'yes' or                    exists($expression/@value) and not($expression/@value castable as xs:integer))" id="column-count" role="Warning"><value-of select="local-name()"/>="<value-of select="."/>" should be a positive integer.  A non-positive or non-integer value will be rounded to the nearest integer value greater than or equal to 1.</report>
  </rule>

  <rule context="fo:*/@column-width">
    <let name="number-columns-spanned" value="ahf:parser-runner(../@number-columns-spanned)"/>
    <report test="exists(../@number-columns-spanned) and     local-name($number-columns-spanned) = 'Number' and                   (exists($number-columns-spanned/@value) and      number($number-columns-spanned/@value) &gt;= 1.5)" id="column-width" role="Warning"><value-of select="local-name()"/> is ignored with 'number-columns-spanned' is present and has a value greater than 1.</report>
  </rule>

  <rule context="fo:*/@flow-map-reference">
    <!-- http://www.w3.org/TR/xsl11/#flow-map-reference -->
    <report test="empty(/fo:root/fo:layout-master-set/fo:flow-map/@flow-map-name[. eq current()])">flow-map-reference="<value-of select="."/>" does not match any fo:flow-map name.</report>
  </rule>

  <rule context="fo:*/@flow-name">
    <!-- http://www.w3.org/TR/xsl11/#flow-name -->
    <assert test="count(../../*/@flow-name[. eq current()]) = 1">flow-name="<value-of select="."/>" must be unique within its fo:page-sequence.</assert>
    <report test="not(. = ('xsl-region-body',          'xsl-region-start',          'xsl-region-end',          'xsl-region-before',          'xsl-region-after')) and               empty(key('region-name', .)) and               empty(/fo:root/fo:layout-master-set/fo:flow-map[@flow-map-name = current()/ancestor::fo:page-sequence[1]/@flow-map-reference]/fo:flow-assignment/fo:flow-source-list/fo:flow-name-specifier/@flow-name-reference[. eq current()])" role="Warning">flow-name="<value-of select="."/>" does not match any named or default region-name or a flow-name-reference.</report>
  </rule>

  <rule context="fo:*/@flow-name-reference">
    <!-- http://www.w3.org/TR/xsl11/#flow-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]) = 1">flow-name-reference="<value-of select="., ancestor::fo-flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]"/>" must be unique within its fo:flow-map.</assert>
    <!-- http://www.w3.org/TR/xsl11/#fo_flow-source-list -->
    <!-- These flows must be either all fo:flow formatting objects or
         all fo:static-content formatting objects. -->
    <assert test="count(distinct-values(for $fo in key('flow-name', .)[ancestor::fo:page-sequence/@flow-map-reference = current()/ancestor::fo:flow-map/@flow-map-name] return local-name($fo))) = 1" role="Warning">flow-name-reference="<value-of select="."/>" should only be used with all fo:flow or all fo:static-content.</assert>
  </rule>

  <rule context="fo:*/@language">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <!-- What would be generated if we could... -->
    <!-- http://www.w3.org/TR/xsl11/#language -->
    <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">language="<value-of select="."/>" should be an EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit') or string-length($expression/@token) = 2 or string-length($expression/@token) = 3)">language="<value-of select="."/>" should be a 3-letter code conforming to a ISO639-2 terminology or bibliographic code or a 2-letter code conforming to a ISO639 2-letter code or 'none' or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: 'language="<value-of select="."/>"'</report>
    <!-- http://www.w3.org/TR/xsl11/#d0e4626 -->
    <report test="$expression instance of element(EnumerationToken) and string-length($expression/@token) = 2" id="language_2-letter" role="Warning">language="<value-of select="."/>" uses a 2-letter code.  A 2-letter code in conformance with ISO639 will be converted to the corresponding 3-letter ISO639-2 terminology code.</report>
    <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('mul', 'none')" id="language_und" role="Warning">language="<value-of select="."/>" will be converted to 'und'.</report>
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

  <rule context="fo:*/@region-name-reference">
    <!-- http://www.w3.org/TR/xsl11/#region-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:region-name-specifier/@region-name-reference[. eq current()]) = 1">region-name-reference="<value-of select="."/>" must be unique within its fo:flow-map.</assert>
  </rule>

</pattern><?DSDL_INCLUDE_END fo.sch?>
    <?DSDL_INCLUDE_START fo-property.sch?><pattern xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" id="fo-property">
   <xsl:include href="file:/E:/Projects/oxygen/focheck/xsl/parser-runner.xsl"/>

   <!-- absolute-position -->
   <!-- auto | absolute | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#absolute-position -->
   <rule context="fo:*/@absolute-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">absolute-position="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'absolute', 'fixed', 'inherit'))">absolute-position="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'absolute', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">absolute-position="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: absolute-position="<value-of select="."/>"</report>
   </rule>

   <!-- active-state -->
   <!-- link | visited | active | hover | focus -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#active-state -->
   <rule context="fo:*/@active-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">active-state="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'visited', 'active', 'hover', 'focus'))">active-state="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'link', 'visited', 'active', 'hover', or 'focus'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">active-state="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: active-state="<value-of select="."/>"</report>
   </rule>

   <!-- alignment-adjust -->
   <!-- auto | baseline | before-edge | text-before-edge | middle | central | after-edge | text-after-edge | ideographic | alphabetic | hanging | mathematical | <percentage> | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#alignment-adjust -->
   <rule context="fo:*/@alignment-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'EMPTY', 'ERROR', 'Object')">alignment-adjust="<value-of select="."/>" should be EnumerationToken, Percent, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">alignment-adjust="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">alignment-adjust="" should be EnumerationToken, Percent, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: alignment-adjust="<value-of select="."/>"</report>
   </rule>

   <!-- alignment-baseline -->
   <!-- auto | baseline | before-edge | text-before-edge | middle | central | after-edge | text-after-edge | ideographic | alphabetic | hanging | mathematical | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#alignment-baseline -->
   <rule context="fo:*/@alignment-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">alignment-baseline="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">alignment-baseline="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">alignment-baseline="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: alignment-baseline="<value-of select="."/>"</report>
   </rule>

   <!-- allowed-height-scale -->
   <!-- [ any | <percentage> ]* | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#allowed-height-scale -->
   <rule context="fo:*/@allowed-height-scale">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'EMPTY', 'ERROR', 'Object')">allowed-height-scale="<value-of select="."/>" should be EnumerationToken or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">allowed-height-scale="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'any' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">allowed-height-scale="" should be EnumerationToken or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: allowed-height-scale="<value-of select="."/>"</report>
   </rule>

   <!-- allowed-width-scale -->
   <!-- [ any | <percentage> ]* | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#allowed-width-scale -->
   <rule context="fo:*/@allowed-width-scale">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'EMPTY', 'ERROR', 'Object')">allowed-width-scale="<value-of select="."/>" should be EnumerationToken or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">allowed-width-scale="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'any' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">allowed-width-scale="" should be EnumerationToken or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: allowed-width-scale="<value-of select="."/>"</report>
   </rule>

   <!-- auto-restore -->
   <!-- true | false -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#auto-restore -->
   <rule context="fo:*/@auto-restore">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">auto-restore="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">auto-restore="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">auto-restore="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: auto-restore="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-attachment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('scroll', 'fixed', 'inherit'))">background-attachment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'scroll', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-attachment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-attachment="<value-of select="."/>"</report>
   </rule>

   <!-- background-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-color -->
   <rule context="fo:*/@background-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>"</report>
   </rule>

   <!-- background-image -->
   <!-- <uri-specification> | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-image -->
   <rule context="fo:*/@background-image">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-image="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">background-image="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-image="" should be URI or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-image="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-horizontal="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal="" should be Percent, Length, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-horizontal="<value-of select="."/>"</report>
   </rule>

   <!-- background-position-vertical -->
   <!-- <percentage> | <length> | top | center | bottom | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-position-vertical -->
   <rule context="fo:*/@background-position-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-vertical="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'top', 'center', 'bottom', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical="" should be Percent, Length, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-vertical="<value-of select="."/>"</report>
   </rule>

   <!-- background-repeat -->
   <!-- repeat | repeat-x | repeat-y | no-repeat | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#background-repeat -->
   <rule context="fo:*/@background-repeat">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'inherit'))">background-repeat="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>"</report>
   </rule>

   <!-- baseline-shift -->
   <!-- baseline | sub | super | <percentage> | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#baseline-shift -->
   <rule context="fo:*/@baseline-shift">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'EMPTY', 'ERROR', 'Object')">baseline-shift="<value-of select="."/>" should be EnumerationToken, Percent, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('baseline', 'sub', 'super', 'inherit'))">baseline-shift="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'baseline', 'sub', 'super', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">baseline-shift="" should be EnumerationToken, Percent, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: baseline-shift="<value-of select="."/>"</report>
   </rule>

   <!-- blank-or-not-blank -->
   <!-- blank | not-blank | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#blank-or-not-blank -->
   <rule context="fo:*/@blank-or-not-blank">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">blank-or-not-blank="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('blank', 'not-blank', 'any', 'inherit'))">blank-or-not-blank="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'blank', 'not-blank', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">blank-or-not-blank="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: blank-or-not-blank="<value-of select="."/>"</report>
   </rule>

   <!-- block-progression-dimension -->
   <!-- auto | <length> | <percentage> | <length-range> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#block-progression-dimension -->
   <rule context="fo:*/@block-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">block-progression-dimension="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">block-progression-dimension="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">block-progression-dimension="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: block-progression-dimension="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-after-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-after-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-after-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-after-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-precedence -->
   <rule context="fo:*/@border-after-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-after-precedence="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-after-precedence="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-after-precedence="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-after-precedence="<value-of select="."/>"</report>
   </rule>

   <!-- border-after-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-style -->
   <rule context="fo:*/@border-after-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-after-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-after-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-after-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-after-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-after-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-after-width -->
   <rule context="fo:*/@border-after-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-after-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-after-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-after-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-after-width="<value-of select="."/>"</report>
   </rule>

   <!-- border-before-color -->
   <!-- <color> | transparent | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-color -->
   <rule context="fo:*/@border-before-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-before-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-before-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-before-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-before-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-precedence -->
   <rule context="fo:*/@border-before-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-before-precedence="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-before-precedence="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-before-precedence="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-before-precedence="<value-of select="."/>"</report>
   </rule>

   <!-- border-before-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-style -->
   <rule context="fo:*/@border-before-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-before-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-before-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-before-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-before-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-before-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-before-width -->
   <rule context="fo:*/@border-before-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-before-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-before-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-before-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-before-width="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-bottom-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-bottom-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-bottom-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-bottom-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom-style -->
   <rule context="fo:*/@border-bottom-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-bottom-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-bottom-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-bottom-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-bottom-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-bottom-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-bottom-width -->
   <rule context="fo:*/@border-bottom-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-bottom-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-bottom-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-bottom-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-bottom-width="<value-of select="."/>"</report>
   </rule>

   <!-- border-collapse -->
   <!-- collapse | collapse-with-precedence | separate | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-collapse -->
   <rule context="fo:*/@border-collapse">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-collapse="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('collapse', 'collapse-with-precedence', 'separate', 'inherit'))">border-collapse="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'collapse', 'collapse-with-precedence', 'separate', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-collapse="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-collapse="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-end-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-end-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-end-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-end-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-precedence -->
   <rule context="fo:*/@border-end-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-end-precedence="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-end-precedence="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-end-precedence="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-end-precedence="<value-of select="."/>"</report>
   </rule>

   <!-- border-end-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-style -->
   <rule context="fo:*/@border-end-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-end-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-end-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-end-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-end-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-end-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-end-width -->
   <rule context="fo:*/@border-end-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-end-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-end-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-end-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-end-width="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-left-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-left-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-left-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-left-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-left-style -->
   <rule context="fo:*/@border-left-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-left-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-left-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-left-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-left-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-left-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-left-width -->
   <rule context="fo:*/@border-left-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-left-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-left-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-left-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-left-width="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-right-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-right-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-right-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-right-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-right-style -->
   <rule context="fo:*/@border-right-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-right-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-right-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-right-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-right-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-right-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-right-width -->
   <rule context="fo:*/@border-right-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-right-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-right-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-right-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-right-width="<value-of select="."/>"</report>
   </rule>

   <!-- border-separation -->
   <!-- <length-bp-ip-direction> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-separation -->
   <rule context="fo:*/@border-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-separation="<value-of select="."/>" should be Length or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">border-separation="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-separation="" should be Length or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-separation="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-start-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-start-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-start-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-start-precedence -->
   <!-- force | <integer> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-precedence -->
   <rule context="fo:*/@border-start-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">border-start-precedence="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">border-start-precedence="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-start-precedence="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-start-precedence="<value-of select="."/>"</report>
   </rule>

   <!-- border-start-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-style -->
   <rule context="fo:*/@border-start-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-start-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-start-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-start-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-start-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-start-width -->
   <!-- <border-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-start-width -->
   <rule context="fo:*/@border-start-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-start-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-start-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-start-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-start-width="<value-of select="."/>"</report>
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
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-top-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-top-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-top-color="<value-of select="."/>"</report>
   </rule>

   <!-- border-top-style -->
   <!-- <border-style> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-style -->
   <rule context="fo:*/@border-top-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">border-top-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">border-top-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-top-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-top-style="<value-of select="."/>"</report>
   </rule>

   <!-- border-top-width -->
   <!-- <border-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width -->
   <rule context="fo:*/@border-top-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">border-top-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">border-top-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">border-top-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: border-top-width="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">bottom="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">bottom="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">bottom="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: bottom="<value-of select="."/>"</report>
   </rule>

   <!-- break-after -->
   <!-- auto | column | page | even-page | odd-page | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#break-after -->
   <rule context="fo:*/@break-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">break-after="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">break-after="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">break-after="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: break-after="<value-of select="."/>"</report>
   </rule>

   <!-- break-before -->
   <!-- auto | column | page | even-page | odd-page | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#break-before -->
   <rule context="fo:*/@break-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">break-before="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">break-before="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">break-before="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: break-before="<value-of select="."/>"</report>
   </rule>

   <!-- caption-side -->
   <!-- before | after | start | end | top | bottom | left | right | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#caption-side -->
   <rule context="fo:*/@caption-side">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">caption-side="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', 'inherit'))">caption-side="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">caption-side="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: caption-side="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: case-name="<value-of select="."/>"</report>
   </rule>

   <!-- case-title -->
   <!-- <string> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#case-title -->
   <rule context="fo:*/@case-title">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EMPTY', 'ERROR', 'Object')">case-title="<value-of select="."/>" should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">case-title="" should be Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: case-title="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-class="<value-of select="."/>"</report>
   </rule>

   <!-- change-bar-color -->
   <!-- <color> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-color -->
   <rule context="fo:*/@change-bar-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-color="<value-of select="."/>"</report>
   </rule>

   <!-- change-bar-offset -->
   <!-- <length> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-offset -->
   <rule context="fo:*/@change-bar-offset">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object')">change-bar-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-offset="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-offset="<value-of select="."/>"</report>
   </rule>

   <!-- change-bar-placement -->
   <!-- start | end | left | right | inside | outside | alternate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-placement -->
   <rule context="fo:*/@change-bar-placement">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-placement="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'alternate'))">change-bar-placement="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', or 'alternate'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-placement="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-placement="<value-of select="."/>"</report>
   </rule>

   <!-- change-bar-style -->
   <!-- <border-style> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-style -->
   <rule context="fo:*/@change-bar-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">change-bar-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset'))">change-bar-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', or 'outset'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-style="<value-of select="."/>"</report>
   </rule>

   <!-- change-bar-width -->
   <!-- <border-width> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#change-bar-width -->
   <rule context="fo:*/@change-bar-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">change-bar-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick'))">change-bar-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', or 'thick'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">change-bar-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: change-bar-width="<value-of select="."/>"</report>
   </rule>

   <!-- character -->
   <!-- <character> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#character -->
   <rule context="fo:*/@character">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EMPTY', 'ERROR', 'Object')">character="<value-of select="."/>" should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">character="" should be Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: character="<value-of select="."/>"</report>
   </rule>

   <!-- clear -->
   <!-- start | end | left | right | inside | outside | both | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#clear -->
   <rule context="fo:*/@clear">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">clear="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', 'inherit'))">clear="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">clear="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: clear="<value-of select="."/>"</report>
   </rule>

   <!-- clip -->
   <!-- <shape> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#clip -->
   <rule context="fo:*/@clip">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Function', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">clip="<value-of select="."/>" should be Function or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">clip="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">clip="" should be Function or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: clip="<value-of select="."/>"</report>
   </rule>

   <!-- color -->
   <!-- <color> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color -->
   <rule context="fo:*/@color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">color="" should be Color or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: color="<value-of select="."/>"</report>
   </rule>

   <!-- color-profile-name -->
   <!-- <name> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color-profile-name -->
   <rule context="fo:*/@color-profile-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">color-profile-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">color-profile-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: color-profile-name="<value-of select="."/>"</report>
   </rule>

   <!-- column-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-count -->
   <rule context="fo:*/@column-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">column-count="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">column-count="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-count="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-count="<value-of select="."/>"</report>
   </rule>

   <!-- column-gap -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-gap -->
   <rule context="fo:*/@column-gap">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">column-gap="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">column-gap="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-gap="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-gap="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-number="<value-of select="."/>"</report>
   </rule>

   <!-- column-width -->
   <!-- <length> | <percentage> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#column-width -->
   <rule context="fo:*/@column-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">column-width="<value-of select="."/>" should be Length or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">column-width="" should be Length or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: column-width="<value-of select="."/>"</report>
   </rule>

   <!-- content-height -->
   <!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-height -->
   <rule context="fo:*/@content-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-height="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: content-height="<value-of select="."/>"</report>
   </rule>

   <!-- content-type -->
   <!-- <string> | auto -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-type -->
   <rule context="fo:*/@content-type">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type="" should be Literal or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: content-type="<value-of select="."/>"</report>
   </rule>

   <!-- content-width -->
   <!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#content-width -->
   <rule context="fo:*/@content-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: content-width="<value-of select="."/>"</report>
   </rule>

   <!-- country -->
   <!-- none | <country> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#country -->
   <rule context="fo:*/@country">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'EMPTY', 'ERROR', 'Object')">country="<value-of select="."/>" should be EnumerationToken or Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">country="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">country="" should be EnumerationToken or Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: country="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object')">destination-placement-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">destination-placement-offset="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: destination-placement-offset="<value-of select="."/>"</report>
   </rule>

   <!-- direction -->
   <!-- ltr | rtl | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#direction -->
   <rule context="fo:*/@direction">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">direction="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ltr', 'rtl', 'inherit'))">direction="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'ltr', 'rtl', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">direction="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: direction="<value-of select="."/>"</report>
   </rule>

   <!-- display-align -->
   <!-- auto | before | center | after | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#display-align -->
   <rule context="fo:*/@display-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">display-align="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'before', 'center', 'after', 'inherit'))">display-align="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'before', 'center', 'after', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">display-align="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: display-align="<value-of select="."/>"</report>
   </rule>

   <!-- dominant-baseline -->
   <!-- auto | use-script | no-change | reset-size | ideographic | alphabetic | hanging | mathematical | central | middle | text-after-edge | text-before-edge | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#dominant-baseline -->
   <rule context="fo:*/@dominant-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">dominant-baseline="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', 'inherit'))">dominant-baseline="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">dominant-baseline="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: dominant-baseline="<value-of select="."/>"</report>
   </rule>

   <!-- empty-cells -->
   <!-- show | hide | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#empty-cells -->
   <rule context="fo:*/@empty-cells">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">empty-cells="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide', 'inherit'))">empty-cells="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'show', 'hide', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">empty-cells="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: empty-cells="<value-of select="."/>"</report>
   </rule>

   <!-- end-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#end-indent -->
   <rule context="fo:*/@end-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">end-indent="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">end-indent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">end-indent="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: end-indent="<value-of select="."/>"</report>
   </rule>

   <!-- ends-row -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#ends-row -->
   <rule context="fo:*/@ends-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">ends-row="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">ends-row="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">ends-row="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: ends-row="<value-of select="."/>"</report>
   </rule>

   <!-- extent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#extent -->
   <rule context="fo:*/@extent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">extent="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">extent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">extent="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: extent="<value-of select="."/>"</report>
   </rule>

   <!-- external-destination -->
   <!-- empty string | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#external-destination -->
   <rule context="fo:*/@external-destination">
      <report test=". eq ''" role="Warning">external-destination="" should be 'empty string | &lt;uri-specification&gt;'.</report>
   </rule>

   <!-- float -->
   <!-- before | start | end | left | right | inside | outside | none | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#float -->
   <rule context="fo:*/@float">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">float="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', 'inherit'))">float="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">float="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: float="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-map-name="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-map-reference="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-name="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: flow-name-reference="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-selection-strategy="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'character-by-character', 'inherit'))">font-selection-strategy="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'character-by-character', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-selection-strategy="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-selection-strategy="<value-of select="."/>"</report>
   </rule>

   <!-- font-size -->
   <!-- <absolute-size> | <relative-size> | <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-size -->
   <rule context="fo:*/@font-size">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">font-size="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit'))">font-size="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-size="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-size="<value-of select="."/>"</report>
   </rule>

   <!-- font-size-adjust -->
   <!-- <number> | none | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-size-adjust -->
   <rule context="fo:*/@font-size-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-size-adjust="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">font-size-adjust="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-size-adjust="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-size-adjust="<value-of select="."/>"</report>
   </rule>

   <!-- font-stretch -->
   <!-- normal | wider | narrower | ultra-condensed | extra-condensed | condensed | semi-condensed | semi-expanded | expanded | extra-expanded | ultra-expanded | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-stretch -->
   <rule context="fo:*/@font-stretch">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'EMPTY', 'ERROR', 'Object')">font-stretch="<value-of select="."/>" should be EnumerationToken or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit'))">font-stretch="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-stretch="" should be EnumerationToken or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-stretch="<value-of select="."/>"</report>
   </rule>

   <!-- font-style -->
   <!-- normal | italic | oblique | backslant | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-style -->
   <rule context="fo:*/@font-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'italic', 'oblique', 'backslant', 'inherit'))">font-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'italic', 'oblique', 'backslant', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-style="<value-of select="."/>"</report>
   </rule>

   <!-- font-variant -->
   <!-- normal | small-caps | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-variant -->
   <rule context="fo:*/@font-variant">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">font-variant="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'small-caps', 'inherit'))">font-variant="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'small-caps', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-variant="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-variant="<value-of select="."/>"</report>
   </rule>

   <!-- font-weight -->
   <!-- normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#font-weight -->
   <rule context="fo:*/@font-weight">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">font-weight="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'bold', 'bolder', 'lighter', 'inherit'))">font-weight="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'bold', 'bolder', 'lighter', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">font-weight="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: font-weight="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">glyph-orientation-horizontal="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">glyph-orientation-horizontal="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">glyph-orientation-horizontal="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: glyph-orientation-horizontal="<value-of select="."/>"</report>
   </rule>

   <!-- glyph-orientation-vertical -->
   <!-- auto | <angle> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#glyph-orientation-vertical -->
   <rule context="fo:*/@glyph-orientation-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">glyph-orientation-vertical="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">glyph-orientation-vertical="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">glyph-orientation-vertical="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: glyph-orientation-vertical="<value-of select="."/>"</report>
   </rule>

   <!-- grouping-separator -->
   <!-- <character> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#grouping-separator -->
   <rule context="fo:*/@grouping-separator">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EMPTY', 'ERROR', 'Object')">grouping-separator="<value-of select="."/>" should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">grouping-separator="" should be Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: grouping-separator="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: grouping-size="<value-of select="."/>"</report>
   </rule>

   <!-- height -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#height -->
   <rule context="fo:*/@height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">height="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">height="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: height="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenate -->
   <!-- false | true | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenate -->
   <rule context="fo:*/@hyphenate">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenate="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">hyphenate="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenate="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenate="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenation-character -->
   <!-- <character> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-character -->
   <rule context="fo:*/@hyphenation-character">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-character="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">hyphenation-character="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-character="" should be Literal or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-character="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenation-keep -->
   <!-- auto | column | page | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-keep -->
   <rule context="fo:*/@hyphenation-keep">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-keep="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'inherit'))">hyphenation-keep="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-keep="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-keep="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenation-ladder-count -->
   <!-- no-limit | <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-ladder-count -->
   <rule context="fo:*/@hyphenation-ladder-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">hyphenation-ladder-count="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">hyphenation-ladder-count="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'no-limit' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-ladder-count="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-ladder-count="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenation-push-character-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-push-character-count -->
   <rule context="fo:*/@hyphenation-push-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-push-character-count="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">hyphenation-push-character-count="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-push-character-count="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-push-character-count="<value-of select="."/>"</report>
   </rule>

   <!-- hyphenation-remain-character-count -->
   <!-- <number> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#hyphenation-remain-character-count -->
   <rule context="fo:*/@hyphenation-remain-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">hyphenation-remain-character-count="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">hyphenation-remain-character-count="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">hyphenation-remain-character-count="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: hyphenation-remain-character-count="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Literal', 'EMPTY', 'ERROR', 'Object')">index-class="<value-of select="."/>" should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">index-class="" should be Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: index-class="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">indicate-destination="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">indicate-destination="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">indicate-destination="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: indicate-destination="<value-of select="."/>"</report>
   </rule>

   <!-- initial-page-number -->
   <!-- auto | auto-odd | auto-even | <number> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#initial-page-number -->
   <rule context="fo:*/@initial-page-number">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">initial-page-number="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'auto-odd', 'auto-even', 'inherit'))">initial-page-number="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'auto-odd', 'auto-even', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">initial-page-number="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: initial-page-number="<value-of select="."/>"</report>
   </rule>

   <!-- inline-progression-dimension -->
   <!-- auto | <length> | <percentage> | <length-range> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#inline-progression-dimension -->
   <rule context="fo:*/@inline-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">inline-progression-dimension="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">inline-progression-dimension="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">inline-progression-dimension="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: inline-progression-dimension="<value-of select="."/>"</report>
   </rule>

   <!-- internal-destination -->
   <!-- empty string | <idref> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#internal-destination -->
   <rule context="fo:*/@internal-destination">
      <report test=". eq ''" role="Warning">internal-destination="" should be 'empty string | &lt;idref&gt;'.</report>
   </rule>

   <!-- intrinsic-scale-value -->
   <!-- <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#intrinsic-scale-value -->
   <rule context="fo:*/@intrinsic-scale-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">intrinsic-scale-value="<value-of select="."/>" should be Percent or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">intrinsic-scale-value="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">intrinsic-scale-value="" should be Percent or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: intrinsic-scale-value="<value-of select="."/>"</report>
   </rule>

   <!-- intrusion-displace -->
   <!-- auto | none | line | indent | block | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#intrusion-displace -->
   <rule context="fo:*/@intrusion-displace">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">intrusion-displace="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'none', 'line', 'indent', 'block', 'inherit'))">intrusion-displace="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'none', 'line', 'indent', 'block', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">intrusion-displace="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: intrusion-displace="<value-of select="."/>"</report>
   </rule>

   <!-- keep-together -->
   <!-- <keep> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-together -->
   <rule context="fo:*/@keep-together">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-together="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-together="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-together="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-together="<value-of select="."/>"</report>
   </rule>

   <!-- keep-with-next -->
   <!-- <keep> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-with-next -->
   <rule context="fo:*/@keep-with-next">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-with-next="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-with-next="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-with-next="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-with-next="<value-of select="."/>"</report>
   </rule>

   <!-- keep-with-previous -->
   <!-- <keep> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#keep-with-previous -->
   <rule context="fo:*/@keep-with-previous">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">keep-with-previous="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">keep-with-previous="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">keep-with-previous="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: keep-with-previous="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">last-line-end-indent="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">last-line-end-indent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">last-line-end-indent="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: last-line-end-indent="<value-of select="."/>"</report>
   </rule>

   <!-- leader-alignment -->
   <!-- none | reference-area | page | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-alignment -->
   <rule context="fo:*/@leader-alignment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">leader-alignment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'reference-area', 'page', 'inherit'))">leader-alignment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'reference-area', 'page', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-alignment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-alignment="<value-of select="."/>"</report>
   </rule>

   <!-- leader-length -->
   <!-- <length-range> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-length -->
   <rule context="fo:*/@leader-length">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">leader-length="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">leader-length="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-length="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-length="<value-of select="."/>"</report>
   </rule>

   <!-- leader-pattern -->
   <!-- space | rule | dots | use-content | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-pattern -->
   <rule context="fo:*/@leader-pattern">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">leader-pattern="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('space', 'rule', 'dots', 'use-content', 'inherit'))">leader-pattern="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'space', 'rule', 'dots', 'use-content', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-pattern="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-pattern="<value-of select="."/>"</report>
   </rule>

   <!-- leader-pattern-width -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#leader-pattern-width -->
   <rule context="fo:*/@leader-pattern-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">leader-pattern-width="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">leader-pattern-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">leader-pattern-width="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: leader-pattern-width="<value-of select="."/>"</report>
   </rule>

   <!-- left -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#left -->
   <rule context="fo:*/@left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">left="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">left="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">left="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: left="<value-of select="."/>"</report>
   </rule>

   <!-- letter-spacing -->
   <!-- normal | <length> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#letter-spacing -->
   <rule context="fo:*/@letter-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">letter-spacing="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">letter-spacing="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">letter-spacing="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: letter-spacing="<value-of select="."/>"</report>
   </rule>

   <!-- letter-value -->
   <!-- auto | alphabetic | traditional -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#letter-value -->
   <rule context="fo:*/@letter-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">letter-value="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'alphabetic', 'traditional'))">letter-value="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'alphabetic', or 'traditional'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">letter-value="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: letter-value="<value-of select="."/>"</report>
   </rule>

   <!-- line-height -->
   <!-- normal | <length> | <number> | <percentage> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-height -->
   <rule context="fo:*/@line-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'EMPTY', 'ERROR', 'Object')">line-height="<value-of select="."/>" should be EnumerationToken, Length, Number, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">line-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-height="" should be EnumerationToken, Length, Number, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-height="<value-of select="."/>"</report>
   </rule>

   <!-- line-height-shift-adjustment -->
   <!-- consider-shifts | disregard-shifts | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-height-shift-adjustment -->
   <rule context="fo:*/@line-height-shift-adjustment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">line-height-shift-adjustment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('consider-shifts', 'disregard-shifts', 'inherit'))">line-height-shift-adjustment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'consider-shifts', 'disregard-shifts', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-height-shift-adjustment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-height-shift-adjustment="<value-of select="."/>"</report>
   </rule>

   <!-- line-stacking-strategy -->
   <!-- line-height | font-height | max-height | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#line-stacking-strategy -->
   <rule context="fo:*/@line-stacking-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">line-stacking-strategy="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('line-height', 'font-height', 'max-height', 'inherit'))">line-stacking-strategy="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'line-height', 'font-height', 'max-height', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">line-stacking-strategy="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: line-stacking-strategy="<value-of select="."/>"</report>
   </rule>

   <!-- linefeed-treatment -->
   <!-- ignore | preserve | treat-as-space | treat-as-zero-width-space | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#linefeed-treatment -->
   <rule context="fo:*/@linefeed-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">linefeed-treatment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', 'inherit'))">linefeed-treatment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">linefeed-treatment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: linefeed-treatment="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">margin-bottom="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-bottom="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-bottom="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-bottom="<value-of select="."/>"</report>
   </rule>

   <!-- margin-left -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-left -->
   <rule context="fo:*/@margin-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">margin-left="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-left="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-left="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-left="<value-of select="."/>"</report>
   </rule>

   <!-- margin-right -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-right -->
   <rule context="fo:*/@margin-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">margin-right="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-right="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-right="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-right="<value-of select="."/>"</report>
   </rule>

   <!-- margin-top -->
   <!-- <margin-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#margin-top -->
   <rule context="fo:*/@margin-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">margin-top="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">margin-top="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">margin-top="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: margin-top="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: marker-class-name="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: master-name="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: master-reference="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">maximum-repeats="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">maximum-repeats="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'no-limit' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">maximum-repeats="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: maximum-repeats="<value-of select="."/>"</report>
   </rule>

   <!-- media-usage -->
   <!-- auto | paginate | bounded-in-one-dimension | unbounded -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#media-usage -->
   <rule context="fo:*/@media-usage">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">media-usage="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'paginate', 'bounded-in-one-dimension', 'unbounded'))">media-usage="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'paginate', 'bounded-in-one-dimension', or 'unbounded'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">media-usage="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: media-usage="<value-of select="."/>"</report>
   </rule>

   <!-- merge-pages-across-index-key-references -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-pages-across-index-key-references -->
   <rule context="fo:*/@merge-pages-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-pages-across-index-key-references="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-pages-across-index-key-references="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-pages-across-index-key-references="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-pages-across-index-key-references="<value-of select="."/>"</report>
   </rule>

   <!-- merge-ranges-across-index-key-references -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-ranges-across-index-key-references -->
   <rule context="fo:*/@merge-ranges-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-ranges-across-index-key-references="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-ranges-across-index-key-references="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-ranges-across-index-key-references="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-ranges-across-index-key-references="<value-of select="."/>"</report>
   </rule>

   <!-- merge-sequential-page-numbers -->
   <!-- merge | leave-separate -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#merge-sequential-page-numbers -->
   <rule context="fo:*/@merge-sequential-page-numbers">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">merge-sequential-page-numbers="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">merge-sequential-page-numbers="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">merge-sequential-page-numbers="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: merge-sequential-page-numbers="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-columns-repeated="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-columns-spanned="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: number-rows-spanned="<value-of select="."/>"</report>
   </rule>

   <!-- odd-or-even -->
   <!-- odd | even | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#odd-or-even -->
   <rule context="fo:*/@odd-or-even">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">odd-or-even="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('odd', 'even', 'any', 'inherit'))">odd-or-even="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'odd', 'even', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">odd-or-even="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: odd-or-even="<value-of select="."/>"</report>
   </rule>

   <!-- orphans -->
   <!-- <integer> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#orphans -->
   <rule context="fo:*/@orphans">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">orphans="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">orphans="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">orphans="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: orphans="<value-of select="."/>"</report>
   </rule>

   <!-- overflow -->
   <!-- visible | hidden | scroll | error-if-overflow | repeat | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#overflow -->
   <rule context="fo:*/@overflow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">overflow="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', 'auto'))">overflow="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', or 'auto'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">overflow="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: overflow="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-after="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-after="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-after="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-after="<value-of select="."/>"</report>
   </rule>

   <!-- padding-before -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-before -->
   <rule context="fo:*/@padding-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-before="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-before="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-before="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-before="<value-of select="."/>"</report>
   </rule>

   <!-- padding-bottom -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-bottom -->
   <rule context="fo:*/@padding-bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-bottom="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-bottom="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-bottom="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-bottom="<value-of select="."/>"</report>
   </rule>

   <!-- padding-end -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-end -->
   <rule context="fo:*/@padding-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-end="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-end="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-end="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-end="<value-of select="."/>"</report>
   </rule>

   <!-- padding-left -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-left -->
   <rule context="fo:*/@padding-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-left="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-left="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-left="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-left="<value-of select="."/>"</report>
   </rule>

   <!-- padding-right -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-right -->
   <rule context="fo:*/@padding-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-right="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-right="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-right="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-right="<value-of select="."/>"</report>
   </rule>

   <!-- padding-start -->
   <!-- <padding-width> | <length-conditional> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-start -->
   <rule context="fo:*/@padding-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-start="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-start="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-start="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-start="<value-of select="."/>"</report>
   </rule>

   <!-- padding-top -->
   <!-- <padding-width> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#padding-top -->
   <rule context="fo:*/@padding-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">padding-top="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">padding-top="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">padding-top="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: padding-top="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">page-citation-strategy="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('all', 'normal', 'non-blank', 'inherit'))">page-citation-strategy="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'all', 'normal', 'non-blank', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-citation-strategy="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-citation-strategy="<value-of select="."/>"</report>
   </rule>

   <!-- page-height -->
   <!-- auto | indefinite | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-height -->
   <rule context="fo:*/@page-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">page-height="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">page-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-height="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-height="<value-of select="."/>"</report>
   </rule>

   <!-- page-number-treatment -->
   <!-- link | no-link -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-number-treatment -->
   <rule context="fo:*/@page-number-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">page-number-treatment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'no-link'))">page-number-treatment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'link' or 'no-link'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-number-treatment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-number-treatment="<value-of select="."/>"</report>
   </rule>

   <!-- page-position -->
   <!-- only | first | last | rest | any | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-position -->
   <rule context="fo:*/@page-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">page-position="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('only', 'first', 'last', 'rest', 'any', 'inherit'))">page-position="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'only', 'first', 'last', 'rest', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-position="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-position="<value-of select="."/>"</report>
   </rule>

   <!-- page-width -->
   <!-- auto | indefinite | <length> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#page-width -->
   <rule context="fo:*/@page-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">page-width="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">page-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">page-width="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: page-width="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">precedence="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">precedence="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">precedence="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: precedence="<value-of select="."/>"</report>
   </rule>

   <!-- provisional-distance-between-starts -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#provisional-distance-between-starts -->
   <rule context="fo:*/@provisional-distance-between-starts">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">provisional-distance-between-starts="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">provisional-distance-between-starts="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">provisional-distance-between-starts="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: provisional-distance-between-starts="<value-of select="."/>"</report>
   </rule>

   <!-- provisional-label-separation -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#provisional-label-separation -->
   <rule context="fo:*/@provisional-label-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">provisional-label-separation="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">provisional-label-separation="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">provisional-label-separation="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: provisional-label-separation="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">region-name="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">region-name="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: region-name="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: region-name-reference="<value-of select="."/>"</report>
   </rule>

   <!-- relative-align -->
   <!-- before | baseline | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#relative-align -->
   <rule context="fo:*/@relative-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">relative-align="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'baseline', 'inherit'))">relative-align="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'before', 'baseline', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">relative-align="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: relative-align="<value-of select="."/>"</report>
   </rule>

   <!-- relative-position -->
   <!-- static | relative | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#relative-position -->
   <rule context="fo:*/@relative-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">relative-position="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('static', 'relative', 'inherit'))">relative-position="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'static', 'relative', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">relative-position="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: relative-position="<value-of select="."/>"</report>
   </rule>

   <!-- rendering-intent -->
   <!-- auto | perceptual | relative-colorimetric | saturation | absolute-colorimetric | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#rendering-intent -->
   <rule context="fo:*/@rendering-intent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">rendering-intent="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', 'inherit'))">rendering-intent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rendering-intent="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rendering-intent="<value-of select="."/>"</report>
   </rule>

   <!-- retrieve-boundary -->
   <!-- page | page-sequence | document -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-boundary -->
   <rule context="fo:*/@retrieve-boundary">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-boundary="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('page', 'page-sequence', 'document'))">retrieve-boundary="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'page', 'page-sequence', or 'document'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-boundary="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-boundary="<value-of select="."/>"</report>
   </rule>

   <!-- retrieve-boundary-within-table -->
   <!-- table | table-fragment | page -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-boundary-within-table -->
   <rule context="fo:*/@retrieve-boundary-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-boundary-within-table="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('table', 'table-fragment', 'page'))">retrieve-boundary-within-table="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'table', 'table-fragment', or 'page'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-boundary-within-table="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-boundary-within-table="<value-of select="."/>"</report>
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
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-class-name="<value-of select="."/>"</report>
   </rule>

   <!-- retrieve-position -->
   <!-- first-starting-within-page | first-including-carryover | last-starting-within-page | last-ending-within-page -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-position -->
   <rule context="fo:*/@retrieve-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-position="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', 'last-ending-within-page'))">retrieve-position="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', or 'last-ending-within-page'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-position="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-position="<value-of select="."/>"</report>
   </rule>

   <!-- retrieve-position-within-table -->
   <!-- first-starting | first-including-carryover | last-starting | last-ending -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#retrieve-position-within-table -->
   <rule context="fo:*/@retrieve-position-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">retrieve-position-within-table="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting', 'first-including-carryover', 'last-starting', 'last-ending'))">retrieve-position-within-table="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'first-starting', 'first-including-carryover', 'last-starting', or 'last-ending'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">retrieve-position-within-table="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: retrieve-position-within-table="<value-of select="."/>"</report>
   </rule>

   <!-- right -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#right -->
   <rule context="fo:*/@right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">right="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">right="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">right="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: right="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">rule-style="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inherit'))">rule-style="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rule-style="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rule-style="<value-of select="."/>"</report>
   </rule>

   <!-- rule-thickness -->
   <!-- <length> -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#rule-thickness -->
   <rule context="fo:*/@rule-thickness">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR', 'Object')">rule-thickness="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">rule-thickness="" should be Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: rule-thickness="<value-of select="."/>"</report>
   </rule>

   <!-- scale-option -->
   <!-- width | height | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scale-option -->
   <rule context="fo:*/@scale-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scale-option="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('width', 'height', 'inherit'))">scale-option="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'width', 'height', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scale-option="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scale-option="<value-of select="."/>"</report>
   </rule>

   <!-- scaling -->
   <!-- uniform | non-uniform | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scaling -->
   <rule context="fo:*/@scaling">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>"</report>
   </rule>

   <!-- scaling-method -->
   <!-- auto | integer-pixels | resample-any-method | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#scaling-method -->
   <rule context="fo:*/@scaling-method">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling-method="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'integer-pixels', 'resample-any-method', 'inherit'))">scaling-method="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'integer-pixels', 'resample-any-method', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling-method="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: scaling-method="<value-of select="."/>"</report>
   </rule>

   <!-- score-spaces -->
   <!-- true | false | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#score-spaces -->
   <rule context="fo:*/@score-spaces">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">score-spaces="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">score-spaces="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">score-spaces="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: score-spaces="<value-of select="."/>"</report>
   </rule>

   <!-- script -->
   <!-- none | auto | <script> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#script -->
   <rule context="fo:*/@script">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'EMPTY', 'ERROR', 'Object')">script="<value-of select="."/>" should be EnumerationToken or Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto', 'inherit'))">script="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">script="" should be EnumerationToken or Literal.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: script="<value-of select="."/>"</report>
   </rule>

   <!-- show-destination -->
   <!-- replace | new -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#show-destination -->
   <rule context="fo:*/@show-destination">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">show-destination="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('replace', 'new'))">show-destination="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'replace' or 'new'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">show-destination="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: show-destination="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">source-document="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">source-document="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">source-document="" should be URI or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: source-document="<value-of select="."/>"</report>
   </rule>

   <!-- space-after -->
   <!-- <space> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-after -->
   <rule context="fo:*/@space-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">space-after="<value-of select="."/>" should be Length or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-after="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-after="" should be Length or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-after="<value-of select="."/>"</report>
   </rule>

   <!-- space-before -->
   <!-- <space> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-before -->
   <rule context="fo:*/@space-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">space-before="<value-of select="."/>" should be Length or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-before="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-before="" should be Length or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-before="<value-of select="."/>"</report>
   </rule>

   <!-- space-end -->
   <!-- <space> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-end -->
   <rule context="fo:*/@space-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">space-end="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-end="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-end="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-end="<value-of select="."/>"</report>
   </rule>

   <!-- space-start -->
   <!-- <space> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#space-start -->
   <rule context="fo:*/@space-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">space-start="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">space-start="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">space-start="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: space-start="<value-of select="."/>"</report>
   </rule>

   <!-- span -->
   <!-- none | all | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#span -->
   <rule context="fo:*/@span">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">span="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'all', 'inherit'))">span="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'all', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">span="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: span="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">start-indent="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">start-indent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">start-indent="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: start-indent="<value-of select="."/>"</report>
   </rule>

   <!-- starting-state -->
   <!-- show | hide -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#starting-state -->
   <rule context="fo:*/@starting-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">starting-state="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide'))">starting-state="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'show' or 'hide'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">starting-state="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: starting-state="<value-of select="."/>"</report>
   </rule>

   <!-- starts-row -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#starts-row -->
   <rule context="fo:*/@starts-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">starts-row="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">starts-row="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">starts-row="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: starts-row="<value-of select="."/>"</report>
   </rule>

   <!-- suppress-at-line-break -->
   <!-- auto | suppress | retain | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#suppress-at-line-break -->
   <rule context="fo:*/@suppress-at-line-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">suppress-at-line-break="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'suppress', 'retain', 'inherit'))">suppress-at-line-break="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'suppress', 'retain', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">suppress-at-line-break="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: suppress-at-line-break="<value-of select="."/>"</report>
   </rule>

   <!-- switch-to -->
   <!-- xsl-preceding | xsl-following | xsl-any | <name>[ <name>]* -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#switch-to -->
   <rule context="fo:*/@switch-to">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">switch-to="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">switch-to="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: switch-to="<value-of select="."/>"</report>
   </rule>

   <!-- table-layout -->
   <!-- auto | fixed | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-layout -->
   <rule context="fo:*/@table-layout">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-layout="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'fixed', 'inherit'))">table-layout="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-layout="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-layout="<value-of select="."/>"</report>
   </rule>

   <!-- table-omit-footer-at-break -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-omit-footer-at-break -->
   <rule context="fo:*/@table-omit-footer-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-omit-footer-at-break="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">table-omit-footer-at-break="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-omit-footer-at-break="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-omit-footer-at-break="<value-of select="."/>"</report>
   </rule>

   <!-- table-omit-header-at-break -->
   <!-- true | false -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#table-omit-header-at-break -->
   <rule context="fo:*/@table-omit-header-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">table-omit-header-at-break="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">table-omit-header-at-break="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">table-omit-header-at-break="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: table-omit-header-at-break="<value-of select="."/>"</report>
   </rule>

   <!-- target-presentation-context -->
   <!-- use-target-processing-context | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-presentation-context -->
   <rule context="fo:*/@target-presentation-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-presentation-context="<value-of select="."/>" should be EnumerationToken or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-target-processing-context'))">target-presentation-context="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'use-target-processing-context'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-presentation-context="" should be EnumerationToken or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-presentation-context="<value-of select="."/>"</report>
   </rule>

   <!-- target-processing-context -->
   <!-- document-root | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-processing-context -->
   <rule context="fo:*/@target-processing-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-processing-context="<value-of select="."/>" should be EnumerationToken or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('document-root'))">target-processing-context="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'document-root'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-processing-context="" should be EnumerationToken or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-processing-context="<value-of select="."/>"</report>
   </rule>

   <!-- target-stylesheet -->
   <!-- use-normal-stylesheet | <uri-specification> -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#target-stylesheet -->
   <rule context="fo:*/@target-stylesheet">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'EMPTY', 'ERROR', 'Object')">target-stylesheet="<value-of select="."/>" should be EnumerationToken or URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-normal-stylesheet'))">target-stylesheet="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'use-normal-stylesheet'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">target-stylesheet="" should be EnumerationToken or URI.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: target-stylesheet="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-align-last="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', 'inherit'))">text-align-last="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-align-last="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-align-last="<value-of select="."/>"</report>
   </rule>

   <!-- text-altitude -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-altitude -->
   <rule context="fo:*/@text-altitude">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">text-altitude="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">text-altitude="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-altitude="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-altitude="<value-of select="."/>"</report>
   </rule>

   <!-- text-decoration -->
   <!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-decoration -->
   <rule context="fo:*/@text-decoration">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-decoration="<value-of select="."/>"</report>
   </rule>

   <!-- text-depth -->
   <!-- use-font-metrics | <length> | <percentage> | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-depth -->
   <rule context="fo:*/@text-depth">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">text-depth="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">text-depth="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-depth="" should be EnumerationToken, Length, or Percent.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-depth="<value-of select="."/>"</report>
   </rule>

   <!-- text-indent -->
   <!-- <length> | <percentage> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-indent -->
   <rule context="fo:*/@text-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-indent="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">text-indent="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-indent="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-indent="<value-of select="."/>"</report>
   </rule>

   <!-- text-shadow -->
   <!-- none | [<color> || <length> <length> <length>? ,]* [<color> || <length> <length> <length>?] | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-shadow -->
   <rule context="fo:*/@text-shadow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Color', 'Length', 'EMPTY', 'ERROR', 'Object')">text-shadow="<value-of select="."/>" should be EnumerationToken, Color, or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-shadow="" should be EnumerationToken, Color, or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-shadow="<value-of select="."/>"</report>
   </rule>

   <!-- text-transform -->
   <!-- capitalize | uppercase | lowercase | none | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#text-transform -->
   <rule context="fo:*/@text-transform">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-transform="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('capitalize', 'uppercase', 'lowercase', 'none', 'inherit'))">text-transform="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'capitalize', 'uppercase', 'lowercase', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">text-transform="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: text-transform="<value-of select="."/>"</report>
   </rule>

   <!-- top -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#top -->
   <rule context="fo:*/@top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">top="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">top="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">top="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: top="<value-of select="."/>"</report>
   </rule>

   <!-- treat-as-word-space -->
   <!-- auto | true | false | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#treat-as-word-space -->
   <rule context="fo:*/@treat-as-word-space">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">treat-as-word-space="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'true', 'false', 'inherit'))">treat-as-word-space="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">treat-as-word-space="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: treat-as-word-space="<value-of select="."/>"</report>
   </rule>

   <!-- unicode-bidi -->
   <!-- normal | embed | bidi-override | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#unicode-bidi -->
   <rule context="fo:*/@unicode-bidi">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">unicode-bidi="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'embed', 'bidi-override', 'inherit'))">unicode-bidi="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'embed', 'bidi-override', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">unicode-bidi="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: unicode-bidi="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">visibility="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'collapse', 'inherit'))">visibility="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'visible', 'hidden', 'collapse', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">visibility="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: visibility="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">white-space-collapse="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">white-space-collapse="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">white-space-collapse="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: white-space-collapse="<value-of select="."/>"</report>
   </rule>

   <!-- white-space-treatment -->
   <!-- ignore | preserve | ignore-if-before-linefeed | ignore-if-after-linefeed | ignore-if-surrounding-linefeed | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#white-space-treatment -->
   <rule context="fo:*/@white-space-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">white-space-treatment="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', 'inherit'))">white-space-treatment="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">white-space-treatment="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: white-space-treatment="<value-of select="."/>"</report>
   </rule>

   <!-- widows -->
   <!-- <integer> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#widows -->
   <rule context="fo:*/@widows">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">widows="<value-of select="."/>" should be Number or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">widows="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">widows="" should be Number or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: widows="<value-of select="."/>"</report>
   </rule>

   <!-- width -->
   <!-- <length> | <percentage> | auto | inherit -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#width -->
   <rule context="fo:*/@width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">width="<value-of select="."/>" should be Length, Percent, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">width="" should be Length, Percent, or EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: width="<value-of select="."/>"</report>
   </rule>

   <!-- word-spacing -->
   <!-- normal | <length> | <space> | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#word-spacing -->
   <rule context="fo:*/@word-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object')">word-spacing="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">word-spacing="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">word-spacing="" should be EnumerationToken or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: word-spacing="<value-of select="."/>"</report>
   </rule>

   <!-- wrap-option -->
   <!-- no-wrap | wrap | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#wrap-option -->
   <rule context="fo:*/@wrap-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">wrap-option="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-wrap', 'wrap', 'inherit'))">wrap-option="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'no-wrap', 'wrap', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">wrap-option="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: wrap-option="<value-of select="."/>"</report>
   </rule>

   <!-- writing-mode -->
   <!-- lr-tb | rl-tb | tb-rl | tb-lr | bt-lr | bt-rl | lr-bt | rl-bt | lr-alternating-rl-bt | lr-alternating-rl-tb | lr-inverting-rl-bt | lr-inverting-rl-tb | tb-lr-in-lr-pairs | lr | rl | tb | inherit -->
   <!-- Inherited: yes -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#writing-mode -->
   <rule context="fo:*/@writing-mode">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">writing-mode="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', 'inherit'))">writing-mode="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">writing-mode="" should be EnumerationToken.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: writing-mode="<value-of select="."/>"</report>
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
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR', 'Object')">z-index="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">z-index="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning">z-index="" should be EnumerationToken or Number.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: z-index="<value-of select="."/>"</report>
   </rule>
</pattern><?DSDL_INCLUDE_END fo-property.sch?>
    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo"/>
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf"/>
    <ns uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf"/>
    
    <phase id="fo">
        <active pattern="fo-fo"/></phase>
    <phase id="property">
        <active pattern="fo-property"/>
    </phase>
    <pattern id="axf">
        <p>http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#axf.document-info</p>
        <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1" role="axf-1">
	  <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="axf-2">name="<value-of select="@name"/>" cannot be used when axf:document-info with name="xmp" is present.</assert>
        </rule>
        <rule context="axf:document-info[@name = 'title']">
	  <assert test="true" id="axf-3" role="Warning">name="<value-of select="@name"/>" is deprecated.  Please use name="document-title".</assert>
        </rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-height -->
	<rule context="fo:*/@axf:background-content-height">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-height="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-height="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-type -->
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
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-width -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-width="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-image -->
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
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position-horizontal -->
	<rule context="fo:*/@axf:background-position-horizontal">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-horizontal="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-horizontal="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-position-vertical -->
	<!-- <percentage> | <length> | top | center | bottom -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position-vertical -->
	<rule context="fo:*/@axf:background-position-vertical">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-vertical="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'top', 'center', or 'bottom'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-vertical="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-repeat -->
	<!-- repeat | repeat-x | repeat-y | no-repeat | paginate -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>"</report>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:outline-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:outline-color="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:outline-level -->
	<!-- <number> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-level">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'axf:outline-level should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'outline-level="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#scaling -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>"</report>
	</rule>

    </pattern>
</schema>