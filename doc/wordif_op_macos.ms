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
\f3wordif_op_macos\fP
.AU "HV BF-124" 2774
R.J. Toscani
.AI
.IH
.AB
Dit document heeft als onderwerp \f3"wordif_op_macos"\fP en is het resultaat van een automatische conversie vanuit platte tekst 
naar het TROFF-formaat, door middel van het script \f3text2troff\fP, een project van Rob Toscani.
.AE
...CS 12 1 13 0 0 10
.1C
.
.
.
.SH 1
\f[3]Stappenplan wordif.sh op MacOS laptop\[P]
.LP
.IP "\m[blue]1." 3
Maak de map `wordif_\:vergel\[ij]king/\:' aan onder Desktop/\:, met daarin de subdirectories: `oud/\:' en `nieuw/\:'
.IP "\m[blue]2." 3
Maak de map `scripts/\:' aan onder Desktop/\: of direct onder $HOME (=\: /Users/\:<user>/\:)
.IP "\m[blue]3." 3
Plaats in de map scripts/\: het bestand `wordif.sh'
.IP "\m[blue]4." 3
Maak dit script executable met:
.DS I 3
.CW
chmod u+x wordif.sh
.DE
.IP "\m[blue]5." 3
Plaats in $HOME eventueel ook een (aan de mapstructuur aangepaste) kopie van \&.bashrc, \&.profile en \&.bash_\:aliases om
in de terminal gemakkel\[ij]ker scripts te kunnen aanroepen en aliassen te kunnen gebruiken voor veelgebruikte commando's
.IP "\m[blue]6." 3
Maak d.m.v. Automator een `Launch Wordif App' launcher aan (/\:bin/\:bash programma) met als inhoud:
.DS I 3
.CW
cd /Users/<user>/Desktop/wordif_vergelijking
/Users/<user>/Desktop/scripts/wordif.sh -d oud nieuw
.DE
en save deze naar Desktop/\:
.IP "\m[blue]7." 3
Een dubbelklik op `Launch Wordif App' maakt nu een diff/\: map aan (als die nog niet bestond) met daarin
de verschilbestanden van de inhoud van oud/\: en nieuw/\:
