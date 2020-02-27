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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	queryBinding="xslt2">
    <xsl:key name="flow-name"
	     match="fo:flow | fo:static-content"
	     use="@flow-name" />
    <xsl:key name="index-key"
	     match="*[exists(@index-key)]"
	     use="@index-key" />
    <xsl:key name="marker-class-name"
	     match="fo:marker"
	     use="@marker-class-name" />
    <xsl:key name="master-name"
	     match="fo:simple-page-master | fo:page-sequence-master |
		    axf:spread-page-master"
	     use="@master-name" />
    <xsl:key name="region-name"
	     match="fo:region-before | fo:region-after |
		    fo:region-start | fo:region-end |
		    fo:region-body | axf:spread-region"
	     use="@region-name" />

    <include href="abstract.sch"/>
    <include href="fo-fo.sch"/>
    <include href="fo-property.sch" />
    <include href="axf-fo.sch" />
    <include href="axf-property.sch" />

    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo" />
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf" />
    <ns uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf" />

    <phase id="fo">
        <active pattern="fo-fo" />
    </phase>
    <phase id="property">
        <active pattern="fo-property" />
    </phase>
    <phase id="axf">
        <active pattern="axf-fo" />
    </phase>
    <phase id="axf-prop">
        <active pattern="axf-property" />
    </phase>
</schema>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
