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
<pattern id="abstract"
	 xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- <color> | inherit -->
  <rule abstract="true" id="color">
    <let name="context" value="."/>
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()" />="<value-of select="."/>" should be Color or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be Color, or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report>
  </rule>

  <!-- <color> | transparent | inherit -->
  <rule abstract="true" id="color-transparent">
    <let name="context" value="."/>
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()" />="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'transparent' or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be Color, 'transparent', or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report>
    <!-- <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('fuschia', 'fucshia')" sqf:fix="color-fuchsia-fix"><value-of select="name()" />="<value-of select="."/>" should be 'fuchsia'.</report> -->
    <!-- <sqf:fix id="color-fuchsia-fix"> -->
    <!--     <sqf:param name="context" abstract="true" /> -->
    <!--     <sqf:description> -->
    <!--         <sqf:title>Change @<!-\- <value-of select="name($context)" /> -\-> to 'fuchsia'</sqf:title> -->
    <!-- 	</sqf:description> -->
    <!-- 	<sqf:replace node-type="attribute" target="color" select="'fuchsia'"/> -->
    <!-- </sqf:fix> -->
  </rule>

  <!-- <color> | transparent | inherit -->
  <!-- <rule abstract="true" id="color-transparent2"> -->
  <!--   <let name="expression" value="ahf:parser-runner(.)"/> -->
  <!--   <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()" />="<value-of select="."/>" should be Color, 'transparent', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert> -->
  <!--   <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'transparent' or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report> -->
  <!--   <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be Color, 'transparent', or 'inherit'.</report> -->
  <!--   <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report> -->
  <!--   <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('fuschia', 'fucshia')" sqf:fix="color-fuchsia-fix"><value-of select="name()" />="<value-of select="."/>" should be 'fuchsia'.</report> -->
  <!--   <sqf:fix id="color-fuchsia-fix"> -->
  <!--       <sqf:param name="context" abstract="true" /> -->
  <!--       <sqf:description> -->
  <!--           <sqf:title>Change @<!-\- <value-of select="name($context)" /> -\-> to 'fuchsia'</sqf:title> -->
  <!-- 	</sqf:description> -->
  <!-- 	<sqf:replace node-type="attribute" target="color" select="'fuchsia'"/> -->
  <!--   </sqf:fix> -->
  <!-- </rule> -->

  <!-- border-style -->
  <!-- <border-style> | inherit -->
  <!-- http://www.w3.org/TR/xsl11/#border-top-style -->
  <rule abstract="true" id="border-style">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()" />="<value-of select="."/>" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', 'inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report>
  </rule>

   <!-- border-width -->
   <!-- <border-width> | inherit -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width" /> -->
   <rule abstract="true" id="border-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="name()" />="<value-of select="."/>" should be 'thin', 'medium', 'thick', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))"><value-of select="name()" />="<value-of select="."/>" token should be 'thin', 'medium', 'thick', or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()" />="" should be 'thin', 'medium', 'thick', 'inherit', or Length.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name()" />="<value-of select="."/>"</report>
   </rule>

</pattern>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
