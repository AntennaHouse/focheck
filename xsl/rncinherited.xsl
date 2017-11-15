<!-- ============================================================= -->
<!--  MODULE:     rncinherited.xsl                                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Generate Relax NG compact syntax schema from     -->
<!--              the XML for the XSL 1.1 Recommendation           -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: Relax NG compact syntax schema                   -->
<!--                                                               -->
<!-- CREATED FOR: Antenna House                                    -->
<!--                                                               -->
<!-- CREATED BY:  Antenna House                                    -->
<!--              3844 Kennett Pike, Suite 200                     -->
<!--              Greenville, DE 19807                             -->
<!--              USA                                              -->
<!--              https://www.antennahouse.com/                    -->
<!--              support@antennahouse.com                         -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              18 March 2015                                    -->
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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf xs">

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

<!-- Defined in 'common.xsl'. -->

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
    select="$all-properties[ahf:is-inherited(.)]"
    as="xs:string+" />


<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template match="/">

  <xsl:call-template name="ahf:rnc-initial-comment" />
  <xsl:text>
default namespace fo = "http://www.w3.org/1999/XSL/Format"
namespace axf = "http://www.antennahouse.com/names/XSL/Extensions"
namespace local = ""

include "fo.rnc"

# FOs
</xsl:text>
  <xsl:if test="$debug">
    <xsl:message select="$inherited-properties" />
  </xsl:if>

  <!-- From http://www.w3.org/TR/xsl11/#fo_marker:

          Property values set on an fo:marker or its ancestors will
          not be inherited by the children of the fo:marker when they
          are retrieved by an fo:retrieve-marker or
          fo:retrieve-table-marker.

       so don't add any inherited properties to fo:marker, because
       they won't do anything. -->
  <xsl:for-each
      select="key('all-fo-divs', true())[not(@id eq 'fo_marker')]">

    <xsl:variable name="element"
                  select="substring-after(head, 'fo:')"/>

    <!-- Property groups that apply to this FO. -->
    <xsl:variable name="property-groups"
                  select="key('property-group', slist/sitem/specref/@ref)"/>

    <!-- All properties for this FO, specified either singly or as
         part of a property group. -->
    <xsl:variable name="properties"
                  select="key('property', slist/sitem/specref/@ref)/@id |
                          $property-groups/div3[not(@id eq 'font-model')]/@id"
                  as="xs:string*"/>

    <xsl:variable name="extra-inherited-properties"
                  select="$inherited-properties[not(. = $properties)]"
                  as="xs:string*" />

    <xsl:if test="$debug">
      <xsl:message><xsl:value-of select="$element"/></xsl:message>
      <xsl:for-each select="$properties">
        <xsl:sort/>
        <xsl:message> - <xsl:value-of select="."/></xsl:message>
      </xsl:for-each>

        <xsl:for-each select="$extra-inherited-properties">
          <xsl:message>...<xsl:value-of select="."/></xsl:message>
        </xsl:for-each>
        <xsl:message>...</xsl:message>
    </xsl:if>

    <xsl:if test="exists($extra-inherited-properties)">
      <xsl:text>&#10;fo_</xsl:text>
      <xsl:value-of select="$element" />
      <xsl:text>.attlist &amp;=&#10;</xsl:text>
      <xsl:for-each select="$extra-inherited-properties">
        <xsl:sort />
        <xsl:text>    </xsl:text>
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
