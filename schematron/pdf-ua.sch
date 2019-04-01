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
  <report test="empty(@xml:lang) or @xml:lang = ''" role="Error">'@xml:lang' should be specified on fo:root to indicate the natural language of the text and metadata.</report>
</rule>

<!-- 13-004 - Figure tag alternative or replacement text missing. -->
<!-- https://www.antennahouse.com/product/ahf66/ahf-pdf.html#alttext -->
<rule context="fo:external-graphic | fo:instream-foreign-object">
  <report test="(empty(@axf:alttext) or @axf:alttext = '') and @role != ''" role="Warning">An '<name />' with missing or empty '@axf:alttext' and non-empty '@role' will use the '@role' value as alternate text. '@role' is not designed for this purpose.</report>
  <report test="(empty(@axf:alttext) or @axf:alttext = '') and (empty(@role) or @role = '')" role="Error">An '<name />' with missing or empty '@axf:alttext' and missing or empty '@role' will have ' ' as alternate text.</report>
</rule>

</pattern>
</schema>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
