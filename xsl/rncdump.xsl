<!-- ============================================================= -->
<!--  MODULE:     rncdump.xsl                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Generate Relax NG compact syntax schema from     -->
<!--              the XML for the XSL 1.1 Recommendation           -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: Relax NG compact syntax schema                   -->
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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf xs">

<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Common parameters, keys, functions, and templates. -->
<xsl:import href="common.xsl" />


<!-- ============================================================= -->
<!-- SERIALIZATION                                                 -->
<!-- ============================================================= -->

<xsl:output method="text" encoding="UTF-8" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- Defined in 'common.xsl'. -->


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Defined in 'common.xsl'. -->


<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Additional variables defined in 'common.xsl'. -->

<!-- Names of FOs in which the 'point' FOs - i.e., fo:change-bar-begin
     and fo:change-bar-end - are NOT allowed.  See "points" in
     http://www.w3.org/TR/xsl/#d0e6532 -->
<xsl:variable
    name="no-point-fos"
    select="'root layout-master-set declarations bookmark-tree
page-sequence page-sequence-wrapper color-profile title folio-prefix
folio-suffix simple-page-master page-sequence-master flow-map
single-page-master-reference repeatable-page-master-reference
repeatable-page-master-alternatives conditional-page-master-reference
region-body region-before region-after region-start region-end
flow-assignment flow-source-list flow-target-list flow-name-specifier
region-name-specifier'"
    as="xs:string" />

<xsl:variable name="no-point-fo-list"
              select="tokenize($no-point-fos, '\s+')"
              as="xs:string+" />

<!-- Shorthand properties aren't listed in the definitions of the FOs
     to which they apply, so they have to be added
     programmatically. -->

<!-- Shorthands (and a few non-shorthands) that apply to all FOs to
     which a group of properties applies. -->
<xsl:variable name="shorthands-for-property-group" as="element(item)+">
  <!-- 'absolute-position' and 'relative-position' apply to different
       sets of FOs, so okay to list shorthand twice:
       'absolute-position' applies only to fo:block-container. -->
  <item group="common-absolute-position-properties">position</item>
  <!-- Omit 'border-spacing' since it is inherited and, as such, will
       be allowed on every element. -->
  <item group="common-border-padding-and-background-properties">
background background-position border border-bottom border-color
border-left border-right border-style border-top
border-width padding</item>
  <item group="common-margin-properties-block">margin</item>
  <!-- Pretend that 'margin-top', etc., are shorthands to save having
       to parse cross-references between
       common-margin-properties-inline and
       common-margin-properties-block sections.  See, e.g.,
       http://www.w3.org/TR/xsl11/#d0e21775 -->
  <item group="common-margin-properties-inline">
margin margin-top margin-bottom margin-left margin-right</item>
  <!-- 'position' is a shorthand. 'top', 'right', 'bottom' and 'left'
       are not shorthands, but their definitions as relative position
       properties are just links to full definitions in
       'common-absolute-position-properties'. -->
  <item group="common-relative-position-properties">position top right bottom left</item>
</xsl:variable>

<!-- Shorthands (and a few non-shorthands) that apply to FOs to which
     some other property always applies. -->
<xsl:variable name="shorthands-for-property" as="element(item)+">
  <item property="alignment-baseline">vertical-align</item>
  <item property="break-after">page-break-after</item>
  <item property="break-before">page-break-before</item>
  <!-- 'max-height', 'max-width', 'min-height', and 'min-width' aren't
       listed in the shorthand section but they're also not listed for
       the FOs to which they apply. -->
  <item property="inline-progression-dimension">max-height max-width min-height min-width</item>

  <!-- Omit 'page-break-inside' since it is an inherited property. -->
  <!--<item property="keep-together">page-break-inside</item>-->

  <!-- Omit 'white-space' since it is an inherited property. -->
  <!--<item property="linefeed-treatment">white-space</item>-->

  <item property="page-height">size</item>
</xsl:variable>


<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template match="/">

  <xsl:call-template name="ahf:rnc-initial-comment" />
<xsl:text>
default namespace fo = "http://www.w3.org/1999/XSL/Format"
namespace axf = "http://www.antennahouse.com/names/XSL/Extensions"
namespace local = ""

start = fo_root

# FOs
</xsl:text>
  <xsl:if test="$debug">
    <xsl:message>Property groups:</xsl:message>
    <xsl:for-each select="key('all-property-group', true())">
      <xsl:sort select="@id"/>
      <xsl:message> - <xsl:value-of select="@id"/></xsl:message>
    </xsl:for-each>
    <xsl:message></xsl:message>

    <xsl:message>Formatting objects:</xsl:message>
  </xsl:if>

  <xsl:for-each select="/spec/body/div1/div2/div3
                        [head[starts-with(., 'fo:')]]">

    <xsl:variable name="element"
                  select="substring-after(head, 'fo:')"/>


    <xsl:variable name="properties"
                  select="key('property', slist/sitem/specref/@ref)/@id"/>

    <xsl:variable name="property-groups"
                  select="key('property-group', slist/sitem/specref/@ref)"/>

    <xsl:if test="$debug">
      <xsl:message><xsl:value-of select="$element"/></xsl:message>
      <xsl:for-each select="$properties">
        <xsl:sort/>
        <xsl:message> - <xsl:value-of select="."/></xsl:message>
      </xsl:for-each>

      <xsl:if test="$debug >= 2 and
                    key('property-group', slist/sitem/specref/@ref)">
        <xsl:message>...Property groups:</xsl:message>
        <xsl:for-each select="key('property-group', slist/sitem/specref/@ref)">
          <xsl:message>...<xsl:value-of select="@id"/></xsl:message>
          <xsl:for-each select="div3/@id">
            <xsl:message>......<xsl:value-of select="."/></xsl:message>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:message>...</xsl:message>
      </xsl:if>
    </xsl:if>

    <xsl:text>
fo_</xsl:text>
    <xsl:value-of select="$element" />
    <xsl:text> =
## </xsl:text>
    <xsl:value-of select="normalize-space(p[. eq 'Common Usage:']/following-sibling::p[1])" />
    <xsl:text>
  element </xsl:text>
    <xsl:value-of select="$element" />
    <xsl:text> {
</xsl:text>
    <xsl:if test="exists($properties) or exists($property-groups)">
      <xsl:text>    fo_</xsl:text>
      <xsl:value-of select="$element" />
      <xsl:text>.attlist,&#10;</xsl:text>
    </xsl:if>
      <xsl:text>    fo_</xsl:text>
      <xsl:value-of select="$element" />
      <xsl:text>.model
}
</xsl:text>

    <xsl:text>&#10;fo_</xsl:text>
    <xsl:value-of select="$element" />
    <xsl:text>.model =&#10;</xsl:text>
    <!-- fo:wrapper has the 'fo:markers' text in a <ulist>. -->
    <xsl:if test="some $p in (p | ulist)
                    satisfies contains(normalize-space($p), 'zero or more fo:markers')">
      <xsl:text>    fo_marker*,&#10;</xsl:text>
    </xsl:if>
    <xsl:if
        test="some $p in p
                satisfies contains($p, 'optionally followed by an fo:initial-property-set')">
      <xsl:text>    fo_initial-property-set?,&#10;</xsl:text>
    </xsl:if>
    <xsl:text>    ( </xsl:text>
    <xsl:variable name="model" as="xs:string+">
      <xsl:apply-templates select="p[. eq 'Contents:']" />
    </xsl:variable>
    <!-- fo:wrapper may only contain what its parent may contain, so
         there's three separate patterns for fo:wrapper and three
         'neutral' FO lists that refer to them. -->
    <xsl:variable name="model" as="xs:string+"
        select="if (count($model) = 1 and $model eq 'text')
                  then '( text | neutral.fo.list.inline )*'
                else if ($model = 'inline.fo.list' and
                         $model = 'block.fo.list')
                  then insert-before($model,
                                     index-of($model, 'block.fo.list') + 1,
                                     ' | neutral.fo.list')
                else if ($model = 'block.fo.list')
                  then insert-before($model,
                                     index-of($model, 'block.fo.list') + 1,
                                     ' | neutral.fo.list.block')
                else if ($model = 'inline.fo.list')
                  then insert-before($model,
                                     index-of($model, 'inline.fo.list') + 1,
                                     ' | neutral.fo.list.inline')
                else $model" />
    <xsl:variable name="model" as="xs:string+"
        select="if ($model = ('text', 'inline.fo.list'))
                  then ('( ', $model, ' &amp; (inline.out-of-line.fo.list)* )')
                else $model" />
    <xsl:value-of select="$model" separator="" />
    <xsl:if test="not($model = 'empty') and not($element = $no-point-fo-list)">
      <xsl:text> &amp; (point.fo.list)*</xsl:text>
    </xsl:if>
    <xsl:text> )&#10;</xsl:text>

    <xsl:if test="exists($properties) or exists($property-groups)">
      <xsl:text>&#10;fo_</xsl:text>
      <xsl:value-of select="$element" />
      <xsl:text>.attlist =&#10;</xsl:text>
      <xsl:for-each select="$property-groups">
        <xsl:sort />
        <xsl:text>    </xsl:text>
        <xsl:value-of select="@id" />
        <xsl:if test="position() != last() or exists($properties)">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
      <xsl:for-each
          select="$properties,
                  for $property in $properties
                    return tokenize($shorthands-for-property[@property = $property],
                                    '\s+')">
        <xsl:sort />
        <xsl:text>    </xsl:text>
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>

  <xsl:text>
#
# Property groups
#

# Property groups also include applicable shorthands that expand to
# properties defined in the property group in the XSL spec.

</xsl:text>

  <xsl:variable name="property-groups"
                select="key('all-property-group', true())"/>

  <xsl:if test="$debug">
    <xsl:for-each select="$property-groups">
      <xsl:message><xsl:value-of select="@id"/></xsl:message>
    </xsl:for-each>
  </xsl:if>

  <xsl:for-each select="$property-groups">
    <xsl:value-of select="@id" />
    <xsl:text> =&#10;</xsl:text>
    <xsl:for-each
        select="div3[not(@id eq 'font-model')]/@id ,
                tokenize(normalize-space($shorthands-for-property-group[@group = current()/@id]),
                         '\s')">
      <xsl:sort />
      <xsl:text>    </xsl:text>
      <xsl:value-of select="." />
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>

  <xsl:text>
# Properties
</xsl:text>

  <xsl:variable name="properties"
                select="$all-properties"/>

  <xsl:if test="$debug">
    <xsl:for-each select="$properties">
      <xsl:message><xsl:value-of select="."/></xsl:message>
    </xsl:for-each>
  </xsl:if>

  <xsl:for-each select="$properties">
    <!-- 'xml.lang' -> 'xml:lang'. -->
    <xsl:variable name="att-name"
                  select="translate(., '.', ':')"
                  as="xs:string" />
    <xsl:variable name="values"
                  select="normalize-space(../../following-sibling::td[1])"
                  as="xs:string" />
    <xsl:variable name="required"
                  select="contains(../../following-sibling::td[2], 'required')"
                  as="xs:boolean" />

    <xsl:value-of select="." />
    <xsl:text> =
    ## </xsl:text>
    <xsl:value-of select="$values" />
    <xsl:text>
    attribute </xsl:text>
    <xsl:value-of select="$att-name" />
    <xsl:text> { </xsl:text>
    <xsl:value-of
        select="if ($values eq '&lt;name>')
                  then 'xsd:NCName'
                else if ($values eq '&lt;id>')
                  then 'xsd:ID'
                else if ($values eq '&lt;idref>')
                  then 'xsd:IDREF'
                else if ($att-name eq 'xml:lang')
                  then 'xsd:language'
                else 'text'" />
    <xsl:text> }</xsl:text>
    <xsl:value-of select="if ($required) then '' else '?'" />
    <xsl:if test="contains($values, '&lt;keep&gt;')">
      <xsl:text>,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.within-line { text }?,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.within-column { text }?,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.within-page { text }?</xsl:text>
    </xsl:if>
    <xsl:if test="contains($values, '&lt;length-range&gt;') or
                  contains($values, '&lt;space&gt;')">
      <xsl:text>,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.minimum { text }?,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.optimum { text }?,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.maximum { text }?</xsl:text>
    </xsl:if>
    <xsl:if test="contains($values, '&lt;space&gt;')">
      <xsl:text>,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.precedence { text }?</xsl:text>
    </xsl:if>
    <xsl:if test="contains($values, '&lt;length-conditional&gt;')">
      <xsl:text>,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.length { text }?</xsl:text>
    </xsl:if>
    <xsl:if test="contains($values, '&lt;space&gt;') or
                  contains($values, '&lt;length-conditional&gt;')">
      <xsl:text>,
    attribute </xsl:text>
      <xsl:value-of select="$att-name" />
      <xsl:text>.conditionality { text }?</xsl:text>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>

  <xsl:text>
#
# Additional patterns
#

# For fo:instream-foreign-object
anything =
   ( element * {
        attribute * - id { text }*,
        anything } |
     text )*

non-xsl =
  ( attribute * - ( local:* | xml:* ) { text }*,
    element * - ( local:* | fo:* ) { attribute * { text }*, anything }* )

# From http://www.w3.org/TR/xsl/#fo_wrapper:
#
#    An fo:wrapper is only permitted to have children that would be #
#    permitted to be children of the parent of the fo:wrapper
#
fo_wrapper.block =
## The fo:wrapper formatting object is used to specify inherited properties for a group of formatting objects.
  element wrapper {
    fo_wrapper.attlist,
    fo_wrapper.model.block
}

fo_wrapper.model.block =
    fo_marker*,
    ( ( ( (text|block.fo.list)* | neutral.fo.list.block)* ) &amp; (point.fo.list)* )

fo_wrapper.inline =
## The fo:wrapper formatting object is used to specify inherited properties for a group of formatting objects.
  element wrapper {
    fo_wrapper.attlist,
    fo_wrapper.model.inline
}

fo_wrapper.model.inline =
    fo_marker*,
    ( ( ( (text|inline.fo.list)* | neutral.fo.list.inline)* &amp; (inline.out-of-line.fo.list)* ) &amp; (point.fo.list)* )

#
# FO groups
#

block.fo.list =
      fo_block
      | fo_block-container
      | fo_table-and-caption
      | fo_table
      | fo_list-block

inline.fo.list =
      fo_bidi-override
      | fo_character
      | fo_external-graphic
      | fo_instream-foreign-object
      | fo_inline
      | fo_inline-container
      | fo_leader
      | fo_page-number
      | fo_page-number-citation
      | fo_page-number-citation-last
      | fo_scaling-value-citation
      | fo_basic-link
      | fo_multi-toggle
      | fo_index-page-citation-list

neutral.fo.list =
      fo_multi-switch
      | fo_multi-properties
      | fo_index-range-begin
      | fo_index-range-end
      | fo_wrapper
      | fo_retrieve-marker
      | fo_retrieve-table-marker # Rely on Schematron to indicate where invalid
      | fo_float # Rely on Schematron to indicate where invalid

neutral.fo.list.block =
      fo_multi-switch
      | fo_multi-properties
      | fo_index-range-begin
      | fo_index-range-end
      | fo_wrapper.block
      | fo_retrieve-marker
      | fo_retrieve-table-marker # Rely on Schematron to indicate where invalid
      | fo_float # Rely on Schematron to indicate where invalid

neutral.fo.list.inline =
      fo_multi-switch
      | fo_multi-properties
      | fo_index-range-begin
      | fo_index-range-end
      | fo_wrapper.inline
      | fo_retrieve-marker
      | fo_retrieve-table-marker # Rely on Schematron to indicate where invalid
      | fo_float # Rely on Schematron to indicate where invalid

inline.out-of-line.fo.list =
      fo_footnote

point.fo.list =
      fo_change-bar-begin
      | fo_change-bar-end

# End.
</xsl:text>
</xsl:template>

<xsl:template match="p[. eq 'Contents:']">
  <xsl:apply-templates select="following-sibling::eg[1]" />
</xsl:template>

<xsl:template match="eg">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="p[. eq 'Contents:'][../head eq 'fo:instream-foreign-object']"
              priority="5" as="xs:string">
  <xsl:sequence select="'non-xsl'" />
</xsl:template>

<xsl:template match="loc" as="xs:string">
  <xsl:sequence select="substring-after(@href, '#')" />
</xsl:template>

<xsl:template match="eg/text()" as="xs:string">
  <!-- Convert '#PCDATA' to 'text' keyword and convert 'EMPTY' to
       'empty' keyword. -->
  <xsl:sequence
      select="replace(replace(normalize-space(.), '#PCDATA', 'text'),
                      'EMPTY',
                      'empty')" />
</xsl:template>

</xsl:stylesheet>
