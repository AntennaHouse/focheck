<?xml version="1.0" encoding="UTF-8"?>
<!-- This file was generated on Mon Mar 6, 2023 15:44 (UTC) by REx v5.56 which is Copyright (c) 1979-2023 by Gunther Rademacher <grd@gmx.net> -->
<!-- REx command line: axf-expression.ebnf -xslt -tree -main -->

<xsl:stylesheet version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:p="axf-expression">
  <!--~
   ! The index of the lexer state for accessing the combined
   ! (i.e. level > 1) lookahead code.
  -->
  <xsl:variable name="p:lk" as="xs:integer" select="1"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the begin of the token that has been consumed.
  -->
  <xsl:variable name="p:b0" as="xs:integer" select="2"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the end of the token that has been consumed.
  -->
  <xsl:variable name="p:e0" as="xs:integer" select="3"/>

  <!--~
   ! The index of the lexer state for accessing the code of the
   ! level-1-lookahead token.
  -->
  <xsl:variable name="p:l1" as="xs:integer" select="4"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the begin of the level-1-lookahead token.
  -->
  <xsl:variable name="p:b1" as="xs:integer" select="5"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the end of the level-1-lookahead token.
  -->
  <xsl:variable name="p:e1" as="xs:integer" select="6"/>

  <!--~
   ! The index of the lexer state for accessing the code of the
   ! level-2-lookahead token.
  -->
  <xsl:variable name="p:l2" as="xs:integer" select="7"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the begin of the level-2-lookahead token.
  -->
  <xsl:variable name="p:b2" as="xs:integer" select="8"/>

  <!--~
   ! The index of the lexer state for accessing the position in the
   ! input string of the end of the level-2-lookahead token.
  -->
  <xsl:variable name="p:e2" as="xs:integer" select="9"/>

  <!--~
   ! The index of the lexer state for accessing the token code that
   ! was expected when an error was found.
  -->
  <xsl:variable name="p:error" as="xs:integer" select="10"/>

  <!--~
   ! The index of the lexer state that points to the first entry
   ! used for collecting action results.
  -->
  <xsl:variable name="p:result" as="xs:integer" select="11"/>

  <!--~
   ! The codepoint to charclass mapping for 7 bit codepoints.
  -->
  <xsl:variable name="p:MAP0" as="xs:integer+" select="
    47, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 2, 5, 2, 6, 7, 8, 9, 10, 11, 12, 13, 2, 14, 14,
    14, 14, 14, 14, 14, 14, 14, 14, 2, 2, 2, 2, 2, 2, 2, 15, 15, 16, 15, 15, 15, 17, 18, 18, 18, 19, 18, 20, 18, 18, 18, 18, 21, 22, 18, 18, 18, 18, 18, 23, 18,
    2, 2, 2, 2, 18, 2, 24, 15, 25, 26, 27, 15, 28, 29, 30, 31, 18, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 18, 2, 2, 2, 2, 2
  "/>

  <!--~
   ! The codepoint to charclass mapping for codepoints below the surrogate block.
  -->
  <xsl:variable name="p:MAP1" as="xs:integer+" select="
    108, 124, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 156, 181, 181, 181, 181, 181, 214, 215, 213, 214, 214, 214, 214, 214, 214,
    214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214,
    214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214,
    214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 214, 247, 261, 277, 337, 292, 363, 379, 395, 414, 414, 414, 406, 321, 313, 321, 313,
    321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 431, 431, 431, 431, 431, 431, 431, 306, 321, 321, 321, 321, 321, 321, 321,
    321, 347, 414, 414, 415, 413, 414, 414, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 414, 414, 414, 414, 414,
    414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 320, 321, 321, 321,
    321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 321, 414, 47, 0,
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 2, 5, 2, 6, 7, 8, 9, 10, 11, 12, 13, 2, 15, 15, 16, 15, 15,
    15, 17, 18, 18, 18, 19, 18, 20, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 2, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18,
    14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 18, 18, 2, 2, 18, 18, 21, 22, 18, 18, 18, 18, 18, 23, 18, 2, 2, 2, 2, 18, 2, 24,
    15, 25, 26, 27, 15, 28, 29, 30, 31, 18, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 18, 2, 2, 2, 2, 2, 2, 2, 46, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46
  "/>

  <!--~
   ! The codepoint to charclass mapping for codepoints above the surrogate block.
  -->
  <xsl:variable name="p:MAP2" as="xs:integer+" select="
    57344, 63744, 64976, 65008, 65536, 983040, 63743, 64975, 65007, 65533, 983039, 1114111, 2, 18, 2, 18, 18, 2
  "/>

  <!--~
   ! The token-set-id to DFA-initial-state mapping.
  -->
  <xsl:variable name="p:INITIAL" as="xs:integer+" select="
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
  "/>

  <!--~
   ! The DFA transition table.
  -->
  <xsl:variable name="p:TRANSITION" as="xs:integer+" select="
    814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 768, 772, 1310, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 814, 814, 1310, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 837, 814, 784, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814,
    814, 814, 814, 1082, 814, 1310, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 798, 799, 1310, 814, 814, 1314, 814, 814, 814, 814, 814,
    814, 814, 814, 814, 814, 848, 814, 949, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 807, 813, 1310, 814, 814, 1314, 814, 814, 814,
    814, 814, 814, 814, 814, 814, 814, 1387, 823, 1310, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1296, 834, 1310, 814, 814, 1314, 814,
    814, 814, 814, 814, 814, 814, 814, 814, 814, 1316, 845, 1310, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 880, 856, 1310, 814, 814,
    1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1093, 867, 928, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 859, 814, 935,
    814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1131, 1040, 942, 814, 814, 878, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1143,
    1040, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1236, 1040, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 776, 814, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 814, 1071, 814, 955, 814, 814, 814, 1104, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 965, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 814, 814, 814, 902, 814, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1160, 814, 955, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 814, 814, 814, 814, 1071, 814, 955, 814, 870, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1143, 1040, 955, 888, 1114, 814, 1414, 898, 1029,
    910, 814, 814, 814, 814, 814, 814, 1143, 921, 955, 998, 963, 1224, 814, 814, 1156, 814, 814, 814, 814, 814, 814, 814, 1205, 973, 955, 814, 814, 1410, 814,
    814, 814, 814, 814, 814, 814, 814, 814, 814, 790, 991, 1012, 814, 1026, 913, 814, 814, 814, 1261, 814, 814, 814, 814, 814, 814, 1071, 1037, 955, 814, 815,
    814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 1048, 1373, 814, 1056, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 1068, 1004,
    980, 814, 826, 1377, 1127, 814, 1249, 814, 814, 814, 814, 814, 814, 1071, 1079, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071,
    1090, 955, 814, 1101, 814, 814, 814, 814, 1112, 814, 814, 814, 814, 814, 814, 983, 1122, 955, 1139, 1151, 814, 1168, 1179, 814, 814, 814, 814, 814, 814,
    814, 814, 1071, 814, 955, 1171, 814, 814, 814, 1182, 1190, 814, 1201, 814, 814, 814, 814, 814, 1071, 814, 955, 1213, 1213, 814, 814, 814, 814, 1360, 1222,
    814, 814, 814, 814, 814, 1071, 1232, 955, 1019, 814, 1244, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 1257, 955, 814, 814, 814, 814, 814, 814,
    814, 814, 814, 814, 814, 814, 814, 1071, 1269, 955, 1328, 814, 814, 814, 814, 1277, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 814, 814, 814, 814,
    1338, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 814, 1285, 814, 1295, 814, 1060, 1304, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 814, 814,
    890, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 1324, 955, 814, 1336, 1346, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955,
    814, 1400, 814, 1358, 814, 814, 814, 814, 814, 814, 814, 814, 814, 1071, 814, 955, 1405, 1368, 814, 814, 1350, 1385, 814, 814, 814, 814, 814, 814, 814,
    1071, 814, 955, 814, 814, 814, 1287, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 955, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814,
    814, 1214, 1395, 1193, 814, 814, 1314, 814, 814, 814, 814, 814, 814, 814, 814, 814, 814, 524, 524, 524, 524, 524, 524, 524, 524, 0, 0, 0, 0, 16, 919, 919,
    0, 0, 0, 640, 20, 0, 8576, 0, 0, 13, 13, 782, 919, 919, 0, 1152, 0, 0, 1152, 0, 0, 0, 0, 0, 0, 1280, 0, 0, 0, 1280, 1280, 0, 0, 0, 0, 0, 0, 0, 0, 56, 1408,
    1408, 1408, 0, 0, 0, 0, 0, 0, 3328, 0, 1536, 1536, 1536, 0, 0, 0, 0, 0, 19, 19, 0, 1664, 1664, 1664, 0, 0, 0, 0, 0, 20, 20, 0, 1792, 1792, 1792, 0, 0, 0, 0,
    0, 21, 21, 0, 1920, 1920, 1920, 0, 0, 0, 0, 0, 54, 0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 0, 1792, 0, 45, 0, 0, 0, 0, 0, 0, 0, 3584, 65, 0, 0, 66, 0, 0, 0, 0, 17,
    919, 919, 0, 0, 0, 78, 0, 0, 0, 0, 0, 58, 0, 0, 0, 26, 26, 0, 0, 782, 782, 0, 0, 19, 20, 0, 8576, 919, 0, 0, 19, 20, 0, 8618, 919, 0, 0, 19, 20, 42, 22,
    919, 0, 0, 19, 640, 0, 8576, 0, 0, 19, 20, 0, 0, 919, 0, 0, 4736, 0, 0, 0, 0, 0, 0, 38, 0, 24, 27, 27, 0, 0, 782, 782, 0, 0, 43, 0, 0, 0, 0, 0, 919, 919,
    25, 0, 28, 37, 0, 0, 782, 782, 0, 0, 46, 0, 0, 3968, 0, 0, 19, 20, 0, 0, 919, 43, 40, 41, 19, 20, 0, 0, 919, 0, 0, 47, 0, 0, 0, 49, 0, 0, 51, 0, 0, 0, 0, 0,
    73, 74, 0, 0, 29, 29, 0, 0, 0, 0, 0, 782, 782, 0, 0, 2688, 0, 0, 0, 0, 0, 4352, 0, 4992, 0, 5888, 0, 0, 0, 0, 72, 0, 0, 0, 0, 30, 30, 0, 0, 0, 0, 0, 919,
    919, 0, 0, 31, 31, 0, 0, 0, 0, 0, 1024, 1024, 0, 0, 32, 32, 0, 0, 0, 0, 0, 1920, 1920, 1920, 0, 0, 52, 0, 0, 0, 0, 0, 2048, 0, 0, 0, 77, 0, 0, 0, 0, 0, 0,
    55, 0, 25, 33, 33, 0, 3456, 0, 0, 0, 67, 0, 0, 0, 0, 782, 22, 22, 0, 0, 2816, 0, 48, 0, 0, 0, 0, 782, 919, 919, 0, 4480, 0, 0, 53, 3504, 0, 0, 0, 71, 0, 0,
    0, 0, 18, 919, 919, 0, 0, 60, 5760, 0, 0, 0, 0, 0, 4096, 0, 0, 0, 2944, 3200, 0, 0, 0, 0, 0, 6272, 0, 0, 0, 0, 5248, 0, 0, 0, 0, 0, 8576, 0, 0, 2432, 0,
    2304, 0, 0, 0, 0, 0, 782, 919, 919, 24, 44, 0, 0, 0, 0, 0, 0, 0, 256, 0, 83, 0, 0, 0, 0, 0, 0, 59, 0, 0, 34, 34, 0, 0, 0, 0, 0, 783, 919, 919, 0, 57, 0, 0,
    0, 2560, 0, 0, 0, 79, 0, 0, 0, 82, 0, 5632, 5632, 0, 0, 0, 0, 0, 2176, 0, 0, 0, 0, 35, 35, 0, 0, 0, 0, 39, 70, 0, 0, 0, 0, 0, 0, 75, 0, 4864, 0, 0, 0, 0, 0,
    0, 63, 0, 4224, 0, 0, 0, 0, 0, 0, 0, 1536, 76, 0, 0, 0, 0, 80, 0, 0, 19, 20, 0, 8576, 0, 0, 0, 0, 0, 0, 0, 1664, 0, 36, 36, 0, 0, 0, 0, 0, 3840, 0, 0, 0, 0,
    50, 0, 0, 0, 0, 0, 0, 68, 69, 0, 0, 3072, 0, 0, 0, 0, 0, 6144, 0, 0, 0, 0, 5376, 0, 0, 0, 0, 0, 0, 81, 0, 0, 5504, 0, 0, 3712, 0, 0, 0, 6016, 0, 0, 0, 0,
    62, 0, 0, 64, 0, 5120, 0, 0, 0, 0, 0, 0, 1408, 1408, 256, 256, 256, 0, 0, 0, 0, 0, 6400, 0, 0, 0, 0, 3712, 0, 0, 0, 0, 4608, 0, 0, 0, 0, 61, 0, 0, 0
  "/>

  <!--~
   ! The DFA-state to expected-token-set mapping.
  -->
  <xsl:variable name="p:EXPECTED" as="xs:integer+" select="
    42, 46, 50, 54, 77, 63, 112, 67, 58, 74, 81, 88, 58, 95, 92, 105, 104, 98, 99, 100, 109, 58, 118, 116, 58, 58, 69, 58, 84, 122, 58, 70, 59, 126, 58, 132,
    57, 130, 58, 58, 58, 58, 264, 520, 67108872, 67109128, 491560, 17116, 18140, 8420362, 8420874, -67601398, -492278, 8, 67108864, 32, 32800, 65536, 0, 0, 0,
    0, 1, 4, 4, 64, 8388608, 536870912, -1073741824, 0, 0, 0, 8, 0, 469762048, 32768, 65536, 131072, 262144, 16, 16, 262144, 4, 8388608, 0, 1, 2, 12, 524288,
    4194304, 50331648, 134217728, 262144, 4194304, 16777216, 0, 32768, 65536, 131072, 262144, 65536, 131072, 262144, 131072, 262144, 0, 0, 65536, 131072,
    262144, 131072, 131072, 0, 3670016, 62914560, 402653184, 262143, 262143, 0, 0, 8, 8, 2032, 12288, 245760, 0, 960, 4096, 8192, 98304, 128, 256, 0, 0, 384,
    32768
  "/>

  <!--~
   ! The token-string table.
  -->
  <xsl:variable name="p:TOKEN" as="xs:string+" select="
    '(0)',
    'EOF',
    'Number',
    'S',
    'Literal',
    'AlphaOrDigits',
    'NCName',
    &quot;'#'&quot;,
    &quot;'%'&quot;,
    &quot;'('&quot;,
    &quot;')'&quot;,
    &quot;'*'&quot;,
    &quot;'+'&quot;,
    &quot;','&quot;,
    &quot;'-'&quot;,
    &quot;'CMYK'&quot;,
    &quot;'Grayscale'&quot;,
    &quot;'Registration'&quot;,
    &quot;'Separation'&quot;,
    &quot;'cap'&quot;,
    &quot;'ch'&quot;,
    &quot;'cm'&quot;,
    &quot;'dcem'&quot;,
    &quot;'div'&quot;,
    &quot;'dpcm'&quot;,
    &quot;'dpi'&quot;,
    &quot;'em'&quot;,
    &quot;'emu'&quot;,
    &quot;'ex'&quot;,
    &quot;'gr'&quot;,
    &quot;'ic'&quot;,
    &quot;'in'&quot;,
    &quot;'jpt'&quot;,
    &quot;'lh'&quot;,
    &quot;'mm'&quot;,
    &quot;'mod'&quot;,
    &quot;'pc'&quot;,
    &quot;'pt'&quot;,
    &quot;'pvh'&quot;,
    &quot;'pvmax'&quot;,
    &quot;'pvmin'&quot;,
    &quot;'pvw'&quot;,
    &quot;'px'&quot;,
    &quot;'q'&quot;,
    &quot;'rem'&quot;,
    &quot;'rlh'&quot;,
    &quot;'vh'&quot;,
    &quot;'vmax'&quot;,
    &quot;'vmin'&quot;,
    &quot;'vw'&quot;
  "/>

  <!--~
   ! Match next token in input string, starting at given index, using
   ! the DFA entry state for the set of tokens that are expected in
   ! the current context.
   !
   ! @param $input the input string.
   ! @param $begin the index where to start in input string.
   ! @param $token-set the expected token set id.
   ! @return a sequence of three: the token code of the result token,
   ! with input string begin and end positions. If there is no valid
   ! token, return the negative id of the DFA state that failed, along
   ! with begin and end positions of the longest viable prefix.
  -->
  <xsl:function name="p:match" as="xs:integer+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="begin" as="xs:integer"/>
    <xsl:param name="token-set" as="xs:integer"/>

    <xsl:variable name="result" select="$p:INITIAL[1 + $token-set]"/>
    <xsl:sequence select="p:transition($input, $begin, $begin, $begin, $result, $result mod 128, 0)"/>
  </xsl:function>

  <!--~
   ! The DFA state transition function. If we are in a valid DFA state, save
   ! it's result annotation, consume one input codepoint, calculate the next
   ! state, and use tail recursion to do the same again. Otherwise, return
   ! any valid result or a negative DFA state id in case of an error.
   !
   ! @param $input the input string.
   ! @param $begin the begin index of the current token in the input string.
   ! @param $current the index of the current position in the input string.
   ! @param $end the end index of the result in the input string.
   ! @param $result the result code.
   ! @param $current-state the current DFA state.
   ! @param $previous-state the  previous DFA state.
   ! @return a sequence of three: the token code of the result token,
   ! with input string begin and end positions. If there is no valid
   ! token, return the negative id of the DFA state that failed, along
   ! with begin and end positions of the longest viable prefix.
  -->
  <xsl:function name="p:transition">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="begin" as="xs:integer"/>
    <xsl:param name="current" as="xs:integer"/>
    <xsl:param name="end" as="xs:integer"/>
    <xsl:param name="result" as="xs:integer"/>
    <xsl:param name="current-state" as="xs:integer"/>
    <xsl:param name="previous-state" as="xs:integer"/>

    <xsl:choose>
      <xsl:when test="$current-state eq 0">
        <xsl:variable name="result" select="$result idiv 128"/>
        <xsl:variable name="end" select="$end - $result idiv 64"/>
        <xsl:variable name="end" select="if ($end gt string-length($input)) then string-length($input) + 1 else $end"/>
        <xsl:sequence select="
          if ($result ne 0) then
          (
            $result mod 64 - 1,
            $begin,
            $end
          )
          else
          (
            - $previous-state,
            $begin,
            $current - 1
          )
        "/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="c0" select="(string-to-codepoints(substring($input, $current, 1)), 0)[1]"/>
        <xsl:variable name="c1" as="xs:integer">
          <xsl:choose>
            <xsl:when test="$c0 &lt; 128">
              <xsl:sequence select="$p:MAP0[1 + $c0]"/>
            </xsl:when>
            <xsl:when test="$c0 &lt; 55296">
              <xsl:variable name="c1" select="$c0 idiv 16"/>
              <xsl:variable name="c2" select="$c1 idiv 32"/>
              <xsl:sequence select="$p:MAP1[1 + $c0 mod 16 + $p:MAP1[1 + $c1 mod 32 + $p:MAP1[1 + $c2]]]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="p:map2($c0, 1, 6)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="current" select="$current + 1"/>
        <xsl:variable name="i0" select="128 * $c1 + $current-state - 1"/>
        <xsl:variable name="i1" select="$i0 idiv 8"/>
        <xsl:variable name="next-state" select="$p:TRANSITION[$i0 mod 8 + $p:TRANSITION[$i1 + 1] + 1]"/>
        <xsl:sequence select="
          if ($next-state &gt; 127) then
            p:transition($input, $begin, $current, $current, $next-state, $next-state mod 128, $current-state)
          else
            p:transition($input, $begin, $current, $end, $result, $next-state, $current-state)
        "/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Recursively translate one 32-bit chunk of an expected token bitset
   ! to the corresponding sequence of token strings.
   !
   ! @param $result the result of previous recursion levels.
   ! @param $chunk the 32-bit chunk of the expected token bitset.
   ! @param $base-token-code the token code of bit 0 in the current chunk.
   ! @return the set of token strings.
  -->
  <xsl:function name="p:token">
    <xsl:param name="result" as="xs:string*"/>
    <xsl:param name="chunk" as="xs:integer"/>
    <xsl:param name="base-token-code" as="xs:integer"/>

    <xsl:sequence select="
      if ($chunk = 0) then
        $result
      else
        p:token
        (
          ($result, if ($chunk mod 2 != 0) then $p:TOKEN[$base-token-code] else ()),
          if ($chunk &lt; 0) then $chunk idiv 2 + 2147483648 else $chunk idiv 2,
          $base-token-code + 1
        )
    "/>
  </xsl:function>

  <!--~
   ! Calculate expected token set for a given DFA state as a sequence
   ! of strings.
   !
   ! @param $state the DFA state.
   ! @return the set of token strings
  -->
  <xsl:function name="p:expected-token-set" as="xs:string*">
    <xsl:param name="state" as="xs:integer"/>

    <xsl:if test="$state > 0">
      <xsl:for-each select="0 to 1">
        <xsl:variable name="i0" select=". * 83 + $state - 1"/>
        <xsl:variable name="i1" select="$i0 idiv 4"/>
        <xsl:sequence select="p:token((), $p:EXPECTED[$i0 mod 4 + $p:EXPECTED[$i1 + 1] + 1], . * 32 + 1)"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:function>

  <!--~
   ! Classify codepoint by doing a tail recursive binary search for a
   ! matching codepoint range entry in MAP2, the codepoint to charclass
   ! map for codepoints above the surrogate block.
   !
   ! @param $c the codepoint.
   ! @param $lo the binary search lower bound map index.
   ! @param $hi the binary search upper bound map index.
   ! @return the character class.
  -->
  <xsl:function name="p:map2" as="xs:integer">
    <xsl:param name="c" as="xs:integer"/>
    <xsl:param name="lo" as="xs:integer"/>
    <xsl:param name="hi" as="xs:integer"/>

    <xsl:variable name="m" select="($hi + $lo) idiv 2"/>
    <xsl:choose>
      <xsl:when test="$lo &gt; $hi">
        <xsl:sequence select="0"/>
      </xsl:when>
      <xsl:when test="$p:MAP2[$m] &gt; $c">
        <xsl:sequence select="p:map2($c, $lo, $m - 1)"/>
      </xsl:when>
      <xsl:when test="$p:MAP2[6 + $m] &lt; $c">
        <xsl:sequence select="p:map2($c, $m + 1, $hi)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$p:MAP2[12 + $m]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Parse FunctionName.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-FunctionName" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(6, $input, $state)"/>              <!-- NCName -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'FunctionName', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse the 1st loop of production FunctionCall (zero or more). Use
   ! tail recursion for iteratively updating the lexer state.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-FunctionCall-1">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:choose>
      <xsl:when test="$state[$p:error]">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$state[$p:l1] != 13">                                     <!-- ',' -->
            <xsl:sequence select="$state"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="state" select="p:consume(13, $input, $state)"/>     <!-- ',' -->
            <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>  <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
            <xsl:variable name="state" select="p:whitespace($input, $state)"/>
            <xsl:variable name="state" select="
              if ($state[$p:error]) then
                $state
              else
                p:parse-Expr($input, $state)
            "/>
            <xsl:sequence select="p:parse-FunctionCall-1($input, $state)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Parse FunctionCall.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-FunctionCall" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-FunctionName($input, $state)
    "/>
    <xsl:variable name="state" select="p:lookahead1W(1, $input, $state)"/>          <!-- S^WS | '(' -->
    <xsl:variable name="state" select="p:consume(9, $input, $state)"/>              <!-- '(' -->
    <xsl:variable name="state" select="p:lookahead1W(6, $input, $state)"/>          <!-- Number | S^WS | Literal | NCName | '#' | '(' | ')' | '-' -->
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] != 10">                                       <!-- ')' -->
          <xsl:variable name="state" select="p:whitespace($input, $state)"/>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-Expr($input, $state)
          "/>
          <xsl:variable name="state" select="p:parse-FunctionCall-1($input, $state)"/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="state" select="p:consume(10, $input, $state)"/>             <!-- ')' -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'FunctionCall', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse EnumerationToken.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-EnumerationToken" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(6, $input, $state)"/>              <!-- NCName -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'EnumerationToken', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse Color.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-Color" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(7, $input, $state)"/>              <!-- '#' -->
    <xsl:variable name="state" select="p:lookahead1W(4, $input, $state)"/>          <!-- S^WS | AlphaOrDigits | 'CMYK' | 'Grayscale' | 'Registration' |
                                                                                         'Separation' -->
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 15">                                        <!-- 'CMYK' -->
          <xsl:variable name="state" select="p:consume(15, $input, $state)"/>       <!-- 'CMYK' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 16">                                        <!-- 'Grayscale' -->
          <xsl:variable name="state" select="p:consume(16, $input, $state)"/>       <!-- 'Grayscale' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 17">                                        <!-- 'Registration' -->
          <xsl:variable name="state" select="p:consume(17, $input, $state)"/>       <!-- 'Registration' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 18">                                        <!-- 'Separation' -->
          <xsl:variable name="state" select="p:consume(18, $input, $state)"/>       <!-- 'Separation' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="p:consume(5, $input, $state)"/>        <!-- AlphaOrDigits -->
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'Color', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse RelativeUnitName.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-RelativeUnitName" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(26, $input, $state)"/>             <!-- 'em' -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'RelativeUnitName', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse RelativeLength.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-RelativeLength" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(2, $input, $state)"/>              <!-- Number -->
    <xsl:variable name="state" select="p:lookahead1W(2, $input, $state)"/>          <!-- S^WS | 'em' -->
    <xsl:variable name="state" select="p:whitespace($input, $state)"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-RelativeUnitName($input, $state)
    "/>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'RelativeLength', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse Percent.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-Percent" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(2, $input, $state)"/>              <!-- Number -->
    <xsl:variable name="state" select="p:lookahead1W(0, $input, $state)"/>          <!-- S^WS | '%' -->
    <xsl:variable name="state" select="p:consume(8, $input, $state)"/>              <!-- '%' -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'Percent', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse RelativeNumeric.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-RelativeNumeric" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:l1] eq 2">                                        <!-- Number -->
          <xsl:variable name="state" select="p:lookahead2W(3, $input, $state)"/>    <!-- S^WS | '%' | 'em' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$state[$p:l1], subsequence($state, $p:lk + 1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 514">                                       <!-- Number '%' -->
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-Percent($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-RelativeLength($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'RelativeNumeric', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse AbsoluteUnitName.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-AbsoluteUnitName" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 21">                                        <!-- 'cm' -->
          <xsl:variable name="state" select="p:consume(21, $input, $state)"/>       <!-- 'cm' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 34">                                        <!-- 'mm' -->
          <xsl:variable name="state" select="p:consume(34, $input, $state)"/>       <!-- 'mm' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 31">                                        <!-- 'in' -->
          <xsl:variable name="state" select="p:consume(31, $input, $state)"/>       <!-- 'in' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 37">                                        <!-- 'pt' -->
          <xsl:variable name="state" select="p:consume(37, $input, $state)"/>       <!-- 'pt' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 36">                                        <!-- 'pc' -->
          <xsl:variable name="state" select="p:consume(36, $input, $state)"/>       <!-- 'pc' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 42">                                        <!-- 'px' -->
          <xsl:variable name="state" select="p:consume(42, $input, $state)"/>       <!-- 'px' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 44">                                        <!-- 'rem' -->
          <xsl:variable name="state" select="p:consume(44, $input, $state)"/>       <!-- 'rem' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 22">                                        <!-- 'dcem' -->
          <xsl:variable name="state" select="p:consume(22, $input, $state)"/>       <!-- 'dcem' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 28">                                        <!-- 'ex' -->
          <xsl:variable name="state" select="p:consume(28, $input, $state)"/>       <!-- 'ex' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 19">                                        <!-- 'cap' -->
          <xsl:variable name="state" select="p:consume(19, $input, $state)"/>       <!-- 'cap' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 32">                                        <!-- 'jpt' -->
          <xsl:variable name="state" select="p:consume(32, $input, $state)"/>       <!-- 'jpt' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 43">                                        <!-- 'q' -->
          <xsl:variable name="state" select="p:consume(43, $input, $state)"/>       <!-- 'q' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 25">                                        <!-- 'dpi' -->
          <xsl:variable name="state" select="p:consume(25, $input, $state)"/>       <!-- 'dpi' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 24">                                        <!-- 'dpcm' -->
          <xsl:variable name="state" select="p:consume(24, $input, $state)"/>       <!-- 'dpcm' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 27">                                        <!-- 'emu' -->
          <xsl:variable name="state" select="p:consume(27, $input, $state)"/>       <!-- 'emu' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 20">                                        <!-- 'ch' -->
          <xsl:variable name="state" select="p:consume(20, $input, $state)"/>       <!-- 'ch' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 30">                                        <!-- 'ic' -->
          <xsl:variable name="state" select="p:consume(30, $input, $state)"/>       <!-- 'ic' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 33">                                        <!-- 'lh' -->
          <xsl:variable name="state" select="p:consume(33, $input, $state)"/>       <!-- 'lh' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 45">                                        <!-- 'rlh' -->
          <xsl:variable name="state" select="p:consume(45, $input, $state)"/>       <!-- 'rlh' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 49">                                        <!-- 'vw' -->
          <xsl:variable name="state" select="p:consume(49, $input, $state)"/>       <!-- 'vw' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 46">                                        <!-- 'vh' -->
          <xsl:variable name="state" select="p:consume(46, $input, $state)"/>       <!-- 'vh' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 48">                                        <!-- 'vmin' -->
          <xsl:variable name="state" select="p:consume(48, $input, $state)"/>       <!-- 'vmin' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 47">                                        <!-- 'vmax' -->
          <xsl:variable name="state" select="p:consume(47, $input, $state)"/>       <!-- 'vmax' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 41">                                        <!-- 'pvw' -->
          <xsl:variable name="state" select="p:consume(41, $input, $state)"/>       <!-- 'pvw' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 38">                                        <!-- 'pvh' -->
          <xsl:variable name="state" select="p:consume(38, $input, $state)"/>       <!-- 'pvh' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 40">                                        <!-- 'pvmin' -->
          <xsl:variable name="state" select="p:consume(40, $input, $state)"/>       <!-- 'pvmin' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 39">                                        <!-- 'pvmax' -->
          <xsl:variable name="state" select="p:consume(39, $input, $state)"/>       <!-- 'pvmax' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="p:consume(29, $input, $state)"/>       <!-- 'gr' -->
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'AbsoluteUnitName', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse AbsoluteLength.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-AbsoluteLength" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:consume(2, $input, $state)"/>              <!-- Number -->
    <xsl:variable name="state" select="p:lookahead1W(9, $input, $state)"/>          <!-- EOF | S^WS | ')' | '*' | '+' | ',' | '-' | 'cap' | 'ch' | 'cm' |
                                                                                         'dcem' | 'div' | 'dpcm' | 'dpi' | 'emu' | 'ex' | 'gr' | 'ic' | 'in' |
                                                                                         'jpt' | 'lh' | 'mm' | 'mod' | 'pc' | 'pt' | 'pvh' | 'pvmax' | 'pvmin' |
                                                                                         'pvw' | 'px' | 'q' | 'rem' | 'rlh' | 'vh' | 'vmax' | 'vmin' | 'vw' -->
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] != 1                                            (: EOF :)
                    and $state[$p:l1] != 10                                           (: ')' :)
                    and $state[$p:l1] != 11                                           (: '*' :)
                    and $state[$p:l1] != 12                                           (: '+' :)
                    and $state[$p:l1] != 13                                           (: ',' :)
                    and $state[$p:l1] != 14                                           (: '-' :)
                    and $state[$p:l1] != 23                                           (: 'div' :)
                    and $state[$p:l1] != 35">                                       <!-- 'mod' -->
          <xsl:variable name="state" select="p:whitespace($input, $state)"/>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-AbsoluteUnitName($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'AbsoluteLength', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse AbsoluteNumeric.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-AbsoluteNumeric" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-AbsoluteLength($input, $state)
    "/>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'AbsoluteNumeric', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse Numeric.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-Numeric" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:l1] eq 2">                                        <!-- Number -->
          <xsl:variable name="state" select="p:lookahead2W(10, $input, $state)"/>   <!-- EOF | S^WS | '%' | ')' | '*' | '+' | ',' | '-' | 'cap' | 'ch' | 'cm' |
                                                                                         'dcem' | 'div' | 'dpcm' | 'dpi' | 'em' | 'emu' | 'ex' | 'gr' | 'ic' |
                                                                                         'in' | 'jpt' | 'lh' | 'mm' | 'mod' | 'pc' | 'pt' | 'pvh' | 'pvmax' |
                                                                                         'pvmin' | 'pvw' | 'px' | 'q' | 'rem' | 'rlh' | 'vh' | 'vmax' | 'vmin' |
                                                                                         'vw' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$state[$p:l1], subsequence($state, $p:lk + 1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 514                                           (: Number '%' :)
                     or $state[$p:lk] = 1666">                                      <!-- Number 'em' -->
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-RelativeNumeric($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-AbsoluteNumeric($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'Numeric', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse PrimaryExpr.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-PrimaryExpr" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:l1] eq 6">                                        <!-- NCName -->
          <xsl:variable name="state" select="p:lookahead2W(8, $input, $state)"/>    <!-- EOF | S^WS | '(' | ')' | '*' | '+' | ',' | '-' | 'div' | 'mod' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$state[$p:l1], subsequence($state, $p:lk + 1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 9">                                         <!-- '(' -->
          <xsl:variable name="state" select="p:consume(9, $input, $state)"/>        <!-- '(' -->
          <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>    <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
          <xsl:variable name="state" select="p:whitespace($input, $state)"/>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-Expr($input, $state)
          "/>
          <xsl:variable name="state" select="p:consume(10, $input, $state)"/>       <!-- ')' -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 2">                                         <!-- Number -->
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-Numeric($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 4">                                         <!-- Literal -->
          <xsl:variable name="state" select="p:consume(4, $input, $state)"/>        <!-- Literal -->
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 7">                                         <!-- '#' -->
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-Color($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:lk] = 582">                                       <!-- NCName '(' -->
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-FunctionCall($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-EnumerationToken($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'PrimaryExpr', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse UnaryExpr.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-UnaryExpr" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" as="item()+">
      <xsl:choose>
        <xsl:when test="$state[$p:error]">
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:when test="$state[$p:l1] = 14">                                        <!-- '-' -->
          <xsl:variable name="state" select="p:consume(14, $input, $state)"/>       <!-- '-' -->
          <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>    <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
          <xsl:variable name="state" select="p:whitespace($input, $state)"/>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-UnaryExpr($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="state" select="
            if ($state[$p:error]) then
              $state
            else
              p:parse-PrimaryExpr($input, $state)
          "/>
          <xsl:sequence select="$state"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'UnaryExpr', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse the 1st loop of production MultiplicativeExpr (zero or more). Use
   ! tail recursion for iteratively updating the lexer state.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-MultiplicativeExpr-1">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:choose>
      <xsl:when test="$state[$p:error]">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="state" select="p:lookahead1W(7, $input, $state)"/>      <!-- EOF | S^WS | ')' | '*' | '+' | ',' | '-' | 'div' | 'mod' -->
        <xsl:choose>
          <xsl:when test="$state[$p:l1] != 11                                         (: '*' :)
                      and $state[$p:l1] != 23                                         (: 'div' :)
                      and $state[$p:l1] != 35">                                     <!-- 'mod' -->
            <xsl:sequence select="$state"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="state" as="item()+">
              <xsl:choose>
                <xsl:when test="$state[$p:error]">
                  <xsl:sequence select="$state"/>
                </xsl:when>
                <xsl:when test="$state[$p:l1] = 11">                                <!-- '*' -->
                  <xsl:variable name="state" select="p:consume(11, $input, $state)"/> <!-- '*' -->
                  <xsl:sequence select="$state"/>
                </xsl:when>
                <xsl:when test="$state[$p:l1] = 23">                                <!-- 'div' -->
                  <xsl:variable name="state" select="p:consume(23, $input, $state)"/> <!-- 'div' -->
                  <xsl:sequence select="$state"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="state" select="p:consume(35, $input, $state)"/> <!-- 'mod' -->
                  <xsl:sequence select="$state"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>  <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
            <xsl:variable name="state" select="p:whitespace($input, $state)"/>
            <xsl:variable name="state" select="
              if ($state[$p:error]) then
                $state
              else
                p:parse-UnaryExpr($input, $state)
            "/>
            <xsl:sequence select="p:parse-MultiplicativeExpr-1($input, $state)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Parse MultiplicativeExpr.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-MultiplicativeExpr" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-UnaryExpr($input, $state)
    "/>
    <xsl:variable name="state" select="p:parse-MultiplicativeExpr-1($input, $state)"/>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'MultiplicativeExpr', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse the 1st loop of production AdditiveExpr (zero or more). Use
   ! tail recursion for iteratively updating the lexer state.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-AdditiveExpr-1">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:choose>
      <xsl:when test="$state[$p:error]">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$state[$p:l1] != 12                                         (: '+' :)
                      and $state[$p:l1] != 14">                                     <!-- '-' -->
            <xsl:sequence select="$state"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="state" as="item()+">
              <xsl:choose>
                <xsl:when test="$state[$p:error]">
                  <xsl:sequence select="$state"/>
                </xsl:when>
                <xsl:when test="$state[$p:l1] = 12">                                <!-- '+' -->
                  <xsl:variable name="state" select="p:consume(12, $input, $state)"/> <!-- '+' -->
                  <xsl:sequence select="$state"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="state" select="p:consume(14, $input, $state)"/> <!-- '-' -->
                  <xsl:sequence select="$state"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>  <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
            <xsl:variable name="state" select="p:whitespace($input, $state)"/>
            <xsl:variable name="state" select="
              if ($state[$p:error]) then
                $state
              else
                p:parse-MultiplicativeExpr($input, $state)
            "/>
            <xsl:sequence select="p:parse-AdditiveExpr-1($input, $state)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Parse AdditiveExpr.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-AdditiveExpr" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-MultiplicativeExpr($input, $state)
    "/>
    <xsl:variable name="state" select="p:parse-AdditiveExpr-1($input, $state)"/>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'AdditiveExpr', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse Expr.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-Expr" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-AdditiveExpr($input, $state)
    "/>
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'Expr', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Parse Expression.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:parse-Expression" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="count" select="count($state)"/>
    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="state" select="p:lookahead1W(5, $input, $state)"/>          <!-- Number | S^WS | Literal | NCName | '#' | '(' | '-' -->
    <xsl:variable name="state" select="p:whitespace($input, $state)"/>
    <xsl:variable name="state" select="
      if ($state[$p:error]) then
        $state
      else
        p:parse-Expr($input, $state)
    "/>
    <xsl:variable name="state" select="p:consume(1, $input, $state)"/>              <!-- EOF -->
    <xsl:variable name="end" select="$state[$p:e0]"/>
    <xsl:sequence select="p:reduce($state, 'Expression', $count, $begin, $end)"/>
  </xsl:function>

  <!--~
   ! Create a textual error message from a parsing error.
   !
   ! @param $input the input string.
   ! @param $error the parsing error descriptor.
   ! @return the error message.
  -->
  <xsl:function name="p:error-message" as="xs:string">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="error" as="element(error)"/>

    <xsl:variable name="begin" select="xs:integer($error/@b)"/>
    <xsl:variable name="context" select="string-to-codepoints(substring($input, 1, $begin - 1))"/>
    <xsl:variable name="linefeeds" select="index-of($context, 10)"/>
    <xsl:variable name="line" select="count($linefeeds) + 1"/>
    <xsl:variable name="column" select="($begin - $linefeeds[last()], $begin)[1]"/>
    <xsl:variable name="expected" select="if ($error/@x or $error/@ambiguous-input) then () else p:expected-token-set($error/@s)"/>
    <xsl:sequence select="
      string-join
      (
        (
          if ($error/@o) then
            ('syntax error, found ', $p:TOKEN[$error/@o + 1])
          else
            'lexical analysis failed',
          '&#10;',
          'while expecting ',
          if ($error/@x) then
            $p:TOKEN[$error/@x + 1]
          else
          (
            '['[exists($expected[2])],
            string-join($expected, ', '),
            ']'[exists($expected[2])]
          ),
          '&#10;',
          if ($error/@o or $error/@e = $begin) then
            ()
          else
            ('after successfully scanning ', string($error/@e - $begin), ' characters beginning '),
          'at line ', string($line), ', column ', string($column), ':&#10;',
          '...', substring($input, $begin, 64), '...'
        ),
        ''
      )
    "/>
  </xsl:function>

  <!--~
   ! Consume one token, i.e. compare lookahead token 1 with expected
   ! token and in case of a match, shift lookahead tokens down such that
   ! l1 becomes the current token, and higher lookahead tokens move down.
   ! When lookahead token 1 does not match the expected token, raise an
   ! error by saving the expected token code in the error field of the
   ! lexer state.
   !
   ! @param $code the expected token.
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:consume" as="item()+">
    <xsl:param name="code" as="xs:integer"/>
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:choose>
      <xsl:when test="$state[$p:error]">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:when test="$state[$p:l1] eq $code">
        <xsl:variable name="begin" select="$state[$p:e0]"/>
        <xsl:variable name="end" select="$state[$p:b1]"/>
        <xsl:variable name="whitespace">
          <xsl:if test="$begin ne $end">
            <xsl:value-of select="substring($input, $begin, $end - $begin)"/>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="token" select="$p:TOKEN[1 + $state[$p:l1]]"/>
        <xsl:variable name="name" select="if (starts-with($token, &quot;'&quot;)) then 'TOKEN' else $token"/>
        <xsl:variable name="begin" select="$state[$p:b1]"/>
        <xsl:variable name="end" select="$state[$p:e1]"/>
        <xsl:variable name="node">
          <xsl:element name="{$name}">
            <xsl:sequence select="substring($input, $begin, $end - $begin)"/>
          </xsl:element>
        </xsl:variable>
        <xsl:sequence select="
          subsequence($state, $p:l1, 6),
          0, 0, 0,
          subsequence($state, 10),
          $whitespace/node(),
          $node/node()
        "/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="error">
          <xsl:element name="error">
            <xsl:attribute name="b" select="$state[$p:b1]"/>
            <xsl:attribute name="e" select="$state[$p:e1]"/>
            <xsl:choose>
              <xsl:when test="$state[$p:l1] lt 0">
                <xsl:attribute name="s" select="- $state[$p:l1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="o" select="$state[$p:l1]"/>
                <xsl:attribute name="x" select="$code"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:variable>
        <xsl:sequence select="
          subsequence($state, 1, $p:error - 1),
          $error/node(),
          subsequence($state, $p:error + 1)
        "/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Consume whitespace.
   !
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result.
   ! @return the updated state.
  -->
  <xsl:function name="p:whitespace" as="item()+">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="begin" select="$state[$p:e0]"/>
    <xsl:variable name="end" select="$state[$p:b1]"/>
    <xsl:choose>
      <xsl:when test="$begin eq $end">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="whitespace">
          <xsl:value-of select="substring($input, $begin, $end - $begin)"/>
        </xsl:variable>
        <xsl:sequence select="
          0,
          $state[$p:b0],
          $end,
          subsequence($state, $p:e0 + 1),
          $whitespace/node()
        "/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Use p:match to fetch the next token, but skip any leading
   ! whitespace.
   !
   ! @param $input the input string.
   ! @param $begin the index where to start.
   ! @param $token-set the valid token set id.
   ! @return a sequence of three values: the token code of the result
   ! token, with input string positions of token begin and end.
  -->
  <xsl:function name="p:matchW">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="begin" as="xs:integer"/>
    <xsl:param name="token-set" as="xs:integer"/>

    <xsl:variable name="match" select="p:match($input, $begin, $token-set)"/>
    <xsl:choose>
      <xsl:when test="$match[1] = 3">                                               <!-- S^WS -->
        <xsl:sequence select="p:matchW($input, $match[3], $token-set)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$match"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Lookahead one token on level 1 with whitespace skipping.
   !
   ! @param $set the code of the DFA entry state for the set of valid tokens.
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result stack.
   ! @return the updated state.
  -->
  <xsl:function name="p:lookahead1W" as="item()+">
    <xsl:param name="set" as="xs:integer"/>
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:choose>
      <xsl:when test="$state[$p:l1] ne 0">
        <xsl:sequence select="$state"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="match" select="
          p:matchW($input, $state[$p:e0], $set),
          0, 0, 0
        "/>
        <xsl:sequence select="
          $match[1],
          subsequence($state, $p:b0, 2),
          $match,
          subsequence($state, 10)
        "/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! Lookahead one token on level 2 with whitespace skipping.
   !
   ! @param $set the code of the DFA entry state for the set of valid tokens.
   ! @param $input the input string.
   ! @param $state lexer state, error indicator, and result stack.
   ! @return the updated state.
  -->
  <xsl:function name="p:lookahead2W" as="item()+">
    <xsl:param name="set" as="xs:integer"/>
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="state" as="item()+"/>

    <xsl:variable name="match" select="
      if ($state[$p:l2] ne 0) then
        subsequence($state, $p:l2, 3)
      else
        p:matchW($input, $state[$p:e1], $set)
    "/>
    <xsl:sequence select="
      $match[1] * 64 + $state[$p:l1],
      subsequence($state, $p:b0, 5),
      $match,
      subsequence($state, 10)
    "/>
  </xsl:function>

  <!--~
   ! Reduce the result stack, creating a nonterminal element. Pop
   ! $count elements off the stack, wrap them in a new element
   ! named $name, and push the new element.
   !
   ! @param $state lexer state, error indicator, and result.
   ! @param $name the name of the result node.
   ! @param $count the number of child nodes.
   ! @param $begin the input index where the nonterminal begins.
   ! @param $end the input index where the nonterminal ends.
   ! @return the updated state.
  -->
  <xsl:function name="p:reduce" as="item()+">
    <xsl:param name="state" as="item()+"/>
    <xsl:param name="name" as="xs:string"/>
    <xsl:param name="count" as="xs:integer"/>
    <xsl:param name="begin" as="xs:integer"/>
    <xsl:param name="end" as="xs:integer"/>

    <xsl:variable name="node">
      <xsl:element name="{$name}">
        <xsl:sequence select="subsequence($state, $count + 1)"/>
      </xsl:element>
    </xsl:variable>
    <xsl:sequence select="subsequence($state, 1, $count), $node/node()"/>
  </xsl:function>

  <!--~
   ! Parse start symbol Expression from given string.
   !
   ! @param $s the string to be parsed.
   ! @return the result as generated by parser actions.
  -->
  <xsl:function name="p:parse-Expression" as="item()*">
    <xsl:param name="s" as="xs:string"/>

    <xsl:variable name="state" select="0, 1, 1, 0, 0, 0, 0, 0, 0, false()"/>
    <xsl:variable name="state" select="p:parse-Expression($s, $state)"/>
    <xsl:variable name="error" select="$state[$p:error]"/>
    <xsl:choose>
      <xsl:when test="$error">
        <xsl:variable name="ERROR">
          <xsl:element name="ERROR">
            <xsl:sequence select="$error/@*, p:error-message($s, $error)"/>
          </xsl:element>
        </xsl:variable>
        <xsl:sequence select="$ERROR/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="subsequence($state, $p:result)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--~
   ! The input filename, or string, if surrounded by curly braces.
  -->
  <xsl:param name="input" as="xs:string?" select="()"/>

  <!--~
   ! The (simple) main program.
  -->
  <xsl:template name="main" match="/">
    <xsl:param name="input" as="xs:string?" select="$input"/>

    <xsl:choose>
      <xsl:when test="empty($input)">
        <xsl:sequence select="error(xs:QName('main'), '&#xA;    Usage: java net.sf.saxon.Transform -xsl:axf-expression.xslt -it:main input=INPUT&#xA;&#xA;      parse INPUT, which is either a filename or literal text enclosed in curly braces')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="result" select="
          if (matches($input, '^\{.*\}$')) then
            p:parse-Expression(substring($input, 2, string-length($input) - 2))
          else
            p:parse-Expression(unparsed-text($input, 'utf-8'))
        "/>
        <xsl:choose>
          <xsl:when test="empty($result/self::ERROR)">
            <xsl:sequence select="$result"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="error(xs:QName('p:parse-Expression'), concat('&#10;    ', replace($result, '&#10;', '&#10;    ')))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>