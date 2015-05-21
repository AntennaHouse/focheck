<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">fo-fo</xsl:attribute>
            <xsl:attribute name="name">fo-fo</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M0"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">fo-property</xsl:attribute>
            <xsl:attribute name="name">fo-property</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M1"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/XSL/Format" prefix="fo"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.antennahouse.com/names/XSLT/Functions/Document"
                                             prefix="ahf"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.antennahouse.com/names/XSL/Extensions" prefix="axf"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">axf</xsl:attribute>
            <xsl:attribute name="name">axf</xsl:attribute>
            <svrl:text>http://www.antennahouse.com/product/ahf60/docs/ahf-ext.html#axf.document-info</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN fo-fo-->


	  <!--RULE -->
   <xsl:template match="fo:float | fo:footnote" priority="1003" mode="M0">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:float | fo:footnote"/>

		    <!--REPORT -->
      <xsl:if test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(for $ancestor in ancestor::fo:* return local-name($ancestor)) = ('float', 'footnote')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>An '<xsl:text/>
               <xsl:value-of select="local-name()"/>
               <xsl:text/>' is not allowed as a descendant of 'fo:float' or 'fo:footnote'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:retrieve-table-marker" priority="1002" mode="M0">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:retrieve-table-marker"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ancestor::fo:table-header) or                   exists(ancestor::fo:table-footer) or                   (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(ancestor::fo:table-header) or exists(ancestor::fo:table-footer) or (exists(parent::fo:table) and empty(preceding-sibling::fo:table-body) and empty(following-sibling::fo:table-column))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An fo:retrieve-table-marker is only permitted as the descendant of an fo:table-header or fo:table-footer or as a child of fo:table in a position where fo:table-header or fo:table-footer is permitted.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-count | fo:*/@number-columns-spanned"
                 priority="1001"
                 mode="M0">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@column-count | fo:*/@number-columns-spanned"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--REPORT column-count-->
      <xsl:if test="local-name($expression) = 'Number' and                   (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or                    $expression/@is-zero = 'yes' or                    exists($expression/@value) and not($expression/@value castable as xs:integer))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'Number' and (exists($expression/@is-positive) and $expression/@is-positive eq 'no' or $expression/@is-zero = 'yes' or exists($expression/@value) and not($expression/@value castable as xs:integer))">
            <xsl:attribute name="role">column-count</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Warning: @<xsl:text/>
               <xsl:value-of select="local-name()"/>
               <xsl:text/> should be a positive integer.  The FO formatter will round a non-positive or non-integer value to the nearest integer value greater than or equal to 1.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-width" priority="1000" mode="M0">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@column-width"/>
      <xsl:variable name="number-columns-spanned"
                    select="ahf:parser-runner(../@number-columns-spanned)"/>

		    <!--REPORT column-width-->
      <xsl:if test="exists(../@number-columns-spanned) and     local-name($number-columns-spanned) = 'Number' and                   (exists($number-columns-spanned/@value) and      number($number-columns-spanned/@value) &gt;= 1.5)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="exists(../@number-columns-spanned) and local-name($number-columns-spanned) = 'Number' and (exists($number-columns-spanned/@value) and number($number-columns-spanned/@value) &gt;= 1.5)">
            <xsl:attribute name="role">column-width</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Warning: @<xsl:text/>
               <xsl:value-of select="local-name()"/>
               <xsl:text/> is ignored with @number-columns-spanned is present and has a value greater than 1.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M0"/>
   <xsl:template match="@*|node()" priority="-2" mode="M0">
      <xsl:apply-templates select="@*|*" mode="M0"/>
   </xsl:template>

   <!--PATTERN fo-property-->
   <xsl:include xmlns="http://purl.oclc.org/dsdl/schematron"
                href="file:/C:/projects/oxygen/focheck/xsl/parser-runner.xsl"/>

	  <!--RULE -->
   <xsl:template match="fo:*/@absolute-position" priority="1211" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@absolute-position"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'absolute-position' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'absolute', 'fixed', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'absolute', 'fixed', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'absolute-position' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'absolute', 'fixed', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'absolute-position="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@active-state" priority="1210" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@active-state"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'active-state' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'visited', 'active', 'hover', 'focus'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'visited', 'active', 'hover', 'focus'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'active-state' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'link', 'visited', 'active', 'hover', or 'focus'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'active-state="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@alignment-adjust" priority="1209" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@alignment-adjust"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'alignment-adjust' should be EnumerationToken, Percent, or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'alignment-adjust' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'alignment-adjust="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@alignment-baseline" priority="1208" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@alignment-baseline"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'alignment-baseline' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'alignment-baseline' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'baseline', 'before-edge', 'text-before-edge', 'middle', 'central', 'after-edge', 'text-after-edge', 'ideographic', 'alphabetic', 'hanging', 'mathematical', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'alignment-baseline="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@allowed-height-scale" priority="1207" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@allowed-height-scale"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'allowed-height-scale' should be EnumerationToken or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'allowed-height-scale' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'any' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'allowed-height-scale="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@allowed-width-scale" priority="1206" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@allowed-width-scale"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'allowed-width-scale' should be EnumerationToken or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('any', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'allowed-width-scale' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'any' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'allowed-width-scale="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@auto-restore" priority="1205" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@auto-restore"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'auto-restore' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'auto-restore' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'auto-restore="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-attachment" priority="1204" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-attachment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-attachment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('scroll', 'fixed', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('scroll', 'fixed', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'background-attachment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'scroll', 'fixed', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-attachment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-color" priority="1203" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-image" priority="1202" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-image"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-image' should be URI or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'background-image' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-image="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-position-horizontal"
                 priority="1201"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-position-horizontal"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-position-horizontal' should be Percent, Length, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('left', 'center', 'right', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'background-position-horizontal' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'left', 'center', 'right', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-position-horizontal="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-position-vertical"
                 priority="1200"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-position-vertical"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Percent', 'Length', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-position-vertical' should be Percent, Length, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('top', 'center', 'bottom', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'background-position-vertical' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'top', 'center', 'bottom', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-position-vertical="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@background-repeat" priority="1199" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@background-repeat"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'background-repeat' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('repeat', 'repeat-x', 'repeat-y', 'no-repeat', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'background-repeat' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'repeat', 'repeat-x', 'repeat-y', 'no-repeat', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'background-repeat="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@baseline-shift" priority="1198" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@baseline-shift"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Percent', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'baseline-shift' should be EnumerationToken, Percent, or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('baseline', 'sub', 'super', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('baseline', 'sub', 'super', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'baseline-shift' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'baseline', 'sub', 'super', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'baseline-shift="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@blank-or-not-blank" priority="1197" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@blank-or-not-blank"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'blank-or-not-blank' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('blank', 'not-blank', 'any', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('blank', 'not-blank', 'any', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'blank-or-not-blank' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'blank', 'not-blank', 'any', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'blank-or-not-blank="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@block-progression-dimension" priority="1196" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@block-progression-dimension"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'block-progression-dimension' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'block-progression-dimension' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'block-progression-dimension="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-after-color" priority="1195" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-after-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-after-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-after-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-after-precedence" priority="1194" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-after-precedence"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-after-precedence' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-after-precedence' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'force' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-after-precedence="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-after-style" priority="1193" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-after-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-after-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-after-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-after-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-after-width" priority="1192" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-after-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-after-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-after-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-after-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-before-color" priority="1191" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-before-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-before-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-before-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-before-precedence" priority="1190" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-before-precedence"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-before-precedence' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-before-precedence' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'force' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-before-precedence="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-before-style" priority="1189" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-before-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-before-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-before-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-before-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-before-width" priority="1188" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-before-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-before-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-before-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-before-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-bottom-color" priority="1187" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-bottom-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-bottom-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-bottom-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-bottom-style" priority="1186" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-bottom-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-bottom-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-bottom-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-bottom-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-bottom-width" priority="1185" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-bottom-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-bottom-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-bottom-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-bottom-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-collapse" priority="1184" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@border-collapse"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-collapse' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('collapse', 'collapse-with-precedence', 'separate', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('collapse', 'collapse-with-precedence', 'separate', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-collapse' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'collapse', 'collapse-with-precedence', 'separate', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-collapse="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-end-color" priority="1183" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-end-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-end-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-end-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-end-precedence" priority="1182" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-end-precedence"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-end-precedence' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-end-precedence' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'force' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-end-precedence="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-end-style" priority="1181" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-end-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-end-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-end-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-end-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-end-width" priority="1180" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-end-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-end-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-end-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-end-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-left-color" priority="1179" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-left-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-left-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-left-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-left-style" priority="1178" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-left-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-left-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-left-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-left-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-left-width" priority="1177" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-left-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-left-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-left-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-left-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-right-color" priority="1176" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-right-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-right-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-right-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-right-style" priority="1175" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-right-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-right-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-right-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-right-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-right-width" priority="1174" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-right-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-right-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-right-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-right-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-separation" priority="1173" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-separation"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-separation' should be Length or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-separation' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-separation="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-start-color" priority="1172" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-start-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-start-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-start-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-start-precedence" priority="1171" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-start-precedence"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-start-precedence' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('force', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-start-precedence' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'force' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-start-precedence="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-start-style" priority="1170" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-start-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-start-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-start-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-start-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-start-width" priority="1169" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-start-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-start-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-start-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-start-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-top-color" priority="1168" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-top-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-top-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-top-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-top-style" priority="1167" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-top-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-top-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-top-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-top-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@border-top-width" priority="1166" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@border-top-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'border-top-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'border-top-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', 'thick', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'border-top-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@bottom" priority="1165" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@bottom"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'bottom' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'bottom' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'bottom="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@break-after" priority="1164" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@break-after"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'break-after' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'break-after' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'break-after="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@break-before" priority="1163" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@break-before"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'break-before' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'even-page', 'odd-page', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'break-before' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'column', 'page', 'even-page', 'odd-page', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'break-before="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@caption-side" priority="1162" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@caption-side"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'caption-side' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'caption-side' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'before', 'after', 'start', 'end', 'top', 'bottom', 'left', 'right', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'caption-side="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@case-name" priority="1161" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@case-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'case-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'case-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@case-title" priority="1160" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@case-title"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'case-title' should be Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'case-title="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-class" priority="1159" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-class"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-class' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-class="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-color" priority="1158" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-offset" priority="1157" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-offset"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-offset' should be Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-offset="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-placement" priority="1156" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-placement"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-placement' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'alternate'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'alternate'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'change-bar-placement' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', or 'alternate'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-placement="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-style" priority="1155" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', 'outset'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'change-bar-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'hidden', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inset', or 'outset'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@change-bar-width" priority="1154" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@change-bar-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'change-bar-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('thin', 'medium', 'thick'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'change-bar-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'thin', 'medium', or 'thick'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'change-bar-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@character" priority="1153" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@character"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'character' should be Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'character="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@clear" priority="1152" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@clear"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'clear' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'clear' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'start', 'end', 'left', 'right', 'inside', 'outside', 'both', 'none', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'clear="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@clip" priority="1151" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@clip"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Function', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Function', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'clip' should be Function or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'clip' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'clip="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@color" priority="1150" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'color' should be Color or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@color-profile-name" priority="1149" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@color-profile-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'color-profile-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'color-profile-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-count" priority="1148" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@column-count"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'column-count' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'column-count' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'column-count="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-gap" priority="1147" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@column-gap"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'column-gap' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'column-gap' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'column-gap="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-number" priority="1146" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@column-number"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'column-number' should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'column-number="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@column-width" priority="1145" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@column-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'column-width' should be Length or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'column-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@content-height" priority="1144" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@content-height"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'content-height' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'content-height' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'content-height="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@content-type" priority="1143" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@content-type"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'content-type' should be Literal or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'content-type' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'content-type="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@content-width" priority="1142" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@content-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'content-width' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'content-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'scale-to-fit', 'scale-down-to-fit', 'scale-up-to-fit', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'content-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@country" priority="1141" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@country"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'country' should be EnumerationToken or Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'country' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'country="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@destination-placement-offset"
                 priority="1140"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@destination-placement-offset"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'destination-placement-offset' should be Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'destination-placement-offset="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@direction" priority="1139" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@direction"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'direction' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ltr', 'rtl', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ltr', 'rtl', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'direction' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'ltr', 'rtl', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'direction="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@display-align" priority="1138" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@display-align"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'display-align' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'before', 'center', 'after', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'before', 'center', 'after', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'display-align' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'before', 'center', 'after', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'display-align="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@dominant-baseline" priority="1137" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@dominant-baseline"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'dominant-baseline' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'dominant-baseline' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'use-script', 'no-change', 'reset-size', 'ideographic', 'alphabetic', 'hanging', 'mathematical', 'central', 'middle', 'text-after-edge', 'text-before-edge', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'dominant-baseline="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@empty-cells" priority="1136" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@empty-cells"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'empty-cells' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'empty-cells' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'show', 'hide', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'empty-cells="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@end-indent" priority="1135" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@end-indent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'end-indent' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'end-indent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'end-indent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@ends-row" priority="1134" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@ends-row"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'ends-row' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'ends-row' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'ends-row="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@extent" priority="1133" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@extent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'extent' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'extent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'extent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@float" priority="1132" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@float"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'float' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'float' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'before', 'start', 'end', 'left', 'right', 'inside', 'outside', 'none', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'float="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@flow-map-name" priority="1131" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@flow-map-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'flow-map-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'flow-map-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@flow-map-reference" priority="1130" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@flow-map-reference"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'flow-map-reference' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'flow-map-reference="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@flow-name" priority="1129" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@flow-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'flow-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'flow-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@flow-name-reference" priority="1128" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@flow-name-reference"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'flow-name-reference' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'flow-name-reference="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-selection-strategy" priority="1127" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@font-selection-strategy"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-selection-strategy' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'character-by-character', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'character-by-character', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-selection-strategy' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'character-by-character', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-selection-strategy="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-size" priority="1126" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@font-size"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-size' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-size' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', 'larger', 'smaller', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-size="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-size-adjust" priority="1125" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@font-size-adjust"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-size-adjust' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-size-adjust' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-size-adjust="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-stretch" priority="1124" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@font-stretch"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-stretch' should be EnumerationToken or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-stretch' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal', 'wider', 'narrower', 'ultra-condensed', 'extra-condensed', 'condensed', 'semi-condensed', 'semi-expanded', 'expanded', 'extra-expanded', 'ultra-expanded', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-stretch="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-style" priority="1123" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@font-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'italic', 'oblique', 'backslant', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'italic', 'oblique', 'backslant', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal', 'italic', 'oblique', 'backslant', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-variant" priority="1122" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@font-variant"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-variant' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'small-caps', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'small-caps', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-variant' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal', 'small-caps', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-variant="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@font-weight" priority="1121" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@font-weight"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'font-weight' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'bold', 'bolder', 'lighter', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'bold', 'bolder', 'lighter', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'font-weight' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal', 'bold', 'bolder', 'lighter', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'font-weight="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@glyph-orientation-horizontal"
                 priority="1120"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@glyph-orientation-horizontal"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'glyph-orientation-horizontal' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'glyph-orientation-horizontal' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'glyph-orientation-horizontal="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@glyph-orientation-vertical" priority="1119" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@glyph-orientation-vertical"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'glyph-orientation-vertical' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'glyph-orientation-vertical' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'glyph-orientation-vertical="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@grouping-separator" priority="1118" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@grouping-separator"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'grouping-separator' should be Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'grouping-separator="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@grouping-size" priority="1117" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@grouping-size"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'grouping-size' should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'grouping-size="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@height" priority="1116" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@height"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'height' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'height' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'height="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenate" priority="1115" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@hyphenate"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenate' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenate' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'false', 'true', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenate="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenation-character" priority="1114" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@hyphenation-character"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenation-character' should be Literal or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenation-character' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenation-character="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenation-keep" priority="1113" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@hyphenation-keep"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenation-keep' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'column', 'page', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenation-keep' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'column', 'page', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenation-keep="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenation-ladder-count" priority="1112" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@hyphenation-ladder-count"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenation-ladder-count' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenation-ladder-count' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'no-limit' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenation-ladder-count="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenation-push-character-count"
                 priority="1111"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@hyphenation-push-character-count"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenation-push-character-count' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenation-push-character-count' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenation-push-character-count="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@hyphenation-remain-character-count"
                 priority="1110"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@hyphenation-remain-character-count"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'hyphenation-remain-character-count' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'hyphenation-remain-character-count' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'hyphenation-remain-character-count="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@index-class" priority="1109" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@index-class"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'index-class' should be Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'index-class="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@indicate-destination" priority="1108" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@indicate-destination"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'indicate-destination' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'indicate-destination' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'indicate-destination="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@initial-page-number" priority="1107" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@initial-page-number"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'initial-page-number' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'auto-odd', 'auto-even', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'auto-odd', 'auto-even', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'initial-page-number' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'auto-odd', 'auto-even', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'initial-page-number="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@inline-progression-dimension"
                 priority="1106"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@inline-progression-dimension"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'inline-progression-dimension' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'inline-progression-dimension' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'inline-progression-dimension="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@intrinsic-scale-value" priority="1105" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@intrinsic-scale-value"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'intrinsic-scale-value' should be Percent or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'intrinsic-scale-value' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'intrinsic-scale-value="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@intrusion-displace" priority="1104" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@intrusion-displace"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'intrusion-displace' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'none', 'line', 'indent', 'block', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'none', 'line', 'indent', 'block', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'intrusion-displace' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'none', 'line', 'indent', 'block', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'intrusion-displace="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@keep-together" priority="1103" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@keep-together"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'keep-together' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'keep-together' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'always', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'keep-together="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@keep-with-next" priority="1102" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@keep-with-next"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'keep-with-next' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'keep-with-next' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'always', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'keep-with-next="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@keep-with-previous" priority="1101" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@keep-with-previous"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'keep-with-previous' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'always', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'keep-with-previous' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'always', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'keep-with-previous="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@last-line-end-indent" priority="1100" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@last-line-end-indent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'last-line-end-indent' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'last-line-end-indent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'last-line-end-indent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@leader-alignment" priority="1099" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@leader-alignment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'leader-alignment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'reference-area', 'page', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'reference-area', 'page', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'leader-alignment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'reference-area', 'page', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'leader-alignment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@leader-length" priority="1098" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@leader-length"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'leader-length' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'leader-length' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'leader-length="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@leader-pattern" priority="1097" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@leader-pattern"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'leader-pattern' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('space', 'rule', 'dots', 'use-content', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('space', 'rule', 'dots', 'use-content', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'leader-pattern' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'space', 'rule', 'dots', 'use-content', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'leader-pattern="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@leader-pattern-width" priority="1096" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@leader-pattern-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'leader-pattern-width' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'leader-pattern-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'use-font-metrics' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'leader-pattern-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@left" priority="1095" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@left"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'left' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'left' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'left="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@letter-spacing" priority="1094" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@letter-spacing"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'letter-spacing' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'letter-spacing' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'letter-spacing="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@letter-value" priority="1093" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@letter-value"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'letter-value' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'alphabetic', 'traditional'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'alphabetic', 'traditional'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'letter-value' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'alphabetic', or 'traditional'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'letter-value="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@line-height" priority="1092" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@line-height"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Number', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'line-height' should be EnumerationToken, Length, Number, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'line-height' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'line-height="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@line-height-shift-adjustment"
                 priority="1091"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@line-height-shift-adjustment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'line-height-shift-adjustment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('consider-shifts', 'disregard-shifts', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('consider-shifts', 'disregard-shifts', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'line-height-shift-adjustment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'consider-shifts', 'disregard-shifts', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'line-height-shift-adjustment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@line-stacking-strategy" priority="1090" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@line-stacking-strategy"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'line-stacking-strategy' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('line-height', 'font-height', 'max-height', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('line-height', 'font-height', 'max-height', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'line-stacking-strategy' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'line-height', 'font-height', 'max-height', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'line-stacking-strategy="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@linefeed-treatment" priority="1089" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@linefeed-treatment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'linefeed-treatment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'linefeed-treatment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'ignore', 'preserve', 'treat-as-space', 'treat-as-zero-width-space', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'linefeed-treatment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@margin-bottom" priority="1088" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@margin-bottom"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'margin-bottom' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'margin-bottom' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'margin-bottom="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@margin-left" priority="1087" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@margin-left"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'margin-left' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'margin-left' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'margin-left="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@margin-right" priority="1086" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@margin-right"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'margin-right' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'margin-right' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'margin-right="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@margin-top" priority="1085" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@margin-top"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'margin-top' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'margin-top' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'margin-top="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@marker-class-name" priority="1084" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@marker-class-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'marker-class-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'marker-class-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@master-name" priority="1083" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@master-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'master-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'master-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@master-reference" priority="1082" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@master-reference"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'master-reference' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'master-reference="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@maximum-repeats" priority="1081" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@maximum-repeats"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'maximum-repeats' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-limit', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'maximum-repeats' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'no-limit' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'maximum-repeats="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@media-usage" priority="1080" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@media-usage"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'media-usage' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'paginate', 'bounded-in-one-dimension', 'unbounded'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'paginate', 'bounded-in-one-dimension', 'unbounded'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'media-usage' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'paginate', 'bounded-in-one-dimension', or 'unbounded'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'media-usage="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@merge-pages-across-index-key-references"
                 priority="1079"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@merge-pages-across-index-key-references"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'merge-pages-across-index-key-references' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'merge-pages-across-index-key-references' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'merge' or 'leave-separate'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'merge-pages-across-index-key-references="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@merge-ranges-across-index-key-references"
                 priority="1078"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@merge-ranges-across-index-key-references"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'merge-ranges-across-index-key-references' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'merge-ranges-across-index-key-references' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'merge' or 'leave-separate'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'merge-ranges-across-index-key-references="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@merge-sequential-page-numbers"
                 priority="1077"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@merge-sequential-page-numbers"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'merge-sequential-page-numbers' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('merge', 'leave-separate'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'merge-sequential-page-numbers' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'merge' or 'leave-separate'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'merge-sequential-page-numbers="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@number-columns-repeated" priority="1076" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@number-columns-repeated"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'number-columns-repeated' should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'number-columns-repeated="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@number-columns-spanned" priority="1075" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@number-columns-spanned"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'number-columns-spanned' should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'number-columns-spanned="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@number-rows-spanned" priority="1074" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@number-rows-spanned"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'number-rows-spanned' should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'number-rows-spanned="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@odd-or-even" priority="1073" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@odd-or-even"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'odd-or-even' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('odd', 'even', 'any', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('odd', 'even', 'any', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'odd-or-even' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'odd', 'even', 'any', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'odd-or-even="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@orphans" priority="1072" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@orphans"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'orphans' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'orphans' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'orphans="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@overflow" priority="1071" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@overflow"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'overflow' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', 'auto'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', 'auto'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'overflow' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'visible', 'hidden', 'scroll', 'error-if-overflow', 'repeat', 'replace', 'condense', or 'auto'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'overflow="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-after" priority="1070" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-after"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-after' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-after' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-after="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-before" priority="1069" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-before"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-before' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-before' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-before="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-bottom" priority="1068" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-bottom"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-bottom' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-bottom' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-bottom="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-end" priority="1067" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-end"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-end' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-end' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-end="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-left" priority="1066" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-left"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-left' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-left' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-left="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-right" priority="1065" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-right"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-right' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-right' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-right="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-start" priority="1064" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-start"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-start' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-start' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-start="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@padding-top" priority="1063" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@padding-top"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'padding-top' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'padding-top' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'padding-top="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@page-citation-strategy" priority="1062" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@page-citation-strategy"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'page-citation-strategy' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('all', 'normal', 'non-blank', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('all', 'normal', 'non-blank', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'page-citation-strategy' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'all', 'normal', 'non-blank', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'page-citation-strategy="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@page-height" priority="1061" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@page-height"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'page-height' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'page-height' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'page-height="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@page-number-treatment" priority="1060" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@page-number-treatment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'page-number-treatment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'no-link'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('link', 'no-link'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'page-number-treatment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'link' or 'no-link'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'page-number-treatment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@page-position" priority="1059" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@page-position"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'page-position' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('only', 'first', 'last', 'rest', 'any', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('only', 'first', 'last', 'rest', 'any', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'page-position' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'only', 'first', 'last', 'rest', 'any', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'page-position="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@page-width" priority="1058" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@page-width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'page-width' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'indefinite', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'page-width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'indefinite', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'page-width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@precedence" priority="1057" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@precedence"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'precedence' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'precedence' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true', 'false', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'precedence="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@provisional-distance-between-starts"
                 priority="1056"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@provisional-distance-between-starts"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'provisional-distance-between-starts' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'provisional-distance-between-starts' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'provisional-distance-between-starts="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@provisional-label-separation"
                 priority="1055"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@provisional-label-separation"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'provisional-label-separation' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'provisional-label-separation' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'provisional-label-separation="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@region-name" priority="1054" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@region-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'region-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'region-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@region-name-reference" priority="1053" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@region-name-reference"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'region-name-reference' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'region-name-reference="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@relative-align" priority="1052" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@relative-align"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'relative-align' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'baseline', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('before', 'baseline', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'relative-align' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'before', 'baseline', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'relative-align="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@relative-position" priority="1051" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@relative-position"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'relative-position' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('static', 'relative', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('static', 'relative', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'relative-position' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'static', 'relative', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'relative-position="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@rendering-intent" priority="1050" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@rendering-intent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'rendering-intent' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'rendering-intent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'perceptual', 'relative-colorimetric', 'saturation', 'absolute-colorimetric', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'rendering-intent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@retrieve-boundary" priority="1049" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@retrieve-boundary"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'retrieve-boundary' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('page', 'page-sequence', 'document'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('page', 'page-sequence', 'document'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'retrieve-boundary' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'page', 'page-sequence', or 'document'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'retrieve-boundary="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@retrieve-boundary-within-table"
                 priority="1048"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@retrieve-boundary-within-table"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'retrieve-boundary-within-table' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('table', 'table-fragment', 'page'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('table', 'table-fragment', 'page'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'retrieve-boundary-within-table' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'table', 'table-fragment', or 'page'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'retrieve-boundary-within-table="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@retrieve-class-name" priority="1047" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@retrieve-class-name"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'retrieve-class-name' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'retrieve-class-name="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@retrieve-position" priority="1046" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@retrieve-position"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'retrieve-position' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', 'last-ending-within-page'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', 'last-ending-within-page'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'retrieve-position' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'first-starting-within-page', 'first-including-carryover', 'last-starting-within-page', or 'last-ending-within-page'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'retrieve-position="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@retrieve-position-within-table"
                 priority="1045"
                 mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@retrieve-position-within-table"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'retrieve-position-within-table' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting', 'first-including-carryover', 'last-starting', 'last-ending'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('first-starting', 'first-including-carryover', 'last-starting', 'last-ending'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'retrieve-position-within-table' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'first-starting', 'first-including-carryover', 'last-starting', or 'last-ending'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'retrieve-position-within-table="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@right" priority="1044" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@right"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'right' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'right' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'right="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@rule-style" priority="1043" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@rule-style"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'rule-style' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'rule-style' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'dotted', 'dashed', 'solid', 'double', 'groove', 'ridge', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'rule-style="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@rule-thickness" priority="1042" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@rule-thickness"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'rule-thickness' should be Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'rule-thickness="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@scale-option" priority="1041" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@scale-option"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'scale-option' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('width', 'height', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('width', 'height', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'scale-option' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'width', 'height', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'scale-option="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@scaling" priority="1040" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@scaling"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'scaling' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('uniform', 'non-uniform', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'scaling' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'uniform', 'non-uniform', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'scaling="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@scaling-method" priority="1039" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@scaling-method"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'scaling-method' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'integer-pixels', 'resample-any-method', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'integer-pixels', 'resample-any-method', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'scaling-method' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'integer-pixels', 'resample-any-method', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'scaling-method="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@score-spaces" priority="1038" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@score-spaces"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'score-spaces' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'score-spaces' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true', 'false', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'score-spaces="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@script" priority="1037" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@script"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Literal', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'script' should be EnumerationToken or Literal.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'script' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'auto', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'script="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@show-destination" priority="1036" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@show-destination"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'show-destination' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('replace', 'new'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('replace', 'new'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'show-destination' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'replace' or 'new'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'show-destination="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@source-document" priority="1035" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@source-document"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('URI', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'source-document' should be URI or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'source-document' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'source-document="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@space-after" priority="1034" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@space-after"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'space-after' should be Length or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'space-after' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'space-after="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@space-before" priority="1033" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@space-before"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'space-before' should be Length or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'space-before' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'space-before="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@space-end" priority="1032" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@space-end"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'space-end' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'space-end' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'space-end="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@space-start" priority="1031" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@space-start"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'space-start' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'space-start' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'space-start="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@span" priority="1030" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@span"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'span' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'all', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'all', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'span' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'all', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'span="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@start-indent" priority="1029" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@start-indent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'start-indent' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'start-indent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'start-indent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@starting-state" priority="1028" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@starting-state"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'starting-state' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('show', 'hide'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'starting-state' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'show' or 'hide'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'starting-state="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@starts-row" priority="1027" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@starts-row"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'starts-row' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'starts-row' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'starts-row="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@suppress-at-line-break" priority="1026" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@suppress-at-line-break"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'suppress-at-line-break' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'suppress', 'retain', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'suppress', 'retain', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'suppress-at-line-break' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'suppress', 'retain', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'suppress-at-line-break="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@switch-to" priority="1025" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@switch-to"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'switch-to' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'switch-to="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@table-layout" priority="1024" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@table-layout"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'table-layout' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'fixed', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'fixed', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'table-layout' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'fixed', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'table-layout="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@table-omit-footer-at-break" priority="1023" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@table-omit-footer-at-break"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'table-omit-footer-at-break' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'table-omit-footer-at-break' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'table-omit-footer-at-break="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@table-omit-header-at-break" priority="1022" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@table-omit-header-at-break"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'table-omit-header-at-break' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('true', 'false'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'table-omit-header-at-break' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'true' or 'false'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'table-omit-header-at-break="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@target-presentation-context" priority="1021" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@target-presentation-context"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'target-presentation-context' should be EnumerationToken or URI.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-target-processing-context'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-target-processing-context'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'target-presentation-context' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'use-target-processing-context'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'target-presentation-context="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@target-processing-context" priority="1020" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@target-processing-context"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'target-processing-context' should be EnumerationToken or URI.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('document-root'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('document-root'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'target-processing-context' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'document-root'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'target-processing-context="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@target-stylesheet" priority="1019" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@target-stylesheet"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'URI', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'target-stylesheet' should be EnumerationToken or URI.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-normal-stylesheet'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-normal-stylesheet'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'target-stylesheet' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'use-normal-stylesheet'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'target-stylesheet="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-align-last" priority="1018" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-align-last"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-align-last' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-align-last' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'relative', 'start', 'center', 'end', 'justify', 'inside', 'outside', 'left', 'right', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-align-last="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-altitude" priority="1017" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-altitude"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-altitude' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-altitude' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'use-font-metrics' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-altitude="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-decoration" priority="1016" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-decoration"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-decoration' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-decoration' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'none', 'underline', 'no-underline]', 'overline', 'no-overline', 'line-through', 'no-line-through', 'blink', 'no-blink', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-decoration="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-depth" priority="1015" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-depth"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'Percent', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-depth' should be EnumerationToken, Length, or Percent.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('use-font-metrics', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-depth' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'use-font-metrics' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-depth="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-indent" priority="1014" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-indent"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-indent' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-indent' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-indent="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-shadow" priority="1013" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-shadow"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Color', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Color', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-shadow' should be EnumerationToken, Color, or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-shadow="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@text-transform" priority="1012" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@text-transform"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'text-transform' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('capitalize', 'uppercase', 'lowercase', 'none', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('capitalize', 'uppercase', 'lowercase', 'none', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'text-transform' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'capitalize', 'uppercase', 'lowercase', 'none', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'text-transform="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@top" priority="1011" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@top"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'top' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'top' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'top="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@treat-as-word-space" priority="1010" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@treat-as-word-space"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'treat-as-word-space' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'true', 'false', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'true', 'false', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'treat-as-word-space' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto', 'true', 'false', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'treat-as-word-space="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@unicode-bidi" priority="1009" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@unicode-bidi"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'unicode-bidi' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'embed', 'bidi-override', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'embed', 'bidi-override', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'unicode-bidi' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal', 'embed', 'bidi-override', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'unicode-bidi="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@visibility" priority="1008" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@visibility"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'visibility' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'collapse', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('visible', 'hidden', 'collapse', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'visibility' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'visible', 'hidden', 'collapse', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'visibility="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@white-space-collapse" priority="1007" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@white-space-collapse"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'white-space-collapse' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('false', 'true', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'white-space-collapse' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'false', 'true', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'white-space-collapse="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@white-space-treatment" priority="1006" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@white-space-treatment"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'white-space-treatment' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'white-space-treatment' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'ignore', 'preserve', 'ignore-if-before-linefeed', 'ignore-if-after-linefeed', 'ignore-if-surrounding-linefeed', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'white-space-treatment="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@widows" priority="1005" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@widows"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'widows' should be Number or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'widows' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'widows="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@width" priority="1004" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@width"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Length', 'Percent', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'width' should be Length, Percent, or EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'width' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'width="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@word-spacing" priority="1003" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@word-spacing"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Length', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'word-spacing' should be EnumerationToken or Length.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('normal', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'word-spacing' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'normal' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'word-spacing="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@wrap-option" priority="1002" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@wrap-option"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'wrap-option' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-wrap', 'wrap', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('no-wrap', 'wrap', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'wrap-option' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'no-wrap', 'wrap', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'wrap-option="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@writing-mode" priority="1001" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@writing-mode"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'writing-mode' should be EnumerationToken.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'writing-mode' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'lr-tb', 'rl-tb', 'tb-rl', 'tb-lr', 'bt-lr', 'bt-rl', 'lr-bt', 'rl-bt', 'lr-alternating-rl-bt', 'lr-alternating-rl-tb', 'lr-inverting-rl-bt', 'lr-inverting-rl-tb', 'tb-lr-in-lr-pairs', 'lr', 'rl', 'tb', or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'writing-mode="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@z-index" priority="1000" mode="M1">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="fo:*/@z-index"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('EnumerationToken', 'Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'z-index' should be EnumerationToken or Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="$expression instance of element(EnumerationToken) and not($expression/@token = ('auto', 'inherit'))">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>'z-index' enumeration token is '<xsl:text/>
               <xsl:value-of select="$expression/@token"/>
               <xsl:text/>'.  Token should be 'auto' or 'inherit'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'z-index="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M1"/>
   <xsl:template match="@*|node()" priority="-2" mode="M1">
      <xsl:apply-templates select="@*|*" mode="M1"/>
   </xsl:template>

   <!--PATTERN axf-->


	  <!--RULE axf-1-->
   <xsl:template match="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]"
                 priority="1002"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="axf:document-info[@name = ('author-title', 'description-writer', 'copyright-status', 'copyright-notice', 'copyright-info-url')]"
                       id="axf-1"
                       role="axf-1"/>

		    <!--ASSERT axf-2-->
      <xsl:choose>
         <xsl:when test="empty(../axf:document-info[@name eq 'xmp'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(../axf:document-info[@name eq 'xmp'])">
               <xsl:attribute name="role">axf-2</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"<xsl:text/>
                  <xsl:value-of select="@name"/>
                  <xsl:text/>" axf:document-info cannot be used when "xmp" axf:document-info is present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@axf:outline-color" priority="1001" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@axf:outline-color"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Color', 'EnumerationToken', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'axf:outline-color' should be Color or a color name.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'axf:outline-color="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="fo:*/@axf:outline-level" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="fo:*/@axf:outline-level"/>
      <xsl:variable name="expression" select="ahf:parser-runner(.)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="local-name($expression) = ('Number', 'ERROR', 'Object')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="local-name($expression) = ('Number', 'ERROR', 'Object')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'axf:outline-level should be Number.  '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is a <xsl:text/>
                  <xsl:value-of select="local-name($expression)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="local-name($expression) = 'ERROR'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="local-name($expression) = 'ERROR'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Syntax error: 'outline-level="<xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>"'</svrl:text>
         </svrl:successful-report>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>
</xsl:stylesheet>
