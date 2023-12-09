{ @author: Sylvain Maltais (support@gladir.com)
  @created: 1993
  @website(https://www.gladir.com/CODER/OS2LIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit OS2API;

INTERFACE

Const
 { Relation du processus }
 prNew=$0001;                { Ind‚pendant }
 prChild=$0002;              { Enfant }

  { Priorit‚ de la session }
 prForeground=$0000;         { Premier plan }
 prBackground=$0001;         { ArriŠre plan }

  { ModŠle de session }
 stDefault=$0000;            { Par d‚faut }
 stOS2FullScrn=$0001;        { OS/2 Plein ‚cran }
 stOS2Window=$0002;          { OS/2 en fenˆtre }
 stPM=$0003;                 { Gestionnaire de pr‚sentation d'OS/2 }
 stDosFullScrn=$0004;        { Dos pleine ‚cran }
 stDosWindow=$0007;          { Dos en fenˆtre }

Type
 OS2StartData=Record
  LenStruct:Word;       { Longueur de la structure (peut ˆtre }
                         { 0018h, 001Eh, 0020h, 0032h, 003Ch) }
  Process:Word;         { Relation du nouveau processus (pr??): }
                         { 0000h = Ind‚pendant, 0001h = Enfant}
  Priority:Word;        { Priorit‚ de la session: }
                         { 0000h = Premier plan }
                         { 0001h = ArriŠre plan }
  Trace:Word;           { Les options de traces }
  Title:PChar;          { Titre du programme }
  Name:PChar;           { Nom du programme }
  Args:PChar;           { Argument du programme }
  TermQ:PChar;          { "TermQ"}
  Environment:PChar;    { Variable d'environnement }
  Inherit:WordBool;     { H‚ritier des donn‚es }
  SessionType:Word;     { ModŠle de session (st????) }
  Icon:PChar;           { Nom de l'ic“ne }
  PgmHandle:PChar;      { Le "PgmHandle" }
  PgmControl:Word;      { Le "PgmControl" }
  Column:Word;          { Colonne }
  Row:Word;             { Ligne }
  Width:Word;           { Largeur }
  Height:Word;          { Hauteur }
  Reserved:Word;        { R‚serv‚e }
  ObjectBuffer:LongInt; { Pointeur sur le tampon d'objet }
  ObjectBufferLen:Word; { Longueur du tampon d'objet }
 End;


Function  OS2Exec(Const Data:OS2StartData):Word;
Procedure OS2SetTitle(Name:PChar);

IMPLEMENTATION

{ @description: Cette fonction permet d'ex‚cuter une session
                d'application OS/2.
}

Function OS2Exec(Const Data:OS2StartData):Word;Assembler;ASM
 PUSH DS
  LDS SI,Data
  MOV AH,064h
  MOV BX,0025h
  MOV CX,636Ch
  INT 21h
 POP DS
END;

{ @description: Cette proc‚dure permet de sp‚cifier le nouveau
                nom que doit avoir l'application actuel sous une
                session d'OS/2.
  @remarques:

  - Cette proc‚dure  requŠre  naturellement de  fonctionner sous le
    systŠme d'exploitation  d'OS/2  sans cela elle aura aucun effet
    peut peut-ˆtre cr‚er un plantage sous un systŠme d'exploitation
    DOS compatible mal cod‚.

  - Le  nombre  maximal  de  caractŠres support‚e  comme  titre est
    malheureusement que 13 caractŠres.

  - Il est possible de  restitu‚e le nom  original en envoyant tout
    simplement une chaŒne de caractŠres vide.
}

Procedure OS2SetTitle(Name:PChar);Assembler;ASM
 MOV AH,64h
 MOV DX,0001h
 MOV CX,636Ch
 MOV BX,0000h
 LES DI,Name
 INT 21h
END;

END.