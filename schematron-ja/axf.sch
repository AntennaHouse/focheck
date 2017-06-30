<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015-2017 Antenna House, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
--><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <xsl:key name="flow-name" match="fo:flow | fo:static-content" use="@flow-name"/>
    <xsl:key name="index-key" match="*[exists(@index-key)]" use="@index-key"/>
    <xsl:key name="master-name" match="fo:simple-page-master | fo:page-sequence-master |       axf:spread-page-master" use="@master-name"/>
    <xsl:key name="region-name" match="fo:region-before | fo:region-after |       fo:region-start | fo:region-end |       fo:region-body | axf:spread-region" use="@region-name"/>

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
	<!-- axf:document-info -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.document-info -->
        <p>http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.document-info</p>
        <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1" role="axf-1">
	  <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="axf-2">name=&quot;<value-of select="@name"/>&quot; は　name=&quot;xmp&quot; とのaxf:document-infoが存在している場合、使用することができません。</assert>
        </rule>
        <rule context="axf:document-info[@name = 'title']">
	  <assert test="false()" id="axf-3f" sqf:fix="axf-3fix" role="Warning">name=&quot;<value-of select="@name"/>&quot; は勧められません。name=&quot;document-title&quot;　を利用してください。</assert>
          <sqf:fix id="axf-3fix">
	    <sqf:description>
              <sqf:title>axf:document-info の「title」は 「document-title」に変更します。</sqf:title>
            </sqf:description>
            <sqf:replace match="@name" node-type="attribute" target="name" select="'document-title'"/>
          </sqf:fix>
        </rule>

	<!-- axf:annotation-color -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.annotation-color -->
	<rule context="fo:*/@axf:annotation-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:annotation-color=&quot;<value-of select="."/>&quot; should be Color or 'none'. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">annotation-color=&quot;&quot; should be Color or 'none'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: annotation-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:annotation-contents -->
	<!-- <contents> | none -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.annotation-contents -->
	<rule context="fo:*/@axf:annotation-contents">
	  <assert test="normalize-space(../@axf:annotation-type) = ('Text', 'FreeText', 'Stamp', 'FileAttachment') or local-name(..) = 'basic-link'" role="Warning"><value-of select="name(.)"/> should be used only when @axf:annotation-type is 'Text', 'FreeText', 'Stamp', or 'FileAnnotation' or on fo:basic-link.</assert>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:background-color=&quot;<value-of select="."/>&quot; should be Color or EnumerationToken. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-content -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-content -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-content -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-color -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-image -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position=&quot;&quot; は「[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit」でなければなりません。</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-position-horizontal -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-position-vertical -->
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat=&quot;<value-of select="."/>&quot; は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「repeat」、「repeat-x」、「repeat-y」、「no-repeat」又は「paginate」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat=&quot;&quot; は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-repeat=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:baseline-block-snap -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.baseline-block-snap -->
	<rule context="fo:*/@axf:baseline-block-snap">
	  <assert test="exists(../@axf:baseline-grid) and normalize-space(../@axf:baseline-grid) = ('new', 'none')" role="Warning">axf:baseline-block-snap applies only when axf:baseline-grid is 'new' or 'none'.</assert>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">「axf:outline-color」は色又は色名でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：'axf:outline-color=&quot;<value-of select="."/>&quot;'</report>
	</rule>

	<!-- axf:float -->
	<!-- <float-x> || <float-y> || <float-wrap> || <float-reference> || <float-move> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:float">
	  <let name="tokens" value="tokenize(normalize-space(.), '\s+')"></let>
	  <assert test="every $token in $tokens satisfies matches($token, '^(after|alternate|auto|auto-move|auto-next|before|bottom|center|column|end|inside|keep|keep-float|left|multicol|next|none|normal|outside|page|right|skip|start|top|wrap)$')">Every token in 'axf:float' should be 'after', 'alternate', 'auto', 'auto-move', 'auto-next', 'before', 'bottom', 'center', 'column', 'end', 'inside', 'keep', 'keep-float', 'left', 'multicol', 'next', 'none', 'normal', 'outside', 'page', 'right', 'skip', 'start', 'top' or 'wrap'.  Value is '<value-of select="."/>'.</assert>
	  <assert test="every $token in $tokens satisfies count($tokens[. eq $token]) = 1">Tokens in 'axf:float' must not be repeated.  Value is '<value-of select="."/>'.</assert>
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
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling=&quot;<value-of select="."/>&quot; は列挙トークンでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「uniform」、「non-uniform」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling=&quot;&quot;　は列挙トークンでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：scaling=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.hyphenation-zone -->
	<rule context="fo:*/@axf:hyphenation-zone">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:hyphenation-zone=&quot;<value-of select="."/>&quot;は 列挙トークン又は長さでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:hyphenation-zone=&quot;<value-of select="."/>&quot; の列挙トークンは「<value-of select="$expression/@token"/>」です。トークンは「none」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:hyphenation-zone=&quot;&quot; は 列挙トークン又は長さでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:hyphenation-zone=&quot;<value-of select="."/>&quot;</report>
	  <report test="local-name($expression) = 'Length' and    (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or    $expression/@is-zero = 'yes')" id="axf.hyphenation-zone" role="Warning" sqf:fix="axf.hyphenation-zone-fix">axf:hyphenation-zone=&quot;<value-of select="."/>&quot; は正の長さでなければなりません。</report>
	  <sqf:fix id="axf.hyphenation-zone-fix">
	    <sqf:description>
              <sqf:title> 「none」に@axf:hyphenation-zone 値を変更します。</sqf:title>
	    </sqf:description>
	    <sqf:replace node-type="attribute" target="axf:hyphenation-zone" select="'none'"/>
	  </sqf:fix>
	</rule>

	<!-- axf:indent-here -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.indent-here -->
	<rule context="fo:*/@axf:indent-here">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:indent-here=&quot;<value-of select="."/>&quot; should be EnumerationToken or Length. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:indent-here=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'. トークンは「none」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:indent-here=&quot;&quot; should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:indent-here=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-background-color -->
	<!-- <color> | transparent -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-background-color -->
	<rule context="fo:*/@axf:line-number-background-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be a Color, a color name, or 'transparent'. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be EnumerationToken or Color.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-color -->
	<rule context="fo:*/@axf:line-number-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be a Color or a color name. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be a Color or a color name.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-font-size -->
	<!-- <absolute-size> | <relative-size> | <length> | <percentage> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.w3.org/TR/xsl11/#axf:line-number-font-size -->
	<rule context="fo:*/@axf:line-number-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:line-number-font-size=&quot;<value-of select="."/>&quot; should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller'))">axf:line-number-font-size=&quot;<value-of select="."/>&quot; token should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', or 'smaller'. 列挙トークンは「<value-of select="$expression/@token"/>」です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-font-size=&quot;&quot; should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-font-size=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-initial -->
	<!-- auto | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-initial -->
	<rule context="fo:*/@axf:line-number-initial">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be EnumerationToken or Number. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'. トークンは「auto」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-interval -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-interval -->
	<rule context="fo:*/@axf:line-number-interval">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be EnumerationToken or Number. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'. トークンは「auto」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-offset -->
	<!-- <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-offset -->
	<rule context="fo:*/@axf:line-number-offset">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR')">axf:line-number-offset=&quot;<value-of select="."/>&quot; は長さでなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-offset=&quot;&quot;は長さでなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:line-number-offset=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-start -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-start -->
	<rule context="fo:*/@axf:line-number-start">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be EnumerationToken or Number. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'. トークンは「auto」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-text-decoration -->
	<!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-text-decoration -->
	<rule context="fo:*/@text-decoration">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration=&quot;<value-of select="."/>&quot; は「none」、「underline」、「no-underline]」、「overline」、「no-overline」、「line-through」、「no-line-through」、「blink」、「no-blink」又は「inherit」でなければなりません。「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration=&quot;<value-of select="."/>&quot; のトークンは「none」、「underline」、「no-underline]」、「overline」、「no-overline」、「line-through」、「no-line-through」、「blink」、「no-blink」又は「inherit」でなければなりません。列挙トークンは「<value-of select="$expression/@token"/>」です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration=&quot;&quot; は「none」、「underline」、「no-underline]」、「overline」、「no-overline」、「line-through」、「no-line-through」、「blink」、「no-blink」又は「inherit」でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：text-decoration=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-width -->
	<!-- auto | <width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.line-number-width -->
	<rule context="fo:*/@axf:line-number-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; should be EnumerationToken or Length. 「<value-of select="."/>」は<value-of select="local-name($expression)"/>です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'. トークンは「auto」でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:page-number-prefix -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.page-number-prefix -->
	<rule context="fo:*/@axf:page-number-prefix">
	  <report test="true()" sqf:fix="axf_page-number-prefix_fix" role="Warning">axf:page-number-prefix: A similar function is provided in XSL 1.1. Please use fo:folio-prefix.</report>
          <sqf:fix id="axf_page-number-prefix_fix">
	    <sqf:description>
              <sqf:title>Change @axf:page-number-prefix into fo:folio-prefix.</sqf:title>
            </sqf:description>
            <sqf:add node-type="element" target="fo:folio-prefix">
	      <value-of select="."/>
	    </sqf:add>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.revision-bar-color -->
	<rule context="fo:*/@axf:revision-bar-color">
	  <report test="true()" sqf:fix="axf_revision-bar-color_fix" role="Warning">axf:revision-bar-color: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-color_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-color.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-offset -->
	<!-- <length> -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.revision-bar-offset -->
	<rule context="fo:*/@axf:revision-bar-offset">
	  <report test="true()" sqf:fix="axf_revision-bar-offset_fix" role="Warning">axf:revision-bar-offset: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-offset_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-offset.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-position -->
	<!-- start | end | inside | outside | alternate | both -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.revision-bar-position -->
	<rule context="fo:*/@axf:revision-bar-position">
	  <report test="true()" sqf:fix="axf_revision-bar-position_fix" role="Warning">axf:revision-bar-position: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-position_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-position.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-style -->
	<!-- <border-style> -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.revision-bar-style -->
	<rule context="fo:*/@axf:revision-bar-style">
	  <report test="true()" sqf:fix="axf_revision-bar-style_fix" role="Warning">axf:revision-bar-style: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-style_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-style.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-width -->
	<!-- <border-width> -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.revision-bar-width -->
	<rule context="fo:*/@axf:revision-bar-width">
	  <report test="true()" sqf:fix="axf_revision-bar-width_fix" role="Warning">axf:revision-bar-width: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-width_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-width.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:suppress-duplicate-page-number -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.suppress-duplicate-page-number -->
	<rule context="fo:*/@axf:suppress-duplicate-page-number">
	  <report test="true()" sqf:fix="axf_suppress-duplicate-page-number_fix" role="Warning">axf:suppress-duplicate-page-number: A similar function is provided in XSL 1.1. Please use merge-*-index-key-references.</report>
          <sqf:fix id="axf_suppress-duplicate-page-number_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:suppress-duplicate-page-number.</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- http://www.antennahouse.com/product/ahf64/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow=&quot;<value-of select="."/>&quot; はfo:block-container 又は fo:inline-containerのみに適用されています。</report>
	</rule>

    </pattern>
</schema>