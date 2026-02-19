.RP
...TR
...IM
...TM 76-1273-10 39199 39199-11
...MF
...MR
...EG
.fam N
.nr PS 10
.defcolor blue       rgb #17517e
\m[blue]
.nr HORPHANS 5
.nr PORPHANS 3
.nr chapt_nr 0 1
.nr GROWPS 2
.nr PSINCR 1.5p
.TL
\f3wordif_doc\fP
.AU "HV BF-124" 2774
R.J. Toscani
.AI
.IH
.AB
Dit document heeft als onderwerp \f3"wordif_doc"\fP en is het resultaat van een automatische conversie vanuit platte tekst 
naar het TROFF-formaat, door middel van het script \f3text2troff\fP, een project van Rob Toscani.
.AE
...CS 12 1 13 0 0 10
.1C
.nr table_nr 0
.nr ps_decr \n[.s]*2/10
.
.
.
.SH 1
\f[3]HOE HET PROGRAMMA `WORDIF.SH' TE GEBRUIKEN:\[P]
.
.
.
.SH 1
\f[3]1. Voorbereiding:\[P]
.LP
Maak van te voren twee (sub-)mappen aan in de projectmap, en noem die
b\[ij]voorbeeld `oud' en `nieuw' (ook andere namen z\[ij]n toegestaan.)
.LP
Leid nu platte-tekstbestanden af van de te vergel\[ij]ken bronteksten (in b.v. InDesign),
b\[ij] voorkeur één bestand per hoofdstuk of artikel.
.LP
B.v. tekst van een InDesign-artikel selecteren met `Ctrl-A', kopiëren met
`Ctrl-C' en in een PLATTE editor plakken met `Ctrl-V'.
.LP
Sla deze PLATTE-tekstbestanden (tekstcodering Unicode [UTF-8])
zodanig op in `oud/\:' en `nieuw/\:' dat voor elk bestand in `oud'
er een daarmee te vergel\[ij]ken bestand bestaat in `nieuw'.
.LP
Om twee bestanden in verschillende mappen aan elkaar te kunnen relateren moeten
hun bestandsnamen beginnen met hetzelfde NUMMER gevolgd door een UNDERSCORE,
eventueel gevolgd door een vr\[ij] te kiezen gedeelte (dat onderling verschillend
mag z\[ij]n).
.LP
Het programma zal tekstbestanden in die in `oud/\:' z\[ij]n opgeslagen vergel\[ij]ken
met die in `nieuw/\:' waarvan de naam met hetzelfde NUMMER begint, b\[ij]voorbeeld:
.LP
.nr table_nr +1
.ps -\n[ps_decr]
.TS H
center, allbox;
c s s
l l l .
.ft 3
Tabel \n[table_nr]
.P
_
.TH
T{
oud/\:
T}	T{
-
T}	T{
nieuw/\:
T}
T{
1_\:voorwoord.txt
T}	T{
wordt vergeleken met:
T}	T{
1_\:inleiding.txt
T}
T{
2_\:highlights.txt
T}	T{
wordt vergeleken met:
T}	T{
2_\:highlights.txt
T}
T{
3_\:tips.txt
T}	T{
wordt vergeleken met:
T}	T{
3_\:tips&tricks.txt
T}
.TE
.LP
.LP
De laatste deel van de namen kan dus verschillend z\[ij]n.
.LP
Let op:
.IP "\m[blue]\(en" 3
Het aantal genummerde bestanden in `oud/\:' moet gel\[ij]k z\[ij]n aan dat in `nieuw/\:'.
.IP "\m[blue]\(en" 3
Per map mag elke waarde van NUMMER maar één keer voorkomen.
.IP "\m[blue]\(en" 3
In bestandsnamen mogen na de `_\:' spaties voorkomen, maar verm\[ij]d het b\[ij] voorkeur.
.
.
.
.SH 1
\f[3]2. Werking van het programma:\[P]
.LP
Om het programma te starten, typ in een terminal het volgende commando in,
en druk daarna op <ENTER>:
.DS I 3
.CW
wordif.sh  -d  oud  nieuw
.DE
De optie `-\:d' impliceert dat er \(en zoals hierboven \(en twee mappen worden opgegegeven
(niet twee tekstbestanden).
.LP
Het programma werkt nu één-voor-één alle paren van tekstbestanden in genoemde
mappen af en genereert hieruit verschil-bestanden.
.LP
Deze worden elk als apart HTML-bestand in de map `diff/\:' geplaatst.
De bestandsnaam is als volgt opgebouwd:
.DS I 3
.CW
DATUM_TIJD_'diff'_NUMMER.'html'
.DE
Het NUMMER in de namen van de verschil-bestanden komt overeen met dat van de
vergeleken tekstbestanden.
.LP
Indien het programma doublures en/\:of in één map ontbrekende waarden van NUMMER
tegenkomt, dan geeft het daarvan waarschuwingen in de terminal, maar vervolgt wel
zo goed mogel\[ij]k z\[ij]n taak.
.LP
Zodra het programma klaar is, geeft het hiervan een melding in dezelfde terminal.
.LP
In elk van de resulterende \&.html-bestanden in de map `diff/\:' is:
.IP "\m[blue]\(en" 3
Zwarte tekst: WEL aanwezig op die plaats
in BEIDE vergeleken bestanden in `oud/\:' en `nieuw/\:'
.IP "\m[blue]\(en" 3
Rode tekst:   WEL aanwezig in het bestand in `oud/\:';
NIET op die plaats in het vergeleken bestand in `nieuw/\:';
.IP "\m[blue]\(en" 3
Groene tekst: WEL in het vergeleken bestand in `nieuw/\:';
NIET op die plaats aanwezig in het bestand in `oud/\:'.
.LP
Vanuit elk van deze html-bestanden kan b.v. geprint worden naar PDF.
Verder z\[ij]n er nog de volgende mogel\[ij]kheden:
.IP "\m[blue]\[bu]" 3
Indien tussen `wordif.sh' en `oud' ook nog de optie `-\:p' wordt opgegeven, dan
worden de verschilbestanden direct naar PDF in plaats van naar HTML weggeschreven.
.IP "\m[blue]\[bu]" 3
Indien optie `-\:d' wordt weggelaten, dan moeten er twee tekstbestanden worden
opgegegeven in plaats van twee mappen. Er volgt dan slechts één vergel\[ij]king
in plaats van een reeks vergel\[ij]kingen, en één verschilbestand.
