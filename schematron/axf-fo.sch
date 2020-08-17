<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015-2020 Antenna House, Inc.

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
<pattern id="axf-fo"
	 xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- axf:custom-property -->
  <!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.custom-property -->
  <rule context="axf:custom-property">
    <assert test="empty((../../axf:document-info, ../axf:document-info)[@name eq 'xmp'])" role="Warning"><value-of select="name()"/>" is ignored when axf:document-info with name="xmp" is present.</assert>
    <assert test="normalize-space(@name) ne ''" role="Warning">name="" should not be empty.</assert>
    <assert test="not(normalize-space(@name) = ('Title', 'Author', 'Subject', 'Keywords', 'Creator', 'Producer', 'CreationDate', 'ModDate', 'Trapped'))">name="<value-of select="@name"/>" cannot be used with <value-of select="name()"/>.</assert>
    <assert test="normalize-space(@value) ne ''" role="Warning">value="" should not be empty.</assert>
  </rule>

  <!-- axf:document-info -->
  <!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.document-info -->
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

  <!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#action-link -->
  <rule context="axf:form-field[@field-type = 'button']">
    <assert test="empty(@internal-destination) or exists(@internal-destination) and (empty(@action-type) or @action-type = 'goto')">'action-type' may only be 'goto' with &lt;axf:form-field field-type="button" internal-destiniation="..."></assert>
    <assert test="empty(@external-destination) or exists(@external-destination) and (empty(@action-type) or @action-type = ('gotor', 'launch', 'uri'))">'action-type' may only be 'gotor', 'launch', or 'uri' with &lt;axf:form-field field-type="button" external-destination="..."></assert>
    <report test="exists(@internal-destination) and exists(@external-destination)" role="Warning">An '<value-of select="name()" />' should not have both 'internal-destination' and 'external-destination' properties.  AH Formatter may report an error or may use 'internal-destination'.</report>
  </rule>
</pattern>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
