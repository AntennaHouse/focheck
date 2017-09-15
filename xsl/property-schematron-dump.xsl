<!-- ============================================================= -->
<!--  MODULE:     property-schematron-dump.xsl                     -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Generate Schematron rules for XSL-FO properties  -->
<!--              from the XML for the XSL 1.1 Recommendation      -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: Schematron phase                                 -->
<!--                                                               -->
<!-- CREATED FOR: Antenna House                                    -->
<!--                                                               -->
<!-- CREATED BY:  Antenna House                                    -->
<!--              3844 Kennett Pike, Suite 200                     -->
<!--              Greenville, DE 19807                             -->
<!--              USA                                              -->
<!--              http://www.antennahouse.com/                     -->
<!--              support@antennahouse.com                         -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              3 February 2015                                  -->
<!--                                                               -->
<!-- CREATED BY:  Tony Graham (tgraham)                            -->
<!--                                                               -->
<!-- ============================================================= -->
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

<!-- ============================================================= -->
<!-- DESIGN CONSIDERATIONS                                         -->
<!-- ============================================================= -->
<!-- XML for the XSL 1.1 Recommendation is available at
     http://www.w3.org/TR/2006/REC-xsl11-20061205/xslspec.xml
                                                                   -->

<!-- ============================================================= -->
<!-- XSL STYLESHEET INVOCATION                                     -->
<!-- ============================================================= -->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:not-yet-xsl="file://not-yet-xsl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf not-yet-xsl xs">


<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Common parameters, keys, functions, and templates. -->
<xsl:import href="common.xsl" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<xsl:key name="property"
         match="div3"
         use="@id"/>
<xsl:key name="all-property-group"
         match="/spec/body/div1[@id='pr-section']/div2[@id]"
         use="@id"/>
<xsl:key name="property-group-by-property"
         match="/spec/body/div1[@id='pr-section']/div2[@id][exists(div3)]"
         use="div3/@id"/>
<xsl:key name="property-table"
         match="/spec/back/div1[@id='property-index']/div2[@id = 'prtab1']/table/tbody/tr/td[@class = 'propindex']/specref/@ref"
         use="."/>


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Parameters defined in 'common.xsl'. -->


<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Additional variables defined in 'common.xsl'. -->

<!-- Extended property values to override definitions in XSL spec.  -->
<xsl:variable name="property-value-overrides" as="element(item)*" />

<!-- Properties for which no Schematron rule will be generated.
     Mostly the properties that can have string values.

     This property may be overridden in a stylesheet that imports this
     stylesheet to produce a different set of skipped properties. -->
<xsl:variable name="skipped-properties" as="xs:string">
allowed-height-scale
allowed-width-scale
background-image
character
content-type
country
external-destination
font-family
format
grouping-separator
hyphenation-character
id
index-key
internal-destination
language
ref-id
ref-index-key
reference-orientation
role
src
text-align
</xsl:variable>

<xsl:variable
    name="skipped-properties-list" as="xs:string+"
    select="tokenize(normalize-space($skipped-properties), '\s')" />

<xsl:namespace-alias stylesheet-prefix="not-yet-xsl"
                     result-prefix="xsl" />

<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template match="/">
  <xsl:call-template name="ahf:initial-comment" />

  <xsl:if test="$debug">
    <xsl:message>Property groups:</xsl:message>
    <xsl:for-each select="key('all-property-group', true())">
      <xsl:sort select="@id"/>
      <xsl:message> - <xsl:value-of select="@id"/></xsl:message>
    </xsl:for-each>
    <xsl:message></xsl:message>

    <xsl:message>Allowed properties:</xsl:message>
    <xsl:for-each select="$all-properties">
      <xsl:sort/>
      <xsl:message> - <xsl:value-of select="."/></xsl:message>
    </xsl:for-each>
    <xsl:message></xsl:message>

    <xsl:message>Skipped properties:</xsl:message>
    <xsl:message select="$skipped-properties-list" />
  </xsl:if>

  <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
          xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
          id="fo-property">
    
    <not-yet-xsl:include href="{$xsl.dir}/parser-runner.xsl" />
    
    <xsl:for-each
      select="$all-properties">
      <xsl:sort/>

      <!-- Some variables controlling the generated code come from the
           spec. -->

      <!-- Property name as extracted from the XSL spec. -->
      <xsl:variable name="property" select="normalize-space(.)"/>

      <xsl:variable
          name="values"
          select="($property-value-overrides[@property = $property],
                   ahf:values($property))[1]"/>

      <!-- Initial value of the property. -->
      <xsl:variable name="initial-value"
                    select="ahf:initial-value(.)"/>

      <xsl:text>&#10;&#10;   </xsl:text>
      <xsl:comment>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$property" />
        <xsl:text> </xsl:text>
      </xsl:comment>
      <xsl:text>&#10;   </xsl:text>
      <xsl:comment>
        <xsl:text> </xsl:text>
        <xsl:value-of select="ahf:values($property)" />
        <xsl:text> </xsl:text>
      </xsl:comment>
      <xsl:text>&#10;   </xsl:text>
      <xsl:comment>
        <xsl:text> Inherited: </xsl:text>
        <xsl:value-of select="if (ahf:is-inherited(.)) then 'yes' else 'no'" />
        <xsl:text> </xsl:text>
      </xsl:comment>
      <xsl:text>&#10;   </xsl:text>
      <xsl:comment>
        <xsl:text> Shorthand: </xsl:text>
        <xsl:value-of select="if (ahf:is-shorthand(.)) then 'yes' else 'no'" />
        <xsl:text> </xsl:text>
      </xsl:comment>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment>
        <xsl:text> http://www.w3.org/TR/xsl11/#</xsl:text>
        <xsl:value-of select="$property" />
        <xsl:text> </xsl:text>
      </xsl:comment>
      <xsl:text>&#10;   </xsl:text>
      <rule context="fo:*/@{$property}">
        <xsl:choose>
          <xsl:when test="$property = $skipped-properties-list or
                          ahf:is-shorthand($property)">
            <!-- 'internal-destination' and 'external-destination' are
                 skipped, but they both can be an empty string. -->
            <xsl:if test="not($initial-value eq 'empty string')">
              <report test=". eq ''" role="Warning">
                <xsl:value-of select="$property" />
                <xsl:text>="" should be '</xsl:text>
                <xsl:value-of select="ahf:values($property)" />
                <xsl:text>'.</xsl:text>
              </report>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <let name="expression" value="ahf:parser-runner(.)"/>

            <xsl:variable
                name="datatypes"
                select="ahf:values-to-expression-types($values, $property)"
                as="xs:string+" />

            <!-- Contortions because NCName being returned from REx
                 parser as EnumerationToken/NCName and because <color>
                 is more than just a literal color. -->
            <xsl:variable
                name="use-datatypes"
                select="distinct-values(for $datatype in $datatypes
                                          return if ($datatype = ('NCName'))
                                                   then 'EnumerationToken'
                                                 else if ($datatype = ('Color', 'Literal'))
                                                   then ($datatype, 'EnumerationToken')
                                                 else $datatype)"
                as="xs:string+" />

            <!-- Enumeration tokens, if any, allowed for property. -->
            <xsl:variable name="enum-tokens" as="xs:string*">
              <xsl:call-template name="values-to-enum-report">
                <xsl:with-param
                    name="values"
                    select="normalize-space($values)"/>
                <xsl:with-param
                    name="property"
                    select="$property"/>
              </xsl:call-template>
            </xsl:variable>

            <assert
                test="local-name($expression) = ('{string-join(($use-datatypes,
                                                                'EMPTY',
                                                                'ERROR',
                                                                'Object'),
                                                               ''', ''')}'){if ($use-datatypes = 'Length' and not($use-datatypes = 'Number')) then ' or $expression/@value = ''0''' else ()}">
              <xsl:value-of select="$property" />
              <xsl:text>="</xsl:text>
              <value-of select="." />
              <xsl:text>" should be </xsl:text>
              <xsl:value-of
                  select="ahf:allowed-datatypes-text($use-datatypes,
                                                     $enum-tokens)" />
              <xsl:text>.  '</xsl:text>
              <value-of select="." />
              <xsl:text>' is a </xsl:text>
              <value-of select="local-name($expression)" />
              <xsl:text>.</xsl:text>
            </assert>

            <xsl:if test="exists($enum-tokens) and
                          not($datatypes = ('Color', 'NCName', 'URI'))">
              <report
                  test="{concat('$expression instance of element(EnumerationToken) and not($expression/@token = (''',
                                string-join($enum-tokens, ''', '''),
                                '''))')}">
                <xsl:value-of select="$property" />
                <xsl:text>="</xsl:text>
                <value-of select="." />
                <xsl:text>" token should be </xsl:text>
                <xsl:for-each select="$enum-tokens">
                  <xsl:value-of select="if (position() > 1)
                                          then (if (last() > 2)
                                                  then ','
                                                else (),
                                                if (position() = last())
                                                  then ' or '
                                                else ' ')
                                         else ()"
                                separator="" />
                  <xsl:text>'</xsl:text>
                  <xsl:value-of select="." />
                  <xsl:text>'</xsl:text>
                </xsl:for-each>
                <xsl:text>. Enumeration token is '</xsl:text>
                <value-of select="$expression/@token"/>
                <xsl:text>'.</xsl:text>
              </report>
            </xsl:if>
            <xsl:if test="not($initial-value eq 'empty string')">
              <report test="local-name($expression) = 'EMPTY'"
                      role="Warning">
                <xsl:value-of select="$property" />
                <xsl:text>="" should be </xsl:text>
                <xsl:value-of
                    select="ahf:allowed-datatypes-text($use-datatypes,
                                                       $enum-tokens)" />
                <xsl:text>.</xsl:text>
              </report>
            </xsl:if>
            <report test="local-name($expression) = 'ERROR'">
              <xsl:text>Syntax error: </xsl:text>
              <xsl:value-of select="$property" />
              <xsl:text>="</xsl:text>
              <value-of select="." />
              <xsl:text>"</xsl:text>
            </report>
          </xsl:otherwise>
        </xsl:choose>
      </rule>
    </xsl:for-each>
  </pattern>

</xsl:template>

  <!-- values-to-enum-report -->
  <xsl:template name="values-to-enum-report">
    <xsl:param name="values"/>
    <xsl:param name="property"/>
    
    <xsl:if test="$values">
      <xsl:variable name="token">
        <xsl:choose>
          <xsl:when test="contains($values, ' ')">
            <xsl:value-of select="substring-before($values, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$values"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="after-token"
        select="substring-after($values, ' ')"/>

      <xsl:variable name="is-punctuation-token"
                    select="ahf:is-punctuation-token($token)"
                    as="xs:boolean" />

      <xsl:if test="$debug >= 2">
        <xsl:message>token: '<xsl:value-of select="$token"/>', is-punctuation-token: '<xsl:value-of select="$is-punctuation-token"/>'</xsl:message>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$is-punctuation-token">
          <xsl:call-template name="values-to-enum-report">
            <xsl:with-param
              name="values"
              select="$after-token"/>
            <xsl:with-param
              name="property"
              select="$property"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="ahf:is-datatype-token($token)">
          <xsl:variable name="datatype"
            select="substring-before(substring-after($token, '&lt;'), '>')"/>
          <xsl:variable
              name="expanded-datatype"
              select="ahf:expand-datatype($datatype)"
              as="xs:string?" />
          <xsl:choose>
            <xsl:when test="string-length($expanded-datatype) = 0">
              <xsl:call-template name="values-to-enum-report">
                <xsl:with-param
                  name="values"
                  select="$after-token"/>
                <xsl:with-param
                  name="property"
                  select="$property"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="values-to-enum-report">
                <xsl:with-param
                  name="values"
                  select="concat($expanded-datatype, $after-token)"/>
                <xsl:with-param
                  name="property"
                  select="$property"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>

          <xsl:variable name="clean-token"
            select="translate($token, '-[]|,?', '_')"/>

    <xsl:sequence select="$token"/>

          <xsl:if test="$after-token">
            <xsl:call-template name="values-to-enum-report">
              <xsl:with-param
                name="values"
                select="$after-token"/>
              <xsl:with-param
                name="property"
                select="$property"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

<!-- expand-datatype -->
<!-- Some things that look like datatypes in the property values are
     really shorthands for two or more enumerated values.  This named
     template expands the $datatype parameter, if possible.

     This named template is used by the various other named templates
     that each do something for each enumeration token.  When the
     result of this template is an empty string, the calling template
     typically goes on to process the tokens after the token for the
     current datatype.  When the result of this template is an
     expansion into multiple enumeration tokens, the calling template
     typically processes the concatenation of this result and the
     remainder of the original value string that came after the
     datatype. -->
<xsl:function name="ahf:expand-datatype" as="xs:string?">
  <xsl:param name="datatype" as="xs:string" />

  <xsl:variable name="datatype-map" as="element(map)+">
    <map datatype="absolute-size">xx-small | x-small | small | medium | large | x-large | xx-large </map>
    <map datatype="keep">auto | always | &lt;integer> </map>
    <map datatype="margin-width">auto | &lt;length> | &lt;percentage> </map>
    <map datatype="padding-width">&lt;length> | &lt;percentage> </map>
    <map datatype="relative-size">larger | smaller </map>
    <map datatype="background-attachment">scroll | fixed | inherit</map>
    <map datatype="background-color">&lt;color> | transparent | inherit</map>
    <map datatype="background-image">&lt;uri-specification> | none | inherit</map>
    <map datatype="background-position"> [&lt;percentage> | &lt;length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit</map>
    <map datatype="background-repeat">&lt;uri-specification> | none | inherit</map>
    <map datatype="border-style">none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset </map>
    <map datatype="border-width">thin | medium | thick | &lt;length> </map>
    <map datatype="generic-family">serif | sans-serif | cursive | fantasy | monospace </map>
    <map datatype="family-name">&lt;string></map>
    <map datatype="color">&lt;literal-color> | aqua | black | blue | fuchsia | gray | green | lime | maroon | navy | olive | purple | red | silver | teal | white | yellow </map>
    <map datatype="country">&lt;string></map>
    <map datatype="language">&lt;string></map>
    <map datatype="script">&lt;string></map>
  </xsl:variable>

  <xsl:if test="exists($datatype-map[@datatype eq $datatype])">
    <xsl:if test="$debug">
      <xsl:message>Expanding &lt;<xsl:value-of select="$datatype" />></xsl:message>
    </xsl:if>
    <xsl:sequence select="$datatype-map[@datatype eq $datatype]" />
  </xsl:if>
</xsl:function>

<!-- ahf:is-punctuation-token($token as xs:string) as xs:boolean -->
<!-- Returns true() if $token is a "punctuation token", i.e., if it's
     recognisably not a datatype name in a property value
     definition. -->
<xsl:function name="ahf:is-punctuation-token" as="xs:boolean">
  <xsl:param name="token" as="xs:string" />

  <xsl:sequence select="$token = '[[' or
                        $token = '[' or
                        $token = '||' or
                        $token = '|' or
                        $token = '/' or
                        $token = ',]*' or
                        $token = ',]' or
                        $token = ',' or
                        starts-with($token, ']')" />
</xsl:function>

<!-- ahf:is-datatype-token($token as xs:string) as xs:boolean -->
<!-- Returns true() if $token is a "datatype token", i.e., if it's
     recognised as a datatype name in a property value definition
     because it contains '<'. -->
<xsl:function name="ahf:is-datatype-token" as="xs:boolean">
  <xsl:param name="token" as="xs:string" />

  <xsl:sequence select="starts-with($token, '&lt;') or
                        starts-with($token, '[&lt;') or
                        starts-with($token, '[[&lt;')" />
</xsl:function>

<!-- ahf:values-to-expression-types($values as xs:string, $property as xs:string) as xs:string+ -->
<xsl:function name="ahf:values-to-expression-types" as="xs:string*">
  <xsl:param name="values" as="xs:string" />
  <xsl:param name="property" as="xs:string" />

  <xsl:sequence
      select="ahf:values-to-expression-types($values, $property, false())" />
</xsl:function>

<!-- ahf:values-to-expression-types($values as xs:string, $property as xs:string, $seen-enum as xs:boolean) as xs:string+ -->
<xsl:function name="ahf:values-to-expression-types" as="xs:string*">
  <xsl:param name="values" as="xs:string" />
  <xsl:param name="property" as="xs:string" />
  <xsl:param name="seen-enum" as="xs:boolean" />

    <xsl:if test="$values">
      <xsl:variable name="token">
        <xsl:choose>
          <xsl:when test="contains($values, ' ')">
            <xsl:value-of select="substring-before($values, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$values"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="after-token"
        select="substring-after($values, ' ')"/>

      <xsl:variable name="is-punctuation-token"
                    select="ahf:is-punctuation-token($token)"
                    as="xs:boolean" />

      <xsl:variable name="is-datatype-token"
                    select="ahf:is-datatype-token($token)"
                    as="xs:boolean" />

      <xsl:variable name="datatype"
        select="substring-before(substring-after($token, '&lt;'), '>')"/>

      <xsl:variable
          name="expanded-datatype"
          select="ahf:expand-datatype($datatype)"
          as="xs:string?"/>

      <xsl:if test="$debug >= 3">
        <xsl:message>token: '<xsl:value-of select="$token"/>'</xsl:message>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$is-punctuation-token">
          <xsl:sequence
              select="ahf:values-to-expression-types($after-token,
                                                     $property,
                                                     $seen-enum)" />
        </xsl:when>
        <xsl:when test="$is-datatype-token and
                        string-length($expanded-datatype) != 0">
          <xsl:sequence
              select="ahf:values-to-expression-types(concat($expanded-datatype, $after-token),
                                                     $property,
                                                     $seen-enum)" />
        </xsl:when>
        <xsl:otherwise>
        <!-- To get here, it's either a real datatype or it's an
             enumeration token -->

          <xsl:if test="$debug >= 2">
            <xsl:message>token: '<xsl:value-of select="$token"/>', is-punctuation-token: '<xsl:value-of select="$is-punctuation-token"/>'</xsl:message>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="$is-datatype-token">
              <xsl:variable name="datatype-map" as="element(map)+">
                <map datatype="angle">Literal</map>
                <map datatype="character">Literal</map>
                <map datatype="literal-color">Color</map>
                <map datatype="id">EnumerationToken</map>
                <map datatype="shape">Function</map>
                <map datatype="idref">EnumerationToken</map>
                <map datatype="integer">Number</map>
                <map datatype="length">Length</map>
                <map datatype="length-conditional">Length</map>
                <map datatype="length-bp-ip-direction">Length</map>
                <map datatype="length-range">Length</map>
                <map datatype="name">NCName</map>
                <map datatype="number">Number</map>
                <map datatype="percentage">Percent</map>
                <map datatype="space">Length</map>
                <map datatype="string">Literal</map>
                <map datatype="uri-specification">URI</map>
              </xsl:variable>

              <xsl:choose>
                <xsl:when test="exists($datatype-map[@datatype eq $datatype])">
                  <xsl:sequence select="$datatype-map[@datatype eq $datatype]" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message terminate="no">Unsupported datatype: <xsl:value-of select="$datatype"/></xsl:message>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:sequence
                  select="ahf:values-to-expression-types($after-token,
                                                         $property,
                                                         $seen-enum)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="not($seen-enum)">
                <xsl:sequence select="'EnumerationToken'" />
              </xsl:if>
              <xsl:sequence
                  select="ahf:values-to-expression-types($after-token,
                                                         $property,
                                                         true())" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:function>

</xsl:stylesheet>
