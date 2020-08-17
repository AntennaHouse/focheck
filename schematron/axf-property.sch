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
<pattern id="axf-property"
	 xmlns="http://purl.oclc.org/dsdl/schematron"
	 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- axf:annotation-color -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.annotation-color -->
	<rule context="fo:*/@axf:annotation-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:annotation-color="<value-of select="."/>" should be Color or 'none'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">annotation-color="" should be Color or 'none'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: annotation-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:annotation-contents -->
	<!-- <contents> | none -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.annotation-contents -->
	<rule context="fo:*/@axf:annotation-contents">
	  <assert test="normalize-space(../@axf:annotation-type) = ('Text', 'FreeText', 'Stamp', 'FileAttachment') or local-name(..) = 'basic-link'" role="Warning"><value-of select="name(.)"/> should be used only when @axf:annotation-type is 'Text', 'FreeText', 'Stamp', or 'FileAnnotation' or on fo:basic-link.</assert>
	</rule>

	<!-- axf:assumed-page-number -->
	<!-- <number> -->
	<!-- Inherited: yes -->
	<rule context="fo:*/@axf:assumed-page-number">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'axf:assumed-page-number should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'assumed-page-number="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-height">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-height="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-height="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-height="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-height="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type="" should be Literal or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-type="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-width -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-width="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-image -->
	<rule context="fo:*/@axf:background-image">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-image="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">background-image="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-image="" should be URI or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-image="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-position -->
	<!-- [ [<percentage> | <length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position-horizontal -->
	<rule context="fo:*/@axf:background-position-horizontal">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-horizontal="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">background-position-horizontal="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-horizontal="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-horizontal="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-position-vertical -->
	<!-- <percentage> | <length> | top | center | bottom -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-position-vertical -->
	<rule context="fo:*/@axf:background-position-vertical">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-position-vertical="<value-of select="."/>" should be Percent, Length, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">background-position-vertical="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'top', 'center', or 'bottom'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-position-vertical="" should be Percent, Length, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-position-vertical="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-repeat -->
	<!-- repeat | repeat-x | repeat-y | no-repeat | paginate -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>"</report>
	</rule>

	<!-- axf:baseline-block-snap -->
	<!-- none | [auto | before | after | center] || [border-box | margin-box] -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.baseline-block-snap -->
	<rule context="fo:*/@axf:baseline-block-snap">
	  <assert test="exists(../@axf:baseline-grid) and normalize-space(../@axf:baseline-grid) = ('new', 'none')" role="Warning">axf:baseline-block-snap applies only when axf:baseline-grid is 'new' or 'none'.</assert>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:outline-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:outline-color="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:float -->
	<!-- <float-x> || <float-y> || <float-wrap> || <float-reference> || <float-move> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:float">
	  <let name="tokens" value="tokenize(normalize-space(.), '\s+')" />
	  <assert test="every $token in $tokens satisfies matches($token, '^(after|alternate|auto|auto-move|auto-next|before|bottom|center|column|end|inside|keep|keep-float|left|multicol|next|none|normal|outside|page|right|skip|start|top|wrap)$')">Every token in 'axf:float' should be 'after', 'alternate', 'auto', 'auto-move', 'auto-next', 'before', 'bottom', 'center', 'column', 'end', 'inside', 'keep', 'keep-float', 'left', 'multicol', 'next', 'none', 'normal', 'outside', 'page', 'right', 'skip', 'start', 'top' or 'wrap'.  Value is '<value-of select="."/>'.</assert>
	  <assert test="every $token in $tokens satisfies count($tokens[. eq $token]) = 1">Tokens in 'axf:float' must not be repeated.  Value is '<value-of select="."/>'.</assert>
	</rule>

	<!-- axf:outline-level -->
	<!-- <number> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-level">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'axf:outline-level should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'outline-level="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- axf:background-content-width -->
	<rule context="fo:*/@axf:background-content-height | fo:*/@axf:background-content-width">
	  <report test="true()" role="Warning"><value-of select="name(.)" /> should not be used with AH Formatter V6.6 or later.  Use axf:background-size with AH Formatter V6.6 or later.</report>
	</rule>

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))"><value-of select="name(.)" />="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>"</report>
	</rule>

	<!-- axf:column-rule-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:column-rule-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:column-rule-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:column-rule-color="<value-of select="."/>"'</report>
	</rule>

	<!-- axf:column-rule-length -->
	<!-- <length> | <percentage> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.column-rule-length -->
	<rule context="fo:*/@axf:column-rule-length">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:column-rule-length="<value-of select="."/>" should be Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:column-rule-length="" should be Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:column-rule-length="<value-of select="."/>"</report>
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
	<rule context="fo:*/@axf:field-button-icon |
		       fo:*/@axf:field-button-icon-down |
		       fo:*/@axf:field-button-icon-rollover">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EMPTY', 'ERROR', 'Object')">field-button-icon="<value-of select="."/>" should be URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="local-name(.)"/>="" should be URI.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="local-name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:field-font-size -->
	<!-- font-size | auto | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.field-font-size -->
	<rule context="fo:*/@axf:field-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:field-font-size="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('font-size', 'auto'))">axf:field-font-size="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'font-size' or 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:field-font-size="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:field-font-size="<value-of select="."/>"</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.hyphenation-zone -->
	<rule context="fo:*/@axf:hyphenation-zone">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:hyphenation-zone="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:hyphenation-zone="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:hyphenation-zone="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:hyphenation-zone="<value-of select="."/>"</report>
	  <report test="local-name($expression) = 'Length' and
			(exists($expression/@is-positive) and $expression/@is-positive eq 'no' or
			$expression/@is-zero = 'yes')" id="axf.hyphenation-zone" role="Warning" sqf:fix="axf.hyphenation-zone-fix">axf:hyphenation-zone="<value-of select="."/>" should be a positive length.</report>
	  <sqf:fix id="axf.hyphenation-zone-fix">
	    <sqf:description>
              <sqf:title>Change the @axf:hyphenation-zone value to 'none'</sqf:title>
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
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:indent-here="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:indent-here="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:indent-here="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:indent-here="<value-of select="."/>"</report>
	</rule>

	<!-- axf:initial-letters-color -->
	<!-- <color> | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.initial-letters -->
	<rule context="fo:*/@axf:initial-letters-color">
	  <extends rule="color" />
	</rule>

	<!-- axf:keep-together-within-dimension -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.keep-together-within-dimension -->
	<rule context="fo:*/@axf:keep-together-within-dimension">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:keep-together-within-dimension="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">axf:keep-together-within-dimension="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:keep-together-within-dimension="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:keep-together-within-dimension="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-background-color -->
	<!-- <color> | transparent -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-background-color -->
	<rule context="fo:*/@axf:line-number-background-color">
	  <extends rule="color-transparent" />
	</rule>

	<!-- axf:line-number-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-color -->
	<rule context="fo:*/@axf:line-number-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be a Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be a Color or a color name.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-font-size -->
	<!-- <absolute-size> | <relative-size> | <length> | <percentage> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf:line-number-font-size -->
	<rule context="fo:*/@axf:line-number-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:line-number-font-size="<value-of select="."/>" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller'))">axf:line-number-font-size="<value-of select="."/>". Allowed keywords are 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', and 'smaller'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-font-size="" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-font-size="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-initial -->
	<!-- auto | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-initial -->
	<rule context="fo:*/@axf:line-number-initial">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-interval -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-interval -->
	<rule context="fo:*/@axf:line-number-interval">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-offset -->
	<!-- <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-offset -->
	<rule context="fo:*/@axf:line-number-offset">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR')">axf:line-number-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-offset="" should be Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-offset="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-start -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-start -->
	<rule context="fo:*/@axf:line-number-start">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-text-decoration -->
	<!-- none | [ [ underline | no-underline] || [ overline | no-overline ] || [ line-through | no-line-through ] || [ blink | no-blink ] ] | inherit -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-text-decoration -->
	<rule context="fo:*/@text-decoration">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration="<value-of select="."/>" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration="<value-of select="."/>". Allowed keywords are 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration="" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: text-decoration="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-width -->
	<!-- auto | <width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.line-number-width -->
	<rule context="fo:*/@axf:line-number-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-duration -->
	<!-- intrinsic | infinity | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-duration -->
	<rule context="fo:*/@axf:media-duration">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('intrinsic', 'infinity'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'intrinsic' or 'infinity'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	  <report test="../@axf:media-play-mode = 'once'" role="Warning"><value-of select="name(.)"/> is invalid when axf:media-play-mode="once" is specified.</report>
	</rule>

	<!-- axf:media-play-mode -->
	<!-- once | continuously | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-play-mode -->
	<rule context="fo:*/@axf:media-play-mode">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('once', 'continuously'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'once' or 'continuously'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-skin-color -->
	<!-- auto | <color> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-skin-color -->
	<rule context="fo:*/@axf:media-skin-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:media-skin-color="<value-of select="."/>" should be Color or 'auto'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">media-skin-color="" should be Color or 'auto'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: media-skin-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-volume -->
	<!-- <percentage> | <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-volume -->
	<rule context="fo:*/@axf:media-volume">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Percent', 'Number', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">media-volume="<value-of select="."/>" should be Percent, Number, or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">media-volume="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be Percent, Number, or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: media-volume="<value-of select="."/>"</report>
	</rule>

	<!-- axf:media-window-height -->
	<!-- axf:media-window-width -->
	<!-- auto | <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-window-height -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.media-window-width -->
	<rule context="fo:*/@axf:media-window-height |
		       fo:*/@axf:media-window-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:page-number-prefix -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.page-number-prefix -->
	<rule context="fo:*/@axf:page-number-prefix">
	  <report test="true()" sqf:fix="axf_page-number-prefix_fix" role="Warning">axf:page-number-prefix: A similar function is provided in XSL 1.1. Please use fo:folio-prefix.</report>
          <sqf:fix id="axf_page-number-prefix_fix">
	    <sqf:description>
              <sqf:title>Change @axf:page-number-prefix into fo:folio-prefix.</sqf:title>
            </sqf:description>
            <sqf:add node-type="element" target="fo:folio-prefix">
	      <value-of select="." />
	    </sqf:add>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:poster-content-type -->
	<!-- <string> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.poster-content -->
	<rule context="fo:*/@axf:poster-content-type">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">content-type="<value-of select="."/>" should be Literal or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">content-type="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-type="" should be Literal or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-type="<value-of select="."/>"</report>
	</rule>

	<!-- axf:poster-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.poster-image -->
	<rule context="fo:*/@axf:poster-image">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">poster-image="<value-of select="."/>" should be URI or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto'))">poster-image="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">poster-image="" should be URI or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: poster-image="<value-of select="."/>"</report>
	</rule>

	<!-- axf:revision-bar-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-color -->
	<rule context="fo:*/@axf:revision-bar-color">
	  <report test="true()" sqf:fix="axf_revision-bar-color_fix" role="Warning">axf:revision-bar-color: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-color_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-color.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-offset -->
	<!-- <length> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-offset -->
	<rule context="fo:*/@axf:revision-bar-offset">
	  <report test="true()" sqf:fix="axf_revision-bar-offset_fix" role="Warning">axf:revision-bar-offset: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-offset_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-offset.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-position -->
	<!-- start | end | inside | outside | alternate | both -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-position -->
	<rule context="fo:*/@axf:revision-bar-position">
	  <report test="true()" sqf:fix="axf_revision-bar-position_fix" role="Warning">axf:revision-bar-position: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-position_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-position.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-style -->
	<!-- <border-style> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-style -->
	<rule context="fo:*/@axf:revision-bar-style">
	  <report test="true()" sqf:fix="axf_revision-bar-style_fix" role="Warning">axf:revision-bar-style: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-style_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-style.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:revision-bar-width -->
	<!-- <border-width> -->
	<!-- Inherited: yes -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.revision-bar-width -->
	<rule context="fo:*/@axf:revision-bar-width">
	  <report test="true()" sqf:fix="axf_revision-bar-width_fix" role="Warning">axf:revision-bar-width: A similar function is provided in XSL 1.1. Please use fo:change-bar-begin and fo:change-bar-end.</report>
          <sqf:fix id="axf_revision-bar-width_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:revision-bar-width.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:suppress-duplicate-page-number -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.suppress-duplicate-page-number -->
	<rule context="fo:*/@axf:suppress-duplicate-page-number">
	  <report test="true()" sqf:fix="axf_suppress-duplicate-page-number_fix" role="Warning">axf:suppress-duplicate-page-number: A similar function is provided in XSL 1.1. Please use merge-*-index-key-references.</report>
          <sqf:fix id="axf_suppress-duplicate-page-number_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:suppress-duplicate-page-number.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- axf:text-justify -->
	<!-- auto | inter-word | inter-character | distribute -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.text-justify -->
	<rule context="fo:*/@axf:text-justify">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY')">axf:text-justify="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inter-word', 'inter-character', 'distribute'))">axf:text-justify="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'inter-word', 'inter-character', or 'distribute'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-justify="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:text-justify="<value-of select="."/>"</report>
	  <report test="local-name($expression) = 'EnumerationToken' and
			$expression/@token = 'distribute'" id="axf.text-justify" role="Warning" sqf:fix="axf.text-justify-fix">axf:text-justify="<value-of select="."/>" has been replaced by 'inter-character'.</report>
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
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:text-line-color="<value-of select="."/>" should be Color or 'auto'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-line-color="" should be Color or 'auto'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: text-line-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:text-line-style -->
	<!-- <border-style> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.w3.org/TR/xsl11/#axf:text-line-style -->
	<rule context="fo:*/@axf:text-line-style">
	  <extends rule="border-style" />
	</rule>

	<!-- axf:text-line-width -->
	<!-- auto | <border-width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.text-line-width -->
	<rule context="fo:*/@axf:text-line-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:text-line-width="<value-of select="."/>" should be 'auto', 'thin', 'medium', 'thick', 'inherit', or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'thin', 'medium', 'thick', 'inherit'))">axf:text-line-width="<value-of select="."/>". Allowed keywords are 'auto', 'thin', 'medium', 'thick', and 'inherit'. Token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:text-line-width="" should be 'auto', 'thin', 'medium', 'thick', 'inherit', or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:text-line-width="<value-of select="."/>"</report>
	</rule>

   <!-- color-profile-name -->
   <!-- #CMYK | #Grayscale | #RGB -->
   <!-- Inherited: no -->
   <!-- Shorthand: no -->
   <!-- http://www.w3.org/TR/xsl11/#color-profile-name -->
   <!-- https://www.docs.antennahouse.com/formatter/ahf-pdf.html#pdfx -->
   <rule context="fo:*/@color-profile-name">
      <let name="expression" value="normalize-space(.)"/>
      <report test="not($expression = ('#CMYK', '#Grayscale', '#RGB'))">color-profile-name="<value-of select="."/>". Allowed keywords are '#CMYK', '#Grayscale', and '#RGB'. Token is '<value-of select="$expression"/>'.</report>
   </rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow="<value-of select="."/>" applies only on fo:block-container or fo:inline-container.</report>
	</rule>

</pattern>

<!-- Local Variables:  -->
<!-- mode: nxml        -->
<!-- End:              -->
