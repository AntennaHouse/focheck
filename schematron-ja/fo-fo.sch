<?xml version="1.0" encoding="UTF-8"?>
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
--><pattern id="fo-fo" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document">

  <!-- FOs -->

  <rule context="fo:basic-link | fo:bookmark">
    <!-- https://www.w3.org/TR/xsl/#fo_basic-link -->
    <!-- https://www.w3.org/TR/xsl11/#fo_bookmark -->
    <assert test="exists(@internal-destination | @external-destination)" role="Warning">An '<value-of select="name()"/>' should have an 'internal-destination' or 'external-destination' property.</assert>
    <report test="exists(@internal-destination) and exists(@external-destination)" role="Warning"><value-of select="name()"/> は internal-destination と external-destination のプロパティの両方を持ってなければなりません。FO プロセサーはエラーを報告できるし、internal-destination も使用できる。</report>
  </rule>

  <rule context="fo:change-bar-begin">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-begin -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = following::fo:change-bar-end/@change-bar-class)" role="Warning">fo:change-bar-end と一致する対を成らない <value-of select="name()"/> は、文書の最後に一致する change-bar-end と想定します。</report>
  </rule>

  <rule context="fo:change-bar-end">
    <!-- https://www.w3.org/TR/xsl/#fo_change-bar-end -->
    <report test="exists(@change-bar-class) and not(@change-bar-class = preceding::fo:change-bar-begin/@change-bar-class)" role="Warning">fo:change-bar-begin と一致する対を成らない <value-of select="name()"/> は、無効にします。</report>
  </rule>

  <rule context="fo:float">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="exists(ancestor::fo:float) or exists(ancestor::fo:footnote)"><value-of select="name()"/> は fo:float 又は fo:footnote の子孫として許されていません。</report>
  </rule>

  <rule context="fo:footnote">
    <!-- https://www.w3.org/TR/xsl/#d0e6532 -->
    <report test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')"><value-of select="name()"/> は fo:float 又は fo:footnote の子孫として許されていません。</report>
    <!-- https://www.w3.org/TR/xsl/#fo_footnote -->
    <!--
    <assert
	test="ancestor::fo:flow/@flow-name eq 'xsl-region-body' or
	      (not(ancestor::fo:flow/@flow-name = ('xsl-region-after', 'xsl-region-before', 'xsl-region-end', 'xsl-region-start')) and
	       ancestor::fo:flow/@flow-name eq /fo:root/fo:layout-master-set/fo:simple-page-master[@master-name eq current()/ancestor::fo:page-sequence/@master-reference]/fo:region-body/@region-name)">An 'fo:footnote' must be a descendant of a flow that is assigned to one or more region-body regions.</assert>
    -->
    <report test="exists(ancestor::fo:block-container[@absolute-position = ('absolute', 'fixed')])" role="Warning">絶対位置の領域を生成する fo:block-container の子孫である fo:footnote は、通常のブロックレベルの領域として配置されます。</report>
    <report test="exists(descendant::fo:block-container[@absolute-position = ('absolute', 'fixed')])">fo:footnote は、子孫として、絶対位置の領域を生成する fo:block-container を持つことが許されていません。</report>
    <report test="exists(descendant::fo:*[local-name() = ('float', 'footnote', 'marker')])">fo:footnote は fo:float、fo:footnote 又は fo:marker の子孫として許されていません。</report>
  </rule>

  <rule context="fo:list-block">
    <assert test="exists((., ancestor::*)/@provisional-distance-between-starts)" role="Warning" sqf:fix="list-block-pdbs-fix">provisional-distance-between-starts がなく、継承された値がない fo:list-block は、24pt を使用します。</assert>
    <sqf:fix id="list-block-pdbs-fix">
      <sqf:description>
        <sqf:title>provisional-distance-between-starts を追加して下さい。</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="provisional-distance-between-starts"/>
    </sqf:fix>
    <assert test="exists((., ancestor::*)/@provisional-label-separation)" role="Warning" sqf:fix="list-block-pls-fix">provisional-label-separation がなく、継承された値がない fo:list-block は、6pt を使用します。</assert>
    <sqf:fix id="list-block-pls-fix">
      <sqf:description>
        <sqf:title>provisional-label-separation を追加して下さい。</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="provisional-label-separation"/>
    </sqf:fix>
  </rule>

  <rule context="fo:list-item-body[empty(@start-indent)]">
    <report test="true()" id="list-item-body-start-indent" role="Warning" sqf:fix="list-item-body-start-indent-fix">start-indent のない fo:list-item-body は継承された start-indent の値を使用します。</report>
    <sqf:fix id="list-item-body-start-indent-fix">
      <sqf:description>
        <sqf:title>start-indent=&quot;body-start()&quot; を追加します。</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="start-indent" select="'body-start()'"/>
    </sqf:fix>
  </rule>

  <rule context="fo:list-item-label[empty(@end-indent)]">
    <report test="true()" id="list-item-label-end-indent" role="Warning" sqf:fix="list-item-label-end-indent-fix">end-indent のない fo:list-item-label は 継承された end-indent の値を使用します。</report>
    <sqf:fix id="list-item-label-end-indent-fix">
      <sqf:description>
        <sqf:title>end-indent=&quot;label-end()&quot; を追加します。</sqf:title>
      </sqf:description>
      <sqf:add node-type="attribute" target="end-indent" select="'label-end()'"/>
    </sqf:fix>
  </rule>

  <rule context="fo:marker">
    <!-- https://www.w3.org/TR/xsl/#fo_marker -->
    <assert test="exists(ancestor::fo:flow)">fo:marker は fo:flow のみの子孫として許されています。</assert>
    <assert test="empty(ancestor::fo:marker)">fo:marker は fo:marker の子孫として許されていません。</assert>
    <assert test="empty(ancestor::fo:retrieve-marker)">fo:marker は fo:retrieve-marker の子孫として許されていません。</assert>
    <assert test="empty(ancestor::fo:retrieve-table-marker)">fo:marker は fo:retrieve-table-marker の子孫として許されていません。</assert>
  </rule>

  <rule context="fo:retrieve-marker">
    <!-- https://www.w3.org/TR/xsl/#fo_retrieve-marker -->
    <assert test="exists(ancestor::fo:static-content)">fo:retrieve-marker は fo:static-content のみの子孫として許されています。</assert>
  </rule>

  <rule context="fo:retrieve-table-marker">
    <!-- https://www.w3.org/TR/xsl/#fo_retrieve-table-marker -->
    <assert test="exists(ancestor::fo:table-header) or                   exists(ancestor::fo:table-footer) or                   (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">fo:retrieve-table-marker は fo:table-header のみ又は fo:table-footer の子孫として、それも fo:table-header 又は fo:table-footer が許されている位置にある fo:table の子として許されています。</assert>
  </rule>

  <rule context="fo:root">
    <!-- https://www.w3.org/TR/xsl/#fo_root -->
    <assert id="fo_root-001" test="exists(descendant::fo:page-sequence)">fo:root の少なくとも一つの fo:page-sequence の子孫でなければなりません。</assert>
  </rule>

  <rule context="fo:table-cell">
    <report test="empty(*) and normalize-space() ne ''" role="Warning" sqf:fix="table-cell-empty-fix">fo:table-cell は block-level FO を含むべきです。</report>
    <sqf:fix id="table-cell-empty-fix">
      <let name="text" value="."></let>
      <sqf:description>
        <sqf:title>テクストの周りに fo:block を追加する。</sqf:title>
      </sqf:description>
      <sqf:delete match="node()"/>
      <sqf:add node-type="element" target="fo:block">
	<value-of select="."/>
      </sqf:add>
    </sqf:fix>
  </rule>

  <!-- Properties -->

  <rule context="fo:*/@character | fo:*/@grouping-separator">
    <assert test="string-length(.) = 1" id="character_grouping-separator"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は 単一の文字でなければなりません。</assert>
  </rule>

  <rule context="fo:*/@column-count | fo:*/@number-columns-spanned">
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <report test="local-name($expression) = 'Number' and                   (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or                    $expression/@is-zero = 'yes' or                    exists($expression/@value) and not($expression/@value castable as xs:integer))" id="column-count" role="Warning" sqf:fix="column-count-fix"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は正の整数でなければなりません。非正又は非整数値は一番近い整数値に丸められます。</report>
    <sqf:fix id="column-count-fix">
      <sqf:description>
        <sqf:title>@column-count 値を変更し </sqf:title>
      </sqf:description>
      <sqf:replace node-type="attribute" target="column-count" select="max((1, round(.)))"/>
    </sqf:fix>
  </rule>

  <rule context="fo:*/@column-width[exists(../@number-columns-spanned)]">
    <let name="number-columns-spanned" value="ahf:parser-runner(../@number-columns-spanned)"></let>
    <report test="local-name($number-columns-spanned) = 'Number' and                   (exists($number-columns-spanned/@value) and      number($number-columns-spanned/@value) &gt;= 1.5)" id="column-width" role="Warning"><value-of select="name()"/>number-columns-spanned が存在して １以上の値を持つ場合、無限されます。</report>
  </rule>

  <rule context="fo:*/@flow-map-reference">
    <!-- https://www.w3.org/TR/xsl11/#flow-map-reference -->
    <report test="empty(/fo:root/fo:layout-master-set/fo:flow-map/@flow-map-name[. eq current()])">flow-map-reference=&quot;<value-of select="."/>&quot; は任意の fo:flow-map 名と一致しません。</report>
  </rule>

  <rule context="fo:*/@flow-name">
    <!-- https://www.w3.org/TR/xsl11/#flow-name -->
    <assert test="count(../../*/@flow-name[. eq current()]) = 1">flow-name=&quot;<value-of select="."/>&quot; は fo:page-sequence 内で特殊でなければなりません。</assert>
    <report test="not(. = ('xsl-region-body',          'xsl-region-start',          'xsl-region-end',          'xsl-region-before',          'xsl-region-after',          'xsl-footnote-separator',          'xsl-before-float-separator')) and               empty(key('region-name', .)) and               empty(/fo:root/fo:layout-master-set/fo:flow-map[@flow-map-name = current()/ancestor::fo:page-sequence[1]/@flow-map-reference]/fo:flow-assignment/fo:flow-source-list/fo:flow-name-specifier/@flow-name-reference[. eq current()])" role="Warning">flow-name=&quot;<value-of select="."/>&quot;は任意の名前付き又は指定 された region-name 又は flow-name-reference と一致しません。</report>
  </rule>

  <rule context="fo:*/@flow-name-reference">
    <!-- https://www.w3.org/TR/xsl11/#flow-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]) = 1">flow-name-reference=&quot;<value-of select="., ancestor::fo-flow-map//fo:flow-name-specifier/@flow-name-reference[. eq current()]"/>&quot; は fo:flow-map 内で特殊でなければなりません。</assert>
    <!-- https://www.w3.org/TR/xsl11/#fo_flow-source-list -->
    <!-- These flows must be either all fo:flow formatting objects or
         all fo:static-content formatting objects. -->
    <assert test="count(distinct-values(for $fo in key('flow-name', .)[ancestor::fo:page-sequence/@flow-map-reference = current()/ancestor::fo:flow-map/@flow-map-name] return local-name($fo))) = 1" role="Warning">flow-name-reference=&quot;<value-of select="."/>&quot; は全ての fo:flow と fo:static-content のみに使用する必要があります。</assert>
  </rule>

  <rule context="fo:*/@hyphenation-character">
    <assert test="string-length(.) = 1 or . eq 'inherit'" id="hyphenation-character"><value-of select="name()"/>=&quot;<value-of select="."/>&quot; は 単一文字 又は inherit でなければなりません。</assert>
  </rule>

  <rule context="fo:*/@language">
    <let name="expression" value="ahf:parser-runner(.)"></let>
    <!-- What would be generated if we could... -->
    <!-- https://www.w3.org/TR/xsl11/#language -->
    <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">language=&quot;<value-of select="."/>&quot; は EnumerationToken でなければなりません。「<value-of select="."/>」は <value-of select="local-name($expression)"/> です。</assert>
    <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit') or string-length($expression/@token) = 2 or string-length($expression/@token) = 3)">language=&quot;<value-of select="."/>&quot; は ISO639-2 用語又は書誌に対応している 3 文字コード、ISO639 2 文字コード に対応している 2 文字コード、none 又は inherit でなければなりません。</report>
    <report test="local-name($expression) = 'ERROR'">シンタックスエラー： language=&quot;<value-of select="."/>&quot;</report>
    <!-- https://www.w3.org/TR/xsl11/#d0e4626 -->
    <!-- Warnings aren't needed (#21) -->
    <!--
    <report test="$expression instance of element(EnumerationToken) and string-length($expression/@token) = 2" id="language_2-letter" role="Warning">language="<value-of select="." />" uses a 2-letter code.  A 2-letter code in conformance with ISO639 will be converted to the corresponding 3-letter ISO639-2 terminology code.</report>
    <report test="$expression instance of element(EnumerationToken) and $expression/@token = ('mul', 'none')" id="language_und" role="Warning">language="<value-of select="." />" will be converted to 'und'.</report>
    -->
  </rule>

  <rule context="fo:marker/@marker-class-name">
    <!-- https://www.w3.org/TR/xsl/#fo_marker -->
    <!-- Error in XSL 1.1 spec, but AH Formatter not complaining. -->
    <assert test="count(../../fo:marker[@marker-class-name eq current()]) = 1" role="Warning">marker-class-name=&quot;<value-of select="."/>&quot; は 同じ親を持つ fo:marker の中で特殊でなければなりません。</assert>
  </rule>

  <rule context="fo:*/@master-name">
    <!-- https://www.w3.org/TR/xsl11/#master-name -->
    <assert test="count(key('master-name', .)) = 1" role="Warning">master-name=&quot;<value-of select="."/>&quot; は 特殊でなければなりません。</assert>
  </rule>

  <rule context="fo:*/@master-reference">
    <!-- https://www.w3.org/TR/xsl11/#master-reference -->
    <assert test="exists(key('master-name', .))" role="Warning">master-reference=&quot;<value-of select="."/>&quot; は文書内にある master-name を参照する必要があります。</assert>
    <report test="count(key('master-name', .)) &gt; 1" role="Warning">master-reference=&quot;<value-of select="."/>&quot; は文書にある複数の master-name を参照しています。</report>
  </rule>

  <rule context="fo:*/@overflow">
    <!-- https://www.w3.org/TR/xsl11/#overflow -->
    <report test=". eq 'repeat' and ../@absolute-position = ('absolute', 'fixed')" role="Warning">overflow=&quot;<value-of select="."/>&quot; の絶対位置の領域は auto を処理されます。</report>
  </rule>

  <rule context="fo:index-key-reference/@ref-index-key">
    <!-- https://www.w3.org/TR/xsl11/#ref-index-key -->
    <let name="index-key-reference" value="."></let>
    <report test="empty(key('index-key', .))" role="Warning">ref-index-key=&quot;<value-of select="."/>&quot; は任意の index-key 値と一致しません。</report>
    <report test="exists(key('index-key', .)) and (some $index-hit in key('index-key', .) satisfies $index-hit &gt;&gt; $index-key-reference)" role="Warning">ref-index-key=&quot;<value-of select="."/>&quot;は一致する index-key 値の前に発生します。</report>
  </rule>

  <rule context="fo:*/@region-name">
    <!-- https://www.w3.org/TR/xsl11/#region-name -->
    <assert test="count(distinct-values(for $fo in key('region-name', .) return local-name($fo))) = 1" role="Warning">region-name=&quot;<value-of select="."/>&quot; は同じクラスの領域のみに使用する必要があります。</assert>
    <assert test="not(. eq 'xsl-region-body') or local-name(..) eq 'region-body'">region-name=&quot;<value-of select="."/>&quot; は fo:region-body のみに使用する必要があります。</assert>
    <assert test="not(. eq 'xsl-region-start') or local-name(..) eq 'region-start'">region-name=&quot;<value-of select="."/>&quot; は fo:region-start のみに使用する必要があります。</assert>
    <assert test="not(. eq 'xsl-region-end') or local-name(..) eq 'region-end'">region-name=&quot;<value-of select="."/>&quot; は fo:region-end のみに使用する必要ことがあります。</assert>
    <assert test="not(. eq 'xsl-region-before') or local-name(..) eq 'region-before'">region-name=&quot;<value-of select="."/>&quot; は fo:region-before のみに使用する必要があります。</assert>
    <assert test="not(. eq 'xsl-region-after') or local-name(..) eq 'region-after'">region-name=&quot;<value-of select="."/>&quot; は fo:region-after のみに使用する必要があります。</assert>
  </rule>

  <rule context="fo:*/@region-name-reference">
    <!-- https://www.w3.org/TR/xsl11/#region-name-reference -->
    <assert test="count(ancestor::fo:flow-map//fo:region-name-specifier/@region-name-reference[. eq current()]) = 1">region-name-reference=&quot;<value-of select="."/>&quot; は fo:flow-map 内で特殊でなくてはいけません。</assert>
  </rule>

   <!-- retrieve-class-name -->
   <rule context="fo:*/@retrieve-class-name">
      <assert test="exists(key('marker-class-name', .))" role="Warning"><value-of select="local-name()"/>=&quot;<value-of select="."/>&quot; は 既存しているfo:markerには参照しません。</assert>
   </rule>

  <rule context="fo:*/@span">
    <!-- https://www.w3.org/TR/xsl11/#span -->
    <report test="exists(ancestor::fo:static-content)" sqf:fix="span_fix" role="warning">@span は、fo:flow によって返された領域のみに効果があります。</report>
    <sqf:fix id="span_fix">
      <sqf:description>
        <sqf:title>Delete @span</sqf:title>
      </sqf:description>
      <sqf:delete/>
    </sqf:fix>
  </rule>

</pattern><!-- Local Variables:  --><!-- mode: nxml        --><!-- End:              -->