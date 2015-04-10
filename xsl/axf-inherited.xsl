<!-- ============================================================= -->
<!--  MODULE:     axf-inherited.xsl                                -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Generate Relax NG compact syntax schema to add   -->
<!--              a set of inherited extension properties to evey  -->
<!--              FO in the XSL 1.1 Recommendation                 -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: Relax NG compact syntax schema module            -->
<!--                                                               -->
<!-- CREATED FOR: Antenna House                                    -->
<!--                                                               -->
<!-- CREATED BY:  Antenna House                                    -->
<!--              3844 Kennett Pike, Suite 200                     -->
<!--              Greenville, DE 19807                             -->
<!--              USA                                              -->
<!--              http://www.antennahouse.com/                     -->
<!--              support@antennahouse.com                         -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              28 March 2015                                    -->
<!--                                                               -->
<!-- CREATED BY:  Tony Graham (tgraham)                            -->
<!--                                                               -->
<!-- ============================================================= -->
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

<!-- ============================================================= -->
<!-- DESIGN CONSIDERATIONS                                         -->
<!-- ============================================================= -->
<!-- XML for the XSL 1.1 Recommendation is available at
     http://www.w3.org/TR/2006/REC-xsl11-20061205/xslspec.xml
                                                                   -->

<!-- ============================================================= -->
<!-- XSL STYLESHEET INVOCATION                                     -->
<!-- ============================================================= -->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf axf xs">

<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Common parameters, keys, functions, and templates. -->
<xsl:import href="common.xsl" />


<!-- ============================================================= -->
<!-- SERIALIZATION                                                 -->
<!-- ============================================================= -->

<xsl:output method="text" encoding="UTF-8" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- Defined in 'common.xsl'. -->

<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Additional parameters defined in 'common.xsl'. -->

<!-- The Relax NG compact syntax module that this module includes. -->
<xsl:param name="include" select="'fo-inherited.rnc'" as="xs:string" />

<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Additional variables defined in 'common.xsl'. -->

<!-- Two tables in Appendix B of the XSL 1.1 Recommendation each list
     some details about every property.
     http://www.w3.org/TR/xsl/#prtab1 lists whether a property is
     inherited. -->
<xsl:variable
    name="inherited-properties"
    as="element(property)+">
<property name="axf:layer-name" model="'none' | text" description="Specifies to which layer the area is arranged." />
<property name="axf:overprint" model="text" description="" />
<property name="axf:line-break" model="'normal' | 'strict'" description="" />
<property name="axf:word-break" model="'normal' | 'break-all' | 'keep-all'" description="" />
<property name="axf:word-wrap" model="'normal' | 'break-word'" description="" />
<property name="axf:abbreviation-character-count" model="'auto' | text" description="" />
<property name="axf:hyphenation-minimum-character-count" model="text" description="" />
<property name="axf:hyphenation-zone" model="'none' | text" description="" />
<property name="axf:hyphenate-hyphenated-word" model="'true' | 'false'" description="" />
<property name="axf:soft-hyphen-treatment" model="'auto' | 'preserve'" description="" />
<property name="axf:punctuation-trim" model="text" description="" />
<property name="axf:text-justify-trim" model="text" description="" />
<property name="axf:kerning-mode" model="'none' | 'pair' | 'auto'" description="" />
<property name="axf:punctuation-spacing" model="text" description="" />
<property name="axf:hanging-punctuation" model="text" description="" />
<property name="axf:avoid-widow-words" model="'true' | 'false'" description="" />
<property name="axf:text-autospace" model="text" description="" />
<property name="axf:text-autospace-width" model="text" description="" />
<property name="axf:letter-spacing-side" model="'both' | 'start' | 'end'" description="" />
<property name="axf:text-align-string" model="'start' | 'center' | 'end' | 'inside' | 'outside' | 'left' | 'right'" description="" />
<property name="axf:text-align-first" model="'relative' | 'start' | 'center' | 'end' | 'justify' | 'inside' | 'outside' | 'left' | 'right'" description="" />
<property name="axf:leader-expansion" model="'auto' | 'force'" description="" />
<property name="axf:text-kashida-space" model="text" description="" />
<property name="axf:justify-nbsp" model="'true' | 'false'" description="" />
<property name="axf:vertical-underline-side" model="'left' | 'right' | 'depend-on-language' | 'auto'" description="" />
<property name="axf:text-orientation" model="'mixed' | 'upright' | 'sideways-right' | 'sideways' | 'none'" description="" />
<property name="axf:text-combine-horizontal" model="text" description="" />
<property name="axf:text-emphasis-style" model="text" description="" />
<property name="axf:text-emphasis-position" model="'before' | 'after'" description="" />
<property name="axf:text-emphasis-offset" model="text" description="" />
<property name="axf:text-emphasis-skip" model="text" description="" />
<property name="axf:text-emphasis-font-family" model="text" description="" />
<property name="axf:text-emphasis-font-size" model="text" description="" />
<property name="axf:text-emphasis-font-style" model="'normal' | 'italic'" description="" />
<property name="axf:text-emphasis-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="" />
<property name="axf:text-emphasis-font-stretch" model="text" description="" />
<property name="axf:text-emphasis-font-color" model="text" description="" />
<property name="axf:normalize" model="'auto' | 'none' | 'nfc' | 'nfkc' | 'nfd' | 'nfkd'" description="" />
<property name="axf:normalize-exclude" model="'full-composition-exclusion' | 'none'" description="" />
<property name="axf:number-transform" model="text" description="" />
<property name="axf:kansuji-style" model="'simple' | 'grouping' | 'readable'" description="" />
<property name="axf:kansuji-letter" model="text" description="" />
<property name="axf:kansuji-grouping-letter" model="text" description="" />
<property name="axf:ligature-mode" model="text" description="" />
<property name="axf:japanese-glyph" model="'none' | 'jp78' | 'jp83' | 'jp90' | 'jp04'" description="" />
<property name="axf:alt-glyph" model="text" description="" />
<property name="axf:base-uri" model="text" description="" />
<property name="axf:suppress-duplicate-page-number" model="'true' | 'false'" description="" />
<property name="axf:assumed-page-number" model="text" description="" />
<property name="axf:line-number" model="'none' | 'show' | 'hide'" description="" />
<property name="axf:line-number-background-color" model="text" description="" />
<property name="axf:line-number-color" model="text" description="" />
<property name="axf:line-number-display-align" model="'auto' | 'before' | 'center' | 'after'" description="" />
<property name="axf:line-number-font-family" model="text" description="" />
<property name="axf:line-number-font-size" model="text" description="" />
<property name="axf:line-number-font-style" model="'normal' | 'italic'" description="" />
<property name="axf:line-number-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="" />
<property name="axf:line-number-offset" model="text" description="" />
<property name="axf:line-number-position" model="'start' | 'end' | 'inside' | 'outside' | 'alternate'" description="" />
<property name="axf:line-number-text-align" model="'auto' | 'start' | 'center' | 'end' | 'inside' | 'outside' | 'left' | 'right'" description="" />
<property name="axf:line-number-text-decoration" model="text" description="" />
<property name="axf:line-number-text-width" model="text" description="" />
<property name="axf:line-continued-mark" model="text" description="" />
<property name="axf:line-continued-mark-background-color" model="text" description="" />
<property name="axf:line-continued-mark-color" model="text" description="" />
<property name="axf:line-continued-mark-font-family" model="text" description="" />
<property name="axf:line-continued-mark-font-size" model="text" description="" />
<property name="axf:line-continued-mark-font-style" model="'normal' | 'italic'" description="" />
<property name="axf:line-continued-mark-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="" />
<property name="axf:line-continued-mark-offset" model="text" description="" />
<property name="axf:revision-bar-color" model="text" description="" />
<property name="axf:revision-bar-offset" model="text" description="" />
<property name="axf:revision-bar-position" model="'start' | 'end' | 'inside' | 'outside' | 'alternate' | 'both'" description="" />
<property name="axf:revision-bar-style" model="text" description="" />
<property name="axf:revision-bar-width" model="text" description="" />
<property name="axf:suppress-duplicate-footnote" model="'true' | 'false'" description="" />
<property name="axf:diagonal-border-color" model="text" description="" />
<property name="axf:diagonal-border-width" model="text" description="" />
<property name="axf:reverse-diagonal-border-color" model="text" description="" />
<property name="axf:reverse-diagonal-border-style" model="text" description="" />
<property name="axf:reverse-diagonal-border-width" model="text" description="" />
<property name="axf:repeat-footnote-in-table-footer" model="'true' | 'false'" description="" />
<property name="axf:repeat-footnote-in-table-header" model="'true' | 'false'" description="" />
<property name="axf:overflow-align" model="'normal' | 'start' | 'end' | 'center'" description="" />
<property name="axf:overflow-condense" model="'letter-spacing' | 'font-stretch' | 'font-size' | 'line-height' | 'auto' | 'none'" description="" />
<property name="axf:overflow-condense-limit-font-size" model="text" description="" />
<property name="axf:overflow-condense-limit-font-stretch" model="text" description="" />
<property name="axf:overflow-replace" model="text" description="" />
<property name="axf:overflow-limit" model="text" description="" />
<property name="axf:overflow-limit-inline" model="text" description="" />
<property name="axf:overflow-limit-block" model="text" description="" />
</xsl:variable>


<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template match="/">

  <xsl:call-template name="ahf:rnc-initial-comment" />
  <xsl:text>
default namespace fo = "http://www.w3.org/1999/XSL/Format"
namespace axf = "http://www.antennahouse.com/names/XSL/Extensions"
namespace local = ""

include "</xsl:text>
  <xsl:value-of select="$include" />
  <xsl:text>"

# FOs
</xsl:text>
  <xsl:if test="$debug">
    <xsl:message select="$inherited-properties" />
  </xsl:if>

  <xsl:for-each select="key('all-fo-divs', true())">

    <xsl:variable name="element"
                  select="substring-after(head, 'fo:')"/>

    <!--  -->
    <xsl:variable
        name="patterns"
        select="for $property in $inherited-properties/@name
                  return translate($property, ':', '_')"
        as="xs:string+"/>

    <xsl:if test="$debug">
      <xsl:message><xsl:value-of select="$element"/></xsl:message>
      <xsl:for-each select="$patterns">
        <xsl:sort/>
        <xsl:message> - <xsl:value-of select="."/></xsl:message>
      </xsl:for-each>
    </xsl:if>

    <xsl:text>&#10;fo_</xsl:text>
    <xsl:value-of select="$element" />
    <xsl:text>.attlist &amp;=&#10;</xsl:text>
    <xsl:for-each select="$patterns">
      <xsl:sort />
      <xsl:text>    </xsl:text>
      <xsl:value-of select="." />
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:text>
#
# Properties
#

</xsl:text>

  <xsl:for-each select="$inherited-properties">
    <xsl:sort select="@name" />
    <xsl:value-of select="translate(@name, ':', '_')" />
    <xsl:text> = &#10;</xsl:text>
    <xsl:text>    attribute </xsl:text>
    <xsl:value-of select="@name" />
    <xsl:text> { </xsl:text>
    <xsl:value-of select="@model" />
    <xsl:text> }?&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
