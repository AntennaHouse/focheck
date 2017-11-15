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
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	queryBinding="xslt2">
    <xsl:key name="flow-name"
	     match="fo:flow | fo:static-content"
	     use="@flow-name" />
    <xsl:key name="index-key"
	     match="*[exists(@index-key)]"
	     use="@index-key" />
    <xsl:key name="master-name"
	     match="fo:simple-page-master | fo:page-sequence-master |
		    axf:spread-page-master"
	     use="@master-name" />
    <xsl:key name="region-name"
	     match="fo:region-before | fo:region-after |
		    fo:region-start | fo:region-end |
		    fo:region-body | axf:spread-region"
	     use="@region-name" />

    <include href="fo.sch"/>
    <include href="fo-property.sch" />
    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo" />
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf" />
    <ns uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf" />
    
    <phase id="fo">
        <active pattern="fo-fo" /></phase>
    <phase id="property">
        <active pattern="fo-property"></active>
    </phase>

    <pattern id="axf">
	<!-- axf:document-info -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.document-info -->
        <p>http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.document-info</p>
        <rule context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1" role="axf-1">
	  <assert test="empty(../axf:document-info[@name eq 'xmp'])" role="axf-2">name="<value-of select="@name"/>" cannot be used when axf:document-info with name="xmp" is present.</assert>
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

	<!-- axf:annotation-color -->
	<!-- <color> | none -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.annotation-color -->
	<rule context="fo:*/@axf:annotation-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">axf:annotation-color="<value-of select="."/>" should be Color or 'none'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">annotation-color="" should be Color or 'none'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: annotation-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:annotation-contents -->
	<!-- <contents> | none -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.annotation-contents -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#background-color -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-content -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-content -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-content-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object')">content-width="<value-of select="."/>" should be EnumerationToken, Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">content-width="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">content-width="" should be EnumerationToken, Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: content-width="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-image -->
	<!-- <uri-specification> | none | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-image -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-position-horizontal -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-position-vertical -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-repeat -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.baseline-block-snap -->
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

	<!-- axf:background-scaling -->
	<!-- uniform | non-uniform | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.background-content -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.column-rule-length -->
	<rule context="fo:*/@axf:column-rule-length">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:column-rule-length="<value-of select="."/>" should be Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:column-rule-length="" should be Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:column-rule-length="<value-of select="."/>"</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.hyphenation-zone -->
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
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.indent-here -->
	<rule context="fo:*/@axf:indent-here">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY')">axf:indent-here="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none'))">axf:indent-here="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'none'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:indent-here="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:indent-here="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-background-color -->
	<!-- <color> | transparent -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-background-color -->
	<rule context="fo:*/@axf:line-number-background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Color', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be a Color, a color name, or 'transparent'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Color.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-color -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf:line-number-font-size -->
	<rule context="fo:*/@axf:line-number-font-size">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'EMPTY', 'ERROR', 'Object') or $expression/@value = '0'">axf:line-number-font-size="<value-of select="."/>" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller'))">axf:line-number-font-size="<value-of select="."/>" token should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', or 'smaller'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-font-size="" should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', Length, or Percent.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-font-size="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-initial -->
	<!-- auto | <number> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-initial -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-interval -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-offset -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-start -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-text-decoration -->
	<rule context="fo:*/@text-decoration">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">text-decoration="<value-of select="."/>" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">text-decoration="<value-of select="."/>" token should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'. Enumeration token is '<value-of select="$expression/@token"/>'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">text-decoration="" should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: text-decoration="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-width -->
	<!-- auto | <width> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.line-number-width -->
	<rule context="fo:*/@axf:line-number-width">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'EMPTY', 'ERROR')"><value-of select="name(.)"/>="<value-of select="."/>" should be EnumerationToken or Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))"><value-of select="name(.)"/>="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning"><value-of select="name(.)"/>="" should be EnumerationToken or Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: <value-of select="name(.)"/>="<value-of select="."/>"</report>
	</rule>

	<!-- axf:page-number-prefix -->
	<!-- <string> -->
	<!-- Inherited: no -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.page-number-prefix -->
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

	<!-- axf:revision-bar-color -->
	<!-- <color> -->
	<!-- Inherited: yes -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.revision-bar-color -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.revision-bar-offset -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.revision-bar-position -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.revision-bar-style -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.revision-bar-width -->
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
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.suppress-duplicate-page-number -->
	<rule context="fo:*/@axf:suppress-duplicate-page-number">
	  <report test="true()" sqf:fix="axf_suppress-duplicate-page-number_fix" role="Warning">axf:suppress-duplicate-page-number: A similar function is provided in XSL 1.1. Please use merge-*-index-key-references.</report>
          <sqf:fix id="axf_suppress-duplicate-page-number_fix">
	    <sqf:description>
              <sqf:title>Delete @axf:suppress-duplicate-page-number.</sqf:title>
            </sqf:description>
	    <sqf:delete />
          </sqf:fix>
	</rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- http://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow="<value-of select="."/>" applies only on fo:block-container or fo:inline-container.</report>
	</rule>

    </pattern>
</schema>
