<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2019 Antenna House, Inc.

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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
	queryBinding="xslt2">

<ns prefix="fo"
    uri="http://www.w3.org/1999/XSL/Format" />
<ns prefix="axf"
    uri="http://www.antennahouse.com/names/XSL/Extensions" />
<ns prefix="ahf"
    uri="http://www.antennahouse.com/names/XSLT/Functions/Document" />

<phase id="pdf-ua">
  <active pattern="pdf-ua-pattern" />
</phase>

<pattern id="pdf-ua-pattern">

<!-- 11-001 - Natural language for text in page content cannot be
              determined. -->
<!-- https://www.antennahouse.com/product/ahf66/ahf-pdf.html#taggedpdf -->
<rule context="fo:root">
  <report test="empty(@xml:lang) or @xml:lang = ''" role="Error" sqf:fix="root-xml-lang-fix">An '<name />' with missing or empty '@xml:lang' will not set the language for the document.</report>
    <sqf:fix id="root-xml-lang-fix">
      <sqf:description>
        <sqf:title>Add 'xml:lang'</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="xml:lang" select="'en'" />
    </sqf:fix>
</rule>

<!-- 13-004 - Figure tag alternative or replacement text missing. -->
<!-- https://www.antennahouse.com/product/ahf66/ahf-pdf.html#alttext -->
<rule context="fo:external-graphic | fo:instream-foreign-object">
  <report test="(empty(@axf:alttext) or @axf:alttext = '') and @role != ''" role="Warning" sqf:fix="graphic-alttext-fix">An '<name />' with missing or empty '@axf:alttext' and non-empty '@role' will use the '@role' value as alternate text. '@role' is not designed for this purpose.</report>
  <report test="(empty(@axf:alttext) or @axf:alttext = '') and (empty(@role) or @role = '')" role="Error" sqf:fix="graphic-alttext-fix">An '<name />' with missing or empty '@axf:alttext' and missing or empty '@role' will have ' ' as alternate text.</report>
<sqf:fix id="graphic-alttext-fix">
  <sqf:description>
    <sqf:title>Add alternative text for the graphic</sqf:title>
  </sqf:description>
  <sqf:user-entry name="alttext">
    <sqf:description>
      <sqf:title>Provide alternative text:</sqf:title>
    </sqf:description>
  </sqf:user-entry>
  <sqf:add node-type="attribute" target="axf:alttext" select="$alttext"/>
</sqf:fix></rule>

</pattern>
</schema>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
