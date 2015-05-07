<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <pattern xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document" id="fo-fo">
  
  
  <rule context="fo:*/@column-count" role="column-count">
    <let name="expression" value="ahf:parser-runner(.)"/>
    <report test="local-name($expression) = 'Number' and                   (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or                    $expression/@is-zero = 'yes' or                    exists($expression/@value) and not($expression/@value castable as xs:integer))" role="column-count">Warning: @column-count should be a positive integer.  The FO formatter will round a non-positive or non-integer value to the nearest integer value greater than or equal to 1.</report>
  </rule>
</pattern>
    <pattern xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="fo-property">
   <xsl:include href="file:/C:/projects/oxygen/focheck/xsl/parser-runner.xsl"/>

   
   
   
   
   <rule context="fo:*/@absolute-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'absolute-position' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'absolute', 'fixed', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'absolute', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'absolute-position="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@active-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'active-state' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'visited', 'active', 'hover', 'focus'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'link', 'visited', 'active', 'hover', or 'focus'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'active-state="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@alignment-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')">'alignment-adjust' should be EnumerationToken, Percent, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'alignment-adjust="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@alignment-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'alignment-baseline' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'alignment-baseline="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@allowed-height-scale">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">'allowed-height-scale' should be EnumerationToken, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'any' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'allowed-height-scale="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@allowed-width-scale">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">'allowed-width-scale' should be EnumerationToken, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'any' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'allowed-width-scale="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@auto-restore">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'auto-restore' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'auto-restore="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-attachment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'background-attachment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('scroll', 'fixed', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'scroll', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-attachment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'background-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-image">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')">'background-image' should be URI, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-image="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-position-horizontal">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')">'background-position-horizontal' should be Percent, Length, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-position-horizontal="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-position-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')">'background-position-vertical' should be Percent, Length, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'top', 'center', 'bottom', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-position-vertical="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@background-repeat">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'background-repeat' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'background-repeat="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@baseline-shift">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')">'baseline-shift' should be EnumerationToken, Percent, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('baseline', 'sub', 'super', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'baseline', 'sub', 'super', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'baseline-shift="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@blank-or-not-blank">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'blank-or-not-blank' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('blank', 'not-blank', 'any', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'blank', 'not-blank', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'blank-or-not-blank="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@block-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'block-progression-dimension' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'block-progression-dimension="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-after-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-after-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-after-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-after-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'border-after-precedence' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-after-precedence="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-after-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-after-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-after-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-after-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-after-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-after-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-before-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-before-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-before-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-before-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'border-before-precedence' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-before-precedence="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-before-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-before-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-before-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-before-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-before-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-before-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-bottom-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-bottom-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-bottom-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-bottom-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-bottom-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-bottom-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-bottom-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-bottom-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-bottom-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-collapse">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-collapse' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('collapse', 'collapse-with-precedence', 'separate', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'collapse', 'collapse-with-precedence', 'separate', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-collapse="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-end-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-end-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-end-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-end-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'border-end-precedence' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-end-precedence="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-end-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-end-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-end-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-end-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-end-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-end-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-left-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-left-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-left-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-left-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-left-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-left-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-left-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-left-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-left-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-right-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-right-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-right-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-right-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-right-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-right-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-right-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-right-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-right-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">'border-separation' should be Length, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-separation="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-start-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-start-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-start-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-start-precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'border-start-precedence' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'force' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-start-precedence="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-start-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-start-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-start-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-start-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-start-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-start-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-top-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'border-top-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-top-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-top-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'border-top-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-top-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@border-top-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'border-top-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'border-top-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'bottom' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'bottom="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@break-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'break-after' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'break-after="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@break-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'break-before' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'break-before="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@caption-side">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'caption-side' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'caption-side="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@case-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'case-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'case-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@case-title">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'ERROR', 'Object')">'case-title' should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'case-title="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-class">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'change-bar-class' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-class="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'change-bar-color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-offset">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'ERROR', 'Object')">'change-bar-offset' should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-offset="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-placement">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'change-bar-placement' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'alternate'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', or 'alternate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-placement="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'change-bar-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', or 'outset'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@change-bar-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'change-bar-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'thin', 'medium', or 'thick'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'change-bar-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@character">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'ERROR', 'Object')">'character' should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'character="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@clear">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'clear' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'clear="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@clip">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Function', 'EnumerationToken', 'ERROR', 'Object')">'clip' should be Function, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'clip="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@color">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">'color' should be Color, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'color="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@color-profile-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'color-profile-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'color-profile-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@column-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'column-count' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'column-count="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@column-gap">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'column-gap' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'column-gap="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@column-number">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'column-number' should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'column-number="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@column-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'ERROR', 'Object')">'column-width' should be Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'column-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@content-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'content-height' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'content-height="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@content-type">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')">'content-type' should be Literal, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'content-type="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@content-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'content-width' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'content-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@country">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')">'country' should be EnumerationToken, Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'country="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@destination-placement-offset">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'ERROR', 'Object')">'destination-placement-offset' should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'destination-placement-offset="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@direction">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'direction' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ltr', 'rtl', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'ltr', 'rtl', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'direction="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@display-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'display-align' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'before', 'center', 'after', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'before', 'center', 'after', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'display-align="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@dominant-baseline">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'dominant-baseline' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'dominant-baseline="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@empty-cells">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'empty-cells' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'show', 'hide', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'empty-cells="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@end-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'end-indent' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'end-indent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@ends-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'ends-row' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'ends-row="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@extent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'extent' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'extent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@float">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'float' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'float="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@flow-map-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'flow-map-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'flow-map-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@flow-map-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'flow-map-reference' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'flow-map-reference="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@flow-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'flow-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'flow-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@flow-name-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'flow-name-reference' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'flow-name-reference="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-selection-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'font-selection-strategy' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'character-by-character', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'character-by-character', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-selection-strategy="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-size">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'font-size' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-size="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-size-adjust">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'font-size-adjust' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-size-adjust="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-stretch">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">'font-stretch' should be EnumerationToken, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-stretch="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'font-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'italic', 'oblique', 'backslant', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'italic', 'oblique', 'backslant', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-variant">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'font-variant' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'small-caps', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'small-caps', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-variant="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@font-weight">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'font-weight' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'bold', 'bolder', 'lighter', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'bold', 'bolder', 'lighter', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'font-weight="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@glyph-orientation-horizontal">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'glyph-orientation-horizontal' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'glyph-orientation-horizontal="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@glyph-orientation-vertical">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'glyph-orientation-vertical' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'glyph-orientation-vertical="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@grouping-separator">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'ERROR', 'Object')">'grouping-separator' should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'grouping-separator="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@grouping-size">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'grouping-size' should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'grouping-size="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'height' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'height="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenate">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'hyphenate' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenate="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenation-character">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')">'hyphenation-character' should be Literal, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenation-character="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenation-keep">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'hyphenation-keep' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'column', 'page', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenation-keep="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenation-ladder-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'hyphenation-ladder-count' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'no-limit' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenation-ladder-count="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenation-push-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'hyphenation-push-character-count' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenation-push-character-count="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@hyphenation-remain-character-count">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'hyphenation-remain-character-count' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'hyphenation-remain-character-count="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@index-class">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Literal', 'ERROR', 'Object')">'index-class' should be Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'index-class="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@indicate-destination">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'indicate-destination' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'indicate-destination="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@initial-page-number">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'initial-page-number' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'auto-odd', 'auto-even', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'auto-odd', 'auto-even', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'initial-page-number="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@inline-progression-dimension">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'inline-progression-dimension' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'inline-progression-dimension="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@intrinsic-scale-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Percent', 'EnumerationToken', 'ERROR', 'Object')">'intrinsic-scale-value' should be Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'intrinsic-scale-value="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@intrusion-displace">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'intrusion-displace' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'none', 'line', 'indent', 'block', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'none', 'line', 'indent', 'block', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'intrusion-displace="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@keep-together">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'keep-together' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'keep-together="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@keep-with-next">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'keep-with-next' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'keep-with-next="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@keep-with-previous">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'keep-with-previous' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'always', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'keep-with-previous="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@language">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')">'language' should be EnumerationToken, Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'language="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@last-line-end-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'last-line-end-indent' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'last-line-end-indent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@leader-alignment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'leader-alignment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'reference-area', 'page', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'reference-area', 'page', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'leader-alignment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@leader-length">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'leader-length' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'leader-length="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@leader-pattern">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'leader-pattern' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('space', 'rule', 'dots', 'use-content', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'space', 'rule', 'dots', 'use-content', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'leader-pattern="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@leader-pattern-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'leader-pattern-width' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'leader-pattern-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'left' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'left="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@letter-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'letter-spacing' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'letter-spacing="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@letter-value">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'letter-value' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'alphabetic', 'traditional'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'alphabetic', or 'traditional'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'letter-value="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@line-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'ERROR', 'Object')">'line-height' should be EnumerationToken, Length, Number, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'line-height="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@line-height-shift-adjustment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'line-height-shift-adjustment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('consider-shifts', 'disregard-shifts', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'consider-shifts', 'disregard-shifts', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'line-height-shift-adjustment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@line-stacking-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'line-stacking-strategy' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('line-height', 'font-height', 'max-height', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'line-height', 'font-height', 'max-height', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'line-stacking-strategy="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@linefeed-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'linefeed-treatment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'linefeed-treatment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@margin-bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'margin-bottom' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'margin-bottom="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@margin-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'margin-left' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'margin-left="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@margin-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'margin-right' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'margin-right="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@margin-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'margin-top' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'margin-top="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@marker-class-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'marker-class-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'marker-class-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@master-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'master-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'master-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@master-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'master-reference' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'master-reference="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@maximum-repeats">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'maximum-repeats' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'no-limit' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'maximum-repeats="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@media-usage">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'media-usage' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'paginate', 'bounded-in-one-dimension', 'unbounded'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'paginate', 'bounded-in-one-dimension', or 'unbounded'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'media-usage="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@merge-pages-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'merge-pages-across-index-key-references' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'merge-pages-across-index-key-references="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@merge-ranges-across-index-key-references">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'merge-ranges-across-index-key-references' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'merge-ranges-across-index-key-references="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@merge-sequential-page-numbers">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'merge-sequential-page-numbers' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'merge' or 'leave-separate'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'merge-sequential-page-numbers="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@number-columns-repeated">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'number-columns-repeated' should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'number-columns-repeated="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@number-columns-spanned">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'number-columns-spanned' should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'number-columns-spanned="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@number-rows-spanned">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'ERROR', 'Object')">'number-rows-spanned' should be Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'number-rows-spanned="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@odd-or-even">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'odd-or-even' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('odd', 'even', 'any', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'odd', 'even', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'odd-or-even="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@orphans">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'orphans' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'orphans="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@overflow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'overflow' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', 'auto'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', or 'auto'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'overflow="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-after' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-after="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-before' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-before="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-bottom">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-bottom' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-bottom="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-end' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-end="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-left">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-left' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-left="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-right' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-right="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-start' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-start="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@padding-top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'padding-top' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'padding-top="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@page-citation-strategy">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'page-citation-strategy' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('all', 'normal', 'non-blank', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'all', 'normal', 'non-blank', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'page-citation-strategy="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@page-height">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'page-height' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'page-height="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@page-number-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'page-number-treatment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'no-link'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'link' or 'no-link'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'page-number-treatment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@page-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'page-position' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('only', 'first', 'last', 'rest', 'any', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'only', 'first', 'last', 'rest', 'any', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'page-position="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@page-width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'page-width' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'page-width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@precedence">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'precedence' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'precedence="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@provisional-distance-between-starts">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'provisional-distance-between-starts' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'provisional-distance-between-starts="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@provisional-label-separation">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'provisional-label-separation' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'provisional-label-separation="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@region-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'region-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'region-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@region-name-reference">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'region-name-reference' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'region-name-reference="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@relative-align">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'relative-align' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'baseline', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'before', 'baseline', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'relative-align="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@relative-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'relative-position' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('static', 'relative', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'static', 'relative', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'relative-position="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@rendering-intent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'rendering-intent' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'rendering-intent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@retrieve-boundary">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'retrieve-boundary' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('page', 'page-sequence', 'document'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'page', 'page-sequence', or 'document'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'retrieve-boundary="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@retrieve-boundary-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'retrieve-boundary-within-table' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('table', 'table-fragment', 'page'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'table', 'table-fragment', or 'page'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'retrieve-boundary-within-table="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@retrieve-class-name">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'retrieve-class-name' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'retrieve-class-name="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@retrieve-position">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'retrieve-position' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', 'last-ending-within-page'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', or 'last-ending-within-page'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'retrieve-position="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@retrieve-position-within-table">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'retrieve-position-within-table' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting', 'first-including-carryover', 'last-starting', 'last-ending'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'first-starting', 'first-including-carryover', 'last-starting', or 'last-ending'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'retrieve-position-within-table="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@right">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'right' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'right="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@rule-style">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'rule-style' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'rule-style="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@rule-thickness">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'ERROR', 'Object')">'rule-thickness' should be Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'rule-thickness="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@scale-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'scale-option' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('width', 'height', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'width', 'height', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'scale-option="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@scaling">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'scaling' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'scaling="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@scaling-method">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'scaling-method' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'integer-pixels', 'resample-any-method', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'integer-pixels', 'resample-any-method', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'scaling-method="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@score-spaces">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'score-spaces' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'score-spaces="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@script">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')">'script' should be EnumerationToken, Literal.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'auto', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'script="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@show-destination">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'show-destination' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('replace', 'new'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'replace' or 'new'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'show-destination="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@source-document">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')">'source-document' should be URI, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'source-document="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@space-after">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">'space-after' should be Length, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'space-after="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@space-before">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">'space-before' should be Length, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'space-before="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@space-end">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'space-end' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'space-end="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@space-start">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'space-start' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'space-start="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@span">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'span' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'all', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'all', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'span="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@start-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'start-indent' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'start-indent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@starting-state">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'starting-state' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'show' or 'hide'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'starting-state="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@starts-row">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'starts-row' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'starts-row="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@suppress-at-line-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'suppress-at-line-break' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'suppress', 'retain', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'suppress', 'retain', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'suppress-at-line-break="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@switch-to">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'switch-to' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'switch-to="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@table-layout">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'table-layout' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'fixed', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'fixed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'table-layout="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@table-omit-footer-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'table-omit-footer-at-break' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'table-omit-footer-at-break="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@table-omit-header-at-break">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'table-omit-header-at-break' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'true' or 'false'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'table-omit-header-at-break="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@target-presentation-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">'target-presentation-context' should be EnumerationToken, URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-target-processing-context'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'use-target-processing-context'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'target-presentation-context="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@target-processing-context">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">'target-processing-context' should be EnumerationToken, URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('document-root'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'document-root'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'target-processing-context="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@target-stylesheet">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">'target-stylesheet' should be EnumerationToken, URI.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-normal-stylesheet'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'use-normal-stylesheet'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'target-stylesheet="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-align-last">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'text-align-last' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-align-last="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-altitude">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'text-altitude' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-altitude="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-decoration">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'text-decoration' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-decoration="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-depth">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">'text-depth' should be EnumerationToken, Length, Percent.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'use-font-metrics' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-depth="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-indent">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'text-indent' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-indent="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-shadow">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Color', 'Length', 'ERROR', 'Object')">'text-shadow' should be EnumerationToken, Color, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-shadow="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@text-transform">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'text-transform' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('capitalize', 'uppercase', 'lowercase', 'none', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'capitalize', 'uppercase', 'lowercase', 'none', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'text-transform="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@top">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'top' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'top="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@treat-as-word-space">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'treat-as-word-space' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'true', 'false', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto', 'true', 'false', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'treat-as-word-space="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@unicode-bidi">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'unicode-bidi' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'embed', 'bidi-override', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal', 'embed', 'bidi-override', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'unicode-bidi="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@visibility">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'visibility' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'collapse', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'visible', 'hidden', 'collapse', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'visibility="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@white-space-collapse">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'white-space-collapse' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'false', 'true', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'white-space-collapse="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@white-space-treatment">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'white-space-treatment' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'white-space-treatment="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@widows">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">'widows' should be Number, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'widows="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@width">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">'width' should be Length, Percent, EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'width="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@word-spacing">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">'word-spacing' should be EnumerationToken, Length.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'normal' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'word-spacing="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@wrap-option">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'wrap-option' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-wrap', 'wrap', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'no-wrap', 'wrap', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'wrap-option="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@writing-mode">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">'writing-mode' should be EnumerationToken.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'writing-mode="<value-of select="."/>"'</report>
   </rule>

   
   
   
   
   <rule context="fo:*/@z-index">
      <let name="expression" value="ahf:parser-runner(.)"/>
      <assert test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">'z-index' should be EnumerationToken, Number.  '<value-of select="."/>' is a <value-of select="local-name($expression)"/>.</assert>
      <report test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">Enumeration token is: '<value-of select="$expression/@token"/>'.  Token should be 'auto' or 'inherit'.</report>
      <report test="local-name($expression) = 'ERROR'">Syntax error: 'z-index="<value-of select="."/>"'</report>
   </rule>
</pattern>
    <ns uri="http://www.w3.org/1999/XSL/Format" prefix="fo"/>
    <ns uri="http://www.antennahouse.com/names/XSLT/Functions/Document" prefix="ahf"/>
    
    <phase id="fo">
        <active pattern="fo-fo"/></phase>
    <phase id="property">
        <active pattern="fo-property"/>
    </phase>
    <pattern id="axf">
        <p>http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#axf.document-info</p>
        <rule context="ahf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]" id="axf-1" role="axf-1">
            <assert test="empty(../ahf:document-info[@name eq 'xmp'])" role="axf-2">"<value-of select="@name"/>" axf:document-info cannot be used when "xmp" axf:document-info is present.</assert>
        </rule>
    </pattern>
</schema>