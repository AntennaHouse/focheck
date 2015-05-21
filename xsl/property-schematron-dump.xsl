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
external-destination
font-family
format
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
      select="$all-properties[not(. = $skipped-properties-list) and
                              not(ahf:is-shorthand(.))]">
      <xsl:sort/>

      <!-- Some variables controlling the generated code come from the spec. -->

      <!-- Property name as extracted from the XSL spec. -->
      <xsl:variable name="property" select="normalize-space(.)"/>

      <xsl:variable name="values"
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
      <rule context="fo:*/@{$property}">
        <let name="expression" value="ahf:parser-runner(.)"/>

        <xsl:variable name="datatypes" as="xs:string+">
          <xsl:call-template name="values-to-expression-types">
            <xsl:with-param
                name="values"
                select="$values"/>
            <xsl:with-param
                name="property"
                select="$property"/>
            <xsl:with-param
                name="seen-enum"
                select="false()"/>
          </xsl:call-template>
        </xsl:variable>

        <!-- Contortions because NCName being returned from REx parser
             as EnumerationToken/NCName and because <color> is more
             than just a literal color. -->
        <xsl:variable
            name="use-datatypes"
            select="distinct-values(for $datatype in $datatypes
                                      return if ($datatype = ('NCName'))
                                               then 'EnumerationToken'
                                             else if ($datatype = ('Color'))
                                               then ('Color', 'EnumerationToken')
                                             else $datatype)"
            as="xs:string+" />
        <assert
            test="local-name($expression) = ('{string-join(($use-datatypes,
                                                            'ERROR',
                                                            'Object'),
                                                           ''', ''')}')">
          <xsl:text>'</xsl:text>
          <xsl:value-of select="$property" />
          <xsl:text>' should be </xsl:text>
          <xsl:for-each select="$use-datatypes">
            <xsl:value-of select="if (position() > 1)
                                    then (if (last() > 2)
                                            then ','
                                          else (),
                                          if (position() = last())
                                            then ' or '
                                          else ' ')
                                   else ()"
                          separator="" />
            <xsl:value-of select="." />
          </xsl:for-each>
          <xsl:text>.  '</xsl:text>
          <value-of select="." />
          <xsl:text>' is a </xsl:text>
          <value-of select="local-name($expression)" />
          <xsl:text>.</xsl:text>
        </assert>

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

        <xsl:if test="exists($enum-tokens) and
                      not($datatypes = ('Color', 'NCName'))">
          <report
              test="{concat('$expression instance of element(EnumerationToken) and not($expression/@token = (''',
                            string-join($enum-tokens, ''', '''),
                            '''))')}">
            <xsl:text>'</xsl:text>
            <xsl:value-of select="$property" />
            <xsl:text>' enumeration token is '</xsl:text>
            <value-of select="$expression/@token"/>
            <xsl:text>'.  Token should be </xsl:text>
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
            <xsl:text>.</xsl:text>
          </report>
        </xsl:if>
        <report test="local-name($expression) = 'ERROR'">
          <xsl:text>Syntax error: '</xsl:text>
          <xsl:value-of select="$property" />
          <xsl:text>="</xsl:text>
          <value-of select="." />
          <xsl:text>"'</xsl:text>
        </report>
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

      <xsl:variable name="is-punctuation-token">
        <xsl:call-template name="is-punctuation-token">
          <xsl:with-param name="token" select="$token"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="is-datatype-token">
        <xsl:call-template name="is-datatype-token">
          <xsl:with-param name="token" select="$token"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$debug >= 2">
        <xsl:message>token: '<xsl:value-of select="$token"/>', is-punctuation-token: '<xsl:value-of select="$is-punctuation-token"/>'</xsl:message>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$is-punctuation-token = 'TRUE'">
          <xsl:call-template name="values-to-enum-report">
            <xsl:with-param
              name="values"
              select="$after-token"/>
            <xsl:with-param
              name="property"
              select="$property"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$is-datatype-token = 'TRUE'">
          <xsl:variable name="datatype"
            select="substring-before(substring-after($token, '&lt;'), '>')"/>
          <xsl:variable name="expanded-datatype">
            <xsl:call-template name="expand-datatype">
              <xsl:with-param name="datatype" select="$datatype"/>
            </xsl:call-template>
          </xsl:variable>
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
       that each do something for each enumeration token.  When the result
       of this template is an empty string, the calling template typically
       goes on to process the tokens after the token for the current
       datatype.  When the result of this template is an expansion into
       multiple enumeration tokens, the calling template typically
       processes the concatenation of this result and the
       remainder of the original value string that came after the
       datatype. -->
  <xsl:template name="expand-datatype">
    <xsl:param name="datatype"/>

    <xsl:choose>
      <xsl:when test="$datatype = 'absolute-size'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;absolute-size></xsl:message>
        </xsl:if>
        <xsl:text>xx-small | x-small | small | medium | large | x-large | xx-large </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'keep'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;keep></xsl:message>
        </xsl:if>
        <xsl:text>auto | always | &lt;integer> </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'margin-width'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;margin-width></xsl:message>
        </xsl:if>
        <xsl:text>auto | &lt;length> | &lt;percentage> </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'padding-width'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;padding-width></xsl:message>
        </xsl:if>
        <xsl:text>&lt;length> | &lt;percentage> </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'relative-size'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;relative-size></xsl:message>
        </xsl:if>
        <xsl:text>larger | smaller </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'background-attachment'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;background-attachment></xsl:message>
        </xsl:if>
        <xsl:text>scroll | fixed | inherit</xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'background-color'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;background-color></xsl:message>
        </xsl:if>
        <xsl:text>&lt;color> | transparent | inherit</xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'background-image'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;background-image></xsl:message>
        </xsl:if>
        <xsl:text>&lt;uri-specification> | none | inherit</xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'background-position'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;background-position></xsl:message>
        </xsl:if>
        <xsl:text> [&lt;percentage> | &lt;length> ]{1,2} | [ [top | center | bottom] || [left | center | right] ] ] | inherit</xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'background-repeat'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;background-repeat></xsl:message>
        </xsl:if>
        <xsl:text>&lt;uri-specification> | none | inherit</xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'border-style'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;border-style></xsl:message>
        </xsl:if>
        <xsl:text>none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'border-width'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;border-width></xsl:message>
        </xsl:if>
        <xsl:text>thin | medium | thick | &lt;length> </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'generic-family'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;generic-family></xsl:message>
        </xsl:if>
        <xsl:text>serif | sans-serif | cursive | fantasy | monospace </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'family-name'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;family-name></xsl:message>
        </xsl:if>
        <xsl:text>&lt;string></xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'color'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;color></xsl:message>
        </xsl:if>
        <xsl:text>&lt;literal-color> | aqua | black | blue | fuchsia | gray | green | lime | maroon | navy | olive | purple | red | silver | teal | white | yellow </xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'country'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;country></xsl:message>
        </xsl:if>
        <xsl:text>&lt;string></xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'language'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;language></xsl:message>
        </xsl:if>
        <xsl:text>&lt;string></xsl:text>
      </xsl:when>
      <xsl:when test="$datatype = 'script'">
        <xsl:if test="$debug">
          <xsl:message>Expanding &lt;script></xsl:message>
        </xsl:if>
        <xsl:text>&lt;string></xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- is-punctuation-token -->
  <!-- Result is text 'TRUE' if $token is a "punctuation token", i.e.,
       if it's recognisably not a datatype name in a property value
       definition. -->
  <xsl:template name="is-punctuation-token">
    <xsl:param name="token"/>

    <xsl:if test="$token = '[[' or
                  $token = '[' or
                  $token = '||' or
                  $token = '|' or
                  $token = '/' or
                  $token = ',]*' or
                  $token = ',]' or
                  $token = ',' or
                  starts-with($token, ']')">TRUE</xsl:if>
  </xsl:template>

  <!-- is-datatype-token -->
  <!-- Result is text 'TRUE' if $token is a "datatype token", i.e.,
       if it's recognised as a datatype name in a property value
       definition because it contains '<'. -->
  <xsl:template name="is-datatype-token">
    <xsl:param name="token"/>

    <xsl:if test="starts-with($token, '&lt;') or
                  starts-with($token, '[&lt;') or
                  starts-with($token, '[[&lt;')">TRUE</xsl:if>
  </xsl:template>

  <!-- values-to-expression-types -->
  <xsl:template name="values-to-expression-types">
    <xsl:param name="values"/>
    <xsl:param name="property"/>
    <xsl:param name="seen-enum" select="false()"/>

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

      <xsl:variable name="is-punctuation-token">
        <xsl:call-template name="is-punctuation-token">
          <xsl:with-param name="token" select="$token"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="is-datatype-token">
        <xsl:call-template name="is-datatype-token">
          <xsl:with-param name="token" select="$token"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="datatype"
        select="substring-before(substring-after($token, '&lt;'), '>')"/>

      <xsl:variable name="expanded-datatype">
        <xsl:call-template name="expand-datatype">
          <xsl:with-param name="datatype" select="$datatype"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$debug >= 3">
        <xsl:message>token: '<xsl:value-of select="$token"/>'</xsl:message>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$is-punctuation-token = 'TRUE'">
          <xsl:call-template name="values-to-expression-types">
            <xsl:with-param
              name="values"
              select="$after-token"/>
            <xsl:with-param
              name="property"
              select="$property"/>
            <xsl:with-param name="seen-enum" select="$seen-enum"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$is-datatype-token = 'TRUE' and
                        string-length($expanded-datatype) != 0">
          <xsl:call-template name="values-to-expression-types">
            <xsl:with-param
              name="values"
              select="concat($expanded-datatype, $after-token)"/>
            <xsl:with-param
              name="property"
              select="$property"/>
            <xsl:with-param name="seen-enum" select="$seen-enum"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        <!-- To get here, it's either a real datatype or it's an
             enumeration token -->

          <xsl:if test="$debug >= 2">
            <xsl:message>token: '<xsl:value-of select="$token"/>', is-punctuation-token: '<xsl:value-of select="$is-punctuation-token"/>'</xsl:message>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="$is-datatype-token = 'TRUE'">
              <xsl:choose>
                <xsl:when test="$datatype = 'angle'">
                  <xsl:sequence select="Literal" />
                </xsl:when>
                <xsl:when test="$datatype = 'character'">
                  <xsl:sequence select="'Literal'" />
                </xsl:when>
                <xsl:when test="$datatype = 'literal-color'">
                  <xsl:sequence select="'Color'" />
                </xsl:when>
                <xsl:when test="$datatype = 'id'">
                  <xsl:sequence select="'EnumerationToken'" />
                </xsl:when>
                <xsl:when test="$datatype = 'shape'">
                  <xsl:sequence select="'Function'" />
                </xsl:when>
                <xsl:when test="$datatype = 'idref'">
                  <xsl:sequence select="'EnumerationToken'" />
                </xsl:when>
                <xsl:when test="$datatype = 'integer'">
                  <xsl:sequence select="'Number'" />
                </xsl:when>
                <xsl:when test="$datatype = 'length'">
                  <xsl:sequence select="'Length'" />
                </xsl:when>
                <xsl:when test="$datatype = 'length-conditional'">
                  <xsl:sequence select="'Length'" />
                </xsl:when>
                <xsl:when test="$datatype = 'length-bp-ip-direction'">
                  <xsl:sequence select="'Length'" />
                </xsl:when>
                <xsl:when test="$datatype = 'length-range'">
                  <xsl:sequence select="'Length'" />
                </xsl:when>
                <xsl:when test="$datatype = 'name'">
                  <xsl:sequence select="'NCName'" />
                </xsl:when>
                <xsl:when test="$datatype = 'number'">
                  <xsl:sequence select="'Number'" />
                </xsl:when>
                <xsl:when test="$datatype = 'percentage'">
                  <xsl:sequence select="'Percent'" />
                </xsl:when>
                <xsl:when test="$datatype = 'space'">
                  <xsl:sequence select="'Length'" />
                </xsl:when>
                <xsl:when test="$datatype = 'string'">
                  <xsl:sequence select="'Literal'" />
                </xsl:when>
                <xsl:when test="$datatype = 'uri-specification'">
                  <xsl:sequence select="'URI'" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message terminate="no">Unsupported datatype: <xsl:value-of select="$datatype"/></xsl:message>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="values-to-expression-types">
                <xsl:with-param
                  name="values"
                  select="$after-token"/>
                <xsl:with-param
                  name="property"
                  select="$property"/>
                <xsl:with-param name="seen-enum" select="$seen-enum"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="not($seen-enum)">
                <xsl:sequence select="'EnumerationToken'" />
              </xsl:if>
              <xsl:call-template name="values-to-expression-types">
                <xsl:with-param
                  name="values"
                  select="$after-token"/>
                <xsl:with-param
                  name="property"
                  select="$property"/>
                <xsl:with-param name="seen-enum" select="true()"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
