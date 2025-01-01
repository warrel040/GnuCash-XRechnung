<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
   xmlns:Invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
   xmlns:saxon="http://saxon.sf.net/" version="1.1"> <!--exclude-result-prefixes="#all" version="2.0"-->

<!-- abgeleitet aus ubl-invoice-xr -->

    <xsl:output method="text" indent="no"/>

<!-- ############## Anwenderspezifisch belegbar ############# -->
    <xsl:variable name="steuerWirk">Y</xsl:variable>    <!-- Steuerwirksam? Y (für Ja) oder N  -->
    <xsl:variable name="steuerInkl">N</xsl:variable>    <!-- Inklusive Steuer Y (für Ja) oder N  -->
    <xsl:variable name="steuerTab">                     <!-- Umsetzung von Steuerwert auf Steuertabelle. Format: #[Steuersatz]=[Name der Tabelle]#... -->
#7=Vorsteuer-7#19=Vorsteuer-19#
    </xsl:variable>
    <xsl:variable name="konto">Aufwendungen</xsl:variable>          <!-- Names des Kontos auf das die Rechnung gebucht werden soll -->
<!-- ######################################################## -->

    <!-- Ersetzung von '' "" ; durch # # , -->
    <xsl:variable name="von">""'';</xsl:variable>
    <xsl:variable name="nach">####,</xsl:variable>

<!-- dieses Muster findet Invoice -->
    <xsl:template match="/Invoice:Invoice">
        <xsl:variable name="f1" select="cbc:ID"/>
        <!-- Format Datum ist: YYYY-MM-DD. Soll: DD.MM.YYYY-->
        <xsl:variable name="f2" select="concat(substring(cbc:IssueDate, 9, 2), '.', substring(cbc:IssueDate, 6, 2), '.', substring(cbc:IssueDate, 1, 4))"/>
        <xsl:variable name="f3">
          <xsl:apply-templates mode="BG-7" select="./cac:AccountingCustomerParty"/>
        </xsl:variable>
        <xsl:variable name="f4" select="./cac:OrderReference/cbc:ID"/>
        <xsl:variable name="f5" select="./cbc:Note"/>
        <xsl:variable name="f6"></xsl:variable>

        <xsl:apply-templates mode="BG-25x" select="./cac:LegalMonetaryTotal">
            <xsl:with-param name="feld1" select="$f1"/>
            <xsl:with-param name="feld2" select="$f2"/>
            <xsl:with-param name="feld3" select="$f3"/>
            <xsl:with-param name="feld4" select="$f4"/>
            <xsl:with-param name="feld5" select="$f5"/>
            <xsl:with-param name="feld6" select="$f6"/>
        </xsl:apply-templates>

        <xsl:apply-templates mode="BG-25" select="./cac:InvoiceLine">
            <xsl:with-param name="feld1" select="$f1"/>
            <xsl:with-param name="feld2" select="$f2"/>
            <xsl:with-param name="feld3" select="$f3"/>
            <xsl:with-param name="feld4" select="$f4"/>
            <xsl:with-param name="feld5" select="$f5"/>
            <xsl:with-param name="feld6" select="$f6"/>
        </xsl:apply-templates>
    </xsl:template>

<!-- dieses Muster findet AccountingCustomerParty -->
    <xsl:template mode="BG-7" match="/Invoice:Invoice/cac:AccountingCustomerParty">
       <xsl:value-of select="cac:Party/cac:PartyIdentification/cbc:ID"/>
    </xsl:template>

<!-- dieses Muster findet InvoiceLine -->
    <xsl:template mode="BG-25" match="/Invoice:Invoice/cac:InvoiceLine">
        <xsl:param name="feld1">f1</xsl:param>
        <xsl:param name="feld2">f2</xsl:param>
        <xsl:param name="feld3">f3</xsl:param>
        <xsl:param name="feld4">f4</xsl:param>
        <xsl:param name="feld5">f5</xsl:param>
        <xsl:param name="feld6">f6</xsl:param>
        <xsl:variable name="feld7" select="translate(./cac:Item/cbc:Name, $von, $nach)"/>  <!-- '' "" und ; ersetzen -->
        <xsl:variable name="feld8"></xsl:variable>
        <xsl:variable name="feld9" select="$konto"/>
        <xsl:variable name="feld10" select="./cbc:InvoicedQuantity"/>
        <!-- hat Decimalpunkt, braucht Komma -->
        <xsl:variable name="feld11" select="translate (./cbc:LineExtensionAmount, '.', ',')"/>  
        <xsl:variable name="feld12"></xsl:variable>
        <xsl:variable name="feld13"></xsl:variable>
        <xsl:variable name="feld14"></xsl:variable>
        <xsl:variable name="feld15" select="$steuerWirk"/>
        <xsl:variable name="feld16" select="$steuerInkl"/>

        <xsl:variable name="test" select="substring-after($steuerTab, concat ('#', ./cac:Item/cac:ClassifiedTaxCategory/cbc:Percent, '='))"/>
        <xsl:variable name="feld17">
            <xsl:choose>
              <xsl:when test="string-length ($test) &lt; 1"><xsl:value-of select="./cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="substring-before ($test, '#')"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="feld18"></xsl:variable>
        <xsl:variable name="feld19"></xsl:variable>
        <xsl:variable name="feld20"></xsl:variable>
        <xsl:variable name="feld21"></xsl:variable>

        <xsl:value-of select="concat ($feld1, ';', $feld2, ';', $feld3, ';', $feld4, ';', $feld5, ';', $feld6, ';', $feld7, ';', $feld8, ';', $feld9, ';', $feld10, ';', $feld11, ';', $feld12, ';', $feld13, ';', $feld14, ';', $feld15, ';', $feld16, ';', $feld17, ';', $feld18, ';', $feld19, ';', $feld20, ';', $feld21, ';', '&#x0A;')" disable-output-escaping="yes"/>

    </xsl:template>

<!-- dieses Muster findet LegalMonetaryTotal -->
    <xsl:template mode="BG-25x" match="/Invoice:Invoice/cac:LegalMonetaryTotal">  
        <xsl:param name="feld1">f1</xsl:param>
        <xsl:param name="feld2">f2</xsl:param>
        <xsl:param name="feld3">f3</xsl:param>
        <xsl:param name="feld4">f4</xsl:param>
        <xsl:param name="feld5">f5</xsl:param>
        <xsl:param name="feld6">f6</xsl:param>
        <xsl:variable name="feld7">Geleistete Zahlung</xsl:variable>  
        <xsl:variable name="feld8"></xsl:variable>
        <xsl:variable name="feld9" select="$konto"/>
        <xsl:variable name="feld10" select="./cbc:InvoicedQuantity"/>
        <!-- hat Decimalpunkt, braucht Komma -->
        <xsl:variable name="feld11" select="concat ('-', translate (./cbc:PrepaidAmount, '.', ','))"/>  
        <xsl:variable name="feld12"></xsl:variable>
        <xsl:variable name="feld13"></xsl:variable>
        <xsl:variable name="feld14"></xsl:variable>
        <xsl:variable name="feld15" select="$steuerWirk"/>
        <xsl:variable name="feld16">Y</xsl:variable>

        <xsl:variable name="test" select="substring-after($steuerTab, concat ('#', ./cac:Item/cac:ClassifiedTaxCategory/cbc:Percent, '='))"/>
        <xsl:variable name="feld17">
            <xsl:choose>
              <xsl:when test="string-length ($test) &lt; 1"><xsl:value-of select="./cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="substring-before ($test, '#')"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="feld18"></xsl:variable>
        <xsl:variable name="feld19"></xsl:variable>
        <xsl:variable name="feld20"></xsl:variable>
        <xsl:variable name="feld21"></xsl:variable>

        <xsl:value-of select="concat ($feld1, ';', $feld2, ';', $feld3, ';', $feld4, ';', $feld5, ';', $feld6, ';', $feld7, ';', $feld8, ';', $feld9, ';', $feld10, ';', $feld11, ';', $feld12, ';', $feld13, ';', $feld14, ';', $feld15, ';', $feld16, ';', $feld17, ';', $feld18, ';', $feld19, ';', $feld20, ';', $feld21, ';', '&#x0A;')" disable-output-escaping="yes"/>

    </xsl:template>
 
</xsl:stylesheet>
