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
--><pattern id="axf-fo" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- axf:custom-property -->
	<!-- https://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.custom-property -->
        <rule context="axf:custom-property">
	  <assert test="empty((../../axf:document-info, ../axf:document-info)[@name eq 'xmp'])" role="Warning"><value-of select="name()"/>&quot; is ignored when axf:document-info with name=&quot;xmp&quot; is present.</assert>
          <assert test="normalize-space(@name) ne ''" role="Warning">name=&quot;&quot; は空ではいけません。</assert>
          <assert test="not(normalize-space(@name) = ('Title', 'Author', 'Subject', 'Keywords', 'Creator', 'Producer', 'CreationDate', 'ModDate', 'Trapped'))">name=&quot;<value-of select="@name"/>&quot; は <value-of select="name()"/>と利用することができません。</assert>
          <assert test="normalize-space(@value) ne ''" role="Warning">value=&quot;&quot; は空ではいけません。</assert>
        </rule>

	<!-- axf:document-info -->
	<!-- https://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.document-info -->
        <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1">
	  <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="Warning">name=&quot;<value-of select="@name"/>&quot; is ignored when axf:document-info with name=&quot;xmp&quot; is present.</assert>
        </rule>
        <rule context="axf:document-info[@name = 'title']">
	  <assert test="false()" id="axf-3f" sqf:fix="axf-3fix" role="Warning">name=&quot;<value-of select="@name"/>&quot; は勧められません。name=&quot;document-title&quot; を利用してください。</assert>
          <sqf:fix id="axf-3fix">
	    <sqf:description>
              <sqf:title>Change the 'title' axf:document-info into 'document-title'</sqf:title>
            </sqf:description>
            <sqf:replace match="@name" node-type="attribute" target="name" select="'document-title'"/>
          </sqf:fix>
        </rule>
</pattern><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->