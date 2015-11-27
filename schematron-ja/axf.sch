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
--><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <xsl:key name="flow-name" match="fo:flow | fo:static-content" use="@flow-name"/>
    <xsl:key name="index-key" match="*[exists(@index-key)]" use="@index-key"/>
    <xsl:key name="master-name" match="fo:simple-page-master | fo:page-sequence-master" use="@master-name"/>
    <xsl:key name="region-name" match="fo:region-before | fo:region-after |       fo:region-start | fo:region-end |       fo:region-body" use="@region-name"/>

    <include href="fo.sch"></include>
    <include href="fo-property.sch"></include>
    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo"></ns>
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf"></ns>
    <ns uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf"></ns>
    
    <phase id="fo">
        <active pattern="fo-fo"/></phase>
    <phase id="property">
        <active pattern="fo-property"/>
    </phase>
    <pattern id="axf">
        <p>http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#axf.document-info</p>
        <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1" role="axf-1">
	  <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="axf-2">name=&quot;<value-of select="@name"/>&quot; は　name=&quot;xmp&quot; とのaxf:document-infoが存在している場合、使用することができません。</assert>
        </rule>
        <rule context="axf:document-info[@name = 'title']">
	  <assert test="true()" id="axf-3" role="Warning">name=&quot;<value-of select="@name"/>&quot; は勧められません。Please use name=&quot;document-title&quot;.</assert>
        </rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color=&quot;<value-of select="."/>&quot; は色又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color=&quot;&quot; は色又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'"> シンタックスエラー：background-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-height -->
	<rule context="fo:*/@axf:background-content-height">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-height=&quot;<value-of select="."/>&quot;　は 列挙トークン、長さ又はパーセントでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「auto」、「scale-to-fit」、「scale-down-to-fit」、「scale-up-to-fit」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height=&quot;&quot; は列挙トークン、長さ又はパーセントでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-height=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-type -->
	<rule context="fo:*/@axf:background-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type=&quot;<value-of select="."/>&quot; はリテラル又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「auto」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type=&quot;&quot; はリテラル又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-type=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-width -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-content-width -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width=&quot;<value-of select="."/>&quot; は列挙トークン、長さ又はパーセントでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width=&quot;<value-of select="."/>&quot; の列挙 トークンは「<value-of select="$expression/@token"/>」です。トークンは「auto」、「scale-to-fit」、「scale-down-to-fit」、「scale-up-to-fit」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width=&quot;&quot; は列挙トークン、長さ又はパーセントでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-width=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color=&quot;<value-of select="."/>&quot; は色又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color=&quot;&quot; は色又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'"> シンタックスエラー：background-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-image -->
	<rule context="fo:*/@axf:background-image">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-image=&quot;<value-of select="."/>&quot; はＵＲＩ又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">background-image=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「none」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-image=&quot;&quot; はＵＲＩ又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-image=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-position -->
	<!-- [ [<percentage> | <length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: yes -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position=&quot;&quot; は「[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit」でなければなりません。</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position-horizontal -->
	<rule context="fo:*/@axf:background-position-horizontal">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-horizontal=&quot;<value-of select="."/>&quot; はパーセント、長さ又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「left」、「center」、「right」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal=&quot;&quot; はパーセント、長さ又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-position-horizontal=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-position-vertical -->
	<!-- <percentage> | <length> | top | center | bottom -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-position-vertical -->
	<rule context="fo:*/@axf:background-position-vertical">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-vertical=&quot;<value-of select="."/>&quot;はパーセント、長さ又は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「top」、「center」又は「bottom」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical=&quot;&quot; はパーセント、長さ又は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-position-vertical=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-repeat -->
	<!-- repeat | repeat-x | repeat-y | no-repeat | paginate -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat=&quot;<value-of select="."/>&quot; は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「repeat」、「repeat-x」、「repeat-y」、「no-repeat」又は「paginate」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat=&quot;&quot; は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-repeat=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">「axf:outline-color」は色又は色名でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：'axf:outline-color=&quot;<value-of select="."/>&quot;'</report>
	</rule>

	<!-- axf:outline-level -->
	<!-- <number> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-level">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">「axf:outline-level 」は数でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： 'outline-level=&quot;<value-of select="."/>&quot;'</report>
	</rule>

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#scaling -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling=&quot;<value-of select="."/>&quot; は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「uniform」、「non-uniform」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling=&quot;&quot;　は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：scaling=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow=&quot;<value-of select="."/>&quot; fo:block-container 又は fo:inline-containerのみ適用されています。</report>
	</rule>

    </pattern>
</schema>