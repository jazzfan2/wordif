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
Maak map `wordif_\:vergel\[ij]king/\:' aan onder Desktop/\:, met daarin de subdirectories: `oud/\:' en `nieuw/\:'
.IP "\m[blue]2." 3
Maak map `scripts/\:' aan onder Desktop/\: of direct onder $HOME
.IP "\m[blue]3." 3
[INFORMATIEF] Check of wdiff() is geïnstalleerd
.IP "\m[blue]4." 3
[INFORMATIEF] Check of Python2 en/\:of Python3 is geïnstalleerd, en zo ja: de __\:future_\:_ module
.IP "\m[blue]5." 3
[INFORMATIEF] Check of gawk() is geïnstalleerd
.IP "\m[blue]6." 3
[INFORMATIEF] Check of gcc, xcode, clang, tcc, pcc, idc of sdcc z\[ij]n geïnstalleerd (compilers)
.IP "\m[blue]7." 3
Plaats in scripts/\: de bestanden wordif.sh, wdiffer2.py [VERVALLEN], wdiffer2.sh [VERVALLEN] (, wdiffer.py [VERVALLEN], wdiffer.sh [VERVALLEN])
.IP "\m[blue]8." 3
Maak al deze scripts executable met chmod u+\:x
.IP "\m[blue]9." 3
Plaats in $HOME eventueel ook nog een (aangepaste) kopie van \&.bashrc, \&.profile en \&.bash_\:aliases
.IP "\m[blue]10." 3
Maak d.m.v. Automator een `Launch Wordif App' launcher aan (/\:bin/\:bash programma) met als inhoud:
.DS I 3
.CW
cd /Users/jacqueline/Desktop/wordif_vergelijking
/Users/jacqueline/Desktop/scripts/wordif.sh -d oud nieuw
.DE
en save deze naar Desktop/\:
.IP "\m[blue]11." 3
Maak in de code van `wordif.sh' de paden naar de wdiffer-scripts compleet, gel\[ij]k aan bovenstaande locaties [VERVALLEN].
.IP "\m[blue]12." 3
Een dubbelklik op `Launch Wordif App' maakt nu een diff/\: map aan (als die nog niet bestond) met daarin
de verschilbestanden van de inhoud van oud/\: en nieuw/\:
