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
--><pattern id="axf-property" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- axf:annotation-color -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.annotation-color -->
	<rule context="fo:*/@axf:annotation-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:annotation-color=&quot;<value-of select="."/>&quot; は Color 又は none でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">annotation-color=&quot;&quot; は Color 又は none でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：annotation-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:annotation-contents -->
	<!-- <contents> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.annotation-contents -->
	<rule context="fo:*/@axf:annotation-contents">
	  <assert test="normalize-space(../@axf:annotation-type) = ('Text', 'FreeText', 'Stamp', 'FileAttachment') or local-name(..) = 'basic-link'" role="Warning"><value-of select="name(.)"/>@axf:annotation-type が Text、FreeText、Stamp、FileAnnotation 又は fo:basic-link の場合のみに利用しなければなりません。</assert>
	</rule>

	<!-- axf:assumed-page-number -->
	<!-- <number> -->
	<!-- Inherited: yes -->
	<rule context="fo:*/@axf:assumed-page-number">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">axf:assumed-page-number は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：'assumed-page-number=&quot;<value-of select="."/>&quot;'</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:background-color=&quot;<value-of select="."/>&quot; は Color 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は Color 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-height">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-height=&quot;<value-of select="."/>&quot; は EnumerationToken、Length 又は Percent でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto、scale-to-fit、scale-down-to-fit、scale-up-to-fit 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height=&quot;&quot; は EnumerationToken、Length 又は Percent でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-height=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type=&quot;<value-of select="."/>&quot; は Literal 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type=&quot;&quot; は Literal 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-type=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-width -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width=&quot;<value-of select="."/>&quot; は EnumerationToken、Length 又は Percent でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto、scale-to-fit、scale-down-to-fit、scale-up-to-fit 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width=&quot;&quot; は EnumerationToken、Length 又は Percent でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-width=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-image -->
	<rule context="fo:*/@axf:background-image">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-image=&quot;<value-of select="."/>&quot; は ＵＲＩ 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">background-image=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは none 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-image=&quot;&quot; は ＵＲＩ 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-image=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-position -->
	<!-- [ [<percentage> | <length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position=&quot;&quot; は [ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit でなければなりません。</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position-horizontal -->
	<rule context="fo:*/@axf:background-position-horizontal">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-horizontal=&quot;<value-of select="."/>&quot; は Percent、Length 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは left、center、right 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal=&quot;&quot; は Percent、Length 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-position-horizontal=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-position-vertical -->
	<!-- <percentage> | <length> | top | center | bottom -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position-vertical -->
	<rule context="fo:*/@axf:background-position-vertical">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-vertical=&quot;<value-of select="."/>&quot; は Percent、Length 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは top、center 又は bottom でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical=&quot;&quot; は Percent、Length 又はEnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-position-vertical=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-repeat -->
	<!-- repeat | repeat-x | repeat-y | no-repeat | paginate -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat=&quot;<value-of select="."/>&quot; は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは repeat、repeat-x、repeat-y、no-repeat 又は paginate でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat=&quot;&quot; は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：background-repeat=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:baseline-block-snap -->
	<!-- none | [auto | before | after | center] || [border-box | margin-box] -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.baseline-block-snap -->
	<rule context="fo:*/@axf:baseline-block-snap">
	  <assert test="exists(../@axf:baseline-grid) and normalize-space(../@axf:baseline-grid) = ('new', 'none')" role="Warning">axf:baseline-block-snap は axf:baseline-grid が new 又は none の場合のみに適用されます。</assert>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">axf:outline-color は Color 又は色名でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：'axf:outline-color=&quot;<value-of select="."/>&quot;'</report>
	</rule>

	<!-- axf:float -->
	<!-- <float-x> || <float-y> || <float-wrap> || <float-reference> || <float-move> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:float">
	  <let name="tokens" value="tokenize(normalize-space(.), '\s+')"></let>
	  <assert test="every $token in $tokens satisfies matches($token, '^(after|alternate|auto|auto-move|auto-next|before|bottom|center|column|end|inside|keep|keep-float|left|multicol|next|none|normal|outside|page|right|skip|start|top|wrap)$')">axf:float の全てのトークンは after、 alternate、auto、auto-move、auto-next、before、bottom、center、column、end、inside、keep、keep-float、left、multicol、next、none、normal、outside、page、right、skip、start、top 又は wrap でなければなりません。値は <value-of select="."/> です。</assert>
	  <assert test="every $token in $tokens satisfies count($tokens[. eq $token]) = 1">axf:float 内のトークンは繰り返すことはできません。値は <value-of select="."/> です。</assert>
	</rule>

	<!-- axf:outline-level -->
	<!-- <number> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-level">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">axf:outline-level は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： outline-level=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- axf:background-content-width -->
	<rule context="fo:*/@axf:background-content-height | fo:*/@axf:background-content-width">
	  <report test="true()" role="Warning"><value-of select="name(.)"/>AH Formatter V6.6 以降に利用できません。AH Formatter V6.6 以降で axf:background-size を利用します。</report>
	</rule>

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling=&quot;<value-of select="."/>&quot; は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは uniform、non-uniform 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling=&quot;&quot; は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：scaling=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:column-rule-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:column-rule-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">axf:column-rule-color は Color 又は色名でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:column-rule-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:column-rule-length -->
	<!-- <length> | <percentage> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.column-rule-length -->
	<rule context="fo:*/@axf:column-rule-length">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:column-rule-length=&quot;<value-of select="."/>&quot; は Length 又は Percent でなければなりません。&lt;50/62/78% &gt;「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:column-rule-length=&quot;&quot; は Length 又は Percent でなければなりません。&lt;50/62/78% &gt;</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:column-rule-length=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:field-button-icon -->
	<!-- axf:field-button-icon-down -->
	<!-- axf:field-button-icon-rollover -->
	<!-- <uri-specification> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.field-button-icon -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.field-button-icon-down -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.field-button-icon-rollover -->
	<rule context="fo:*/@axf:field-button-icon |          fo:*/@axf:field-button-icon-down |          fo:*/@axf:field-button-icon-rollover">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('URI', 'EMPTY', 'ERROR', 'Object')">field-button-icon=&quot;<value-of select="."/>&quot; は URI でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="local-name(.)"/>=&quot;&quot; は URI でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="local-name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:field-font-size -->
	<!-- font-size | auto | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.field-font-size -->
	<rule context="fo:*/@axf:field-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:field-font-size=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('font-size', 'auto'))">axf:field-font-size=&quot;<value-of select="."/>&quot; の列挙トークンは <value-of select="$expression/@token"/> です。トークンは font-size 又は autoでなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:field-font-size=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー: axf:field-font-size=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.hyphenation-zone -->
	<rule context="fo:*/@axf:hyphenation-zone">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:hyphenation-zone=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:hyphenation-zone=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは none でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:hyphenation-zone=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:hyphenation-zone=&quot;<value-of select="."/>&quot;</report>
	  <report test="local-name($expression) = 'Length' and    (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or    $expression/@is-zero = 'yes')" id="axf.hyphenation-zone" role="Warning" sqf:fix="axf.hyphenation-zone-fix">axf:hyphenation-zone=&quot;<value-of select="."/>&quot; は正の長さでなければなりません。</report>
	  <sqf:fix id="axf.hyphenation-zone-fix">
	    <sqf:description>
              <sqf:title>none に @axf:hyphenation-zone 値を変更します。</sqf:title>
	    </sqf:description>
	    <sqf:replace node-type="attribute" target="axf:hyphenation-zone" select="'none'"/>
	  </sqf:fix>
	</rule>

	<!-- axf:indent-here -->
	<!-- none | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.indent-here -->
	<rule context="fo:*/@axf:indent-here">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:indent-here=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:indent-here=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは none でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:indent-here=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:indent-here=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:initial-letters-color -->
	<!-- <color> | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.initial-letters -->
	<rule context="fo:*/@axf:initial-letters-color">
	  <extends rule="color"/>
	</rule>

	<!-- axf:keep-together-within-dimension -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.keep-together-within-dimension -->
	<rule context="fo:*/@axf:keep-together-within-dimension">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:keep-together-within-dimension=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">axf:keep-together-within-dimension=&quot;<value-of select="."/>&quot; の列挙トークンは <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:keep-together-within-dimension=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:keep-together-within-dimension=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-background-color -->
	<!-- <color> | transparent -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-background-color -->
	<rule context="fo:*/@axf:line-number-background-color">
	  <extends rule="color-transparent"/>
	</rule>

	<!-- axf:line-number-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-color -->
	<rule context="fo:*/@axf:line-number-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は Color 又は色名でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は Color 又は色名でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-font-size -->
	<!-- <absolute-size> | <relative-size> | <length> | <percentage> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf:line-number-font-size -->
	<rule context="fo:*/@axf:line-number-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:line-number-font-size=&quot;<value-of select="."/>&quot; は xx-small、x-small、small、medium、large、x-large、xx-large、larger、smaller、Length 又は Percent でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller'))">axf:line-number-font-size=&quot;<value-of select="."/>&quot; です。許可されているキーワードは xx-smal、x-small、small、medium、large、x-large、xx-large、larger又はsmallerです。トークン は <value-of select="$expression/@token"/> です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-font-size=&quot;&quot; は xx-small、x-small、small、medium、large、x-large、xx-large、larger、smaller、Length 又は Percent でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:line-number-font-size=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-initial -->
	<!-- auto | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-initial -->
	<rule context="fo:*/@axf:line-number-initial">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Number でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-interval -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-interval -->
	<rule context="fo:*/@axf:line-number-interval">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Number でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-offset -->
	<!-- <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-offset -->
	<rule context="fo:*/@axf:line-number-offset">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR')">axf:line-number-offset=&quot;<value-of select="."/>&quot; は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-offset=&quot;&quot; は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:line-number-offset=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-start -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-start -->
	<rule context="fo:*/@axf:line-number-start">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Number でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-text-decoration -->
	<!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-text-decoration -->
	<rule context="fo:*/@text-decoration">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration=&quot;<value-of select="."/>&quot; は none、underline、no-underline]、overline、no-overline、line-through、no-line-through、blink、no-blink 又は inherit でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration=&quot;<value-of select="."/>&quot; です。許可されているキーワードは none、underline、no-underline]、overline、no-overline、line-through、no-line-through、blink、no-blink又はinheritです。トークン は <value-of select="$expression/@token"/> です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration=&quot;&quot; は none、underline、no-underline]、overline、no-overline、line-through、no-line-through、blink、no-blink 又は inherit でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：text-decoration=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:line-number-width -->
	<!-- auto | <width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-width -->
	<rule context="fo:*/@axf:line-number-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=「<value-of select="."/>&quot;」は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:media-duration -->
	<!-- intrinsic | infinity | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-duration -->
	<rule context="fo:*/@axf:media-duration">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('intrinsic', 'infinity'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは intrinsic 又は infinity です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Number でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	  <report test="../@axf:media-play-mode = 'once'" role="Warning"><value-of select="name(.)"/>axf:media-play-mode=&quot;once&quot; を指定した場合は無効にする。</report>
	</rule>

	<!-- axf:media-play-mode -->
	<!-- once | continuously | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-play-mode -->
	<rule context="fo:*/@axf:media-play-mode">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; は EnumerationToken 又は Number でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('once', 'continuously'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは once 又は continuously でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Number でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:media-skin-color -->
	<!-- auto | <color> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-skin-color -->
	<rule context="fo:*/@axf:media-skin-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:media-skin-color=&quot;<value-of select="."/>&quot; は Color 又は auto でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">media-skin-color=&quot;&quot; は Color 又は auto でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： media-skin-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:media-volume -->
	<!-- <percentage> | <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-volume -->
	<rule context="fo:*/@axf:media-volume">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Percent', 'Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">media-volume=&quot;<value-of select="."/>&quot; は Percent、Number 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">media-volume=&quot;<value-of select="."/>&quot; の enumeration token は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は Percent、Number 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： media-volume=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:media-window-height -->
	<!-- axf:media-window-width -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-window-height -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-window-width -->
	<rule context="fo:*/@axf:media-window-height |          fo:*/@axf:media-window-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>=「<value-of select="."/>&quot;」は EnumerationToken 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>=&quot;&quot; は EnumerationToken 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： <value-of select="name(.)"/>=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:page-number-prefix -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.page-number-prefix -->
	<rule context="fo:*/@axf:page-number-prefix">
	  <report test="true()" sqf:fix="axf_page-number-prefix_fix" role="Warning">axf:page-number-prefix：同様の機能が XSL1.1 で用意しています。fo:folio-prefix を利用して下さい。</report>
          <sqf:fix id="axf_page-number-prefix_fix">
	    <sqf:description>
              <sqf:title>@axf:page-number-prefix into fo:folio-prefix を変更する。</sqf:title>
            </sqf:description>
            <sqf:add node-type="element" target="fo:folio-prefix">
	      <value-of select="."/>
	    </sqf:add>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:poster-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.poster-content -->
	<rule context="fo:*/@axf:poster-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type=&quot;<value-of select="."/>&quot; は Literal 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type=&quot;&quot; は Literal 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー：content-type=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:poster-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.poster-image -->
	<rule context="fo:*/@axf:poster-image">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">poster-image=&quot;<value-of select="."/>&quot; は ＵＲＩ 又は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto'))">poster-image=&quot;<value-of select="."/>&quot; の enumeration token は <value-of select="$expression/@token"/> です。トークンは none 又は auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">poster-image=&quot;&quot; は ＵＲＩ 又は EnumerationToken でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： poster-image=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:revision-bar-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-color -->
	<rule context="fo:*/@axf:revision-bar-color">
	  <report test="true()" sqf:fix="axf_revision-bar-color_fix" role="Warning">axf:revision-bar-color: 同様の機能が XSL1.1 で用意しています。fo:change-bar-begin and fo:change-bar-end を利用して下さい。</report>
          <sqf:fix id="axf_revision-bar-color_fix">
	    <sqf:description>
              <sqf:title>@axf:revision-bar-color を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-offset -->
	<!-- <length> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-offset -->
	<rule context="fo:*/@axf:revision-bar-offset">
	  <report test="true()" sqf:fix="axf_revision-bar-offset_fix" role="Warning">axf:revision-bar-offset：同様の機能が XSL1.1 で用意しています。fo:change-bar-begin and fo:change-bar-end を利用して下さい。</report>
          <sqf:fix id="axf_revision-bar-offset_fix">
	    <sqf:description>
              <sqf:title>@axf:revision-bar-offset を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-position -->
	<!-- start | end | inside | outside | alternate | both -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-position -->
	<rule context="fo:*/@axf:revision-bar-position">
	  <report test="true()" sqf:fix="axf_revision-bar-position_fix" role="Warning">axf:revision-bar-position：同様の機能が XSL1.1 で用意しています。fo:change-bar-begin and fo:change-bar-end を利用して下さい。</report>
          <sqf:fix id="axf_revision-bar-position_fix">
	    <sqf:description>
              <sqf:title>@axf:revision-bar-position を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-style -->
	<!-- <border-style> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-style -->
	<rule context="fo:*/@axf:revision-bar-style">
	  <report test="true()" sqf:fix="axf_revision-bar-style_fix" role="Warning">axf:revision-bar-style：同様の機能が XSL1.1 で用意しています。fo:change-bar-begin and fo:change-bar-end を利用して下さい。</report>
          <sqf:fix id="axf_revision-bar-style_fix">
	    <sqf:description>
              <sqf:title>@axf:revision-bar-style を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-width -->
	<!-- <border-width> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-width -->
	<rule context="fo:*/@axf:revision-bar-width">
	  <report test="true()" sqf:fix="axf_revision-bar-width_fix" role="Warning">axf:revision-bar-width：同様の機能が XSL1.1 で用意しています。fo:change-bar-begin and fo:change-bar-end を利用して下さい。</report>
          <sqf:fix id="axf_revision-bar-width_fix">
	    <sqf:description>
              <sqf:title>@axf:revision-bar-width を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:suppress-duplicate-page-number -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.suppress-duplicate-page-number -->
	<rule context="fo:*/@axf:suppress-duplicate-page-number">
	  <report test="true()" sqf:fix="axf_suppress-duplicate-page-number_fix" role="Warning">axf:suppress-duplicate-page-number： 同様の機能が XSL1.1 で用意しています。merge-*-index-key-references を利用してください。</report>
          <sqf:fix id="axf_suppress-duplicate-page-number_fix">
	    <sqf:description>
              <sqf:title>@axf:suppress-duplicate-page-number を削除する。</sqf:title>
            </sqf:description>
	    <sqf:delete/>
          </sqf:fix>
	</rule>

	<!-- axf:text-justify -->
	<!-- auto | inter-word | inter-character | distribute -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.text-justify -->
	<rule context="fo:*/@axf:text-justify">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY')">axf:text-justify=&quot;<value-of select="."/>&quot; should be EnumerationToken. 「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inter-word', 'inter-character', 'distribute'))">axf:text-justify=&quot;<value-of select="."/>&quot; enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'inter-word', 'inter-character', or 'distribute'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-justify=&quot;&quot; should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:text-justify=&quot;<value-of select="."/>&quot;</report>
	  <report test="local-name($expression) = 'EnumerationToken' and    $expression/@token = 'distribute'" id="axf.text-justify" role="Warning" sqf:fix="axf.text-justify-fix">axf:text-justify=&quot;<value-of select="."/>&quot; has been replaced by 'inter-character'.</report>
	  <sqf:fix id="axf.text-justify-fix">
	    <sqf:description>
              <sqf:title>Change the @axf:text-justify value to 'inter-character'</sqf:title>
	    </sqf:description>
	    <sqf:replace node-type="attribute" target="axf:text-justify" select="'inter-character'"/>
	  </sqf:fix>
	</rule>

	<!-- axf:text-line-color -->
	<!-- auto | <color> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.text-line-color -->
	<rule context="fo:*/@axf:text-line-color">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:text-line-color=&quot;<value-of select="."/>&quot; は Color 又は auto でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>=&quot;<value-of select="."/>&quot; の EnumerationToken は <value-of select="$expression/@token"/> です。トークンは auto でなければなりません。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-line-color=&quot;&quot; は Color 又は auto でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： text-line-color=&quot;<value-of select="."/>&quot;</report>
	</rule>

	<!-- axf:text-line-style -->
	<!-- <border-style> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.w3.org/TR/xsl11/#axf:text-line-style -->
	<rule context="fo:*/@axf:text-line-style">
	  <extends rule="border-style"/>
	</rule>

	<!-- axf:text-line-width -->
	<!-- auto | <border-width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.text-line-width -->
	<rule context="fo:*/@axf:text-line-width">
	  <let name="expression" value="ahf:parser-runner(.)"></let>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:text-line-width=&quot;<value-of select="."/>&quot; は auto、thin、medium、thick、inherit 又は Length でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'thin', 'medium', 'thick', 'inherit'))">axf:text-line-width=&quot;<value-of select="."/>&quot; です。許可されたキーワードは auto、thin、medium、thick又は inherit です。トークン は <value-of select="$expression/@token"/> です。</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-line-width=&quot;&quot; は auto、thin、medium、thick、inherit 又は Length でなければなりません。</report>
	  <report test="local-name($expression) = 'ERROR'">シンタックスエラー： axf:text-line-width=&quot;<value-of select="."/>&quot;</report>
	</rule>

   <!-- color-profile-name -->
   <!-- #CMYK | #Grayscale | #RGB -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color-profile-name -->
   <!-- https://www.docs.antennahouse.com/formatter/ahf-pdf.html#pdfx -->
   <rule context="fo:*/@color-profile-name">
      <let name="expression" value="normalize-space(.)"></let>
      <report test="not($expression = ('#CMYK', '#Grayscale', '#RGB'))">color-profile-name=&quot;<value-of select="."/>&quot; です。許可されたキーワードは #CMYK、#Grayscale 又は #RGB です。トークン は <value-of select="$expression"/> です。</report>
   </rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow=&quot;<value-of select="."/>&quot; は fo:block-container 又は fo:inline-container のみに適用されています。</report>
	</rule>

</pattern><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->