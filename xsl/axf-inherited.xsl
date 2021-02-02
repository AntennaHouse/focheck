<!-- ============================================================= -->
<!--  MODULE:     axf-inherited.xsl                                -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      XSL-FO validation with Antenna House extensions  -->
<!--                                                               -->
<!-- PURPOSE:     Generate Relax NG compact syntax schema to add   -->
<!--              a set of inherited extension properties to evey  -->
<!--              FO in the XSL 1.1 Recommendation                 -->
<!--                                                               -->
<!-- INPUT FILE:  XML for the XSL 1.1 Recommendation               -->
<!--                                                               -->
<!-- OUTPUT FILE: Relax NG compact syntax schema module            -->
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
<!--              28 March 2015                                    -->
<!--                                                               -->
<!-- CREATED BY:  Tony Graham (tgraham)                            -->
<!--                                                               -->
<!-- ============================================================= -->
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
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ahf axf xs">

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

<!-- Additional parameters defined in 'common.xsl'. -->

<!-- The Relax NG compact syntax module that this module includes. -->
<xsl:param name="include" select="'fo-inherited.rnc'" as="xs:string" />

<!-- ============================================================= -->
<!-- GLOBAL VARIABLES                                              -->
<!-- ============================================================= -->

<!-- Additional variables defined in 'common.xsl'. -->

<!-- Two tables in Appendix B of the XSL 1.1 Recommendation each list
     some details about every property.
     http://www.w3.org/TR/xsl/#prtab1 lists whether a property is
     inherited. -->
<xsl:variable
    name="inherited-properties"
    as="element(property)+">
<property name="axf:abbreviation-character-count" model="'auto' | text" description="Minimum number of characters considered to be an abbreviation" />
<property name="axf:alt-glyph" model="text" description="Alternative glyph of a character: &lt;number> | &lt;string> &lt;number>?" />
<property name="axf:assumed-page-number" model="text" description="Assumed page number" />
<property name="axf:avoid-widow-words" model="text" description="Spacing behavior between words or characters so that the last line of the paragraph does not have only one word left (one character for CJK): false | true | [&lt;length> || &lt;percentage>]" />
<property name="axf:avoid-widow-words-cjk-punctuation" model="text" description="Whether to include the last punctuation mark and count them in one character when axf:avoid-widow-word=&quot;true&quot;: auto | true | false | &lt;string&gt;" /><!-- V7.1 -->
<property name="axf:balanced-text-align" model="'true' | 'false' | 'auto'" description="Whether to balance entire block including the last line: true | false | auto" /><!-- V7.0 -->
<property name="axf:base-uri" model="text" description="Location which becomes the base of relative URI" />
<property name="axf:border-double-thickness" model="text" description="Line thickness of border-style=&quot;double&quot;" />
<property name="axf:border-connection-form" model="'mixed' | 'precedence' | 'wedge'" description="Shape of border connections" />
<property name="axf:border-wave-form" model="text" description="Wave form for border-style=&quot;wave&quot;" />
<property name="axf:condensed-text-align-last" model="'false' | 'true' | 'justify' | 'auto'" description="whether to set text-align-last=&quot;justify&quot; automatically after condensing the overflow: false | true | justify | auto" /><!-- V7.1 -->
<property name="axf:diagonal-border-color" model="text" description="Color of the diagonal border" />
<property name="axf:diagonal-border-width" model="text" description="Width of the diagonal border" />
<property name="axf:display-alttext" model="'true' | 'false' | 'auto'" description="Whether to display the alternate text of a missing image: true | false | auto" /><!-- V7.0 -->
<property name="axf:flush-zone" model="text" description="Threshold for justifying last line: none | &lt;length> | &lt;percentage>" /><!-- V7.0 -->
<property name="axf:hanging-punctuation" model="text" description="Whether to hang punctuations at the start of the line or end of the line: none | [ start || first || [ force-end | allow-end ] || last ]" />
<property name="axf:hyphenate-caps-word" model="'true' | 'false'" description="Whether to hyphenate words consisting only of uppercase letters: true | false" /><!-- V7.0 -->
<property name="axf:hyphenate-hyphenated-word" model="'true' | 'false'" description="Whether to hyphenate an already hyphenated word" />
<property name="axf:hyphenation-minimum-character-count" model="text" description="Minimum number of the character to hyphenate" />
<property name="axf:hyphenation-zone" model="'none' | text" description="Range where a hyphenation is available: none | &lt;length>" />
<property name="axf:initial-letters-color" model="text" description="Color of a dropped initial: &lt;color>" /><!-- V7.0 -->
<property name="axf:initial-letters-end-indent" model="text" description="Space on the end side of a dropped initial: &lt;length>+" /><!-- V7.0 -->
<property name="axf:initial-letters-first-line-head-height" model="'cap-height' | 'x-height' | 'auto'" description="Alignment of the top of an initial letter: cap-height | x-height | auto" /><!-- V7.0 -->
<property name="axf:initial-letters-leading-punctuation" model="text" description="Size of the leading punctuation of a dropped initial: normal | hide | [&lt;length> || &lt;color>]" /><!-- V7.0 -->
<property name="axf:initial-letters-leading-punctuation-position" model="text" description="Position of the leading punctuation of a dropped initial in the inline progression direction: normal | [[hang | intrude] &amp;&amp; &lt;length>?]" /><!-- V7.0 -->
<property name="axf:initial-letters-leading-punctuation-shift" model="text" description="Position of the leading punctuation of a dropped initial in the block progression direction: normal | [[baseline | before | middle | after] || &lt;length>]" /><!-- V7.0 -->
<property name="axf:initial-letters-text-align" model="'start' | 'center' | 'end' | 'left' | 'right'" description="Alignment of a dropped initial: start | center | end | left | right" /><!-- V7.0 -->
<property name="axf:initial-letters-width" model="text" description="Width of a dropped initial: auto | &lt;length> | &lt;percentage>" /><!-- V7.0 -->
<property name="axf:inline-overflow-align" model="'normal' | 'start' | 'end' | 'left' | 'right'" description="Adjustments when the blocks in &lt;fo:inline-container> overflow: normal | start | end | left | right" /><!-- V7.1 -->
<property name="axf:intrude-into-punctuation" model="text" description="Intrusion of inline element into punctuation: none | [start || end]" /><!-- V7.1 -->
<property name="axf:japanese-glyph" model="'none' | 'jp78' | 'jp83' | 'jp90' | 'jp04'" description="Glyph of Japanese Kanji" />
<property name="axf:justify-nbsp" model="'true' | 'false'" description="Whether to justify NON-BREAKING SPACE" />
<property name="axf:kansuji-grouping-letter" model="text" description="Grouping character used for Japanese numerals" />
<property name="axf:kansuji-letter" model="text" description="Character used for Japanese numerals: kanji | latin | &lt;string>" />
<property name="axf:kansuji-style" model="'simple' | 'grouping' | 'readable'" description="Style used for Japanese numerals" />
<property name="axf:kerning-mode" model="'none' | 'pair' | 'auto'" description="Whether to perform kerning" />
<property name="axf:layer" model="'none' | text" description="Layer to which the area is arranged." />
<property name="axf:leader-expansion" model="'auto' | 'force'" description="Whether to forcibly expand a leader" />
<property name="axf:letter-spacing-side" model="'both' | 'start' | 'end'" description="Which side of the character the space by letter-spacing is distributed" />
<property name="axf:ligature-mode" model="text" description="Whether to perform the ligature processing: none | [ latin || kana || jamo ] | all | auto" />
<property name="axf:line-break" model="text" description="Line-breaking method: auto | [[normal | strict | loose | anywhere] || [line | bpil]]" />
<property name="axf:line-continued-mark" model="text" description="Whether to show line continued marks: &lt;string>" />
<property name="axf:line-continued-mark-background-color" model="text" description="Background color of line continued marks" />
<property name="axf:line-continued-mark-color" model="text" description="Color of line continued marks" />
<property name="axf:line-continued-mark-font-family" model="text" description="Font family of line continued marks" />
<property name="axf:line-continued-mark-font-size" model="text" description="Font size of line continued marks" />
<property name="axf:line-continued-mark-font-style" model="'normal' | 'italic'" description="Whether to make the font style italic" />
<property name="axf:line-continued-mark-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="Font weight of line numbers" />
<property name="axf:line-continued-mark-offset" model="text" description="Offset of line continued marks: &lt;length>" />
<property name="axf:line-number" model="'none' | 'show' | 'hide'" description="Whether to show line numbers" />
<property name="axf:line-number-background-color" model="text" description="Background color of line numbers: &lt;color> | transparent" />
<property name="axf:line-number-color" model="text" description="Color of line numbers" />
<property name="axf:line-number-display-align" model="'auto' | 'before' | 'center' | 'after'" description="Alignment, in the block-progression-direction, of line numbers in the line area" />
<property name="axf:line-number-except-continued-line" model="'true' | 'false'" description="Whether to add line numbers except for continued lines: true | false" /><!-- V7.1 -->
<property name="axf:line-number-font-family" model="text" description="Font family of line numbers" />
<property name="axf:line-number-font-size" model="text" description="Font size of line numbers" />
<property name="axf:line-number-font-style" model="'normal' | 'italic'" description="Whether to make the font style italic" />
<property name="axf:line-number-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="Font weight of line numbers" />
<property name="axf:line-number-format" model="text" description="format of line numbers: &lt;string>" />
<property name="axf:line-number-initial" model="text" description="Line number of the first line: auto | &lt;number>" />
<property name="axf:line-number-interval" model="text" description="Interval of line numbers: &lt;snumber> | auto" />
<property name="axf:line-number-offset" model="text" description="Offset of line numbers: &lt;length>" />
<property name="axf:line-number-orientation" model="'0' | '90' | '180' | '270' | '-90' | '-180' | '-270'" description="Rotates line numbers: 0 | 90 | 180 | 270 | -90 | -180 | -270" />
<property name="axf:line-number-position" model="'start' | 'end' | 'inside' | 'outside' | 'alternate'" description="Position of line numbers: start | end | inside | outside | alternate" />
<property name="axf:line-number-prefix" model="text" description="Prefix of line number: &lt;string>" />
<property name="axf:line-number-reset" model="'auto' | 'none' | 'page' | 'column' | 'force'" description="When to reset line numbers: auto | none | page | column | force" />
<property name="axf:line-number-start" model="text" description="Starting line number: &lt;snumber> | auto" />
<property name="axf:line-number-text-align" model="'auto' | 'start' | 'center' | 'end' | 'inside' | 'outside' | 'left' | 'right'" description="Alignment of line numbers in the line area: auto | start | center | end | inside | outside | left | right" />
<property name="axf:line-number-text-decoration" model="text" description="Text decoration of line numbers" />
<property name="axf:line-number-width" model="text" description="Width of line numbers: auto | &lt;length>" />
<property name="axf:list-style-type" model="text" description="List style: &lt;glyph> | &lt;algorithmic> | &lt;numeric> | &lt;alphabetic> | &lt;symbolic> | &lt;non-repeating> | normal | none" />
<property name="axf:normalize" model="'auto' | 'none' | 'nfc' | 'nfkc' | 'nfd' | 'nfkd'" description="Unicode normalization to perform on text: auto | none | nfc | nfkc | nfd | nfkd" />
<property name="axf:normalize-exclude" model="'full-composition-exclusion' | 'none'" description="Whether Composition Exclusions are excluded or not when the normalization (axf:normalize) is specified: full-composition-exclusion | none" />
<property name="axf:number-transform" model="text" description="Converts the number sequence in the character string: none | kansuji | kansuji-if-vertical | &lt;list-style-type> | &lt;string>" />
<property name="axf:overflow-align" model="'normal' | 'start' | 'end' | 'center'" description="Alignment of the overflowed block: normal | start | end | center" />
<property name="axf:overflow-condense" model="text" description="How to condense the overflowed text within the region: [ font-size | font-stretch | line-height | letter-spacing ]+ | auto | none" />
<property name="axf:overflow-condense-limit-font-size" model="text" description="Minimum font size when axf:overflow-condense=&quot;font-size&quot; is specified: &lt;length> [ visible | hidden | scroll | error-if-overflow | repeat ]" />
<property name="axf:overflow-condense-limit-font-stretch" model="text" description="Minimum value when axf:overflow-condense=&quot;font-stretch&quot; is specified: [ &lt;number> | &lt;percentage> ] [ visible | hidden | scroll | error-if-overflow | repeat ]" />
<property name="axf:overflow-condense-limit-letter-spacing" model="text" description="Minimum value when axf:overflow-condense=&quot;letter-spacing&quot; is specified: none | [ &lt;length> [ visible | hidden | error-if-overflow | repeat ]? ]" /><!-- V7.1 -->
<property name="axf:overflow-condense-limit-line-height" model="text" description="Minimum value when axf:overflow-condense=&quot;line-height&quot; is specified: none | [ &lt;number> [ visible | hidden | error-if-overflow | repeat ]? ]" /><!-- V7.1 -->
<property name="axf:overflow-limit" model="text" description="Overflow limit value: &lt;length>{1,2}" />
<property name="axf:overflow-limit-block" model="text" description="Block overflow limit value" />
<property name="axf:overflow-limit-inline" model="text" description="Inline overflow limit value" />
<property name="axf:overflow-replace" model="text" description="Alternative character string for the specified overflow text" />
<property name="axf:overprint" model="text" description="Overprint setting" />
<property name="axf:punctuation-spacing" model="text" description="Space to trim  between a full width punctuation and a full width character in Japanese" />
<property name="axf:punctuation-trim" model="text" description="How to treat full width punctuations in Japanese" />
<property name="axf:repeat-footnote-in-table-footer" model="'true' | 'false'" description="Whether to repeat the fo:footnote in the fo:table-footer that is repeated by table-omit-footer-at-break=&quot;false&quot;" />
<property name="axf:repeat-footnote-in-table-header" model="'true' | 'false'" description="Whether to repeat the fo:footnote in the fo:table-header that is repeated by table-omit-header-at-break=&quot;false&quot;: true | false" />
<property name="axf:reverse-diagonal-border-color" model="text" description="Color of the reverse diagonal border" />
<property name="axf:reverse-diagonal-border-width" model="text" description="Width of the reverse diagonal border" />
<property name="axf:revision-bar-color" model="text" description="Color of the revision bar: &lt;color>" />
<property name="axf:revision-bar-offset" model="text" description="Offset of the revision bar: &lt;length>" />
<property name="axf:revision-bar-position" model="'start' | 'end' | 'inside' | 'outside' | 'alternate' | 'both'" description="Position of the revision bar: start | end | inside | outside | alternate | both" />
<property name="axf:revision-bar-style" model="text" description="Style of the revision bar: &lt;border-style>" />
<property name="axf:revision-bar-width" model="text" description="Width of the revision bar: &lt;border-width>" />
<property name="axf:ruby-align" model="text" description="Alignment of the ruby: auto | [[distribute-space | distribute-letter] || [center | start | end | start-if-vertical]]" />
<property name="axf:ruby-color" model="text" description="Color of ruby text: &lt;color>" />
<property name="axf:ruby-condense" model="text" description="Font condense when the ruby text is longer than its base: none | &lt;percentage> | &lt;number>" />
<property name="axf:ruby-font-family" model="text" description="Font family of ruby text: [ &lt;family-name> | &lt;generic-family> ]#" />
<property name="axf:ruby-font-size" model="text" description="Font size of ruby text: &lt;number> | &lt;absolute-size> | &lt;relative-size> | &lt;length> | &lt;percentage>" />
<property name="axf:ruby-font-stretch" model="text" description="Font stretch of ruby text: normal | wider | narrower | ultra-condensed | extra-condensed | condensed | semi-condensed | semi-expanded | expanded | extra-expanded | ultra-expanded | &lt;percentage> | &lt;number>" />
<property name="axf:ruby-font-style" model="'normal' | 'italic'" description="Font style of ruby text: normal | italic" />
<property name="axf:ruby-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="Font weight of ruby text: normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900" />
<property name="axf:ruby-limit-overhang" model="text" description="Limit of the amount that ruby overhangs the adjacent base character when ruby is longer than its own base character: &lt;number> | &lt;length> | &lt;percentage>" />
<property name="axf:ruby-limit-space" model="text" description="Limit of the amount of spaces leading and following the ruby text when the ruby text is shorter than its base characters: &lt;number> | &lt;length> | &lt;percentage> | none" />
<property name="axf:ruby-minimum-font-size" model="text" description="Minimum font size of ruby text: none | &lt;absolute-size> | &lt;relative-size> | &lt;length> | &lt;percentage>" />
<property name="axf:ruby-offset" model="text" description="Spacing between the ruby text and its base characters: &lt;number> | &lt;length> | &lt;percentage>" />
<property name="axf:ruby-overhang" model="text" description="How ruby overhangs an adjacent base character: none | auto | [start || end || except-kanji || except-katakana || except-start-open-parenthesis || except-end-close-parenthesis]" />
<property name="axf:ruby-position" model="'before' | 'after'" description="Side of the base characters on which the ruby text appears: before | after" />
<property name="axf:ruby-small-kana" model="'auto' | 'convert'" description="Whether to allow using small kana for ruby text: auto | convert" />
<property name="axf:soft-hyphen-treatment" model="'auto' | 'preserve'" description="Whether to print SOFT HYPHEN (U+00AD)" />
<property name="axf:suppress-duplicate-footnote" model="'true' | 'false'" description="Whether to delete footnotes duplicated in the same page: true | false" />
<property name="axf:suppress-duplicate-marker-contents" model="'true' | 'false'" description="Whether to delete markers duplicated in the same page: true | false" /><!-- V7.0 -->
<property name="axf:suppress-duplicate-page-number" model="'true' | 'false'" description="Whether to delete duplicated page numbers: true | false" />
<property name="axf:tab-overlap-treatment" model="'auto' | 'ignore-tab' | 'next-tab'" description="Behavior when tab alignment makes letters overlap: auto | ignore-tab | next-tab" />
<property name="axf:tab-stops" model="text" description="Tab stop positions" />
<property name="axf:tab-treatment" model="text" description="Treatment for literal tab characters" />
<property name="axf:table-auto-layout-limit" model="text" description="Number of table-rows to read ahead: auto | &lt;number>" /><!-- V7.1 -->
<property name="axf:table-row-orphans" model="text" description="Number of table-rows that must remain at the bottom of the page (column): &lt;integer>" /><!-- V7.0 -->
<property name="axf:table-row-widows" model="text" description="Number of table-rows that must remain at the top of the page (column): &lt;integer>" /><!-- V7.0 -->
<property name="axf:text-align-first" model="'relative' | 'start' | 'center' | 'end' | 'justify' | 'inside' | 'outside' | 'left' | 'right'" description="Text alignment of the first line" />
<property name="axf:text-align-string" model="'start' | 'center' | 'end' | 'inside' | 'outside' | 'left' | 'right' | 'from-table-column()'" description="Text alignment when text-align=&quot;&lt;string>&quot;: start | center | end | inside | outside | left | right | from-table-column()" />
<property name="axf:text-autospace" model="text" description="Whether to add space surrounding ideographic glyphs: none | [ ideograph-numeric || ideograph-alpha || ideograph-parenthesis ] | auto" />
<property name="axf:text-autospace-width" model="text" description="Width for axf:text-autospace" />
<property name="axf:text-combine-horizontal" model="text" description="Sets horizontal-in-vertical composition in vertical writing mode automatically: none | all | [ digits &lt;integer> || alpha &lt;integer> || alphanumeric &lt;integer> ]" />
<property name="axf:text-emphasis-font-color" model="text" description="Color of emphasis marks" />
<property name="axf:text-emphasis-font-family" model="text" description="Font family of emphasis marks" />
<property name="axf:text-emphasis-font-size" model="text" description="Font size of emphasis marks" />
<property name="axf:text-emphasis-font-stretch" model="text" description="Font stretching of emphasis marks" />
<property name="axf:text-emphasis-font-style" model="'normal' | 'italic'" description="Whether emphasis marks are made Italic" />
<property name="axf:text-emphasis-font-weight" model="'normal' | 'bold' | 'bolder' | 'lighter' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900'" description="Font weight of emphasis marks" />
<property name="axf:text-emphasis-offset" model="text" description="Space between emphasis marks and the base characters" />
<property name="axf:text-emphasis-position" model="'before' | 'after'" description="Which side of base characters emphasis marks are put" />
<property name="axf:text-emphasis-skip" model="text" description="Characters to which emphasis marks are not applied: none | [ spaces || punctuation || symbols || narrow ]" />
<property name="axf:text-emphasis-style" model="text" description="Style of emphasis marks: none | [ [ filled | open ] || [ dot | circle | double-circle | triangle | sesame ] ] | &lt;string> " />
<property name="axf:text-indent-if-first-on-page" model="text" description="text-indent of a block at the top of a page or column: &lt;length> | &lt;percentage> | auto" /><!-- V7.0 -->
<property name="axf:text-justify" model="'auto' | 'inter-word' | 'inter-character' | 'distribute'" description="How to justify text: auto | inter-word | inter-character" />
<property name="axf:text-justify-trim" model="text" description="The way to trim spaces between characters in justified text" />
<property name="axf:text-kashida-space" model="text" description="Percentage of Kashida in Arabic justification: &lt;percentage> | auto" />
<property name="axf:text-orientation" model="'mixed' | 'upright' | 'sideways-right' | 'sideways' | 'none'" description="Orientation of text in vertical writing mode" />
<property name="axf:text-stroke" model="text" description="Stroke of the character: &lt;length> &lt;color>? | &lt;color>" />
<property name="axf:text-stroke-color" model="text" description="Stroke color: &lt;color>" />
<property name="axf:text-stroke-width" model="text" description="Stroke width: &lt;length>" />
<property name="axf:vertical-underline-side" model="'left' | 'right' | 'depend-on-language' | 'auto'" description="Which side of the text to put underline in vertical writing-mode" />
<property name="axf:word-break" model="'normal' | 'break-all' | 'keep-all' | 'keep-non-spaces'" description="Whether to enable line breaking even inside a word: normal | break-all | keep-all | keep-non-spaces" />
<property name="axf:word-wrap" model="'normal' | 'break-word'" description="Whether to forcibly break a word when line break cannot be performed: normal | break-word" />
<property name="text-shadow" model="text" description="Shadow to display behind text: none | [ &lt;length>{{2,3}} &amp;&amp; &lt;color>? ]#" exclude="fo:character fo:initial-property-set fo:leader fo:page-number fo:page-number-citation fo:page-number-citation-last fo:scaling-value-citation" combine="yes" />
</xsl:variable>


<!-- ============================================================= -->
<!-- TEMPLATES                                                     -->
<!-- ============================================================= -->

<xsl:template match="/">

  <xsl:call-template name="ahf:rnc-initial-comment" />
  <xsl:text>
# AH Formatter extension properties that are inherited.
#
# These properties are defined in:
#  - https://www.antenna.co.jp/AHF/help/v70e/ahf-ext.html
#  - https://www.antenna.co.jp/AHF/help/v70e/ahf-float.html
#  - https://www.antenna.co.jp/AHF/help/v70e/ahf-ruby.html
#  - https://www.antenna.co.jp/AHF/help/v70e/ahf-spread.html

default namespace fo = "http://www.w3.org/1999/XSL/Format"
namespace axf = "http://www.antennahouse.com/names/XSL/Extensions"
namespace local = ""

include "</xsl:text>
  <xsl:value-of select="$include" />
  <xsl:text>"

# FOs
</xsl:text>
  <xsl:if test="$debug">
    <xsl:message select="$inherited-properties" />
  </xsl:if>

  <xsl:variable
      name="patterns"
      select="for $property in $inherited-properties/@name
                return translate($property, ':', '_')"
      as="xs:string+"/>

  <xsl:for-each select="key('all-fo-divs', true())">

    <xsl:variable name="qname"
                  select="head"
                  as="xs:string" />
    <xsl:variable name="local-name"
                  select="substring-after(head, 'fo:')"
                  as="xs:string" />

    <!--  -->

    <xsl:if test="$debug">
      <xsl:message><xsl:value-of select="$local-name"/></xsl:message>
      <xsl:for-each select="$patterns">
        <xsl:sort/>
        <xsl:message> - <xsl:value-of select="."/></xsl:message>
      </xsl:for-each>
    </xsl:if>

    <xsl:text>&#10;fo_</xsl:text>
    <xsl:value-of select="$local-name" />
    <xsl:text>.attlist &amp;=&#10;</xsl:text>
    <xsl:for-each
        select="$inherited-properties[not($qname = tokenize(@exclude, '\s+'))]">
      <xsl:sort />
        <xsl:text>    </xsl:text>
        <xsl:value-of select="translate(@name, ':', '_')" />
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:text>
#
# Properties
#

</xsl:text>

  <xsl:for-each select="$inherited-properties">
    <xsl:sort select="@name" />
    <xsl:value-of select="translate(@name, ':', '_')" />
    <xsl:text> </xsl:text>
    <xsl:if test="@combine = 'yes'">
      <xsl:text>|</xsl:text>
    </xsl:if>
    <xsl:text>= &#10;</xsl:text>
    <xsl:if test="exists(@description)">
      <xsl:text>    ## </xsl:text>
      <xsl:value-of select="@description" />
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="exists(@exclude)">
      <xsl:text>    ## Exclude: </xsl:text>
      <xsl:value-of select="@exclude" />
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:text>    attribute </xsl:text>
    <xsl:value-of select="@name" />
    <xsl:text> { </xsl:text>
    <xsl:value-of select="@model" />
    <xsl:text> }?&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
