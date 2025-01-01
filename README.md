# GnuCash-XRechnung
Prototypen von Tools für die Nutzung von XRechnung in GnuCash


## Table of content
1. [1 CSV-Datei zum GnuCash-Import aus xRechung-XML erzeugen](#1-csv-datei-zum-gnucash-import-aus-xrechung-xml-erzeugen)
2. [Aufruf](#aufruf)
3. [Spezielle Wertebelegungen](#spezielle-wertebelegungen)
4. [Erzeugte CSV-Datei](#erzeugte-csv-datei)
5. [Darstellung in GnuCash](#darstellung-in-gnucash)
6. [Haftungsausschluss](#haftungsausschluss)

## 1 CSV-Datei zum GnuCash-Import aus xRechung-XML erzeugen

Für xRechnungen gibt es bisher keine Möglichkeit des Imports in GnuCash. Dieses XSLT-Stylesheet **importiereRechnung.xsl** setzt eine xRechnung in eine CSV-Datei um, die von GnuCash importiert werden kann.

### Aufruf
Um das XSLT-Stylesheet zu verwenden, ist ein XSLT-Prozessor erforderlich. Der Aufruf kann dann z.B. wie folgt aussehen:

`xsltproc -o xRechnung.csv importiereRechnung.xsl xRechnung.xml `

### Spezielle Wertebelegungen

Im XSLT-Stylesheet können einige Werte durch den Anwender vorbelegt werden. Diese befinden sich im Kopfteil der Datei.

```html
    <xsl:variable name="steuerWirk">Y</xsl:variable>    <!-- Steuerwirksam? Y (für Ja) oder N  -->
    <xsl:variable name="steuerInkl">N</xsl:variable>    <!-- Inklusive Steuer Y (für Ja) oder N  -->
    <xsl:variable name="steuerTab">                     <!-- Umsetzung von Steuerwert auf Steuertabelle. Format: #[Steuersatz]=[Name der Tabelle]#... -->
#7=Vorsteuer-7#19=Vorsteuer-19#
    </xsl:variable>
    <xsl:variable name="konto">Aufwendungen</xsl:variable>          <!-- Names des Kontos auf das die Rechnung gebucht werden soll -->
```
Die Variablen haben folgende Bedeutung:

**steuerWirk**

Es kann vorgegeben werden, ob die Positionen *steuerwirksam* sind (*Y*) oder nicht (*N*).

**steuerInkl**

Es kann vorgegeben werden, ob die Positionen die *Steuer enthalten* (*Y*) oder nicht (*N*).

**steuerTab**

Diese Variable enthält eine Zuordnung der Prozentsätze der Mehrwert-/Umsatzsteuer zu den Namen der Steuertabellen in GnuCash.

Die Zeile hat folgendes Format:

#[Steuersatz]=[Name der Tabelle]#[Steuersatz]=[Name der Tabelle]#...

Es können Steuertabellen für verschiedene Steuersätze aufgeführt werden. Alle Einträge erfolgen hintereinander in einer Zeile, wie oben im Beispiel zu sehen ist. Die Reihenfolge der Einträge spielt keine Rolle

**konto**

Der Name des Kontos aus GnuCash, auf das die Rechnung eingetragen wird. 

### Erzeugte CSV-Datei 

Am Beispiel der Beispielnachricht *04.01a-INVOICE_ubl.xml* aus dem Bundle [https://xeinkauf.de/xrechnung/versionen-und-bundles/](https://xeinkauf.de/xrechnung/versionen-und-bundles/) erzeugt das XSLT-Stylesheet folgende Importdatei:

`12345;15.05.2019;345LA5324;123;;;Geleistete Zahlung;;Aufwendungen;;-10000,0;;;;Y;Y;;;;;;`
`12345;15.05.2019;345LA5324;123;;;Sanitär und Zubehör;;Aufwendungen;1;818,04;;;;Y;N;Vorsteuer-19;;;;;`
`12345;15.05.2019;345LA5324;123;;;Heizung und Zubehör;;Aufwendungen;1;11718,8;;;;Y;N;Vorsteuer-19;;;;;`

Die genannte Testdatei enthält eine Vorauszahlung. Dafür generiert das XSLT-Stylesheet die erste Zeile mit negativem Vorzeichen. Da zur Vorauszahlung kein Steuersatz angegeben ist, ist eine Vorbelegung der Steuertabelle leider nicht möglich; dies muss in GnuCash dann händisch gemacht werden (siehe nächster Abschnitt).

### Darstellung in GnuCash
Nachdem die oben erzeugte CSV-Datei in GnuCash importiert wurde, stellt GnuCash sie wie folgt dar:
![gnucash](https://github.com/user-attachments/assets/cbf75186-5c5b-425a-a5be-0a30da03d06d)

Beim Importieren sind die Anforderungen von GnuCash in Hinblick auf z.B. die Existenz einer Lieferantennummer zu berücksichtigen. Sie können auf [https://gnucash.org/docs/v5/de/gnucash-guide/busnss-imp-bills-invoices.html](https://gnucash.org/docs/v5/de/gnucash-guide/busnss-imp-bills-invoices.html) nachgelesen werden.


# Haftungsausschluss

Die hier dokumentierten Tools sind prototypische Beispiele. Es wird "as it is" zur Verfügung gestellt. Die Nutzung geschieht auf eigenes Risiko. Der Autor haftet nicht für Schäden, die durch die Nutzung der Tools entstehen.
