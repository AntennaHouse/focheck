<!-- ============================================================= -->
<!--  MODULE:     common.xsl                                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Common key, parameters, variables, templates and -->
<!--              functions for 'focheck' stylesheets.             -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: N/A                                              -->
<!--                                                               -->
<!-- CREATED FOR: Antenna House                                    -->
<!--                                                               -->
<!-- CREATED BY:  Antenna House                                    -->
<!--              240 N. James Street, Suite 208                   -->
<!--              Newark, DE 19804                                 -->
<!--              USA                                              -->
<!--              https://www.antennahouse.com/                    -->
<!--              support@antennahouse.com                         -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              19 March 2015                                    -->
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
<!-- SERIALIZATION                                                 -->
<!-- ============================================================= -->

<xsl:output method="xml" encoding="UTF-8" indent="yes" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- Every <div3> that defines an FO. -->
<xsl:key name="all-fo-divs"
         match="/spec/body/div1/div2/div3[head[starts-with(., 'fo:')]]"
         use="true()"/>
<xsl:key name="property"
         match="div3"
         use="@id"/>
<xsl:key name="property-group"
         match="/spec/body/div1[@id='pr-section']/div2[@id][@id != 'common-aural-properties']"
         use="@id"/>
<xsl:key name="all-property-group"
         match="/spec/body/div1[@id='pr-section']/div2[@id][@id != 'common-aural-properties'][exists(div3)]"
         use="true()"/>
<xsl:key name="property-group-by-property"
         match="/spec/body/div1[@id='pr-section']/div2[@id][exists(div3)]"
         use="div3/@id"/>
<xsl:key name="property-table"
         match="/spec/back/div1[@id='property-index']/div2[@id = 'prtab1']/table/tbody/tr/td[@class = 'propindex']/specref/@ref"
         use="."/>

<!-- Two tables in Appendix B of the XSL 1.1 Recommendation each list
     some details about every property. -->
<!-- http://www.w3.org/TR/xsl/#prtab1
     Columns: Name, Values, Initial Value, Inherited, Percentages -->
<xsl:key name="prtab1-row"
         match="/spec/back/div1[@id='property-index']/div2[@id = 'prtab1']/table/tbody/tr"
         use="td[1]/specref/@ref"/>
<!-- http://www.w3.org/TR/xsl/#prtab2
     Columns: Name, Values, Initial Value, Trait mapping, Core -->
<xsl:key name="prtab2-row"
         match="/spec/back/div1[@id='property-index']/div2[@id = 'prtab2']/table/tbody/tr"
         use="td[1]/specref/@ref"/>


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Version number of current code base. -->
<xsl:param name="version" select="'unknown'" as="xs:string" />

<!-- Year (or years) to insert into license text. -->
<xsl:param name="copyright-year"
           select="xs:string(year-from-dateTime(current-dateTime()))"
           as="xs:string" />

<!-- Whether to emit debugging messages. -->
<xsl:param name="debug" select="()" />

<!-- ID of the Schematron <pattern> generated by this stylesheet.  The
     ID is expected to be used in a Schematron <phase> in a Schematron
     schema that includes the <pattern>. -->
<xsl:param name="id" select="'fo-property'" as="xs:string" />

<!-- Whether to include the aural properties in generated output. -->
<xsl:param name="include-aural" select="'no'" as="xs:string" />

<!-- Location of directory containing 'parser-runner.xsl' stylesheet.
     The generated Schematron will be more portable between machines
     when this is a relative path. -->
<xsl:param name="xsl.dir"
           select="'../xsl'"
           as="xs:string" />


<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<xsl:variable
    name="all-properties"
    select="/spec/back/div1[@id='property-index']/div2[@id = 'prtab1']
            /table/tbody/tr/td[1]/specref/@ref
            [not(ahf:is-aural(.)) and
             not(key('property-group-by-property', .)/head =
                 'Shorthand Properties')]"/>

<!-- Document node for the XSL spec.  Used to provide context for
     keys. -->
<xsl:variable name="xslspec" select="/" as="document-node()" />

<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template name="ahf:initial-comment">
  <xsl:comment> Autogenerated file.  Do not edit. </xsl:comment>
  <xsl:text>&#10;</xsl:text>
  <xsl:comment select="concat(' Generated using ''focheck'' version ',
                              $version,
                              ' ')" />
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="ahf:license" />
</xsl:template>

<xsl:template name="ahf:license">
  <xsl:comment>
     Copyright <xsl:value-of select="$copyright-year" /> Antenna House, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
</xsl:comment>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="ahf:rnc-initial-comment">
  <xsl:text># Autogenerated file.  Do not edit.
# Generated using 'focheck' version </xsl:text>
<xsl:value-of select="$version" /><xsl:text>
#
# Copyright </xsl:text>
<xsl:value-of select="$copyright-year" />
<xsl:text> Antenna House, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
</xsl:text>
</xsl:template>


<!-- ============================================================= -->
<!-- FUNCTIONS                                                     -->
<!-- ============================================================= -->

<!-- Property lookup functions. -->

<!-- ahf:values($property as xs:string) as xs:string -->
<!-- Returns allowed values of $property.  For example,
     ahf:values('country') returns "none | <country> | inherit". -->
<xsl:function name="ahf:values" as="xs:string">
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="normalize-space(key('prtab1-row', $property, $xslspec)/td[2])" />
</xsl:function>

<!-- ahf:initial-value($property as xs:string) as xs:string -->
<!-- Returns initial value of $property. -->
<xsl:function name="ahf:initial-value" as="xs:string">
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="normalize-space(key('prtab1-row', $property, $xslspec)/td[3])" />
</xsl:function>

<!-- ahf:is-inherited($property as xs:string) as xs:boolean -->
<!-- Returns true() if $property is the name of an inherited property.
     Returns false() if not. -->
<xsl:function name="ahf:is-inherited" as="xs:boolean">
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="substring(normalize-space(key('prtab1-row',
                                            $property,
                                            $xslspec)/td[4]), 1, 3) = 'yes'" />
</xsl:function>

<!-- ahf:is-shorthand($property as xs:string) as xs:boolean -->
<!-- Returns true() if $property is the name of a shorthand property.
     Returns false() if not. -->
<xsl:function name="ahf:is-shorthand" as="xs:boolean">
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="normalize-space(key('prtab2-row',
                              $property,
                              $xslspec)/td[4]) = 'Shorthand'" />
</xsl:function>

<!-- ahf:is-aural($property as xs:string) as xs:boolean -->
<!-- Returns true() if $property is an aural property.  Returns
     false() if not. -->
<xsl:function name="ahf:is-aural" as="xs:boolean">
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="key('property-group-by-property',
                  $property,
                  $xslspec)/@id = 'common-aural-properties'" />
</xsl:function>

<!-- ahf:allowed-datatypes-text($datatypes as xs:string+) as xs:string -->
<!-- Returns string of allowed datatypes for use in a message. -->
<xsl:function name="ahf:allowed-datatypes-text" as="xs:string">
  <xsl:param name="datatypes" as="xs:string+" />
  <xsl:param name="enum-tokens" as="xs:string*" />

  <xsl:variable
      name="use-datatypes"
      select="for $datatype in $datatypes
                return if ($datatype eq 'EnumerationToken' and
                           exists($enum-tokens))
                         then for $token in $enum-tokens
                                return concat('''', $token, '''')
                       else $datatype"
      as="xs:string+" />

  <xsl:value-of separator="">
    <xsl:for-each select="$use-datatypes">
      <xsl:value-of select="if (position() > 1)
                              then (if (last() > 2)
                                      then ','
                                    else (),
                                    if (position() = last())
                                      then ' or '
                                   else ' ')
                             else ()"
                    separator="" />
      <xsl:value-of select="." />
    </xsl:for-each>
  </xsl:value-of>
</xsl:function>

</xsl:stylesheet>
