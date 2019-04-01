# focheck 0.7.2

- Licenses for additional components added to `ReadMe.md` (#38).
- Added Schematron for optionally checking Matterhorn Protocol PDF/UA accessibility rules.
- Added `axf:formatter-config` and `axf:output-volume-info`.
- Started validating `axf:formatter-config` using formatter settings schema from 'ahfsettings' framework.
- Added `hsl()` and `hsla()` functions from AH Formatter V6.6.
- Echoing specific error message when expression language syntax error.
- Corrected type in `page-citation-strategy` value list.
- Added this ChangeLog for **focheck** releases

# focheck 0.7.1

- `axf:background-image-resolution` should be optional.
- AH Formatter allows `transparent` as `color` value. 

# focheck 0.7.0

- Added more annotation extension properties: `axf:annotation-border-color`, `axf:annotation-border-style`, `axf:annotation-border-width`, `axf:annotation-flags`, `axf:annotation-font-family`, `axf:annotation-font-size`, `axf:annotation-font-style`, `axf:annotation-font-weight`, `axf:annotation-text-align`, and `axf:annotation-text-color`.
- Added `axf:text-overflow`.
- `font-variant` has extended values in AH Formatter.
- Added `axf:hyphenation-info`.
- Added `axf:border-connection-form`.
- Added `xml:lang`.
- Added `background-image-resolution` plus text decoration properties: `axf:text-line-color`, `axf:text-line-style`, `axf:text-line-width`, and `axf:text-underline-position`.
- Sorted property definitions.
- Main Schematron file is now `focheck.sch`.
- Split `axf.sch` into `axf-fo.sch` and `axf-property.sch`.
- Added SQF for `fo:table-cell` containing only text.
- Started using abstract Schematron rules.
- Trying to make some Schematron messages more readable.
- Added Emacs file mode comment at end of Schematron files.
- Added Schematron for text decoration properties.
- Munging $input to recognize `9cc` as a length broke recognizing `#9cc568`.
- Trying to avoid adding spaces when something is not a length.
- Full list of color keywords baked into `parser-runner.xsl`.
- Inserts template into empty Emacs buffers.
- Emacs `fo-format` function runs formatter.
- Upped copyright year.
- Optionally setting copyright year in generated files.

# focheck 0.6.1

- `font-stretch` may also be a &lt;number>. (#37)
- Added `axf:diagonal-border-style` and `axf:reverse-diagonal-border-style`.
- Added `axf:custom-property` from AH Formatter V6.5.
- Added `axf:column-rule-align`, `axf:column-rule-color`, `axf:column-rule-display`, `axf:column-rule-length`, `axf:column-rule-style`, and `axf:column-rule-width`.
- Added `axf:layer-settings`.
- `axf:layer-name` corrected to be `axf:layer`.
- Changed 'http://www.antennahouse.com' to 'https://www.antennahouse.com' in non-namespace URIs.

# focheck 0.6.0

- Warnings for missing `provisional-distance-between-starts` and `provisional-label-separation`.
- Added `fo:change-bar-begin` and `fo:change-bar-end` rules.
- Updated Japanese translations.
- Updated English and Japanese README.
- Changed `local-name()` to `name()` in some Schematron messages.
- Added OmegaT TMX files.

# focheck 0.5.6

- Added `axf:column-fill` to schema (#34).
- Schematron rule and quick-fix for `span` inside `fo:static-content` (#35).
- Updated URLs to refer to V6.5 Online Manual.
- Using 'https:' in XSL 1.1 URLs.

# focheck 0.5.5

* Added `axf:printer-bin-selection` and `axf:printer-duplex`.

# focheck 0.5.4

* Added rest of 'Page Number' extensions.
* Not checking `allowed-height-scale`, `allowed-width-scale`, or `background-image`.

# focheck 0.5.3

-  Handling multi-valued 'axf:float' property. (#32) 

# focheck 0.5.2

- Added `axf:indent-here` extension property.
- `build.xml` 'fo-property.sch' target also depends on "${property-schematron-dump.xsl}".
- Only checking that `country` is non-empty. (re #31)

# focheck 0.5.1

-  Copy-and-paste error for `axf:line-number-background-color` and `axf:line-number-color` contexts.

# focheck 0.5.0

- Added rest of `axf:line-number-*` extension properties (#30).
- Added `axf:baseline-grid` and `axf:baseline-block-snap` (#29).
- `axf:line-number-*` are inherited.
- Added nested `fo:page-sequence` and some form FOs.
- Added outline properties to `fo:list-item` because people use that.
- Updated URLs in comments to refer to V6.4 Online Manual.
- `axf:annotation-type` also usable with `fo:basic-link`.
- Added `axf:headers` and `axf:scope` from V6.4.
- Fixed typo in a property reference.
- Added `axf_number-type`, `axf_origin-id`, `axf_suppress-folio-prefix`, and `axf_suppress-folio-suffix`.
- Added quick fixes to delete properties superseded by XSL 1.1 FOs and properties.
- Added content models to some descriptions.
- Added `axf:page-number-prefix` warning and quick-fix.
- Added annotation-related properties.
- Added FOs and properties for ruby.
- File name and line number in Schematron messages.
- Added unprefixed `column-gap` to `fo:block-container`.
- Added `axf:output-volume-break` and `axf:output-volume-filename`.
- Added more footnote-related properties on `fo:region-body`.
- `axf:footnote-max-height` does not apply to `fo:footnote`.
- Generating Schematron XSLT depends on `etc/check.sch`.
- Added background and bleed to `axf:spread-page-master`.
- Added `axf:footnote-position`.
- Absent `start-indent` and `end-indent` in lists use inherited values.
- Emacs mode for XSL-FO.
- Added more form-related extension properties.
- Added `xml:id`.
- Preserve modification dates for ease of comparison with OmegaT project.
- `README.md` notes that oXygen 17.1 and 18.0 have focheck 0.3.1.
- Upped copyright year.

# focheck 0.4.1

- Started adding `axf:form` and `axf:tab`.
- Added `axf:pdftag` to `common-accessibility-properties`.
- Added `axf:suppress-if-first-on-page`.
- Added `axf:border-double-width`, `axf:border-wave-form`, `axf:tab-overlap-treatment`, `axf:tab-stops`, `axf:tab-treatment`, `axf:text-justify`, `axf:line-number-format`, `axf:line-number-initial`, `axf:line-number-interval`, `axf:line-number-orientation`, `axf:line-number-prefix`, `axf:line-number-reset`, and `axf:line-number-start`.
- `column-count` applies to `fo:block-container`.
- Schematron and SQF for `axf:hyphenation-zone` (#28) and Schematron for `axf:line-number-interval` and `axf:line-number-offset`.
- Skipping autogenerated Schematron checking of `content-type`.
- Copying catalog for MathML entities from W3C example catalog. (#26)
- Updated documentation links to point to AH Formatter V6.3 Online Manual at http://www.antennahouse.com/product/ahf63/.
- Updated Japanese translation in `README.md`.
- When copying Schematron files to translate, copy only `.sch` files.

# focheck 0.4.0

- For AH Formatter V6.3:
  - Added `axf:spread-page-master` and `axf:spread-region`.
  - Added `cmyk()` and `cmyka()`.
- Schematron Quick Fixes for `fo:list-item-body` and `fo:list-item-label`.
- Added `rgba()`. 

# focheck 0.3.5

- Translated schema documentation annotations (partial).
- More Schematron translations.
- Added `axf:alt-text` and `axf:table-summary`.
- Japanese error messages and hints.
- Started to add Schematron Quick Fixes where possible. 

# focheck 0.3.4

- First, partly localized Japanese release.
- Corrections to Ant targets for standalone checking.
- Now getting deprecation warning for `<axf:document-info name="title" />`.

# focheck 0.3.3

- Checking `index-key` and `ref-index-key`.
- Handling `character`, `grouping-separator`, and `hyphenation-character`.
- Not complaining about EnumerationToken when Literal allowed.
- AH Formatter allows `fo:block-container/@role`.

# focheck 0.3.2

- Removed NVDL validation scenario until NVDL is completed.

# focheck 0.3.1

- Not treating SVG `id` as an ID to avoid false errors when multiple SVG in the FO document.
- Allowing any SVG `version` value to avoid false errors from SVG 1.0 graphics.
- Added initial NVDL validation scenario.
- Handling 'angle' as 'Literal' expression datatype.

# focheck 0.3.0

- Validating MathML3 and SVG 1.1 in `fo:instream-foreign-object`.
- Can't convert RNC 'require' to XSD, so converting schema without either MathML3 or SVG 1.1.
- Added 'htmlmathml-f.ent' from W3C XML Entity Definitions for Characters Rec for use with MathML3.
- Added rules for `fo:marker`.
- Added extension properties for `fo:float`. (#17)
- Had wrong logic when avoiding checking that `internal-destination` and `external-destination` aren't an empty string. (#23)
- Commented out warnings about `language` value that is two letters, 'mul', or 'none'. (#21)
- Simpler model override system.
- Not checking enumeration tokens when URI datatype is also allowed. (#18)
- Coping with unquoted HTTP, etc. URLs containing ':'. 

# focheck 0.2.6

- `fo:basic-link` should not have both `internal-destination` and `external-destination` properties.
- Checking reserved `region-name` values.
- Allowing `xsl-footnote-separator` and `xsl-before-float-separator` reserved `flow-name` values.
- Warning for `master-reference` that refers to `master-name` that has a name conflict
- Allowing `fo:wrapper/text-decoration`.
- Allowing '0' when 'Length' is an allowed datatype. (#12)
- xsd:IDREF checking for `ref-id` and `internal-destination`, but still too zealous. (#20)
- Including 'template/*.properties' in add-on framework bundle. (#19)
- Not reporting empty value when initial value is 'empty string'.
- Revised message for bad enumeration token.
- `fo:footnote` in absolutely-positioned area now a warning, not an error.
- More background properties for `fo:page-sequence` and `fo:simple-page-master`.
- `overflow` extension values `replace` and `condense` apply only on `fo:block-container` and `fo:inline-container`.
- Changed 'AH' to 'Antenna House' in transformation scenario names.

# focheck 0.2.5

- Now listing enumeration tokens in messages about wrong or empty property value.
- Warning that `overflow="repeat"` on an absolutely-positioned area will be treated as `auto`.
- Added `rgba()` as a 'function'.
- Other color 'functions' now return `Color`.

# focheck 0.2.4

- Added Schematron rules for handling `fo:flow-map` and descendants.
- Added Schematron rules for `flow-name`, `master-name`, and `region-name`.
- Also making a property, other than `region-name`, required if 'Inherited' definition contains 'required'.
- When running AH Formatter GUI with '-s' from oXygen, not also opening PDF if it already exists.

# focheck 0.2.3

- Added `axf:footnote-*` properties to `fo:footnote`. (#16) 

# focheck 0.2.2

- Allowing but warning about `<axf:document-info name="title">` (#14)
- Allowing axf:background-\* properties on `fo:page-sequence` and `fo:simple-page-master` (#10)
- Allowing axf:background-content-\* properties where background properties allowed (#11)
- An `fo:retrieve-marker` is only permitted as the descendant of an `fo:static-content`

# focheck 0.2.1

- Reporting empty properties as warnings. (#13) 
- There must be at least one `fo:page-sequence` descendant of `fo:root`.
- Allowing non-XSL elements inside `fo:declarations`.
- Not putting date in generated files.
- Schematron for `language`. (#9) 
- Property comments includes URL
- More repeating of whole attribute first in Schematron messages so the context is more obvious.

# focheck 0.2.0

- Requiring property attributes for which a value is required.
- Schema checking of `<id>` and `<idref>` datatypes.
- Schema checking of `xml:lang` value.
- Improved Schematron checking of `fo:footnote`.

# focheck 0.2.0

- Requiring property attributes for which a value is required.
- Schema checking of `<id>` and `<idref>` datatypes.
- Schema checking of `xml:lang` value.
- Improved Schematron checking of `fo:footnote`.

# focheck 0.1.0

- Handling `max-height`, `max-width`, `min-height`, and `min-width`, including on `fo:block`. (re #6)
- `top`, `right`, `bottom` and `left` are also 'relative position' properties. (re #7)
- 'Neutral' FOs now alternatives to defined content, not just interleaved with defined content. (re #8)
- `fo:wrapper` can have `fo:marker`
- Three variations on `fo:wrapper` in schema since `fo:wrapper` allows only what its parent FO allows.
-  Improved enumeration token message (re #9) and other generated messages/comments.
- Reporting `fo:float` or `fo:footnote` as descendant of `fo:float` or `fo:footnote`.
- Changed name of Zip archive for oXygen framework releases to 'focheck-framework-*.zip'.

# focheck 0.0.12

- Generating documentation comments for inherited Antenna House extension properties. (#3)

# focheck 0.0.11

- Added `@axf:outline-expand`, `@axf:outline-group`, `@axf:outline-level`, `@axf:outline-title`, `@axf:outline-color`, `@axf:outline-font-style`, and `@axf:outline-font-weight`. (#5)
- Added (or uncommented) rules for `fo:retrieve-table-marker`, `@number-columns-spanned`, and `@column-width`.

# focheck 0.0.10

- Added `build-focheck.xml` with `validate` target for validating an FO file using both Relax NG and Schematron.
- No substantive changes to schema or Schematron.

# focheck 0.0.9

- Not parsing either 'id' or 'role' as expressions.
- Accepting any integer for 'font-weight'.
- Handling more Antenna House extensions.
- AH Formatter allows percentage as 'font-stretch' value.
- Generating XSD files as part of 'build' target.

# focheck 0.0.8

- Added more Antenna House extensions..
- Git repository includes XSD version of schema.

# focheck 0.0.7

- Using correct REx-generated parser XSLT file.

# focheck 0.0.6

Initial public release.