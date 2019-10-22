<!-- ============================================================= -->
<!--  MODULE:     parser-runner.xsl                                -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Run a parser generated using REx and predigest   -->
<!--              the results                                      -->
<!--                                                               -->
<!-- INPUT FILE:  None.  Use the 'ahf:parser-runner' function.     -->
<!--                                                               -->
<!-- OUTPUT FILE: None                                             -->
<!--                                                               -->
<!-- CREATED FOR: Antenna House                                    -->
<!--                                                               -->
<!-- CREATED BY:  Antenna House                                    -->
<!--              3844 Kennett Pike, Suite 200                     -->
<!--              Greenville, DE 19807                             -->
<!--              USA                                              -->
<!--              https://www.antennahouse.com/                    -->
<!--              support@antennahouse.com                         -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              3 February 2015                                  -->
<!--                                                               -->
<!-- CREATED BY:  Tony Graham (tgraham)                            -->
<!--                                                               -->
<!-- ============================================================= -->
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
-->

<!-- ============================================================= -->
<!-- DESIGN CONSIDERATIONS                                         -->
<!-- ============================================================= -->
<!-- REx parser generator is at http://www.bottlecaps.de/rex/

     Parser generated using command-line options '-tree -main -xslt'
                                                                   -->

<!-- ============================================================= -->
<!-- XSL STYLESHEET INVOCATION                                     -->
<!-- ============================================================= -->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:p="axf-expression"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf p xs">

<xsl:import href="axf-expression.xslt" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<xsl:param name="input" as="xs:string?" select="()" />
<xsl:param name="debug" select="false()" />


<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Return values of functions. Should be expanded to specify number
     and allowed types of function arguments. -->
<xsl:variable name="ahf:functions" as="element(function)+">
  <function name="abs" returns="Number" />
  <function name="body-start" returns="Length" />
  <function name="ceiling" returns="Number" />
  <function name="floor" returns="Number" />
  <function name="from-nearest-specified-value" returns="Object" />
  <function name="from-page-master-region" returns="Object" />
  <function name="from-parent" returns="Object" />
  <function name="from-table-column" returns="Object" />
  <function name="inherited-property-value" returns="Object" />
  <function name="label-end" returns="Length" />
  <function name="merge-property-values" returns="Object" />
  <function name="max" returns="Number" />
  <function name="min" returns="Number" />
  <function name="proportional-column-width" returns="Length" />
  <function name="rgb" returns="Color" />
  <function name="rgb-icc" returns="Color" />
  <function name="round" returns="Number" />
  <function name="system-color" returns="Color" />
  <function name="system-font" returns="Object" />

  <!-- V6.1 -->
  <function name="linear-gradient" returns="Color" />
  <function name="radial-gradient" returns="Color" />
  <function name="repeating-linear-gradient" returns="Color" />
  <function name="repeating-radial-gradient" returns="Color" />

  <!-- V6.2 -->
  <function name="rgba" returns="Color" />

  <!-- V6.3 -->
  <function name="cmyk" returns="Color" />
  <function name="cmyka" returns="Color" />

  <!-- V6.6 -->
  <function name="hsl" returns="Color" />
  <function name="hsla" returns="Color" />
</xsl:variable>

<xsl:variable
    name="ahf:color-keywords"
    select="'k100', 'aliceblue', 'antiquewhite', 'aqua', 'aquamarine',
            'azure', 'beige', 'bisque', 'black', 'blanchedalmond',
            'blue', 'blueviolet', 'brown', 'burlywood', 'cadetblue',
            'chartreuse', 'chocolate', 'coral', 'cornflowerblue',
            'cornsilk', 'crimson', 'cyan', 'darkblue', 'darkcyan',
            'darkgoldenrod', 'darkgray', 'darkgreen', 'darkgrey',
            'darkkhaki', 'darkmagenta', 'darkolivegreen',
            'darkorange', 'darkorchid', 'darkred', 'darksalmon',
            'darkseagreen', 'darkslateblue', 'darkslategray',
            'darkslategrey', 'darkturquoise', 'darkviolet',
            'deeppink', 'deepskyblue', 'dimgray', 'dimgrey',
            'dodgerblue', 'firebrick', 'floralwhite', 'forestgreen',
            'fuchsia', 'gainsboro', 'ghostwhite', 'gold', 'goldenrod',
            'gray', 'grey', 'green', 'greenyellow', 'honeydew',
            'hotpink', 'indianred', 'indigo', 'ivory', 'khaki',
            'lavender', 'lavenderblush', 'lawngreen', 'lemonchiffon',
            'lightblue', 'lightcoral', 'lightcyan',
            'lightgoldenrodyellow', 'lightgray', 'lightgreen',
            'lightgrey', 'lightpink', 'lightsalmon', 'lightseagreen',
            'lightskyblue', 'lightslategray', 'lightslategrey',
            'lightsteelblue', 'lightyellow', 'lime', 'limegreen',
            'linen', 'magenta', 'maroon', 'mediumaquamarine',
            'mediumblue', 'mediumorchid', 'mediumpurple',
            'mediumseagreen', 'mediumslateblue', 'mediumspringgreen',
            'mediumturquoise', 'mediumvioletred', 'midnightblue',
            'mintcream', 'mistyrose', 'moccasin', 'navajowhite',
            'navy', 'oldlace', 'olive', 'olivedrab', 'orange',
            'orangered', 'orchid', 'palegoldenrod', 'palegreen',
            'paleturquoise', 'palevioletred', 'papayawhip',
            'peachpuff', 'peru', 'pink', 'plum', 'powderblue',
            'purple', 'rebeccapurple', 'red', 'rosybrown',
            'royalblue', 'saddlebrown', 'salmon', 'sandybrown',
            'seagreen', 'seashell', 'sienna', 'silver', 'skyblue',
            'slateblue', 'slategray', 'slategrey', 'snow',
            'springgreen', 'steelblue', 'tan', 'teal', 'thistle',
            'tomato', 'turquoise', 'violet', 'wheat', 'white',
            'whitesmoke', 'yellow', 'yellowgreen'"
    as="xs:string+" />

<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<!-- Entry point when running this stylesheet standalone, e.g., when
     testing from the command line. -->
<xsl:template name="ahf:parser-runner" as="element()+">
  <xsl:param name="input" select="$input" as="xs:string" />
  <xsl:param name="debug" select="string($debug)" as="xs:string" />

  <xsl:sequence select="ahf:parser-runner2($input, boolean($debug))" />
</xsl:template>

<!-- ahf:parser-runner($input as xs:string) as element()+ -->
<!-- Runs the REx-generated parser on $input then reduces the parse
     tree to a XSL 1.1 datatype.  Uses @saxon:memo-function extension
     to memorize return values (when used with Saxon PE or Saxon EE)
     to avoid reparsing the same strings again and again when this is
     used as part of validating an entire XSL-FO document. -->
<xsl:function name="ahf:parser-runner" as="element()+"
              saxon:memo-function="yes"
              xmlns:saxon="http://saxon.sf.net/" >
  <xsl:param name="input" as="xs:string" />

  <xsl:choose>
    <xsl:when test="$input eq ''">
      <EMPTY />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence
          select="ahf:parser-runner2($input, false())"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:parser-runner" as="element()+" >
  <xsl:param name="input" as="xs:string" />
  <xsl:param name="context" as="element()" />

  <xsl:for-each select="$context">
    <xsl:sequence
      select="ahf:parser-runner2($input, false())"/>
  </xsl:for-each>

</xsl:function>

<xsl:function name="ahf:parser-runner2" >
  <xsl:param name="input" as="xs:string" />
  <xsl:param name="debug" as="xs:boolean" />

  <xsl:if test="$debug">
    <xsl:message select="$input" />
  </xsl:if>
  <xsl:sequence
      select="ahf:raw-parser-runner(replace(replace($input,
                                                    'url\(([^''&quot;)]+)\)',
                                                    'url(''$1'')'),
                                            '(\d)(cm|mm|in|pt|pc|px|em|ex|jpt|q|dpi|dd|cc|rem|ch|wch|lh|rlh|vw|vh|vmin|vmax|pvw|pvh|pvmin|pvmax|gr)($|[\s),+])',
                                            '$1 $2$3'),
                                    $debug)" />
</xsl:function>

<xsl:function name="ahf:raw-parser-runner" as="element()+">
  <xsl:param name="input" as="xs:string" />
  <xsl:param name="debug" as="xs:boolean" />

  <xsl:if test="$debug">
    <xsl:message select="$input" />
  </xsl:if>

  <xsl:variable name="parse-tree"
                select="p:parse-Expression($input)"
                as="element()" />

  <xsl:if test="$debug">
    <xsl:message select="$parse-tree" />
  </xsl:if>

  <xsl:variable name="reduced-tree"
    as="element()*"
    select="ahf:reduce-tree($parse-tree)" />

  <xsl:if test="$debug">
    <xsl:message select="local-name($reduced-tree)" />
    <xsl:message select="$reduced-tree" />
  </xsl:if>

  <xsl:sequence select="$reduced-tree" />
</xsl:function>

<xsl:function name="ahf:reduce-tree" as="element()*">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:if test="exists($parse-tree)">
    <xsl:variable name="local-name" select="local-name($parse-tree)"
                  as="xs:string" />

    <xsl:sequence
        select="
if ($local-name eq 'ERROR') then ahf:ERROR($parse-tree)
else if ($local-name eq 'AbsoluteLength') then ahf:AbsoluteLength($parse-tree)
else if ($local-name eq 'AdditiveExpr') then ahf:AdditiveExpr($parse-tree)
else if ($local-name eq 'Color') then ahf:Color($parse-tree)
else if ($local-name eq 'EnumerationToken') then ahf:EnumerationToken($parse-tree)
else if ($local-name eq 'FunctionCall') then ahf:FunctionCall($parse-tree)
else if ($local-name eq 'MultiplicativeExpr') then ahf:MultiplicativeExpr($parse-tree)
else if ($local-name eq 'Number') then ahf:Number($parse-tree)
else if ($local-name eq 'Percent') then ahf:Percent($parse-tree)
else if ($local-name eq 'RelativeLength') then ahf:RelativeLength($parse-tree)
else if ($local-name eq 'UnaryExpr') then ahf:UnaryExpr($parse-tree)
else for $node in $parse-tree/* return ahf:reduce-tree($node)" />
  </xsl:if>
</xsl:function>

<xsl:function name="ahf:ERROR" as="element()*">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:element name="ERROR">
    <xsl:copy-of select="$parse-tree/node()" />
  </xsl:element>

</xsl:function>

<xsl:function name="ahf:AdditiveExpr" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="term1" as="element()"
                select="ahf:reduce-tree($parse-tree/MultiplicativeExpr[1])" />

  <xsl:choose>
    <xsl:when test="count($parse-tree/MultiplicativeExpr) = 1">
      <xsl:sequence select="$term1" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence
          select="ahf:nextAdditiveExpr($term1,
                                       $parse-tree/MultiplicativeExpr[position() > 1])" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:nextAdditiveExpr" as="element()">
  <xsl:param name="term1" as="element()" />
  <xsl:param name="otherTerms" as="element()+" />

  <xsl:variable name="term2"
                select="ahf:reduce-tree($otherTerms[1])"
                as="element()" />
  <xsl:variable name="token"
                select="$otherTerms[1]/preceding-sibling::TOKEN[1]"
                as="xs:string" />

  <xsl:variable name="result" as="element()">
    <xsl:choose>
      <xsl:when test="$term1 instance of element(Object) or
                      $term2 instance of element(Object)">
        <Object />
      </xsl:when>
      <xsl:when test="$term1 instance of element(Length) and
                      $term2 instance of element(Length)">
        <Length />
      </xsl:when>
      <xsl:when test="$term1 instance of element(Percent) and
                      $term2 instance of element(Length)
                      or
                      $term1 instance of element(Length) and
                      $term2 instance of element(Percent)">
        <Length />
      </xsl:when>
      <xsl:when test="$term1 instance of element(Percent) and
                      $term2 instance of element(Percent)">
        <Percent />
      </xsl:when>
      <xsl:when test="$term1 instance of element(Number) and
                      $term2 instance of element(Number)">
        <Number>
          <xsl:if test="$term1/@value and $term2/@value">
            <xsl:variable name="value"
                          select="if ($token eq '+')
                                    then $term1/@value + $term2/@value
                                  else $term1/@value - $term2/@value"
                          as="xs:double" />
            <xsl:sequence select="ahf:number-attrs($value)" />
          </xsl:if>
        </Number>
      </xsl:when>
      <xsl:otherwise>
        <ERROR>Terms cannot be added.</ERROR>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($otherTerms) = 1">
      <xsl:sequence select="$result" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence
          select="ahf:nextAdditiveExpr($result,
                                       $otherTerms[position() > 1])" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:Color" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <Color value="{$parse-tree/AlphaOrDigits}" />
</xsl:function>

<xsl:function name="ahf:EnumerationToken" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:choose>
    <xsl:when test="lower-case($parse-tree) = $ahf:color-keywords">
      <Color value="{$parse-tree/AlphaOrDigits}" />
    </xsl:when>
    <xsl:otherwise>
      <EnumerationToken token="{$parse-tree}" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:MultiplicativeExpr" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="term1" as="element()"
                select="ahf:reduce-tree($parse-tree/UnaryExpr[1])" />

  <xsl:choose>
    <xsl:when test="count($parse-tree/UnaryExpr) = 1">
      <xsl:sequence select="$term1" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence
          select="ahf:nextMultiplicativeExpr($term1,
                                             $parse-tree/UnaryExpr[position() > 1])" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:nextMultiplicativeExpr" as="element()">
  <xsl:param name="term1" as="element()" />
  <xsl:param name="otherTerms" as="element()+" />

  <xsl:variable name="term2"
                select="ahf:reduce-tree($otherTerms[1])"
                as="element()" />
  <xsl:variable name="token"
                select="$otherTerms[1]/preceding-sibling::TOKEN[1]"
                as="xs:string" />

  <xsl:variable name="result" as="element()">
    <xsl:choose>
      <xsl:when test="$term1 instance of element(Object) or
                      $term2 instance of element(Object)">
        <Object />
      </xsl:when>
      <xsl:when test="$term1 instance of element(Length) and
                      $term2 instance of element(Number) or
                      $term1 instance of element(Number) and
                      $term2 instance of element(Length)">
        <Length>
          <xsl:if test="$term1/@value and $term2/@value">
            <xsl:variable name="value"
                          select="if ($token eq '*')
                                    then $term1/@value * $term2/@value
                                  else $term1/@value div $term2/@value"
                          as="xs:double" />
            <xsl:sequence select="ahf:number-attrs($value)" />
          </xsl:if>
        </Length>
      </xsl:when>
      <xsl:when test="$term1 instance of element(Number) and
                      $term2 instance of element(Number)">
        <Number>
          <xsl:if test="$term1/@value and $term2/@value">
            <xsl:variable name="value"
                          select="if ($token eq '*')
                                    then $term1/@value * $term2/@value
                                  else $term1/@value div $term2/@value"
                          as="xs:double" />
            <xsl:sequence select="ahf:number-attrs($value)" />
          </xsl:if>
        </Number>
      </xsl:when>
      <xsl:otherwise>
        <ERROR>Terms cannot be multiplied.</ERROR>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($otherTerms) = 1">
      <xsl:sequence select="$result" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence
          select="ahf:nextMultiplicativeExpr($result,
                                             $otherTerms[position() > 1])" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:UnaryExpr" as="element()+">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="content" as="element()+"
                select="for $node in $parse-tree/* except $parse-tree/TOKEN
                          return ahf:reduce-tree($node)" />

  <xsl:choose>
    <xsl:when test="$parse-tree/TOKEN/text() = '-' and
                    (exists($content/@value) or exists($content/@is-positive))">
      <xsl:element name="{name($content)}">
        <xsl:copy-of select="$content/@*" />
        <xsl:if test="exists($content/@value)">
          <xsl:attribute name="value" select="0 - $content/@value" />
        </xsl:if>
        <xsl:if test="exists($content/@is-positive)">
          <xsl:attribute name="is-positive"
                         select="if ($content/@is-positive eq 'yes')
                                   then 'no'
                                 else 'yes'" />
        </xsl:if>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:AbsoluteLength" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="number" as="element(Number)"
                select="ahf:reduce-tree($parse-tree/Number)" />

  <xsl:choose>
    <xsl:when test="exists($parse-tree/AbsoluteUnitName)">
      <Length unit="{$parse-tree/AbsoluteUnitName}">
        <xsl:copy-of select="$number/@*" />
      </Length>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$number" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:FunctionCall" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:choose>
    <xsl:when test="exists($ahf:functions[@name = $parse-tree/FunctionName/NCName])">
      <xsl:element
          name="{($ahf:functions[@name = $parse-tree/FunctionName/NCName]/@returns, 'Number')[1]}" />
    </xsl:when>
    <xsl:when test="$parse-tree/FunctionName/NCName = 'url'">
      <URI />
    </xsl:when>
    <xsl:otherwise>
      <ERROR>Unknown function name: <xsl:value-of select="$parse-tree/FunctionName/NCName" /></ERROR>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ahf:Number" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <Number>
    <xsl:sequence select="ahf:number-attrs(number($parse-tree))" />
  </Number>
</xsl:function>

<xsl:function name="ahf:Percent" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="number" as="element(Number)"
                select="ahf:reduce-tree($parse-tree/Number)" />

  <Percent>
    <xsl:copy-of select="$number/@*" />
  </Percent>
</xsl:function>

<xsl:function name="ahf:RelativeLength" as="element()">
  <xsl:param name="parse-tree" as="element()*" />

  <xsl:variable name="number" as="element(Number)"
                select="ahf:reduce-tree($parse-tree/Number)" />

  <Length unit="{$parse-tree/RelativeUnitName}">
    <xsl:copy-of select="$number/@*" />
  </Length>
</xsl:function>

<!-- ============================================================= -->
<!-- FUNCTIONS                                                     -->
<!-- ============================================================= -->

<xsl:function name="ahf:number-attrs" as="attribute()+">
  <xsl:param name="value" />

  <xsl:variable name="number" select="number($value)" as="xs:double" />
  <xsl:attribute name="value" select="$number" />
  <xsl:attribute name="is-positive"
                 select="if ($number >= 0) then 'yes' else 'no'" />
  <xsl:attribute name="is-zero"
                 select="if ($number = 0) then 'yes' else 'no'" />
</xsl:function>

</xsl:stylesheet>
