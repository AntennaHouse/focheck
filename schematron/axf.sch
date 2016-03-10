<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copyright 2015-2016 Antenna House, Inc.

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
        <p>http://www.antennahouse.com/product/ahf63/ahf-ext.html#axf.document-info</p>
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

	<!-- axf:background-color -->
	<!-- <color> | transparent | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-color -->
	<rule context="fo:*/@axf:background-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-color="<value-of select="."/>" should be Color or EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-color="" should be Color or EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-color="<value-of select="."/>"</report>
	</rule>

	<!-- axf:background-content-height -->
	<!-- auto | scale-to-fit | scale-down-to-fit | scale-up-to-fit | <length> | <percentage> | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-content-height -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-content-type -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-content-width -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-color -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-image -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-position -->
	<rule context="fo:*/@background-position">
	  <report test=". eq ''" role="Warning">background-position="" should be '[ [&lt;percentage&gt; | &lt;length&gt; ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit'.</report>
	</rule>

	<!-- axf:background-position-horizontal -->
	<!-- <percentage> | <length> | left | center | right | inherit -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-position-horizontal -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-position-vertical -->
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#background-repeat -->
	<rule context="fo:*/@axf:background-repeat">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">background-repeat="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'paginate'))">background-repeat="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'paginate'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">background-repeat="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: background-repeat="<value-of select="."/>"</report>
	</rule>

	<!-- axf:outline-color -->
	<!-- <color> -->
	<!-- Inherited: false -->
	<rule context="fo:*/@axf:outline-color">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'axf:outline-color' should be Color or a color name.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: 'axf:outline-color="<value-of select="."/>"'</report>
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
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#scaling -->
	<rule context="fo:*/@axf:background-scaling">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'EMPTY', 'ERROR', 'Object')">scaling="<value-of select="."/>" should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">scaling="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">scaling="" should be EnumerationToken.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: scaling="<value-of select="."/>"</report>
	</rule>

	<!-- axf:hyphenation-zone -->
	<!-- none | <length> -->
	<!-- Inherited: yes -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#axf.hyphenation-zone -->
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

	<!-- axf:line-number-interval -->
	<!-- <number> | auto -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#axf.line-number-interval -->
	<rule context="fo:*/@axf:line-number-interval">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'EMPTY', 'ERROR')">axf:line-number-interval="<value-of select="."/>" should be EnumerationToken or Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">axf:line-number-interval="<value-of select="."/>" enumeration token is '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-interval="" should be EnumerationToken or Number.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-interval="<value-of select="."/>"</report>
	</rule>

	<!-- axf:line-number-offset -->
	<!-- <length> -->
	<!-- Inherited: no -->
	<!-- Shorthand: no -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#axf.line-number-offset -->
	<rule context="fo:*/@axf:line-number-offset">
	  <let name="expression" value="ahf:parser-runner(.)"/>
	  <assert test="local-name($expression) = ('Length', 'EMPTY', 'ERROR')">axf:line-number-offset="<value-of select="."/>" should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
	  <report test="local-name($expression) = 'EMPTY'" role="Warning">axf:line-number-offset="" should be Length.</report>
	  <report test="local-name($expression) = 'ERROR'">Syntax error: axf:line-number-offset="<value-of select="."/>"</report>
	</rule>

	<!-- overflow -->
	<!-- visible | hidden | scroll | error-if-overflow | repeat | replace | condense | auto -->
	<!-- http://www.antennahouse.com/product/ahf63/ahf-ext.html#axf.overflow -->
	<rule context="fo:*/@overflow">
	  <report test=". = ('replace', 'condense') and not(local-name(..) = ('block-container', 'inline-container'))">overflow="<value-of select="."/>" applies only on fo:block-container or fo:inline-container.</report>
	</rule>

    </pattern>
</schema>
