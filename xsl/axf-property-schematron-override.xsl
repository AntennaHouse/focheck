<!-- ============================================================= -->
<!--  MODULE:     axf-property-schematron-override.xsl             -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Override FO property allowed values with         -->
<!--              Antenna House extensions.                        -->
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
<!--              3 February 2015                                  -->
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
    xmlns:not-yet-xsl="file://not-yet-xsl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf not-yet-xsl xs">


<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Stylesheet for generating Schemtron from XSL spec. -->
<xsl:import href="property-schematron-dump.xsl" />


<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Additional variables defined in imported stylesheets. -->

<!-- Extended property values to override definitions in XSL spec.  -->
<xsl:variable name="property-value-overrides" as="element(item)+">
  <!-- AH Formatter allows <percentage>. -->
  <item property="font-stretch">normal | wider | narrower | ultra-condensed | extra-condensed | condensed | semi-condensed | semi-expanded | expanded | extra-expanded | ultra-expanded | inherit | &lt;percentage></item>
  <item property="font-weight">normal | bold | bolder | lighter | &lt;integer> | inherit</item>
  <item property="overflow">visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto</item>
</xsl:variable>

<!-- Properties for which no Schematron rule will be generated.
     Mostly the properties that can have string values. -->
<xsl:variable name="skipped-properties" as="xs:string">
external-destination
font-family
format
id
index-key
internal-destination
language
ref-id
ref-index-key
reference-orientation
role
src
text-align

force-page-count
</xsl:variable>

</xsl:stylesheet>
