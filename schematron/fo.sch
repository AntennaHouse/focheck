<?xml version="1.0" encoding="UTF-8"?>
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
<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
	 id="fo-fo">
  <!--<xsl:include href="parser-runner.xsl" />-->
  <!--<rule context="fo:retrieve-table-marker">
    <assert test="exists(ancestor::fo:table-header) or
                  exists(ancestor::fo:table-footer) or
                  (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</assert>
  </rule>-->
  <rule context="fo:*/@column-count" role="column-count">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and
                  (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or
                   $expression/@is-zero = 'yes' or
                   exists($expression/@value) and not($expression/@value castable as xs:integer))" role="column-count">Warning: @column-count should be a positive integer.  The FO formatter will round a non-positive or non-integer value to the nearest integer value greater than or equal to 1.</report>
  </rule>
</pattern>
