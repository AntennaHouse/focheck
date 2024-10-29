<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015-2024 Antenna House, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
--><!DOCTYPE pattern
[
<!ENTITY border-style-keywords "'none', 'hidden', 'thin-thick-thin', 'triple', 'thick-thin', 'thin-thick', 'double', 'solid', 'dashed', 'dot-dash', 'dot-dot-dash', 'dotted', 'ridge', 'outset', 'groove', 'inset', 'emboss', 'imprint', 'double-wave', 'double-wavy', 'wave', 'wavy'">
]>
<pattern id="abstract" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- <color> | inherit -->
  <rule abstract="true" id="color">
    <let name="context" value="."></let>
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は Color 又は inherit でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; のトークンは inherit でなければなりません。EnumerationToken は <value-of select="$expression/@token"/> です。</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot; は Color 又は inherit でなければなりません。</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
  </rule>

  <!-- <color> | transparent | inherit -->
  <rule abstract="true" id="color-transparent">
    <let name="context" value="."></let>
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は Color、transparent 又は inherit でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; のトークンは transparent 又は inherit でなければなりません。EnumerationToken は <value-of select="$expression/@token"/> です。</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot;は Color、transparent、inherit でなければなりません。</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
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
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; should be 'none', 'hidden', 'thin-thick-thin', 'triple', 'thick-thin', 'thin-thick', 'double', 'solid', 'dashed', 'dot-dash', 'dot-dot-dash', 'dotted', 'ridge', 'outset', 'groove', 'inset', 'emboss', 'imprint', 'double-wave', 'double-wavy', 'wave', 'wavy', or 'inherit'. 「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'thin-thick-thin', 'triple', 'thick-thin', 'thin-thick', 'double', 'solid', 'dashed', 'dot-dash', 'dot-dot-dash', 'dotted', 'ridge', 'outset', 'groove', 'inset', 'emboss', 'imprint', 'double-wave', 'double-wavy', 'wave', 'wavy', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; token should be 'none', 'hidden', 'thin-thick-thin', 'triple', 'thick-thin', 'thin-thick', 'double', 'solid', 'dashed', 'dot-dash', 'dot-dot-dash', 'dotted', 'ridge', 'outset', 'groove', 'inset', 'emboss', 'imprint', 'double-wave', 'double-wavy', 'wave', 'wavy', or 'inherit'. トークン は <value-of select="$expression/@token"/> です。</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot; should be 'none', 'hidden', 'thin-thick-thin', 'triple', 'thick-thin', 'thin-thick', 'double', 'solid', 'dashed', 'dot-dash', 'dot-dot-dash', 'dotted', 'ridge', 'outset', 'groove', 'inset', 'emboss', 'imprint', 'double-wave', 'double-wavy', 'wave', 'wavy', or 'inherit'.</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
  </rule>

   <!-- border-width -->
   <!-- <border-width> | inherit -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width" /> -->
   <rule abstract="true" id="border-width">
      <let name="expression" value="ahf:parser-runner(.)"></let>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は thin、medium、thick、inherit 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot;のトークンは thin、medium、thick 又は inherit でなければなりません。EnumerationToken は <value-of select="$expression/@token"/> です。</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot; は thin、medium、thick、inherit 又は Length でなければなりません。</report>
      <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
   </rule>

</pattern><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->