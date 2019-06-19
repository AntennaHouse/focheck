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
--><pattern id="abstract" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- <color> | transparent | inherit -->
  <rule abstract="true" id="color-transparent">
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は Color、transparent 又は inherit でなければなりません。<value-of select="."/> は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('transparent', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; のトークンは transparent 又は inherit でなければなりません。EnumerationToken は <value-of select="$expression/@token"/> です。</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot;は Color、transparent、inherit でなければなりません。</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
  </rule>

  <!-- border-style -->
  <!-- <border-style> | inherit -->
  <!-- http://www.w3.org/TR/xsl11/#border-top-style -->
  <rule abstract="true" id="border-style">
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は none、hidden、dotted、dashed、solid、double、groove、ridge、inset、outset、dot-dash、dot-dot-dash、wave 又は inherit でなければなりま せん。<value-of select="."/> は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'dot-dash', 'dot-dot-dash', 'wave', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; のトークンは none、hidden、dotted、dashed、solid、double、groove、ridge、inset、outset、dot-dash、dot-dot-dash、wave 又は inherit でなければなりま せん。トークンは '<value-of select="$expression/@token"/>' です。</report>
    <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot; は none、hidden、dotted、dashed、solid、double、groove、ridge、inset、outset、dot-dash、dot-dot-dash、wave 又は inherit でなければなりま せん。</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
  </rule>

   <!-- border-width -->
   <!-- <border-width> | inherit -->
   <!-- http://www.w3.org/TR/xsl11/#border-top-width" /> -->
   <rule abstract="true" id="border-width">
      <let name="expression" value="ahf:parser-runner(.)"></let>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は thin、medium、thick、inherit 又は Length でなければなりません。<value-of select="."/> は <value-of select="local-name($expression)"/> です。</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))"><value-of select="name()"/>=&quot;<value-of select="."/>&quot;のトークンは thin、medium、thick 又は inherit でなければなりません。EnumerationToken は <value-of select="$expression/@token"/> です。</report>
      <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name()"/>=&quot;&quot; は thin、medium、thick、inherit 又は Length でなければなりません。</report>
      <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name()"/>=&quot;<value-of select="."/>&quot;</report>
   </rule>

</pattern><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->