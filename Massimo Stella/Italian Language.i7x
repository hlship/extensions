Version 2/140608 of Italian Language by Massimo Stella begins here.

"To make Italian the language of play.

Heavily based on code written by Massimo Stella. Now maintained by Leonardo Boselli.

Requires 'Text Capture' by Eric Eve."

Include Text Capture by Eric Eve.

Include Punctuation Removal by Emily Short.
After reading a command:
     remove apostrophes;

Volume 1 - Settings

[A language extension is required to set the following variable correctly:]

The language of play is the Italian language.

[The following only needs to be done for inflected languages which distinguish
the genders -- which is why English doesn't do it.]

An object has a grammatical gender.

[Inform initialises this property sensibly. We can easily check the results:

	When play begins:
		repeat with T running through things:
			say "[T] has [grammatical gender of T]."

By default, if Inform can't see any reason to choose a particular gender,
it will use neuter. We want to change that:]

The grammatical gender of an object is usually masculine gender.
The grammatical gender of a woman is usually feminine gender.
The grammatical gender of a man is usually masculine gender.

[Now we define any unusual tenses we want to support. Inform allows up to 7
tenses, and it requires tenses 1 to 5 to be present, past, perfect, past
perfect, and future; English stops there, but two slots are left free for
other languages to create. ]

The past historic tense is a grammatical tense.

[It's customary to define a constant so that I6 code can conditionally compile
if we're using this extension, though nothing in the I7 compiler needs it.]

Include (-
Constant LIBRARY_ITALIAN;       ! for dependency checking.
-)

Volume 2 - Language

Part 2.1 - Determiners

Chapter 2.1.1 - Articles

Include (-
language Italian

<indefinite-article> ::=
	/b/ un/uno |			[singular, masculine]
	/c/ una/un' |			[singular, feminine]
	/d/ delle/alcune |		[plural, feminine]
	/e/ degli/dei/alcuni	[plural, masculine (by default)]

<definite-article> ::=
	/b/ il/lo/l' |				[singular, masculine]
	/c/ la/l' |				[singular, feminine]
	/d/ le |				[plural, feminine]
	/e/ gli/i				[plural, masculine (by default)]

<np-relative-phrase-implicit> ::=
	/a/ indossato |		[replacing "worn" in English]
	/b/ portato |			["carried"]
	/d/ qui				["here"]

<implicit-player-relationship> ::=
	/a/ indossato |
	/b/ portato

-) in the Preform grammar.

[ Qui sotto iniziano le modifiche all'estensione di personale iniziativa dell'autore. ]

Include (-
Constant LanguageAnimateGender   = male;
Constant LanguageInanimateGender = male;
Constant LanguageContractionForms = 3;     ! Italian has three:

[ LanguageContraction text;
  if (text->0 == 'p' or 'P')
  	if (text->1 == 's' or 'S') return 1;
  	else if (text->1 == 'r' or 'R') return 2;
  if (text->0 == 't' or 'T') return 2;
  if (text->0 == 'a' or 'e' or 'i' or 'o' or 'u' or 'A' or 'E' or 'I' or 'O' or 'U') return 0;
  if (text->0 == 'z' or 'Z' or 'x' or 'X') return 1;
  if (text->0 ~= 's' or 'S') 
	if (text->1 == 'a' or 'e' or 'i' or 'o' or 'u' or 'A' or 'E' or 'I' or 'O' or 'U') return 2;
	if (text->1 == 'c' or 'C') return 1;   ! "degli scorpioni"
	else return 1;
  return 2;
];

Array LanguageArticles -->
!  Contraction form 0:    Contraction form 1:     Contraction form 2:
!  Cdef   Def    Indef    Cdef   Def    Indef     Cdef   Def    Indef
   "L'"   "l'"  "un "     "Lo "  "lo "   "uno "    "Il "  "il "  "un "  
   "L'"   "l'"  "un'"     "La "  "la "   "una "    "La "  "la "  "una "
   "Gli " "gli " "degli " "Gli " "gli "  "degli "  "I "   "i "   "dei "  
   "Le "  "le " "delle "  "Le "  "le "   "delle "  "Le "  "le "  "delle ";
				   !             a           i
				   !             s     p     s     p
				   !             m f n m f n m f n m f n               

Array LanguageGNAsToArticles --> 0 1 0 2 3 0 0 1 0 2 3 0;
-) instead of "Articles" in "Language.i6t".

Chapter 2.1.2 - Numbers

[ BUG: Nella Preform Grammar l'aggiunta del numero "sei" genera un grave conflitto con la seconda persona
singolare al presente del verbo "essere". Per tale motivo "sei" è escluso dalla lista. ]

Include (-
language Italian

<cardinal-number-in-words> ::=
	zero |
	un/uno |
	due |
	tre |
	quattro |
	cinque |
	sette |
	otto |
	nove |
	dieci |
	undici |
	dodici |
	tredici |
	quattordici |
	quindici |
	sedici |
	diciassette |
	diciotto |
	diciannove |
	venti 

<ordinal-number-in-words> ::=
	zero |			
	primo |
	secondo |
	terzo |
	quarto |
	quinto |
	sesto |
	settimo |
	ottavo |
	nono |
	decimo |
	undicesimo |
	dodicesimo

-) in the Preform grammar.

Include (-
Array LanguageNumbers table
	'uno' 1 'un' 1 'due' 2 'tre' 3 'quattro' 4 'cinque' 5
	'sei' 6 'sette' 7 'otto' 8 'nove' 9 'dieci' 10
	'undici' 11 'dodici' 12 'tredici' 13 'quattordici' 14 'quindici' 15
	'sedici' 16 'diciassette' 17 'diciotto' 18 'diciannove' 19 'venti' 20
	'ventuno' 21 'ventidue' 22 'ventitré' 23 'ventiquattro' 24
	'venticinque' 25 'ventisei' 26 'ventisette' 27 'ventotto' 28
	'ventinove' 29 'trenta' 30
;

[ LanguageNumber n f;
	if (n==0)    { print "zero"; rfalse; }
	if (n<0)     { print "meno "; n=-n; }
	#Iftrue (WORDSIZE == 4);
	if (n >= 1000000000) {
		if (f == 1) print ", ";
		if (n<2000000000) print "un miliardo"; 
		if (n>=2000000000) print (LanguageNumber) n/1000000000, " miliardi"; 
		n = n%1000000000; f = 1;
	}
	if (n >= 1000000) {
		if (f == 1) print ", ";
		if (n<2000000) print "un milione"; 
		if (n>=2000000) print (LanguageNumber) n/1000000, " milioni"; 
		n = n%1000000; f = 1;
	}
	#Endif;
	if (n >= 1000) {
		if (f == 1) print ", ";
		if (n<2000) print "mille"; 
		if (n>=2000) print (LanguageNumber) n/1000, "mila"; 
		n = n%1000; f = 0;
	}
	if (n>=100)  { 
		if (f==1) print ", "; 
		if (n<200) print "cento"; 
		if (n>=200) print (LanguageNumber) n/100, "cento"; 
		n=n%100; f=1; 
	}

	if (n==0) rfalse;
	switch(n)
	{
		1:  print "uno";
		2:  print "due";
		3:  print "tre";
		4:  print "quattro";
		5:  print "cinque";
		6:  print "sei";
		7:  print "sette";
		8:  print "otto";
		9:  print "nove";
		10: print "dieci";
		11: print "undici";
		12: print "dodici";
		13: print "tredici";
		14: print "quattordici";
		15: print "quindici";
		16: print "sedici";
		17: print "diciassette";
		18: print "diciotto";
		19: print "diciannove";
		20 to 99:
			switch(n/10)
			{
				2:  print "vent";
					if (n%10 == 0) {print "i"; return; }
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "itré"; return; }
					if (n%10 > 1) {print "i"; LanguageNumber(n%10); return; }
				3:  print "trent";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
				4:  print "quarant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
				5:  print "cinquant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
				6:  print "sessant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
				7:  print "settant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; } 
				8:  print "ottant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
				9:  print "novant";
					if (n%10 == 1) {print "uno"; return; }
					if (n%10 == 3) {print "atré"; return; }
			}
			if (n%10 ~= 0)
			{
				print "a"; LanguageNumber(n%10);
			}
	}
];
-) instead of "Numbers" in "Language.i6t".

Part 2.2 - Nouns

Chapter 2.2.2 - Pronouns and possessives for the player

[The adaptive text viewpoint is the viewpoint of the player when we are
writing response texts which need to work in any tense, person or number.
For example, English uses first person plural, so we write "[We] [look] up."
as a message which could come out as "I look up", "you look up", "he looks up",
and so on. It's "[We]" not "[You]" because the adaptive text viewpoint is
first person plural, not second person singular.

The reason for choosing this in English was that all the pronouns and
possessive adjectives we needed happened to be different for first person
plural: we, us, ours, ourselves, our. We also need these pronouns to be
other than third-person, so that we can define [they], [them] and so on
to refer to objects and not the player. So in practice there are only four
possible choices a language extension can make:

	first person singular (in English: I, me, mine, myself, my)
	second person plural (in English: you, you, yours, yourself, your)
	first person singular (in English: we, us, ours, ourselves, our)
	second person plural (in English: you, you, yours, yourself, your)
]

The adaptive text viewpoint of the Italian language is second person singular.

[So now we define the following text substitutions:

	[tu], [ti], [te], [tuo],[tua],[lo]

and their capitalised forms, which start with "T" not "t".]

To say tu:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "io";
	if the story viewpoint is second person singular:
		say "tu";
	if the story viewpoint is third person singular:
		if the player is male:
			say "egli";
		otherwise:
			say "ella";
	if the story viewpoint is first person plural:
		say "noi";
	if the story viewpoint is second person plural:
		say "voi";
	if the story viewpoint is third person plural:
		if the player is male:
			say "essi";
		otherwise:
			say "esse".

To say ti:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "mi";
	if the story viewpoint is second person singular:
		say "ti";
	if the story viewpoint is third person singular:
		say "si";
	if the story viewpoint is first person plural:
		say "ci";
	if the story viewpoint is second person plural:
		say "si";
	if the story viewpoint is third person plural:
		say "si".

[Un'altra forma utile è il suffisso con valore di complemento oggetto -lo]
To say lo:
	if the prior named object is male:
		if the prior named object is singular-named: 
			say "lo";
		otherwise:
			say "li";
	if the prior named object is female:
		if the prior named object is singular-named: 
			say "la";
		otherwise:
			say "le".

To say te:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "me";
	if the story viewpoint is second person singular:
		say "te";
	if the story viewpoint is third person singular:
		if the player is male:
			say "lui";
		otherwise:
			say "lei";
	if the story viewpoint is first person plural:
		say "noi";
	if the story viewpoint is second person plural:
		say "voi";
	if the story viewpoint is third person plural:
		say "loro".

To say tuo:
	if the story viewpoint is first person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "miei";
			otherwise:
				say "mie";
		otherwise:
			if the prior named object is male:
				say "mio";
			otherwise:
				say "mia";
	if the story viewpoint is second person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "tuoi";
			otherwise:
				say "tue";
		otherwise:
			if the prior named object is male:
				say "tuo";
			otherwise:
				say "tua";
	if the story viewpoint is third person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "suoi";
			otherwise:
				say "sue";
		otherwise:
			if the prior named object is male:
				say "suo";
			otherwise:
				say "sua";
	if the story viewpoint is first person plural:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "nostri";
			otherwise:
				say "nostre";
		otherwise:
			if the prior named object is male:
				say "nostro";
			otherwise:
				say "nostra";
	if the story viewpoint is second person plural:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "vostri";
			otherwise:
				say "vostre";
		otherwise:
			if the prior named object is male:
				say "vostro";
			otherwise:
				say "vostra";
	if the story viewpoint is third person plural:
		say "loro".

[In Italiano tuo/suo... seguono per la concordanza elementi che nel corso
del periodo li seguono, pertanto la costruzione originale con il prior named
object risulta farraginosa. In generale nei responsi la forma più usata è al femminile
singolare, da cui la defizione di tua.]

To say tua:
	if the story viewpoint is first person singular:
		say "mia";
	if the story viewpoint is second person singular:
		say "tua";
	if the story viewpoint is third person singular:
		say "sua";
	if the story viewpoint is first person plural:
		say "nostra";
	if the story viewpoint is second person plural:
		say "vostra";
	if the story viewpoint is third person plural:
		say "loro".

To say Tua:
	if the story viewpoint is first person singular:
		say "Mia";
	if the story viewpoint is second person singular:
		say "Tua";
	if the story viewpoint is third person singular:
		say "Sua";
	if the story viewpoint is first person plural:
		say "Nostra";
	if the story viewpoint is second person plural:
		say "Vostra";
	if the story viewpoint is third person plural:
		say "Loro".

[And now the capitalised forms, which are identical otherwise.]

To say Tu:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "Io";
	if the story viewpoint is second person singular:
		say "Tu";
	if the story viewpoint is third person singular:
		if the player is male:
			say "Egli";
		otherwise:
			say "Ella";
	if the story viewpoint is first person plural:
		say "Noi";
	if the story viewpoint is second person plural:
		say "Voi";
	if the story viewpoint is third person plural:
		if the player is male:
			say "Essi";
		otherwise:
			say "Esse".

To say Ti:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "Mi";
	if the story viewpoint is second person singular:
		say "Ti";
	if the story viewpoint is third person singular:
		say "Si";
	if the story viewpoint is first person plural:
		say "Ci";
	if the story viewpoint is second person plural:
		say "Si";
	if the story viewpoint is third person plural:
		say "Si".

To say Te:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "Me";
	if the story viewpoint is second person singular:
		say "Te";
	if the story viewpoint is third person singular:
		if the player is male:
			say "Lui";
		otherwise:
			say "Lei";
	if the story viewpoint is first person plural:
		say "Noi";
	if the story viewpoint is second person plural:
		say "Voi";
	if the story viewpoint is third person plural:
		say "Loro".

[]

To say Tuo:
	if the story viewpoint is first person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "Miei";
			otherwise:
				say "Mie";
		otherwise:
			if the prior named object is male:
				say "Mio";
			otherwise:
				say "Mia";
	if the story viewpoint is second person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "Tuoi";
			otherwise:
				say "Tue";
		otherwise:
			if the prior named object is male:
				say "Tuo";
			otherwise:
				say "Tua";
	if the story viewpoint is third person singular:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "Suoi";
			otherwise:
				say "Sue";
		otherwise:
			if the prior named object is male:
				say "Suo";
			otherwise:
				say "Sua";
	if the story viewpoint is first person plural:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "Nostri";
			otherwise:
				say "Nostre";
		otherwise:
			if the prior named object is male:
				say "Nostro";
			otherwise:
				say "Nostra";
	if the story viewpoint is second person plural:
		if the prior named object is plural-named:
			if the prior named object is male:
				say "Vostri";
			otherwise:
				say "Vostre";
		otherwise:
			if the prior named object is male:
				say "Vostro";
			otherwise:
				say "Vostra";
	if the story viewpoint is third person plural:
		say "Loro".

Chapter 2.2.3 - Pronouns and possessives for other objects

[These are similar, but easier. They are named from the third-person viewpoint
with the same number as the adaptive text viewpoint. We define:

	[che] = that
	[essi] = it as subject
	[le] = it as object
	[suo] = its as adjective, e.g., "its temperature"
	[il suo] = its as possessive pronoun, e.g., "that label is its"

and similarly for its capitalised forms.]

To say che:
	let the item be the prior named object;
	if the item is the player:
		say "[te]";
	otherwise:
		say "che".

To say essi:
	let the item be the prior named object;
	if the item is the player:
		say "[tu]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "essi";
			otherwise:
				say "esse";
		otherwise:
			if the item is male:
				say "egli";
			otherwise:
				say "ella".

To say le:
	let the item be the prior named object;
	if the item is the player:
		say "[te]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "gli";
			otherwise:
				say "le";
		otherwise:
			if the item is male:
				say "lui";
			otherwise:
				say "lei".

To say suo:
	let the item be the prior named object;
	if the item is the player:
		say "[tuo]";
	otherwise:
		if the item is plural-named:
			say "loro";
		otherwise:
			if the item is male:
				say "suo";
			otherwise:
				say "sua".

To say sua-loro:
	let the item be the prior named object;
	if the item is plural-named:
		say "loro";
	otherwise:
		say "sua".

To say il suo:
	let the item be the prior named object;
	if the item is plural-named:
		if the item is male:
			say "i loro";
		otherwise:
			say "le loro";
	otherwise:
		if the item is male:
			say "il suo";
		otherwise:
			say "la sua".
				
[ Here are the capitalized forms. ]

To say Che:
	let the item be the prior named object;
	if the item is the player:
		say "[Te]";
	otherwise:
		say "Che".

To say Essi:
	let the item be the prior named object;
	if the item is the player:
		say "[Tu]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "Essi";
			otherwise:
				say "Esse";
		otherwise:
			if the item is male:
				say "Egli";
			otherwise:
				say "Ella".

To say Le:
	let the item be the prior named object;
	if the item is the player:
		say "[Te]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "Gli";
			otherwise:
				say "Le";
		otherwise:
			if the item is male:
				say "Lui";
			otherwise:
				say "Lei".

To say Suo:
	let the item be the prior named object;
	if the item is the player:
		say "[Tuo]";
	otherwise:
		if the item is plural-named:
			say "Loro";
		otherwise:
			if the item is male:
				say "Suo";
			otherwise:
				say "Sua".

To say Sua-loro:
	let the item be the prior named object;
	if the item is plural-named:
		say "Loro";
	otherwise:
		say "Sua".

To say Il Suo:
	let the item be the prior named object;
	if the item is plural-named:
		if the item is male:
			say "I loro";
		otherwise:
			say "Le loro";
	otherwise:
		if the item is male:
			say "Il suo";
		otherwise:
			say "La sua".


Chapter 2.2.4 - Directions

North translates into Italian as il nord.
South translates into Italian as il sud.
East translates into Italian as l'est.
West translates into Italian as l'ovest.
Northeast translates into Italian as il nord-est.
Southwest translates into Italian as il sud-ovest.
Southeast translates into Italian as il sud-est.
Northwest translates into Italian as il nord-ovest.
Inside translates into Italian as davanti.
Outside translates into Italian as dietro.
Up translates into Italian as alto.
Down translates into Italian as basso.

Understand "sinistra" as west.
Understand "o" as west.
Understand "destra" as east.
Understand "e" as east.
Understand "sali" as up.

Understand the command "no" as something new.
Understand "nordest" or "ne" as northeast.
Understand "nordovest" or "no" as northwest.
Understand "sudovest" or "so" as southwest.
Understand "sudest" or "se" as southeast.

Up is proper-named.
Down is proper-named.
Inside is proper-named.
Outside is proper-named.

Chapter 2.2.5 - Kinds

Section 2.2.5.1 - In the Standard Rules

[One day we will also want to translate the names of more abstract kinds, but
for now, we'll just translate kinds of objects. This ensures that if we write:

	Quatre hommes sont dans la Théâtre.

then (a) Inform will recognise these as instances of the kind "man", and (b)
it will give them each the printed name "homme" (not "man").
]

A room translates into Italian as una stanza.
A thing translates into Italian as una cosa.
A door translates into Italian as una porta.
A container translates into Italian as un contenitore.
A vehicle translates into Italian as un veicolo.
A player's holdall translates into Italian as un inventario.
A supporter translates into Italian as un supporto.
A backdrop translates into Italian as un fondale.
A person translates into Italian as una persona.
A man translates into Italian as un uomo.
A woman translates into Italian as una femmina.
A animal translates into Italian as un animale.
A device translates into Italian as un dispositivo.
A direction translates into Italian as una direzione.
A region translates into Italian as una regione.

Section 2.2.5.2 - In Rideable Vehicles (for use with Rideable Vehicles by Graham Nelson)

A rideable animal translates into Italian as un animale montabile.
A rideable vehicle translates into Italian as un veicolo montabile.

Section 2.2.5.3 - In Locksmith (for use with Locksmith by Emily Short)

A passkey translates into Italian as una chiave universale.
A keychain translates into Italian as un portachiavi.

Chapter 2.2.6 - Plurals 

[Le cose in italiano sono decisamente più convolute. Questa parte è da rivedere.]

Include (-
language Italian

<singular-noun-to-its-plural> ::=
	<it-plural-exceptions> |
	... <it-plural-by-ending> 

[I nomi in -gia -cia conservano la i al plurale se tali suffissi sono seguiti da vocale.]

<it-plural-exceptions> ::=
	valigia			valigie |
	ciliegia			ciliegie

<it-plural-by-ending> ::=
	*s			0 |				[tas -> tas]
	*a			1e |			[tassa -> tasse]
	*o			1i |			[tasso -> tassi]
	*glio			1		[taglio -> tagli]

-) in the Preform grammar.

Chapter 2.2.7 - Cases

[This will be significant for languages like German, but for French there's
nothing to do.]

Chapter 2.2.8 - Times of day

Include (-
[ PrintTimeOfDay t h aop;
	if (t<0) { print "<nessuna ora>"; return; }
	if (t >= TWELVE_HOURS) { aop = "pm"; t = t - TWELVE_HOURS; } else aop = "am";
	h = t/ONE_HOUR; if (h==0) h=12;
	print h, ":";
	if (t%ONE_HOUR < 10) print "0"; print t%ONE_HOUR, " ", (string) aop;
];
-) instead of "Digital Printing" in "Time.i6t".

Include (-
[ PrintTimeOfDayEnglish t h m dir aop say_minutes quad;
	! adapted the spanish version by Sebastian Arg
	quad = 1; ! =1 es la primera media hora, =2 es la segunda
	h = (t/60) % 12; m = t%60; if (h==0) h=12;
	if (m==0) { if(h==1) {print "un'" ;print "ora"; return ;} else print (number) h;print " ore"; return; } !infsp hack
	dir = "ore";! infsp hack
	if (m > 30) { m = 60-m; h = (h+1)%12; if (h==0) h=12; dir = "ore meno"; quad=2; } !infsp hack
	switch(m) {
		1: say_minutes = "un";
		2: say_minutes = "due";
		3: say_minutes = "tre";
		4: say_minutes = "quattro";
		5: say_minutes = "cinque";
		6: say_minutes = "sei";
		7: say_minutes = "sette";
		8: say_minutes = "otto";
		9: say_minutes = "nove";
		10: say_minutes = "dieci";
		11: say_minutes = "undici";
		12: say_minutes = "dodici";
		13: say_minutes = "tredici";
		14: say_minutes = "quattordici";
		15: if (quad==2) say_minutes = "un quarto"; else say_minutes = "e un quarto";
		16: say_minutes = "sedici";
		17: say_minutes = "diciassette";
		18: say_minutes = "diciotto";
		19: say_minutes = "diciannove";
		20: say_minutes = "venti";
		21: say_minutes = "ventuno";
		22: say_minutes = "ventidue";
		23: say_minutes = "ventitré";
		24: say_minutes = "ventiquattro";
		25: say_minutes = "venticinque";
		26: say_minutes = "ventisei";
		27: say_minutes = "ventisette";
		28: say_minutes = "ventotto";
		29: say_minutes = "ventinove";
		30: say_minutes = "e mezzo";
		default: 
			if (quad == 2){
				print (number) m;
				if (m%5 ~= 0) {
					if (m == 1) print " minuto"; else print " minuti"; ! infsp hack
				}
			}
			if (quad == 1){
				if (h==1) { print (number) h," ore "; print (number) m; } else print (number) h," ore "; print (number) m;
				if (m%5 ~= 0) {
					if (m == 1) print ""; else print ""; ! infsp hack
				}
			}
			return;
	}
	if (h==1) print "un"; else print (number) h; print " ", (string) dir, " ", (string) say_minutes;!infsp hack
];
-) instead of "Analogue Printing" in "Time.i6t".

Include (-
[ LanguageTimeOfDay hours mins;
	print hours/10, hours%10, "h", mins/10, mins%10;
];
-) instead of "Time" in "Language.i6t".

Part 2.3 - Adjectives

[Adjectives have six forms: neuter singular, neuter plural, masculine singular,
masculine plural, feminine singular, feminine plural. They're constructed
using tries:

	n.s.		(base text unchanged)
	n.p.		base modified by <adjective-to-plural>
	m.s.		base modified by <adjective-to-masculine-singular>
	m.p.		base modified by <adjective-to-masculine-singular>
				then further by <adjective-to-masculine-plural>
	f.s.		base modified by <adjective-to-feminine-singular>
	f.p.		base modified by <adjective-to-feminine-singular>
				then further by <adjective-to-feminine-plural>

For Italian, of course, there's no neuter, so the following are easy:]

Include (-
language Italian

<adjective-to-masculine-singular> ::=
	*		0

<adjective-to-masculine-plural> ::=
	<it-adjective-to-masculine-plural-exceptions> |
	...	<it-adjective-to-masculine-plural-by-ending> |
	... <adjective-to-plural>

<adjective-to-plural> ::=
	*		1i

<it-adjective-to-masculine-plural-exceptions> ::=
	rosa		rosa |
	viola		viola |
	indaco		indaco |
	blu			blu |
	snob		snob |
	antinebbia	antinebbia |
	perbene		perbene |
	dabbene		dabbene |
	magico		magici |
	politico		politici |
	restio		restii |
	pio			pii |
	savio		savi |
	serio		seri 

<it-adjective-to-masculine-plural-by-ending> ::=
	*logo		2gi |				[teologo -> teologi]
	*fago		2gi |
	*go			2ghi |			[largo -> larghi]
	*co			2chi 			[bianco -> bianchi]
	
<adjective-to-feminine-singular> ::=
	<it-adjective-to-feminine-singular-exceptions> |
	...	<it-adjective-to-feminine-singular-by-ending> |
	... <it-adjective-to-feminine-default>

<it-adjective-to-feminine-singular-exceptions> ::=
	rosa		rosa |
	viola		viola |
	indaco		indaco |
	blu			blu |
	snob		snob |
	antinebbia	antinebbia |
	perbene		perbene |
	dabbene		dabbene |


<it-adjective-to-feminine-singular-by-ending> ::=
	*tore		4trice |
	*o			1a			

<it-adjective-to-feminine-default> ::=
	*			1a

<adjective-to-feminine-plural> ::=
	<it-adjective-unagreeing> |
	...	<it-adjective-to-feminine-plural-by-ending> |
	... <it-adjective-to-plural-fem>

<it-adjective-unagreeing> ::=
	rosa		rosa |
	viola		viola |
	indaco		indaco |
	blu			blu |
	snob		snob |
	antinebbia	antinebbia |
	perbene		perbene |
	dabbene		dabbene |
	
<it-adjective-to-feminine-plural-by-ending> ::=
	*co	2che |
	*go	2ghe |
	*io	2ie |
	*acio	3cie |
	*ecio	3cie |
	*icio	3cie |
	*ocio	3cie |
	*ucio	3cie |
	*cio		3ce |
	*agio	3gie |
	*egio	3gie |
	*igio	3gie |
	*ogio	3gie |
	*ugio	3gie |
	*gio		3ge
	
<it-adjective-to-plural-fem> ::=
	*	1e

-) in the Preform grammar.

Part 2.4 - Verbs

Chapter 2.4.1 - Verb conjugations

[Now we need to give instructions on how to conjugate verbs. See also the
published guide to Inform syntax, which goes through the English case; but
the French case below shows off features not needed for English, so it's a
better example to follow for other languages.]


Include (-
language Italian

[Avere o Essere?

>--> A small set of verbs conjugates with avere when used transitively, but
with essere when used intransitively:
Inform doesn't know when it prints a verb whether it's being used transitively
or not, so it has to make a decision: and we're going to conjugate all of these
cases with "avere". So our present perfect and past perfect forms of these
verbs will be wrong when they're used intransitively. (But of course if they
are being used in Inform source text then they must be transitive anyway; so
this will only affect printed output in games told in the perfect tenses, which
I can't imagine many people will want to do.)]

[>--> E' molto importante che i verbi irregolari vengano prima dei regolari nel
seguente elenco, in modo tale da poter modificare efficacemente solamente
i modi e i tempi irregolari.]

<verb-conjugation-instructions> ::=
[Auxiliary verbs]
	essere 		<it-essere-conjugation> |
	avere	 	<it-avere-conjugation> |
[Irregular verbs]
	andare	 	<it-andare-conjugation> |
	arrivare 	<it-arrivare-conjugation> |
	stare 		<it-stare-conjugation> |
	cadere 		<it-cadere-conjugation> |
	aprire		<it-aprire-conjugation> |
	guardare		<it-guardare-conjugation> |
	mangiare	<it-mangiare-conjugation> |
	dovere		<it-dovere-conjugation> |
	potere		<it-potere-conjugation> |
	possedere	<it-possedere-conjugation> |   [LEO]
	tenere	<it-tenere-conjugation> |   [LEO]
	togliere	<it-togliere-conjugation> |   [LEO]
	lasciare	<it-lasciare-conjugation> |   [LEO]
	fare			<it-fare-conjugation> |
	bloccare		<it-bloccare-conjugation> |
	sbloccare	<it-sbloccare-conjugation> |
	capire			<it-incoativi-terza-conjugation> |
[Regular -ARE verbs]
	-are 		<it-avere-prima-conjugation> |		[e.g., "donare"]
[Regular -ERE verbs]	
	-ere 		<it-avere-seconda-conjugation> |	[e.g., "svendere"]
[Regular -IRE verbs]
	-ire			<it-avere-terza-conjugation> 

[So here goes with avere, which is not very irregular, but we'll need it as
an auxiliary later.

Note the presence of the asterisks when the past participle is used; "3+*"
expands to the past participle with an asterisk on the end. The closing
asterisk tells Inform that the word marked has to follow adjectival agreement
rules with the subject of the verb - something which doesn't happen for
English, where the asterisks are never used. ]

<it-avere-conjugation> ::=
	2 		avendo |
	3 		avuto |
	<it-avere-tabulation>

<it-avere-tabulation> ::=
	a1+		<it-avere-present> |
	a1-		non <it-avere-present> |
	a2+		<it-avere-past> |
	a2-		non <it-avere-past> |
	a3		<it-avere-perfect> |
	a4		<it-avere-pluperfect> |
	a5+		<it-avere-future> |
	a5-		non <it-avere-future> |
	a6+		<it-avere-past-historic> |
	a6-		non <it-avere-past-historic> |
	p*		3+*	

<it-avere-present> ::=
	ho | hai | ha | abbiamo | avete | hanno

<it-avere-past> ::=
	avevo | avevi | aveva | avevamo | avevate | avevano
	
<it-avere-perfect> ::=
	ho 3 | hai 3 | ha 3 | abbiamo 3 | avete 3 | hanno 3

<it-avere-pluperfect> ::=
	avevo 3 | avevi 3 | aveva 3 | avevamo 3 | avevate 3 | avevano 3

<it-avere-past-historic> ::=
	ebbi | avesti | ebbe | avemmo | aveste | ebbero

<it-avere-future> ::=
	avrò | avrai | avrà | avremo | avrete | avranno

<it-essere-conjugation> ::=
	2		essendo |
	3		stato |
	4		stati  |
	<it-essere-tabulation>

<it-essere-tabulation> ::=
	a1+		<it-essere-present> |
	a1-		non <it-essere-present> |
	a2+		<it-essere-past> |
	a2-		non <it-essere-past> |
	a3		<it-essere-perfect> |
	a4		<it-essere-pluperfect> |
	a5+		<it-essere-future> |
	a5-		non <it-essere-future> |
	a6+		<it-essere-past-historic> |
	a6-		non <it-essere-past-historic> |
	p*		3+*

<it-essere-present> ::=
	sono | sei | è | siamo | siete | sono

<it-essere-past> ::=
	ero |	eri | era | eravamo | eravate | erano

<it-essere-perfect> ::=
	sono 3 | sei  3 | è 3 | siamo 4 | siete 4 | sono 4

<it-essere-pluperfect> ::=
	ero 3 | eri  3 | era 3 | eravamo 4 | eravate 4 | erano 4

<it-essere-past-historic> ::=
	fui | fosti | fu | fummo | foste | furono

<it-essere-future> ::=
	sarò |	sarai | sarà | saremo | sarete | saranno

[
---> Italian : "ANDARE" verb. <----
]

<it-andare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	4		5+ati |
	<it-andare-tabulation>

<it-andare-tabulation> ::=
	a1		<it-andare-present> |
	a2		<it-prima-past> |
	a3		<it-essere-perfect> |
	a4		<it-essere-pluperfect> |
	a5		<it-andare-future> |
	a6		<it-andare-past-historic> |
	a7		<it-stare-plufuture> |
	p*		3+*

<it-andare-present> ::=
	vado | vai | va | 5+iamo | 5+ate | vanno

<it-andare-future> ::=
	5+rò | 5+rai | 5+rà | 5+remo | 5+rete | 5+ranno

<it-andare-past-historic> ::=
	5+ai | 5+asti | 5+ò | 5+ammo | 5+aste | 5+arono

[
---> Italian : "ARRIVARE" verb. <----
]

<it-arrivare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	4		5+ati |
	<it-arrivare-tabulation>

<it-arrivare-tabulation> ::=
	a1		<it-prima-present> |
	a2		<it-prima-past> |
	a3		<it-essere-perfect> |
	a4		<it-essere-pluperfect> |
	a5		<it-arrivare-future> |
	a6		<it-andare-past-historic> |
	a7		<it-stare-plufuture> |
	p*		3+*

<it-arrivare-future> ::=
	5+erò | 5+erai | 5+erà | 5+eremo | 5+erete | 5+eranno


[
---> Italian : "STARE" verb. <----
]

<it-stare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	4		5+ati |
	<it-stare-tabulation>

<it-stare-tabulation> ::=
	a1		<it-stare-present> |
	a2		<it-prima-past> |
	a3		<it-essere-perfect> |
	a4		<it-essere-pluperfect> |
	a5		<it-stare-future> |
	a6		<it-stare-past-historic> |
	a7		<it-stare-plufuture> |
	p*		3+*

<it-stare-present> ::=
	5+o | 5+ai | 5+a | 5+iamo | 5+ate | 5+anno

<it-stare-future> ::=
	5+arò | 5+arai | 5+arà | 5+aremo | 5+arete | 5+aranno

<it-stare-past-historic> ::=
	5+etti | 5+esti | 5+este | 5+emmo | 5+este | 5+ettero

<it-stare-plufuture> ::=
	sarò 3 |	sarai 3 | sarà 3 | saremo 4 | sarete 4 | saranno 4	

[
--------> Italian : "GUARDARE" verb. <-------
]

<it-guardare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-guardare-tabulation>

<it-guardare-tabulation> ::=
	a1		<it-prima-present> |
	a2		<it-prima-past> |
	a3		<it-avere-perfect> |
	a4		<it-avere-pluperfect> |
	a5		<it-prima-future> |
	a6		<it-guardare-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-guardare-past-historic> ::=
	5+ai | 5+asti | 5+ò | 5+ammo | 5+aste | 5+arono

[
---> Italian : "MANGIARE" verb. <----
]

<it-mangiare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-mangiare-tabulation>

<it-mangiare-tabulation> ::=
	a1		<it-mangiare-present> |
	a2		<it-prima-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-mangiare-future> |
	a6		<it-mangiare-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-mangiare-present> ::=
	5+o | 5 | 5+a | 5+amo | 5+ate | 5+ano

<it-mangiare-future> ::=
	mangerò | mangerai | mangerà | mangeremo | mangerete | mangeranno

<it-mangiare-past-historic> ::=
	5+ai | 5+asti | 5+ò | 5+ammo | 5+aste | 5+arono

[
---> Italian : "DOVERE" verb. <----
]

<it-dovere-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+endo |
	3		5+uto |
	4		dev |
	<it-dovere-tabulation>

<it-dovere-tabulation> ::=
	a1		<it-dovere-present> |
	a2		<it-potere-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-dovere-future> |
	a6		<it-dovere-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-dovere-present> ::=
	4+o | 4+i | 4+e | dobbiamo | 4+ete | 4+ono

<it-dovere-future> ::=
	5+rò | 5+rai | 5+rà | 5+remo | 5+rete | 5+ranno

<it-dovere-past-historic> ::=
	5+etti | 5+esti | 5+ette | 5+emmo | 5+este | 5+ettero

[
---> Italian : "POTERE" verb. <----
]

<it-potere-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+endo |
	3		5+uto |
	<it-potere-tabulation>

<it-potere-tabulation> ::=
	a1		<it-potere-present> |
	a2		<it-potere-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-dovere-future> |
	a6		<it-potere-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-potere-present> ::=
	posso | puoi | può | possiamo | potete | possono

<it-potere-past> ::=
	5+evo | 5+evi | 5+eva | 5+evamo | 5+evate | 5+evano

<it-potere-past-historic> ::=
	5+ei | 5+esti | 5+ette | 5+emmo | 5+este | 5+ettero


[LEO]
[
---> Italian : "POSSEDERE" verb. <----
]

<it-possedere-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+endo |
	3		5+uto |
	<it-possedere-tabulation>

<it-possedere-tabulation> ::=
	a1		<it-possedere-present> |
	a2		<it-possedere-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-possedere-future> |
	a6		<it-possedere-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-possedere-present> ::=
	possiedo | possiedi | possiede | 5+iamo | 5+ete | possiedono

<it-possedere-past> ::=
	5+evo | 5+evi | 5+eva | 5+evamo | 5+evate | 5+evano

<it-possedere-future> ::=
	5+erò | 5+erai | 5+erete | 5+eremo | 5+erete | 5+eranno

<it-possedere-past-historic> ::=
	5+ei | 5+esti | 5+ette | 5+emmo | 5+este | 5+ettero

[LEO]
[
---> Italian : "TENERE" verb. <----
]

<it-tenere-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+endo |
	3		5+uto |
	<it-tenere-tabulation>

<it-tenere-tabulation> ::=
	a1		<it-tenere-present> |
	a2		<it-tenere-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-tenere-future> |
	a6		<it-tenere-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-tenere-present> ::=
	tengo | tieni | tiene | 5+iamo | 5+ete | tengono

<it-tenere-past> ::=
	5+evo | 5+evi | 5+eva | 5+evamo | 5+evate | 5+evano

<it-tenere-future> ::=
	terrò | terrai | terrà | terremo | terrete | terranno

<it-tenere-past-historic> ::=
	tenni | 5+esti | 5+ette | 5+emmo | 5+este | tenerono
	
[LEO]
[
---> Italian : "TOGLIERE" verb. <----
]

<it-togliere-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+endo |
	3		tolto |
	<it-togliere-tabulation>

<it-togliere-tabulation> ::=
	a1		<it-togliere-present> |
	a2		<it-togliere-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-togliere-future> |
	a6		<it-togliere-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-togliere-present> ::=
	tolgo | togli | toglie | 5+amo | 5+ete | tolgono

<it-togliere-past> ::=
	5+evo | 5+evi | 5+eva | 5+evamo | 5+evate | 5+evano

<it-togliere-future> ::=
	5+erò | 5+erai | 5+erete | 5+eremo | 5+erete | 5+eranno

<it-togliere-past-historic> ::=
	tolsi | 5+esti | tolse | 5+emmo | 5+este | tolsero

[LEO]
[
---> Italian : "LASCIARE" verb. <----
]

<it-lasciare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-lasciare-tabulation>

<it-lasciare-tabulation> ::=
	a1		<it-lasciare-present> |
	a2		<it-lasciare-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5		<it-lasciare-future> |
	a6		<it-lasciare-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-lasciare-present> ::=
	lascio | lasci | lascia | 5+iamo | 5+ate | lasciano

<it-lasciare-past> ::=
	5+avo | 5+avi | 5+ava | 5+avamo | 5+avate | 5+avano

<it-lasciare-future> ::=
	lascerò | lascerai | lascerete | lasceremo | lascerete | lasceranno

<it-lasciare-past-historic> ::=
	5+ai | 5+asti | 5+ò | 5+ammo | 5+aste | 5+arono
			
[
--------> Italian : "FARE" verb. <-------
]

<it-fare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+acendo |
	3		5+atto |
	<it-fare-tabulation>

<it-fare-tabulation> ::=
	a1		<it-fare-present> |
	a2		<it-fare-past> |
	a3		<it-avere-perfect> |
	a4		<it-avere-pluperfect> |
	a5		<it-fare-future> |
	a6		<it-fare-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-fare-present> ::=
	faccio | fai | fa | facciamo | fate | fanno

<it-fare-past> ::=
	facevo | facevi | faceva | facevamo | facevate | facevano
	
<it-fare-past-historic> ::=
	feci | facesti | fece | facemmo | faceste | fecero

<it-fare-future> ::=
	5+arò | 5+arai | 5+arà | 5+aremo | 5+arete | 5+aranno

[
--------> Italian : "BLOCCARE e SBLOCCARE" verb. <-------
]

<it-bloccare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-bloccare-tabulation>

<it-sbloccare-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-bloccare-tabulation>

<it-bloccare-tabulation> ::=
	a1		<it-bloccare-present> |
	a2		<it-prima-past> |
	a3		<it-avere-perfect> |
	a4		<it-avere-pluperfect> |
	a5		<it-bloccare-future> |
	a6		<it-prima-past-historic> |
	a7		<it-avere-future> 3 |
	p*		3+*

<it-bloccare-present> ::=
	5+o | 5+hi | 5+a | 5+hiamo | 5+ate | 5+ano

<it-bloccare-future> ::=
	5+herò | 5+herai | 5+herà | 5+heremo | 5+herete | 5+heranno

[
---> Italian "first conjugation": regular -ARE verbs. <----
]

<it-first-stem-general> ::=
	*	3					[drop the last three letters: donare-> don]

<it-avere-prima-conjugation> ::=
	5 		<it-first-stem-general>	|
	2		5+ando |
	3		5+ato |
	<it-avere-prima-tabulation>

[Al momento non serve differenziare plurale e singolare nel gerundio]

<it-avere-prima-tabulation> ::=
	a1+		<it-prima-present> |
	a1-		non <it-prima-present> |
	a2+		<it-prima-past> |
	a2-		non <it-prima-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5+		<it-prima-future> |
	a5-		non <it-prima-future> |
	a6+		<it-prima-past-historic> |
	a6-		non <it-prima-past-historic> |
	a7		( t5 avere ) 3 |
	p*		3+*

<it-prima-present> ::=
	5+o | 5+i | 5+a | 5+iamo | 5+ate | 5+ano

<it-prima-past> ::=
	5+avo | 5+avi | 5+ava | 5+avamo | 5+avate | 5+avano

<it-prima-future> ::=
	5+erò | 5+erai | 5+erà | 5+eremo | 5+erete | 5+eranno

<it-prima-past-historic> ::=
	5+ai | 5+asti | 5+ò | 5+ammo | 5+aste | 5+arono

<it-prima-future> ::=
	5+erò | 5+erai | 5+à | 5+eremo | 5+erete | 5+eranno

[
---> Italian "second conjugation": regular -ERE verbs. <----
]

<it-seconda-stem> ::=		[this is not much of a trie:]
	*	3					[in all cases drop the last two letters: finir -> fin]

<it-avere-seconda-conjugation> ::=
	5 <it-seconda-stem>	|
	2		5+endo |
	3		5+uto |
	<it-avere-seconda-tabulation>

<it-avere-seconda-tabulation> ::=
	a1+		<it-seconda-present> |
	a1-		non <it-seconda-present> |
	a2+		<it-seconda-past> |
	a2-		non <it-seconda-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5+		<it-seconda-future> |
	a5-		non <it-seconda-future> |
	a6+		<it-seconda-past-historic> |
	a6-		non <it-seconda-past-historic> |
	a7		( t5 avere ) 3 |
	p*		3+*

<it-seconda-present> ::=
	5+o | 5+i | 5+e | 5+iamo | 5+ete | 5+ono

<it-seconda-past> ::=
	5+evo | 5+evi | 5+eva | 5+evamo | 5+evate | 5+evano

<it-seconda-future> ::=
	5+erò | 5+erai | 5+erà | 5+eremo | 5+erete | 5+eranno
	
<it-seconda-past-historic> ::=
	5+ei | 5+esti | 5+é | 5+emmo | 5+este | 5+erono

<it-seconda-future> ::=
	5+erò | 5+erai | 5+erà | 5+eremo | 5+erete | 5+eranno

[
---> Italian "third conjugation": regular -IRE verbs. <----
]
<it-terza-stem> ::=		
	*	3					[in all cases drop the last three letters]

<it-avere-terza-conjugation> ::=
	5 <it-terza-stem> |
	2		5+endo |
	3		5+ito |
	<it-avere-terza-tabulation>

<it-avere-terza-tabulation> ::=
	a1+		<it-terza-present> |
	a1-		non <it-terza-present> |
	a2+		<it-terza-past> |
	a2-		non <it-terza-past> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5+		<it-terza-future> |
	a5-		non <it-terza-future> |
	a6+		<it-terza-past-historic> |
	a6-		non <it-terza-past-historic> |
	a7		( t5 avere ) 3 |
	p*		3+*

<it-terza-present> ::=
	5+o | 5+i | 5+e | 5+iamo | 5+ite | 5+ono

<it-terza-past> ::=
	5+ivo |	5+ivi | 5+iva | 5+ivamo | 5+ivate | 5+ivano

<it-terza-past-historic> ::=
	5+ii | 5+isti | 5+ì | 5+immo | 5+iste | 5+irono

<it-terza-future> ::=
	5+irò | 5+irai | 5+irà | 5+iremo | 5+irete | 5+iranno

[
---> Italian "third conjugation": aprire. <----
]
<it-terza-stem> ::=		
	*	3					[in all cases drop the last three letters]

<it-aprire-conjugation> ::=
	5 <it-terza-stem> |
	2		5+endo |
	3		aperto |
	<it-avere-terza-tabulation>


[
---> Italian "third conjugation": incoativi. <----
]
<it-terza-stem-inc> ::=		
	*	3					[in all cases drop the last three letters]

<it-incoativi-terza-conjugation> ::=
	5 <it-terza-stem-inc> |
	2		5+endo |
	3		5+ito |
	<it-incoativi-terza-tabulation>

<it-incoativi-terza-tabulation> ::=
	a1+		<it-terza-present-inc> |
	a1-		non <it-terza-present-inc> |
	a2+		<it-terza-past-inc> |
	a2-		non <it-terza-past-inc> |
	a3		( t1 avere ) 3 |
	a4		( t2 avere ) 3 |
	a5+		<it-terza-future-inc> |
	a5-		non <it-terza-future-inc> |
	a6+		<it-terza-past-historic-inc> |
	a6-		non <it-terza-past-historic-inc> |
	a7		( t5 avere ) 3 |
	p*		3+*

<it-terza-present-inc> ::=
	5+isco | 5+isci | 5+isce | 5+iamo | 5+ite | 5+iscono

<it-terza-past-inc> ::=
	5+ivo |	5+ivi | 5+iva | 5+ivamo | 5+ivate | 5+ivano

<it-terza-past-historic-inc> ::=
	5+ii | 5+isti | 5+ì | 5+immo | 5+iste | 5+irono

<it-terza-future-inc> ::=
	5+irò | 5+irai | 5+irà | 5+iremo | 5+irete | 5+iranno


[Just one more thing to do: reflexive verb...
Still to be implemented.]

-) in the Preform grammar.

Chapter 2.4.2 - Meaningful verbs

Section 2.4.2.1 - In the Standard Rules

[We declare Italian equivalents of all meaningful verbs built into the
Standard Rules.]

In Italian essere is a verb meaning to be.
In Italian avere is a verb meaning to have.
In Italian connettere is a verb meaning to relate.
In Italian fornire is a verb meaning to provide.
In Italian contenere is a verb meaning to contain.
In Italian supportare is a verb meaning to support.
In Italian sostenere is a verb meaning to support.
In Italian incorporare is a verb meaning to incorporate.
In Italian racchiudere is a verb meaning to enclose.
In Italian portare is a verb meaning to carry.
In Italian indossare is a verb meaning to wear.
In Italian tenere is a verb meaning to hold.
In Italian nascondere is a verb meaning to conceal.
In Italian sbloccare is a verb meaning to unlock.

Section 2.4.2.2 - In Rideable Vehicles (for use with Rideable Vehicles by Graham Nelson)

In Italian montar su is a verb meaning to mount.
In Italian scendere is a verb meaning to dismount.

Section 2.4.2.3 - In Locksmith (for use with Locksmith by Emily Short)

In Italian sbloccare is a verb meaning to unbolt.

Chapter 2.4.3 - Prepositions

[We need the following in order to make definitions of "prepositions" work
properly.]

Include (-
language Italian

<infinitive-usage-exceptional> ::=
	/c/ essere ...

-) in the Preform grammar.

In Italian essere dentro is a verb meaning to be in.
In Italian essere nella is a verb meaning to be in.
In Italian essere sopra is a verb meaning to be on.
In Italian essere parte di is a verb meaning to be part of.
In Italian essere superiore a is a verb meaning to be greater than.
In Italian essere inferiore a is a verb meaning to be less than.
In Italian essere almeno is a verb meaning to be at least.
In Italian essere al più is a verb meaning to be at most.
In Italian essere accanto is a verb meaning to be adjacent to.
In Italian essere sopra a is a verb meaning to be above.
In Italian essere sotto di is a verb meaning to be below.
In Italian essere di traverso is a verb meaning to be through.

Volume 3 - Responses

When play begins:
	now the description of yourself is "[regarding the player][maiuscolo][Sei][maiuscolo] sempre [lo] [stesso]."

Part 3.1 - Responses

Chapter 3.1.0 - Articulated Prepopositions

To decide which number is the artflag of (sostan - a thing):
	let c1 be character number 1 in the printed name of sostan;
	if c1 is "a" or c1 is "A" or c1 is "e" or c1 is "E" or c1 is "i" or c1 is "I" or c1 is "o" or c1 is "O" or c1 is "u" or c1 is "U", decide on 0;
	if c1 is "z" or c1 is "Z" or c1 is "x" or c1 is "X", decide on 1;
	let c2 be character number 2 in the printed name of sostan;
	if c1 is "s" or c1 is "S":
		if c2 is "a" or c2 is "A" or c2 is "e" or c2 is "E" or c2 is "i" or c2 is "I" or c2 is "o" or c2 is "O" or c2 is "u" or c2 is "U", decide on 2;
		decide on 1;
	if c1 is "p" or c1 is "P":
		if c2 is "s", decide on 1;
	if c1 is "g" or c1 is "G":
		if c2 is "n", decide on 1;
	decide on 2.

To decide which number is the artflag of (sostan - a room):
	let c1 be character number 1 in the printed name of sostan;
	if c1 is "a" or c1 is "A" or c1 is "e" or c1 is "E" or c1 is "i" or c1 is "I" or c1 is "o" or c1 is "O" or c1 is "u" or c1 is "U", decide on 0;
	if c1 is "z" or c1 is "Z" or c1 is "x" or c1 is "X", decide on 1;
	let c2 be character number 2 in the printed name of sostan;
	if c1 is "s" or c1 is "S":
		if c2 is "a" or c2 is "A" or c2 is "e" or c2 is "E" or c2 is "i" or c2 is "I" or c2 is "o" or c2 is "O" or c2 is "u" or c2 is "U", decide on 2;
		decide on 1;
	if c1 is "p" or c1 is "P":
		if c2 is "s", decide on 1;
	if c1 is "g" or c1 is "G":
		if c2 is "n", decide on 1;
	decide on 2.

Articulated preposition is a kind of value. Some articulated prepositions are defined by the Table of Prepositions. 

Table of Prepositions
Name	1Il	2Lo	3La	4I	5Gli	6Le	7L
dip	"del"	"dello"	"della"	"dei"	"degli"	"delle"	"dell[']"
ap	"al"	"allo"	"alla"	"ai"	"agli"	"alle"	"all[']"
dap	"dal"	"dallo"	"dalla"	"dai"	"dagli"	"dalle"	"dall[']"
inp	"nel"	"nello"	"nella"	"nei"	"negli"	"nelle"	"nell[']"
conp	"con il"	"con lo"	"con la"	"con i"	"con gli"	"con le"	"con l[']"
sup	"sul"	"sullo"	"sulla"	"sui"	"sugli"	"sulle"	"sull[']"
perp	"per il"	"per lo"	"per la"	"per i"	"per gli"	"per le"	"per l[']"
trap	"tra il"	"tra lo"	"tra la"	"tra i"	"tra gli"	"tra le"	"tra l[']"
frap	"fra il"	"fra lo"	"fra la"	"fra i"	"fra gli"	"fra le"	"fra l[']"

To say (p - an articulated preposition) the (obj - a thing):
	if obj is female:
		say "[if obj is plural-named][6Le of p] [otherwise if artflag of obj is 0][7L of p][otherwise][3La of P] [end if]";
	otherwise if artflag of obj is 2:
		say "[if obj is plural-named][4I of p] [otherwise][1Il of p] [end if]";
	otherwise:
		say "[if obj is plural-named][5Gli of p] [otherwise if artflag of obj is 0][7L of p][otherwise if artflag of obj is 1][2Lo of p] [end if]";
	say "[regarding the obj][obj]".

Chapter 3.1.1 - Responses in the Standard Rules

[Many thanks to Sarganar for the Collection of Responses]
In Italian stare is a verb.
In Italian guardare is a verb.
In Italian aprire is a verb.
In Italian fare is a verb.
In Italian sembrare is a verb.
In Italian prendere is a verb.
In Italian mettere is a verb.
In Italian togliere is a verb.
In Italian lasciare is a verb.
In Italian andare is a verb.
In Italian posizionare is a verb.
In Italian mangiare is a verb.
In Italian dovere is a verb.
In Italian potere is a verb.
In Italian possedere is a verb. [LEO]
In Italian provare is a verb. [LEO]
In Italian parlare is a verb. [LEO]
In Italian rispondere is a verb. [LEO]
In Italian salutare is a verb. [LEO]
In Italian arrivare is a verb.
In Italian entrare is a verb.
In Italian salire is a verb.
[Trucchetto]
In Italian siedere is a verb. [LEO]
In Italian scendere is a verb.
[Quello per l'uscita è solo un trucchetto, uscire verrà presto implementato completamente]
In Italian escire is a verb.
In Italian vedere is a verb.
In Italian trovare is a verb.
In Italian ispezionare is a verb.
In Italian scoprire is a verb.
In Italian bloccare is a verb.
In Italian chiudere is a verb.
In Italian accendere is a verb.
In Italian spegnere is a verb.
In Italian sfilare is a verb.
In Italian porgere is a verb.
In Italian passare is a verb.
In Italian aspettare is a verb.
[Trucchetto]
In Italian tocchare is a verb.
[Trucchetto]
In Italian ottienere is a verb.
In Italian tenere is a verb. [LEO]
In Italian sentire is a verb.
In Italian agitare is a verb.
In Italian tirare is a verb.
In Italian spingere is a verb.
In Italian ruotare is a verb.
In Italian strizzare is a verb.
In Italian odorare is a verb.
In Italian annusare is a verb. [LEO]
In Italian afferrare is a verb. [LEO]
[Rivedere]
In Italian assaggiare is a verb.
[Trucchetto]
In Italian daare is a verb.
In Italian agitare is a verb.
In Italian ascoltare is a verb.

To say ci sei:
	let be-verb be "[sei]";
	let be-char be character number 1 in be-verb; 
	if be-char is "e" or be-char is "è":
		say "c['][be-verb]";
	otherwise:
		say "ci [be-verb]";
		
To say ci sono:
	if story tense is present tense:
		say "ci sono";
	otherwise if story tense is past tense:
		say "c[']erano";
	otherwise:
		say "ci saranno";
		
[LEO Something goes wrong with adjectives]
[
In Italian aperto is an adjective.
In Italian chiuso is an adjective.
In Italian vuoto is an adjective.
In Italian acceso is an adjective.
In Italian spento is an adjective.
In Italian ingombrante is an adjective.
In Italian fissato is an adjective.
In Italian preso is an adjective.
In Italian rimasto is an adjective.
In Italian lasciato is an adjective.
In Italian commestibile is an adjective.
In Italian indossato is an adjective.
In Italian bloccato is an adjective.
In Italian adatto is an adjective.
In Italian interessato is an adjective.
In Italian capace is an adjective.
]

[LEO Workaround for adjectives]

To say o-agg:
	if the prior named object is nothing:
		now the prior named object is the noun;
	if the prior named object is singular-named:
		if the prior named object is feminine gender:
			say "a";
		otherwise:
			say "o";
	otherwise:
		if the prior named object is feminine gender:
			say "e";
		otherwise:
			say "i";

To say e-agg:
	if the prior named object is nothing:
		now the prior named object is the noun;
	if the prior named object is plural-named:
		say "i";
	otherwise:
		say "e";
					
To say ingombrante: say "ingombrant[e-agg]".
To say fissato: say "fissat[o-agg]".
To say preso: say "pres[o-agg]".
To say rimasto: say "rimast[o-agg]".
To say lasciato: say "lasciat[o-agg]".
To say commestibile: say "commestibil[e-agg]".
To say chiuso: say "chius[o-agg]".
To say aperto: say "apert[o-agg]".
To say vuoto: say "vuot[o-agg]".
To say acceso: say "acces[o-agg]".
To say spento: say "spent[o-agg]".
To say indossato: say "indossat[o-agg]".
To say bloccato: say "bloccat[o-agg]".
To say adatto: say "adatt[o-agg]".
To say interessato: say "interessat[o-agg]".
To say capace: say "capac[e-agg]".
To say contenente: say "contenent[e-agg]". [LEO]
To say sveglio: say "svegli[e-agg]". [LEO]
To say stesso: say "stess[o-agg]". [LEO]
To say salito: say "salit[o-agg]". [LEO]
To say saltato: say "saltat[o-agg]". [LEO]
To say seduto: say "sedut[o-agg]". [LEO]
To say entrato: say "entrat[o-agg]". [LEO]
To say sceso: say "sces[o-agg]". [LEO]
To say uscito: say "uscit[o-agg]". [LEO]
To say tolto: say "tolt[o-agg]". [LEO]
[LEO]

To say enter-pp:
	if the player's command includes "sali":
		say "[salito]";
	otherwise if the player's command includes "salta":
		say "[saltato]";
	otherwise if the player's command includes "siedi":
		say "[seduto]";
	otherwise if the player's command includes "siediti":
		say "[seduto]";
	otherwise:
		say "[entrato]";		

To say exit-pp:
	if the player's command includes "scendi":
		say "[sceso]";
	otherwise:
		say "[uscito]";		

To say Ora:
	let t be "[ora]";
	say "[t in sentence case]";
To say ora:
	if story tense is present tense:
		say "ora";
	otherwise:
		say "allora";
		 
To say Qui:
	let t be "[qui]";
	say "[t in sentence case]";
To say qui:
	if story tense is present tense:
		say "qui";
	otherwise:
		say "là";

To say Su-In the (t - a thing):
	let s be "[su-in the t]";
	say "[s in sentence case]";
		
To say su-in the (t - a thing):
	if t is a container:
		say "[inp the t]";
	otherwise:
	 	say "[sup the t]";

Maiuscolo-ON is a truth state that varies. Maiuscolo-ON is usually false.

to say maiuscolo:
	if Maiuscolo-ON is true:
		now Maiuscolo-ON is false;
		stop capturing text;
		say "[captured text]" in sentence case;
	otherwise:
		now Maiuscolo-ON is true;
		start capturing text;

Section 3.1.1.1 - Standard actions concerning the actor's possessions

[Taking inventory , Taking , Removing it from , Dropping , Putting it on , Inserting it into , Eating ]

[ Taking inventory ]
Print empty inventory rule response (A) is "[regarding the player]Non [stai] portando nulla con [te]."
Print standard inventory rule response (A) is "[regarding the player][Ora] [stai] portando con [te]:[line break]".
Report other people taking inventory rule response (A) is "[The actor] [guardi] tra la [sua-loro] roba.".

[ Taking ]
Can't take yourself rule response (A) is "[regarding the player][maiuscolo][sei][maiuscolo] sempre con [te]."
Can't take other people rule response (A) is "[regarding the player]Non [puoi] prendere [the noun]."
Can't take component parts rule response (A) is "[The noun] [fai] parte [dip the whole]."
Can't take people's possessions rule response (A) is "[The noun] [sembri] appartenere [ap the owner]."
Can't take items out of play rule response (A) is "[The noun] non [sei] a [tua] disposizione."
Can't take what you're inside rule response (A) is "Prima dovresti [if noun is a supporter]scendere[otherwise]uscire[end if] [dap the noun]."
Can't take what's already taken rule response (A) is "[The noun] [sei] già in [regarding the player][tuo] possesso."
Can't take scenery rule response (A) is "[The noun] [sei] troppo [ingombrante] da trasportare."
Can only take things rule response (A) is "[The noun] [sei] fuori dalla [tua] portata."
Can't take what's fixed in place rule response (A) is "[The noun] [sei] [fissato] al proprio posto."
Use player's holdall to avoid exceeding carrying capacity rule response (A) is "(prima [regarding the player][metti] qualcosa [inp the current working sack] per fare spazio)[command clarification break]".
Can't exceed carrying capacity rule response (A) is "[regarding the player]Non [puoi] portare altro."
Standard report taking rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] preso [the noun]."
Standard report taking rule response (B) is "[The actor] [prendi] [the noun]."
[ Removing it from ]
Can't remove what's not inside rule response (A) is "[regarding the noun]Non ne [sei] [rimasto] più."
Can't remove from people rule response (A) is "[The noun] [sei] [dip the owner]."
[ Dropping ]
Can't drop yourself rule response (A) is "[regarding the player]Non [puoi] riuscirci."
Can't drop body parts rule response (A) is "[regarding the player]Non [puoi] lasciare [the noun]."
Can't drop what's already dropped rule response (A) is "[The noun] [sei] già [qui]."
Can't drop what's not held rule response (A) is "[regarding the player]Non [possiedi] [the noun]."
Can't drop clothes being worn rule response (A) is "(prima [regarding the player][togli] [the noun])[command clarification break]".
Can't drop if this exceeds carrying capacity rule response (A) is "Non [regarding nothing][ci sei] più spazio [sup the receptacle]."
Can't drop if this exceeds carrying capacity rule response (B) is "Non [regarding nothing][ci sei] più spazio [inp the receptacle]."
Standard report dropping rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] lasciato [the noun]."
Standard report dropping rule response (B) is "[The actor] [hai] lasciato [the noun]."

[ Putting it on ]
[Can't put what's not held rule response (A) is "Prima di poter mettere [the noun] sopra a qualcos'altro sarebbe il caso di aver[lo] nell'inventario."][DEPRECATED]
Can't put something on itself rule response (A) is "[regarding the player]Non [puoi] mettere [the noun] sopra se [stesso]."
Can't put onto what's not a supporter rule response (A) is "[regarding the player]Non [puoi] mettere [the noun] [sup the second noun]."
Can't put clothes being worn rule response (A) is "(prima [regarding the player][togli] [the noun])[command clarification break]".
Can't put if this exceeds carrying capacity rule response (A) is "Non [regarding nothing][ci sei] più spazio [sup the second noun]."
Concise report putting rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] messo [the noun] [su-in the second noun]."
Standard report putting rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Hai][maiuscolo][otherwise][The actor] [hai][end if] messo [the noun] [su-in the second noun]."
[ Inserting it into ]
Can't insert something into itself rule response (A) is "Non [regarding the player][puoi] mettere [the noun] dentro se [stesso]."
Can't insert into closed containers rule response (A) is "Non [regarding the player][puoi] mettere [the noun] dentro [ap the second noun] perché [regarding the second noun][sei] [chiuso]."
Can't insert into what's not a container rule response (A) is "Non [regarding the player][puoi] mettere [the noun] dentro [ap the second noun] perché non [regarding the second noun][puoi] contenere oggetti."
Can't insert clothes being worn rule response (A) is "(prima [regarding the player][togli] [the noun])[command clarification break]".
Can't insert if this exceeds carrying capacity rule response (A) is "[regarding nothing]Non [ci sei] più spazio [inp the second noun]."
Concise report inserting rule response (A) is "Fatto."
Standard report inserting rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Hai][maiuscolo][otherwise][The actor] [hai][end if] messo [the noun] [su-in the second noun]."
[ Eating ]
Can't eat unless edible rule response (A) is "Non [regarding the player][puoi] mangiare [the noun] perché non [regarding the noun][sei] [commestibile]."
Can't eat clothing without removing it first rule response (A) is "(prima [regarding the player][togli] [the noun])[command clarification break]".
Can't eat other people's food rule response (A) is "Non [regarding the player][puoi] mangiare [the noun] [dip the owner]."
Standard report eating rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] mangiato [the noun]."
Standard report eating rule response (B) is "[if the actor is the player][regarding the player][maiuscolo][Hai][maiuscolo][otherwise][The actor] [hai][end if] mangiato [the noun]."


Section 3.1.1.2 - Standard actions which move the actor

[Going , Entering , Exiting , Getting off]

[ Going ]
Stand up before going rule response (A) is "(prima [regarding the player][scendi] [dap the chaise])[command clarification break]".
Can't travel in what's not a vehicle rule response (A) is "Prima [regarding the player][devi] scendere [dap the nonvehicle]."
Can't travel in what's not a vehicle rule response (B) is "Prima [regarding the player][devi] uscire [dap the nonvehicle]."
Can't go through undescribed doors rule response (A) is "Non [regarding the player][puoi] andare da quella parte."
Can't go through closed doors rule response (A) is "(prima [regarding the player][apri] [the door gone through])[command clarification break]".
Can't go that way rule response (A) is "Non [regarding the player][puoi] andare da quella parte."
Can't go that way rule response (B) is "Non [regarding the player][puoi] andare da quella parte, visto che [the door gone through] [sei] un vicolo cieco."
Describe room gone into rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Vai][maiuscolo][otherwise][The actor] [vai][end if] su."
Describe room gone into rule response (B) is "[if the actor is the player][regarding the player][maiuscolo][Vai][maiuscolo][otherwise][The actor] [vai][end if] giù."
Describe room gone into rule response (C) is "[if the actor is the player][regarding the player][maiuscolo][Vai][maiuscolo][otherwise][The actor] [vai][end if] verso [the noun]."
Describe room gone into rule response (D) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] dall'alto."
Describe room gone into rule response (E) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] dal basso."
Describe room gone into rule response (F) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] [dap the back way]".
Describe room gone into rule response (G) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] ."
Describe room gone into rule response (H) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] [ap the room gone to] dal basso."
Describe room gone into rule response (I) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] [ap the room gone to] dal basso."
Describe room gone into rule response (J) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] [ap the room gone to] [dap the back way]."
Describe room gone into rule response (K) is "[if the actor is the player][regarding the player][maiuscolo][Vai][maiuscolo][otherwise][The actor] [vai][end if] attraverso [the noun]".
Describe room gone into rule response (L) is "[if the actor is the player][regarding the player][maiuscolo][Arrivi][maiuscolo][otherwise][The actor] [arrivi][end if] [dap the noun]".
Describe room gone into rule response (M) is "[sup the vehicle gone by]".
Describe room gone into rule response (N) is "[inp the vehicle gone by]".
Describe room gone into rule response (O) is ", spingendo [the thing gone with], e anche [te] [stesso]".
Describe room gone into rule response (P) is ", spingendo [the thing gone with]".
Describe room gone into rule response (Q) is ", spingendo [the thing gone with] via".
Describe room gone into rule response (R) is ", spingendo [the thing gone with] dentro".
Describe room gone into rule response (S) is ", portando[ti] appresso".

[ Entering ]

Can't enter what's already entered rule response (A) is "[regarding the player][maiuscolo][Sei][maiuscolo] già [sup the noun]."
Can't enter what's already entered rule response (B) is "[regarding the player][maiuscolo][Sei][maiuscolo] già [inp the noun]."
Can't enter what's not enterable rule response (A) is "Non [regarding the player]ci [puoi] salire."
Can't enter what's not enterable rule response (B) is "Non [regarding the player][ti] ci [puoi] sedere."
Can't enter what's not enterable rule response (C) is "Non [regarding the player][ti] ci [puoi] sdraiare."
Can't enter what's not enterable rule response (D) is "Non [regarding the player]ci [puoi] entrare."
Can't enter closed containers rule response (A) is "Non [regarding the player][puoi] entrare [inp the noun] perché [sei] [chiuso]."
Can't enter something carried rule response (A) is "Non [regarding the player][puoi] entrare [inp the noun] perché [lo] [regarding the player][tieni] in mano."
Implicitly pass through other barriers rule response (A) is "([regarding the player][scendi] [dap the current home])[command clarification break]".
Implicitly pass through other barriers rule response (B) is "([regarding the player][esci] [dap the current home])[command clarification break]".
Implicitly pass through other barriers rule response (C) is "([regarding the player][sali] [sup the target])[command clarification break]".
Implicitly pass through other barriers rule response (D) is "([regarding the player][entri] [inp the target])[command clarification break]".
Implicitly pass through other barriers rule response (E) is "([regarding the player][entri] [inp the target])[command clarification break]".
Standard report entering rule response (A) is "[regarding the player][maiuscolo][Sei][maiuscolo] [enter-pp] [sup the noun]."
Standard report entering rule response (B) is "[regarding the player][maiuscolo][Sei][maiuscolo] [enter-pp] [inp the noun]."
Standard report entering rule response (C) is "[The actor] [sei] [enter-pp] [inp the noun]."
Standard report entering rule response (D) is "[The actor] [sei] [enter-pp] [sup the noun]."

[ Exiting ]
Can't exit when not inside anything rule response (A) is "[Ora] non [regarding the player][sei] dentro [if the noun is nothing]a nulla[otherwise][ap the noun][end if]."
Can't exit closed containers rule response (A) is "Non [regarding the player][puoi] uscire [dap the cage] perché [sei] [chiuso]."
Standard report exiting rule response (A) is "[regarding the player][maiuscolo][Sei][maiuscolo] [exit-pp] [dap the container exited from]."
Standard report exiting rule response (B) is "[regarding the player][maiuscolo][Sei][maiuscolo] [exit-pp] [dap the container exited from]."
Standard report exiting rule response (C) is "[The actor] [sei] [exit-pp] [dap the container exited from]."
[ Getting off ]
Can't get off things rule response (A) is "[Ora] non [regarding the player][sei] [sup the noun]."
Standard report getting off rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Sei][maiuscolo][otherwise][The actor] [sei][end if] [exit-pp] [dap the noun]."

Section 3.1.1.3 - Standard actions concerning the actor's vision

[Looking , Examining , Looking under , Searching , Consulting it about]

[ Looking ]
Room description heading rule response (A) is "Buio completo".
Room description heading rule response (B) is " (sopra [the intermediate level])".
Room description heading rule response (C) is " (dentro [the intermediate level])".
Room description body text rule response (A) is "L'oscurità avvolge tutto. Non [regarding the player][puoi] vedere nulla."
Other people looking rule response (A) is "[The actor] si [guardi] attorno."
[ Examining ]
Examine directions rule response (A) is "[regarding the player]Non [vedi] nulla di speciale in quella direzione."
Examine containers rule response (A) is "Dentro [the noun] ".
Examine containers rule response (B) is "[The noun] [sei] [vuoto]."
Examine supporters rule response (A) is "Sopra [the noun] ".
Examine devices rule response (A) is "[Ora] [the noun] [sei] [if the noun is switched on][acceso][otherwise][spento][end if]."
Examine undescribed things rule response (A) is "[regarding the player]Non [trovi] nulla di speciale [inp the noun]."
Report other people examining rule response (A) is "[The actor] [guardi] con attenzione [the noun]."
[ Looking under ]
Standard looking under rule response (A) is "[regarding the player]Non [trovi] nulla di interessante."
Report other people looking under rule response (A) is "[The actor] [guardi] sotto [ap the noun]."
[ Searching ]
Can't search unless container or supporter rule response (A) is "[regarding the player]Non [trovi] nulla di interessante."
Can't search closed opaque containers rule response (A) is "Non [regarding the player][puoi] vederne l'interno visto che [the noun] [sei] [chiuso]."
Standard search containers rule response (A) is "Dentro [ap the noun] ".
Standard search containers rule response (B) is "[The noun] [sei] [vuoto]."
Standard search supporters rule response (A) is "Sopra [the noun] ".
Standard search supporters rule response (B) is "Non [regarding nothing][ci sei] nulla [sup the noun]."
Report other people searching rule response (A) is "[The actor] [ispezioni] [the noun]."
[ Consulting it about ]
Block consulting rule response (A) is "[regarding the player]Non [scopri] nulla di interessante [sup the noun]."
Block consulting rule response (B) is "[The actor] [guardi] verso [the noun]."


Section 3.1.1.4 - Standard actions which change the state of things

[Locking it with , Unlocking it with , Switching on , Switching off , Opening , Closing , Wearing , Taking off]

[ Locking it with ]
Can't lock without a lock rule response (A) is "[The noun] non si [puoi] bloccare."
Can't lock what's already locked rule response (A) is "[Ora] [the noun] [sembri] già [chiuso]."
Can't lock what's open rule response (A) is "Prima [regarding the player][devi] chiudere [the noun]."
Can't lock without the correct key rule response (A) is "[regarding the second noun]Non [sembri] [adatto] per bloccare [the noun]."
Standard report locking rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] bloccato [the noun]."
Standard report locking rule response (B) is "[The actor] [hai] bloccato [the noun]."
[ Unlocking it with ]
Can't unlock without a lock rule response (A) is "[The noun] non si [puoi] sbloccare."
Can't unlock what's already unlocked rule response (A) is "[Ora] [the noun] [sei] [aperto]."
Can't unlock without the correct key rule response (A) is "[The second noun] non [sembri] [adatto] per sbloccare [the noun]."
Standard report unlocking rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] sbloccato [the noun]."
Standard report unlocking rule response (B) is "[The actor] [hai] sbloccato [the noun]."
[ Switching on ]
Can't switch on unless switchable rule response (A) is "[The noun] non si [puoi] accendere."
Can't switch on what's already on rule response (A) is "[The noun] [sei] già [acceso]."
Standard report switching on rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Hai][maiuscolo][otherwise][The actor] [hai][end if] acceso [the noun]."
[ Switching off ]
Can't switch off unless switchable rule response (A) is "[The noun] non si [puoi] spegnere."
Can't switch off what's already off rule response (A) is "[The noun] [sei] già [spento]."
Standard report switching off rule response (A) is "[if the actor is the player][regarding the player][maiuscolo][Hai][maiuscolo][otherwise][The actor] [hai][end if] spento [the noun]."
[ Opening ]
Can't open unless openable rule response (A) is "[The noun] non si [puoi] aprire."
Can't open what's locked rule response (A) is "[The noun] [sembri] [bloccato]."
Can't open what's already open rule response (A) is "[The noun] [sei] già [aperto]."
Reveal any newly visible interior rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] aperto [the noun] trovando ".
Standard report opening rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] aperto [the noun]."
Standard report opening rule response (B) is "[The actor] [hai] aperto[the noun]."
Standard report opening rule response (C) is "[The noun] si [sei] [aperto]."
[ Closing ]
Can't close unless openable rule response (A) is "[The noun] non si [puoi] chiudere."
Can't close what's already closed rule response (A) is "[The noun] [sei] già [chiuso]."
Standard report closing rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] chiuso [the noun]."
Standard report closing rule response (B) is "[The actor] [hai] chiuso [the noun]."
Standard report closing rule response (C) is "[The noun] si [sei] [chiuso]."
[ Wearing ]
Can't wear what's not clothing rule response (A) is "[regarding the player]Non [puoi] indossare [the noun]."
Can't wear what's not held rule response (A) is "[regarding the player]Non [puoi] indossare ciò che non [possiedi]."
Can't wear what's already worn rule response (A) is "[regarding the player][maiuscolo][Indossi][maiuscolo] già [the noun]."
Standard report wearing rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] indossato [the noun]."
Standard report wearing rule response (B) is "[The actor] [hai] indossato [the noun]."
[ Taking off ]
Can't take off what's not worn rule response (A) is "[regarding the player]Non [puoi] togliere ciò che non [indossi]."
Standard report taking off rule response (A) is "[regarding the player][Ti] [sei] [tolto] [the noun] di dosso."
Standard report taking off rule response (B) is "[The actor] [ti] [sei] [tolto] [the noun] di dosso."


Section 3.1.1.5 - Standard actions concerning other people

[Giving it to , Showing it to , Waking , Throwing it at , Attacking , Kissing , Answering it that , Telling it about , Asking it about , Asking it for]

[ Giving it to ]
Can't give what you haven't got rule response (A) is "[regarding the player]Non [puoi] dare ciò che non [possiedi]."
Can't give to yourself rule response (A) is "[regarding the player][maiuscolo][possiedi][maiuscolo] già [the noun]."
Can't give to a non-person rule response (A) is "[The second noun] non [puoi] ricevere [the noun]."
Can't give clothes being worn rule response (A) is "(prima [regarding the player][ti] [togli] [the noun])[command clarification break]".
Block giving rule response (A) is "[The second noun] non [sembri] [interessato]."
Standard report giving rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] dato [the noun] [ap the second noun]."
Standard report giving rule response (B) is "[The actor] [regarding the player][ti] [regarding the actor][hai] dato [the noun]."
Standard report giving rule response (C) is "[The actor] [hai] dato [the noun] [ap the second noun]."
[ Showing it to ]
Can't show what you haven't got rule response (A) is "[regarding the player]Non [possiedi] [the noun]."
Block showing rule response (A) is "[The second noun] non [sei] [interessato]."
[ Waking ]
Block waking rule response (A) is "[regarding the player]Non [puoi] farlo."
[ Throwing it at ]
Implicitly remove thrown clothing rule response (A) is "(prima [regarding the player][ti] [togli] [the noun])[command clarification break]".
Futile to throw things at inanimate objects rule response (A) is "Inutile."
Block throwing at rule response (A) is "[regarding the player]Non [puoi] farlo."
[ Attacking ]
Block attacking rule response (A) is "[regarding the player]Non [puoi] farlo."
[ Kissing ]
Kissing yourself rule response (A) is "[regarding the player]Non [puoi] farlo."
Block kissing rule response (A) is "Non [regarding the player][puoi] baciare [the noun]."
[ Answering it that ]
Block answering rule response (A) is "Nessuna risposta."
[ Telling it about ]
Telling yourself rule response (A) is "[regarding the player][maiuscolo][Parli][maiuscolo] da solo?"
Block telling rule response (A) is "Nessuna reazione."
[ Asking it about ]
Block asking rule response (A) is "Nessuna risposta."

Section 3.1.1.6 - Standard actions which are checked but then do nothing unless rules intervene

[ Waiting ]
Standard report waiting rule response (A) is "Il tempo [regarding nothing][passi]."
Standard report waiting rule response (B) is "[The actor] [aspetti]."
[ Touching ]
Report touching yourself rule response (A) is "Non [regarding the player][hai] ottenuto nulla."
Report touching yourself rule response (B) is "[The actor] [hai] toccato se [stesso]."
Report touching other people rule response (A) is "Non [regarding the player][puoi] toccare [the noun]."
Report touching other people rule response (B) is "[The actor] [regarding the player][ti] [regarding the actor][hai] toccato."
Report touching other people rule response (C) is "[The actor] [hai] toccato [the noun]."
Report touching things rule response (A) is "[regarding the player]Non [hai] sentito nulla di strano."
Report touching things rule response (B) is "[The actor] [hai] toccato [the noun]."
[ Waving ]
Can't wave what's not held rule response (A) is "[regarding the player]Non [puoi] sbandierare [the noun]."
Report waving things rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] agitato [the noun]."
Report waving things rule response (B) is "[The actor] [hai] agitato [the noun]."
[ Pulling ]
Can't pull what's fixed in place rule response (A) is "[The noun] [sei] [fissato] al proprio posto."
Can't pull scenery rule response (A) is "Non [regarding the player][puoi]."
Can't pull people rule response (A) is "Non [regarding the player][puoi] tirare [the noun]."
Report pulling rule response (A) is "Nessuna reazione."
Report pulling rule response (B) is "[The actor] [hai] tirato [the noun]."
[ Pushing ]
Can't push what's fixed in place rule response (A) is "[The noun] [sei] [fissato] al proprio posto."
Can't push scenery rule response (A) is "Non [regarding the player][puoi]."
Can't push people rule response (A) is "Non [regarding the player][puoi] spingere [the noun]."
Report pushing rule response (A) is "Nessun effetto."
Report pushing rule response (B) is "[The actor] [hai] spinto [the noun]."
[ Turning ]
Can't turn what's fixed in place rule response (A) is "[The noun] [sei] [fissato] al proprio posto."
Can't turn scenery rule response (A) is "Non [regarding the player][puoi]."
Can't turn people rule response (A) is "Non [regarding the player][puoi] girare [the noun]."
Report turning rule response (A) is "Nessuna reazione."
Report turning rule response (B) is "[The actor] [hai] girato [the noun]."
[ Pushing it to ]
Can't push unpushable things rule response (A) is "[The noun] non si [puoi] spostare."
Can't push to non-directions rule response (A) is "[regarding the noun]Non [sei] una direzione."
Can't push vertically rule response (A) is "[The noun] non si [puoi] sollevare."
Block pushing in directions rule response (A) is "[The noun] non si [puoi] spostare."
[ Squeezing ]
Innuendo about squeezing people rule response (A) is "Non [regarding the player][puoi] strizzare [the noun]."
Report squeezing rule response (A) is "[regarding the player]Non [hai] ottenuto nulla."
Report squeezing rule response (B) is "[The actor] [hai] strizzato [the noun]."

Section 3.1.1.7 - Standard actions which always do nothing unless rules intervene

[Saying yes , Saying no , Burning , Waking up , Thinking , Smelling , Listening to , Tasting , Cutting , Jumping , Tying it to , Drinking , Saying sorry , Swinging , Rubbing , Setting it to , Waving hands , Buying , Climbing , Sleeping]

[ Saying yes ]
Block saying yes rule response (A) is "[regarding nothing][maiuscolo][Sei][maiuscolo] una domanda retorica."
[ Saying no ]
Block saying no rule response (A) is "[regarding nothing][maiuscolo][Sei][maiuscolo] una domanda retorica."
[ Burning ]
Block burning rule response (A) is "A che scopo?"
[ Waking up ]
Block waking up rule response (A) is "[regarding the player][maiuscolo][Sei][maiuscolo] già [sveglio]."
[ Thinking ]
Block thinking rule response (A) is "Buona idea."
[ Smelling ]
Report smelling rule response (A) is "[regarding the player]Non [hai] sentito nessun odore insolito."
Report smelling rule response (B) is "[The actor] [hai] annusato con attezione."
[ Listening to ]
Report listening rule response (A) is "[regarding the player]Non [hai] sentito nessun suono strano."
Report listening rule response (B) is "[The actor] [hai] ascoltato con attenzione."
[ Tasting ]
Report tasting rule response (A) is "[regarding the player]Non [hai] sentito nessun sapore particolare."
Report tasting rule response (B) is "[The actor] [hai] assaggiato [the noun]."
[ Cutting ]
Block cutting rule response (A) is "[regarding the player]Non [puoi] tagliare [the noun]."
[ Jumping ]
Report jumping rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] spiccato un salto."
Report jumping rule response (B) is "[The actor] [hai] spiccato un salto."
[ Tying it to ]
Block tying rule response (A) is "[regarding the player]Non [puoi] legare [the noun]."
[ Drinking ]
Block drinking rule response (A) is "Non [regarding nothing][ci sei] nulla da bere [qui]."
[ Saying sorry ]
Block saying sorry rule response (A) is "Nessuna scusa."
[ Swinging ]
Block swinging rule response (A) is "Non [regarding nothing][ci sei] nulla da far ondeggiare [qui]."
[ Rubbing ]
Can't rub another person rule response (A) is "Non [regarding the player][puoi] strofinare [the noun]."
Report rubbing rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] strofinato [the noun]."
Report rubbing rule response (B) is "[The actor] [hai] strofinato [the noun]."
[ Setting it to ]
Block setting it to rule response (A) is "Niente da fare."
[ Waving hands ]
Report waving hands rule response (A) is "[regarding the player][maiuscolo][Hai][maiuscolo] agitato le mani."
Report waving hands rule response (B) is "[The actor] [hai] agitato le mani."
[ Buying ]
Block buying rule response (A) is "Nulla da comprare."
[ Climbing ]
Block climbing rule response (A) is "[regarding the player]Non [puoi] farlo."
[ Sleeping ]
Block sleeping rule response (A) is "Non [regarding nothing][sei] il momento."

Section 3.1.1.8 - Standard actions which happen out of world

[Quitting the game , Saving the game , Restoring the game , Restarting the game , Verifying the story file , Switching the story transcript on , Switching the story transcript off , Requesting the story file version , Requesting the score , Preferring abbreviated room descriptions , Preferring unabbreviated room descriptions , Preferring sometimes abbreviated room descriptions , Switching score notification on , Switching score notification off , Requesting the pronoun meanings]

[Quitting the game ]
Quit the game rule response (A) is "Sei sicuro di voler uscire? ".
[ Saving the game ]
Save the game rule response (A) is "Salvataggio fallito."
Save the game rule response (B) is "Ok."
[ Restoring the game ]
Restore the game rule response (A) is "Caricamento fallito."
Restore the game rule response (B) is "Ok."
[ Restarting the game ]
Restart the game rule response (A) is "Sei sicuro di voler ricominciare? ".
Restart the game rule response (B) is "Fallito."
[ Verifying the story file ]
Verify the story file rule response (A) is "La storia è stata controllata ed è integra."
Verify the story file rule response (B) is "La storia è stata controllata, ma potrebbe essere corrotta."
[ Switching the story transcript on ]
Switch the story transcript on rule response (A) is "La trascrizione è già attiva."
Switch the story transcript on rule response (B) is "Inizio della trascrizione per".
Switch the story transcript on rule response (C) is "Tentativo di inizio trascrizione fallito. Potrebbero esserci delle incompatibilità con l'interprete adoperato."
[ Switching the story transcript off ]
Switch the story transcript off rule response (A) is "La trascrizione è già disattiva."
Switch the story transcript off rule response (B) is "[line break]Termine della trascrizione."
Switch the story transcript off rule response (C) is "Tentativo di termine della trascrizione fallito."
[ Requesting the score ]
Announce the score rule response (A) is "[if the story has ended]Nel gioco hai totalizzato[otherwise]Sinora hai totalizzato[end if] [score] rispetto a un massimo di [maximum score], in [turn count] turn[if turn count is greater than 1]i[otherwise]o[end if]".
Announce the score rule response (B) is ", conquistando il titolo di ".
Announce the score rule response (C) is "Non c[']è un punteggio in questa storia."
Announce the score rule response (D) is "[bracket]Il tuo punteggio è appena salito di [number understood in words].[close bracket]".
Announce the score rule response (E) is "[bracket]Il tuo punteggio è appena diminuito di [number understood in words].[close bracket]".
[ Preferring abbreviated room descriptions ]
Standard report preferring abbreviated room descriptions rule response (A) is " è ora nella modalità 'superbrief', che fornisce sempre le descrizioni più brevi delle locazioni (anche di quelle inesplorate)."
[ Preferring unabbreviated room descriptions ]
Standard report preferring unabbreviated room descriptions rule response (A) is " è ora nella modalità 'verbose', che fornisce sempre le descrizioni più lunghe delle locazioni (anche di quelle già esplorate)."
[ Preferring sometimes abbreviated room descriptions ]
Standard report preferring sometimes abbreviated room descriptions rule response (A) is " è ora nella modalità 'brief', che fornisce  descrizioni più lunghe per locazioni già esplorate e descrizioni più corte per i luoghi ancora inesplorati."
[ Switching score notification on ]
Standard report switching score notification on rule response (A) is "Notifica del punteggio attiva."
[ Switching score notification off ]
Standard report switching score notification off rule response (A) is "Notifica del punteggio disattiva."
[ Requesting the pronoun meanings ]
Announce the pronoun meanings rule response (A) is "Ora ".
Announce the pronoun meanings rule response (B) is "significa ".
Announce the pronoun meanings rule response (C) is "non è fissato".
Announce the pronoun meanings rule response (D) is "nessun pronome è noto al gioco.".

Section  3.1.1.9 - Rule supplying a missing noun

Block vaguely going rule response (A) is "Devi specificare la direzione in cui vuoi andare."

Section  3.1.1.10 - Final prompt

Print the final prompt rule response (A) is "> [run paragraph on]".

Section  3.1.1.11 - Final question

Print the final question rule response (A) is "Vorresti ".
Print the final question rule response (B) is " oppure ".
Standard respond to final question rule response (A) is "Per piacere, scegli una delle opzioni."

Section  3.1.1.12 - Printing the locale description

You-can-also-see rule response (A) is "[Qui] ".
You-can-also-see rule response (B) is "Sopra [the domain] [regarding the player]".
You-can-also-see rule response (C) is "Dentro [the domain] [regarding the player]".
You-can-also-see rule response (D) is "[regarding the player][puoi] anche vedere ".
You-can-also-see rule response (E) is "[regarding the player][puoi] vedere ".
You-can-also-see rule response (F) is "".

Section  3.1.1.13 - Printing a locale paragraph about a thing

Use initial appearance in room descriptions rule response (A) is "Sopra [the item] ".

Section  3.1.1.14 - Printing a locale paragraph about a thing

Describe what's on scenery supporters in room descriptions rule response (A) is "Sopra [the item] ".

Section  3.1.1.15 - Turn sequence rulebook

Adjust light rule response (A) is "[Ora] [regarding the player][sei] al buio.".
Generate action rule response (A) is "(considerando solo i primi sedici oggetti)[command clarification break]".
Generate action rule response (B) is "Nulla da fare.".

Section  3.1.1.16 - Action processing rules

Basic accessibility rule response (A) is "Prova a nominare qualcosa di più specifico."
Basic visibility rule response (A) is "E['] buio e non riesci a vedere nulla."
Requested actions require persuasion rule response (A) is "[The noun] [hai] altro da fare."
Carry out requested actions rule response (A) is "[The noun] non [puoi] farlo."

Section  3.1.1.17 - Accessibility

Access through barriers rule response (A) is "Fuori dalla portata."
Can't reach inside closed containers rule response (A) is "[The noun] non [sei] [aperto]."
Can't reach inside rooms rule response (A) is "[regarding the player]Non [puoi] vedere dentro [the noun]."
Can't reach outside closed containers rule response (A) is "[The noun] non [sei] [aperto]."

Section  3.1.1.18 - List writer internal rule   

List writer internal rule response (A) is " (".
List writer internal rule response (B) is ")".
List writer internal rule response (C) is " e ".
List writer internal rule response (D) is "[acceso]".
List writer internal rule response (E) is "[chiuso]".
List writer internal rule response (F) is "[vuoto]".
List writer internal rule response (G) is "[chiuso] e [vuoto]".
List writer internal rule response (H) is "[chiuso] e [acceso]".
List writer internal rule response (I) is "[vuoto] e [acceso]".
List writer internal rule response (J) is "[chiuso], [vuoto][if serial comma option is active],[end if] e [acceso]".
List writer internal rule response (K) is "[acceso] e [indossato]".
List writer internal rule response (L) is "[indossato]".
List writer internal rule response (M) is "[aperto]".
List writer internal rule response (N) is "[aperto] ma [vuoto]".
List writer internal rule response (O) is "[chiuso]".
List writer internal rule response (P) is "[chiuso] e [bloccato]".
List writer internal rule response (Q) is "[contenente]".
List writer internal rule response (R) is " (sopra cui ".
List writer internal rule response (S) is ", sopra cui ".
List writer internal rule response (T) is " (dentro cui ".
List writer internal rule response (U) is ", dentro cui ".
List writer internal rule response (V) is "[regarding the player][vedi]".
List writer internal rule response (W) is "[sei] niente".
List writer internal rule response (X) is "Niente".
List writer internal rule response (Y) is "niente".

Section  3.1.1.19 - Action processing internal rule

Action processing internal rule response (A) is "[bracket]Questo comando permette di eseguire un[']azione al di fuori dal gioco. [The noun] non può reagire a tale richiesta.[close bracket]".
Action processing internal rule response (B) is "Devi nominare un oggetto."
Action processing internal rule response (C) is "Puoi non nominare un oggetto."
Action processing internal rule response (D) is "Devi fornire un nome."
Action processing internal rule response (E) is "Puoi non fornire un nome."
Action processing internal rule response (F) is "Devi fornire un secondo oggetto."
Action processing internal rule response (G) is "Puoi non fornire il secondo oggetto."
Action processing internal rule response (H) is "Devi fornire un secondo nome."
Action processing internal rule response (I) is "Puoi non fornire un secondo nome."
Action processing internal rule response (J) is "(Visto che è accaduto qualcosa di drammatico, la tua lista dei comandi è stata abbreviata)"

Section  3.1.1.20 - Parser error internal rule

Parser error internal rule response (A) is "Non ho capito la frase."
Parser error internal rule response (B) is "Ho capito solo: ".
Parser error internal rule response (C) is "Non ho compreso il numero."
Parser error internal rule response (D) is "Non riesci a vedere nulla del genere."
Parser error internal rule response (E) is "Hai detto troppo poco."
Parser error internal rule response (F) is "[Ora] non lo [possiedi]."
Parser error internal rule response (G) is "Non puoi usare più di un oggetto con quel verbo."
Parser error internal rule response (H) is "Con un verbo, puoi usare più di un oggetto solo una volta per ogni linea."
Parser error internal rule response (I) is "Non capisco a cosa si riferisca [the noun]."
Parser error internal rule response (J) is "Chiedi qualcosa che non è possibile."
Parser error internal rule response (K) is "Quella azione è possibile solo con oggetti animati."
Parser error internal rule response (L) is "Non è un verbo che conosco."
Parser error internal rule response (M) is "Non è qualcosa di cui hai bisogno in questa storia."
Parser error internal rule response (N) is "[regarding the player][Ora] non [puoi] vedere [if the noun is nothing]nulla del genere[otherwise][the noun][end if]."
Parser error internal rule response (O) is "Non ho capito la fine della frase."
Parser error internal rule response (P) is "[if number understood is 0]Nessun[otherwise]Solo [number understood][end if] di questi [sei] a disposizione."
Parser error internal rule response (Q) is "Nulla da fare."
Parser error internal rule response (R) is "Nulla di ciò che hai chiesto [regarding nothing][sei] a disposizione."
Parser error internal rule response (S) is "Il nome non ha alcun senso in questo contesto."
Parser error internal rule response (T) is "[regarding the noun]Forse [puoi] appartenere [ap the noun]."
Parser error internal rule response (U) is "[The noun] non [puoi] contenere nulla."
Parser error internal rule response (V) is "[The noun] non [sei] [aperto]."
Parser error internal rule response (W) is "Come? Ripeti per favore."
Parser error internal rule response (X) is "[The noun] [sei] [vuoto]."

Section  3.1.1.21 - Darkness name internal rule

Darkness name internal rule response (A) is "Buio"

Section  3.1.1.22 - Parser command internal rule

Parser command internal rule response (A) is "Non può essere corretto."
Parser command internal rule response (B) is "Non ci pensare nemmeno."
Parser command internal rule response (C) is "'Oops' può correggere solo una parola."
Parser command internal rule response (D) is "Per ripetere un comando come 'rana, salta', bastare dire 'ancora' e non 'rana, ancora'."
[
Parser command internal rule response (E) is "Meglio se non lo ripeti."
Parser command internal rule response (F) is "Non puoi iniziare con una virgola."
Parser command internal rule response (G) is "Pare che tu voglia parlare a qualcuno ma non riesco a capire chi."
Parser command internal rule response (H) is "Non puoi parlare [ap the noun]."
Parser command internal rule response (I) is "Per parlare ad un tizio prova 'tizio, ciao' o qualcosa di simile."
][DEPRECATED?]

Section  3.1.1.23 - Parser clarification internal rule

Parser clarification internal rule response (A) is "Chi intendi, ".
Parser clarification internal rule response (B) is "Quale intendi, ".
Parser clarification internal rule response (C) is "Scusami, puoi specificare un solo nome. Quale esattamente?".
Parser clarification internal rule response (D) is "A chi vorresti [if the noun is not the player]che [the noun] applicasse[otherwise]applicare[end if] l'azione '[parser command so far]'?".
Parser clarification internal rule response (E) is "Cosa [if the noun is not the player]vorresti che [the noun] facesse[otherwise]intendi fare[end if] con '[parser command so far]'?".
Parser clarification internal rule response (F) is "quelle cose".
Parser clarification internal rule response (G) is "quello".
Parser clarification internal rule response (H) is " o ".

Section  3.1.1.24 - Yes or no question internal rule

Yes or no question internal rule response (A) is "Per favore, rispondi sì o no."

Section  3.1.1.25 - Print protagonist internal rule

Print protagonist internal rule response (A) is "[Tu]".
Print protagonist internal rule response (B) is "[te]".
Print protagonist internal rule response (C) is "[tuo] persona".

Section  3.1.1.26 - Standard implicit taking rule

Standard implicit taking rule response (A) is "(prima [regarding the player][prendi] [the noun])[command clarification break]".
Standard implicit taking rule response (B) is "([the second noun] [prendi] [the noun])[command clarification break]".

Section  3.1.1.27 - Player's obituary

Print obituary headline rule response (A) is " Sei morto ".
Print obituary headline rule response (B) is " Hai vinto ".
Print obituary headline rule response (C) is " Fine ".

Section  3.1.1.28 - Immediately undo rule

Immediately undo rule response (A) is "L'uso di 'undo' non è consentito in questo gioco."
Immediately undo rule response (B) is "Non puoi usare 'undo' per ciò che non è ancora stato fatto.".
Immediately undo rule response (C) is "Il tuo interprete non supporta 'undo'.".
Immediately undo rule response (D) is "'Undo' fallito.".
Immediately undo rule response (E) is "[bracket]Turno precedente annullato.[close bracket]".


Chapter 3.1.2 - Rideable Vehicles (for use with Rideable Vehicles by Graham Nelson)

Understand "monta su/sul/sullo/sui/sugli/sulla/sulle/sull [something]" as mounting.
Understand "smonta da/dal/dallo/dai/dagli/dalla/dalle/dall [something]" as dismounting.

can't mount when mounted on an animal rule response (A) is "[regarding the player][maiuscolo][Stai][maiuscolo] già montando [the steed].".
can't mount when mounted on a vehicle rule response (A) is "[regarding the player][maiuscolo][Stai][maiuscolo] già montando [the conveyance].".
can't mount something unrideable rule response (A) is "[The noun] non [puoi] essere montato.".
standard report mounting rule response (A) is "[regarding the player][maiuscolo][Monti][maiuscolo] [the noun].".
standard report mounting rule response (B) is "[The actor] [monti] [the noun].".
mounting excuses rule response (A) is "[The person asked] [stai] già montando [the steed].".
mounting excuses rule response (B) is "[The person asked] [stai] già montando [the conveyance].".
mounting excuses rule response (C) is "[The noun] non [puoi] essere montato.".
can't dismount when not mounted rule response (A) is "Non [regarding the player][stai] montando nulla.".
standard report dismounting rule response (A) is "[refarding the player][maiuscolo][Smonti][maiuscolo] [dap the noun].[line break][run paragraph on]".
standard report dismounting rule response (B) is "[The actor] [smonti] [dap the noun].".
dismounting excuses rule response (A) is "[The person asked] non [stai] montando nulla.".

Chapter 3.1.3 - Locksmith (for use with Locksmith by Emily Short)

opening doors before entering rule response (A) is "(prima [regarding the player][apri] [the blocking door])[command clarification break]".
closing doors before locking rule response (A) is "(prima [regarding the player][chiudi] [the door ajar])[command clarification break]".
closing doors before locking keylessly rule response (A) is "(prima [regarding the player][chiudi] [the door ajar])[command clarification break]".
unlocking before opening rule response (A) is "(prima [regarding the player][sblocchi] [the sealed chest])[command clarification break]".
standard printing key lack rule response (A) is "[regarding the player]Non [possiedi] la chiave [dip the locked-thing].".
right second rule response (A) is "[The second noun] non [apri] [the noun].".
standard keylessly unlocking rule response (A) is "(con [the key unlocked with])[command clarification break]".
standard keylessly locking rule response (A) is "(con [the key locked with])[command clarification break]".
identify passkeys in inventory rule response (A) is " (che [regarding the noun][apre] [the list of things unbolted by the item])".
passkey description rule response (A) is "[The noun] [sblocchi] [the list of things unbolted by the noun].".
limiting keychains rule response (A) is "[The noun] non [are] una chiave.".
must have accessible the noun rule response (A) is "Senza avere [the noun], [regarding the player] non [puoi] fare nulla.".
must have accessible the second noun rule response (A) is "Senza avere [the second noun], [regarding the player] non [puoi] fare nulla.".
lock debugging rule response (A) is "Sbloccando [the item].".
report universal unlocking rule response (A) is "Tutto si [regarding nothing][sei] sbloccato.".

Chapter 3.1.4 - Basic Screen Effects (for use with Basic Screen Effects by Emily Short)

standard pausing the game rule response (A) is "[paragraph break]Premi SPAZIO per continuare.".

Chapter 3.1.5 - Inanimate Listeners (for use with Inanimate Listeners by Emily Short)

unsuccessful persuasion of inanimate objects rule response (A) is "[The target] non [puoi] agire come una persona.".

Chapter 3.1.7 - Complex Listing (for use with Complex Listing by Emily Short)

[
    standard delimiting rule response (A): "[second delimiter entry]"
    standard delimiting rule response (B): "[alternate second delimiter entry]"
    standard delimiting rule response (C): "[first delimiter entry]"
]

Part 3.2 - The Final Question

Table of Final Question Options (replaced)
final question wording	only if victorious	topic		final response rule		final response activity
"RICOMINCIARE"			false				"ricominciare"	immediately restart the VM rule	--
"CARICARE una partita salvata"	false				"caricare"	immediately restore saved game rule	--
"ricevere qualche commento DIVERTENTE"	true	"divertente"	--	amusing a victorious player
"USCIRE"					false				"uscire"		immediately quit rule	--
--						false				"undo"		immediately undo rule	--

Volume 4 - Command parsing

Part 4.1 - Pronouns and possessives in commands

[ Tali meccanismi sono ancora da implementare... ]

Part 4.2 - Understand grammar

[Generali]
Understand "attacca [something]" or "attacca il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as attacking.
Understand "uccidi [something]" or "uccidi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as attacking.
Understand "prendi [something]" or "prendi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as taking.
Understand "mangia [something]" or "mangia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as eating.
Understand "bacia [something]" or "bacia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as kissing.
Understand "tocca [something]" or "tocca il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as touching.
Understand "brucia [something]" or "brucia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as burning.
Understand "annusa" as smelling.
Understand "bevi [something]" or "bevi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as drinking.
Understand "compra [something]" or "compra il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as buying.
Understand "dormi" as sleeping.
Understand "salta" as jumping.
Understand "svegliati" as waking up.
Understand "taglia [something]" or "taglia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as burning.
Understand "agita le mani" as waving hands.
Understand "colpisci il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" or "colpisci [something]" as swinging.
Understand "spremi [someone]" or "spremi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as squeezing.
Understand "strizza [someone]" or "strizza il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as squeezing.
Understand "ascolta" as listening.
Understand "verifica" as verifying the story file.
Understand "pensa" or "ricorda" as thinking.
Understand "rompi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as attacking.

[Visione]
Understand "guarda [something]" or "guarda il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as examining.
Understand "leggi [something]" or "leggi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as examining.
Understand "guarda dentro [something]" or "guarda dentro il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" or "guarda in/nel/nello/nella/negli/nelle/nell [something]" as searching.
Understand "esamina [something]" or "esamina il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as examining.
Understand "guarda" or "g" as looking.
Understand "guarda sotto il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell/al/alla/allo/all/ai/alle/agli [something]" as looking under.
Understand "guarda sotto [something]" as looking under.
Understand "descrivi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as examining.

[Interazione Fisica]
Understand "calcia [something]" or "calcia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as attacking.
Understand "accendi [something]" or "accendi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as switching on.
Understand "spegni [something]" or "spegni il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as switching off.
Understand "spingi [something]" or "spingi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as pushing.
Understand "indossa [something]" or "indossa il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as wearing.
Understand "togliti il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as taking off.
Understand "togli [something]" or "togli il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as taking off.
Understand "lascia [something]" or "lascia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as dropping.
Understand "mostra [something] a [something]" or "mostra il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] al/alla/allo/all/ai/agli/alle/a [something]" as showing it to.
Understand "poggia [something] su/sopra [something]" or "poggia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] sul/sullo/sulla/sulle/sugli/sopra/sull [something]" as putting it on.
Understand "metti [something] su/sopra [something]" or "metti il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] sul/sullo/sulla/sulle/sugli/sopra/sull [something]" as putting it on.
Understand "inserisci [something] dentro [something]" or "inserisci il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] nel/nello/nella/nei/negli/nelle/nell [something]" as inserting it into.
Understand "metti [something] in/dentro [something]" or "metti il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] nel/nello/nella/nei/negli/nelle/nell [something]" as inserting it into.
Understand "cerca il/la/i/le/lo/l/gli/nel/nello/nell/nella/nelle/negli/nei/dentro/sul/sullo/sull/sulla/sugli/sulle/sui [something]" or "perquisisci  il/la/lo/i/le/gli/l [something]" as searching.
Understand "lega il/la/i/le/lo/gli/l [something]  a/al/alla/alle/agli/ai/allo/all [something]" as tying it to.
Understand "taglia il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as cutting.
Understand "pulisci il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as rubbing.
Understand "strofina il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as rubbing.

[Dialoghi]
Talking to is an action applying to one visible thing.
Understand "parla [something]" or "parla col/colla/colle/con/coll [something]" or "parla al/alla/allo/all/agli/ai/a/alle/all [something]" or "parla con il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as talking to.
Understand "chiedi a [something] di [text]" or "chiedi al/alla/allo/all/a/ai/alle/agli [something] di/del/dei/dello/della/degli/dell/delle/dei/riguardo/circa [text]" as asking it about.
Understand "parla a/al/alla/alle/agli/ai/allo/all [something] riguardo/di/del/della/dello/delle/degli/dell [text]" as telling it about.
Understand "interroga il/la/i/le/lo/gli/l [something] riguardo il/la/i/le/lo/gli/l [text]" as telling it about.
Understand "chiedi a/al/alla/alle/agli/ai/allo/all [something] riguardo/di/del/della/dello/delle/degli/dell [text]" as telling it about.
Understand "chiedi a/al/alla/alle/agli/ai/allo/all [something] il/la/i/le/l/gli/quei/quella/quello/quelle [something]" as asking it for.
Understand "chiedi a/al/alla/alle/agli/ai/allo/all [something] riguardo/di/del/della/dell/dello/delle/degli [text]" as asking it about.
Understand "rispondi a/al/alla/alle/agli/ai/allo/agli/all [someone] riguardo/di/del/della/dell/dello/delle/degli [text]" as answering it that.

[Chiavi]
Understand "apri [something]" or "apri il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as opening.
Understand "chiudi [something]" or "chiudi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as closing.
Understand "sblocca [something] con [something]" or "sblocca il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] con il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as unlocking it with.
Understand "apri [something] con [something]" or "apri il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] con  il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as unlocking it with.
Understand "blocca [something] con [something]" or "blocca il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] con  il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as locking it with.
Understand "chiudi [something] con [something]" or "chiudi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] con  il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something]" as locking it with.
Understand "rimuovi [something] da [something]" or "rimuovi il/la/lo/i/le/gli/l/quei/quella/quello/quelle/quegli/quei/quell [something] da/dalle/dalla/dagli/dai/dall [something]" as removing it from.

[Descrizioni]
Understand "brevi" as preferring sometimes abbreviated room descriptions.

[Inventario]
Understand "inventario" or "inv" or "i" as taking inventory.

[Movimento]
Understand "vai [something]" or "vai a [something]" as going.
Understand "scendi dalla/dal/da/dai/dalle/dagli/dall [something]" as getting off.
Understand "scendi" as exiting.
Understand "esci" as exiting.
Understand "sali su/sul/sullo/sulla/sulle/sugli/sui/sull [something]" as entering.
Understand "salta su/sul/sullo/sulla/sulle/sugli/sui/sull [something]" as entering.
Understand "entra nello/nella/in/nel/nei/negli/nelle/nell [something]" as entering.
Understand "siedi sullo/sulla/su/sul/sui/sugli/sulle/sull [something]" as entering.
Understand "siediti sullo/sulla/su/sul/sui/sugli/sulle/sull [something]" as entering.
Understand "o" as west.
Understand "ovest" as west.
Understand "sud" as south.
Understand "est" as east.
Understand "nord" as north.
Understand "nordovest" as northwest.
Understand "sudovest" as southwest.
Understand "sudest" as southeast.
Understand "nordest" as northeast.
Understand "su" as up.
Understand "giù" or "giu" as down.

[Carica/Salva/Esci]
Understand "punti" or "punteggio" as requesting the score.
Understand "sipunti" or "sipunteggio" or "notifica" as switching score notification on.
Understand "nopunti" or "nopunteggio" or "notifica off" as switching score notification off.
[Understand "esci" as quitting the game.] [LEO meglio usare 'esci' per uscire dai contenitori]
Understand "salva" as saving the game.
Understand "carica" as restoring the game.

[Direzioni]
The printed name of north is "nord". 
The printed name of  northeast is "nordest". 
The printed name of east is "est". 
The printed name of southeast is "sudest". 
The printed name of  south is "sud". 
The printed name of  southwest is "sudovest".
The printed name of  west is "ovest". 
The printed name of  northwest is "nordovest". 
The printed name of up is "su". 
The printed name of down is "giù". 
The printed name of  inside is "dentro". 
The printed name of  outside is "fuori".  

[Sì/no]
Understand "sì" or "si" as saying yes.

Understand the command "no" as something new.
Understand "no" as saying no.

Part 4.3 - Command parser internals

Include (-
[ LanguageVerb i;
    switch (i) {
      'i//','inv','inventario':
               print "inventario";
      'r//':   print "revisionare";
      'x//':   print "esaminare";
      'z//':   print "aspettare";
      'v//':   print "revisionare";
      'a//':   print "aspettare";
      '!//':   print "dire";
      '?//':   print "domandare";
      'q//':   print "uscire";
      'chiudere': print "chiudere";
      'sbloccare': print "sbloccare";
      default: rfalse;
    }
    rtrue;
];

[ LanguageVerbLikesAdverb w;
    if (w == 'look' or 'go' or 'push' or 'walk')
        rtrue;
    rfalse;
];

[ LanguageVerbMayBeName w;
    if (w == 'long' or 'short' or 'normal'
                    or 'brief' or 'full' or 'verbose')
        rtrue;
    rfalse;
];
-) instead of "Commands" in "Language.i6t".

Include (-
Constant AGAIN1__WD     = 'ancora';
Constant AGAIN2__WD     = 'an//';
Constant AGAIN3__WD     = 'ancora';
Constant OOPS1__WD      = 'oops';
Constant OOPS2__WD      = 'oo//';
Constant OOPS3__WD      = 'oops';
Constant UNDO1__WD      = 'undo';
Constant UNDO2__WD      = 'undo';
Constant UNDO3__WD      = 'undo';

Constant ALL1__WD       = 'ogni';
Constant ALL2__WD       = 'ognuno';
Constant ALL3__WD       = 'ognuna';
Constant ALL4__WD       = 'qualsiasi';
Constant ALL5__WD       = 'entrambi';
Constant AND1__WD       = 'e';
Constant AND2__WD       = 'e';
Constant AND3__WD       = 'e';
Constant BUT1__WD       = 'ma';
Constant BUT2__WD       = 'eccetto';
Constant BUT3__WD       = 'ma';
Constant ME1__WD        = 'me';
Constant ME2__WD        = 'me stesso';
Constant ME3__WD        = 'stesso';
Constant OF1__WD        = 'di';
Constant OF2__WD        = 'di';
Constant OF3__WD        = 'di';
Constant OF4__WD        = 'di';
Constant OTHER1__WD     = 'altri';
Constant OTHER2__WD     = 'altro';
Constant OTHER3__WD     = 'altra';
Constant THEN1__WD      = 'allora';
Constant THEN2__WD      = 'allora';
Constant THEN3__WD      = 'allora';

Constant NO1__WD        = 'n//';
Constant NO2__WD        = 'no';
Constant NO3__WD        = 'no';
Constant YES1__WD       = 's//';
Constant YES2__WD       = 'sì';
Constant YES3__WD       = 'sì';

Constant AMUSING__WD    = 'amusing';
Constant FULLSCORE1__WD = 'fullscore';
Constant FULLSCORE2__WD = 'full';
Constant QUIT1__WD      = 'q//';
Constant QUIT2__WD      = 'quit';
Constant RESTART__WD    = 'restart';
Constant RESTORE__WD    = 'restore';
-) instead of "Vocabulary" in "Language.i6t".


Part - Other Extension Fixes

Chapter - Glulx Entry Points (for use with Glulx Entry Points by Emily Short)

Section - Debounce arrange events - unindexed (in place of Section - Debounce arrange events - unindexed in Glulx Entry Points by Emily Short)

[ Gargoyle sends an arrange event while the user is dragging the window borders, but we really only want one event at the end. Debounce the arrange event to ignore the earlier ones. ]

Arranging now in GEP is a truth state variable. Arranging now in GEP is false.

First glulx input handling rule for an arrange-event while arranging now in GEP is false (this is the debounce arrange event rule):
	let ii be 0; [ for the I6 polling code to use ] [FIXED variable 'i' changed to 'ii' to avoid conflict with italian article 'i']
	let final return value be a number;
	let arrange again be true;
	[ Poll for further arrange events ]
	while 1 is 1:
		poll for events in GEP;
		if the current event number in GEP is 0:
			break;
		otherwise if the current glk event is an arrange-event:
			next;
		[ We have a different event ]
		otherwise:
			[ Run the arrange rules ]
			let temp event type be the current glk event;
			set the current glk event in GEP to an arrange-event;
			now final return value is the glulx input handling rules for an arrange event;
			set the current glk event in GEP to temp event type;
			now arrange again is false;
			now final return value is the value returned by glk event handling;
			break;
	[ Run the arrange rules if we didn't get another event type ]
	if arrange again is true:
		now final return value is the glulx input handling rules for an arrange event;
	[ Return values ]
	if final return value is input replacement:
		replace player input;
	if final return value is input continuation:
		require input to continue;
	rule fails;

To decide what number is the glulx input handling rules for an arrange event:
	let final return value be a number;
	now arranging now in GEP is true;
	now final return value is the value returned by glk event handling;
	now arranging now in GEP is false;
	decide on final return value;

To poll for events in GEP:
	(- glk_select_poll( gg_event ); for ( tmp_0 = 0 : tmp_0 < 3 : tmp_0++) { evGlobal-->tmp_0 = gg_event-->tmp_0; } -).

To decide what number is the current event number in GEP:
	(- evGlobal-->0 -).

To set the current glk event in GEP to (ev - a g-event):
	(- evGlobal-->0 = {ev}; -).



Italian Language ends here.

---- DOCUMENTATION ----

(The documentation of this extension is written in italian)

Chapter: Indirizzi utili

L'estensione è stata scritta da Massimo Stella, con il contributo di Tristano Ajmone.
Leonardo Boselli sta curando la manutenzione dell'estensione e la traduzione delle estensioni più utili già disponibili.

Per qualsiasi domanda è possibile contattare l'autore all'indirizzo email:

	leonardo.boselli@istruzione.it

L'estensione "Italian Language" e i suoi futuri aggiornamenti sono disponibili all'indirizzo:

	https://github.com/i7/extensions/tree/master/Massimo-Stella

Le estensioni inglesi tradotte in italiano e i loro futuri aggiornamenti sono reperibili all'indirizzo:

	https://github.com/i7/extensions/tree/master/Leonardo-Boselli 

Chapter: Introduzione

L'estensione "Italian Language" trasforma la lingua dell'interfaccia di gioco di un'avventura scritta con Inform 7 dall'inglese all'italiano. In realtà, non solo la lingua con cui il giocatore interagirà con il gioco diviene l'italiano, ma anche il linguaggio di programmazione vero e proprio potrebbe diventare, in alcuni aspetti, l'italiano. Per il momento la documentazione non tratterà di quest'ultimo aspetto, visto che, almeno in questa fase, è secondario.

Chapter: Installare l'estensione

Per installare l'estensione nel programma Inform 7 installato sul proprio computer è sufficiente scaricare il file "Italian Language.i7x" dall'indirizzo sopra specificato, eseguire Inform 7 e selezionare la voce di menù  File>Install Extension. Una volta eseguita questa operazione, non è più necessario effettuarla successivamente, a meno di non voler installare degli aggiornamenti. 

Per includere l'estensione e utilizzarla nelle proprie avventure occorre scrivere nella finestra dell'editor la seguente linea, magari subito dopo la linea col titolo dell'avventura e l'autore, facendola poi seguire dall'inclusione di altre eventuali estensioni tradotte:

	Include Italian Language by Massimo Stella.

A questo punto è possibile proseguire la scrittura del programma utilizzando tutte le funzionalità che supportano la lingua italiana.

Chapter: I comandi

Qual è il primo effetto dell'inclusione? Tutti i comandi più comuni che un giocatore può voler utilizzare in un'avventura testuale possono essere impartiti in lingua italiana. Per esempio, si può utilizzare "prendi" invece di "take" e così via. In ogni caso, i comandi in inglese e le normali abbreviazioni sono comunque disponibili. Per esempio, si può usare "x", invece di "esamina", per ottenere l'elenco degli oggetti in possesso del giocatore, o "l" invece di "look" (ma anche "g" invece di "guarda"), per visualizzare la descrizione della stanza in cui si trova il giocatore e così via.

I comandi che implicano l'uso di uno o più oggetti, come "apri la gabbia con la chiave", possono essere abbreviati, "apri gabbia con chiave", perdendo gli articoli (ciò deve avvenire per tutti gli articoli presenti, altrimenti il comando non viene compreso). Le preposizioni articolate sono correttamente riconosciute, quindi è corretto scrivere "metti la penna sul tavolo", ma viene accettato anche "metti penna su tavolo".

Chapter: Le risposte

Qual è il secondo effetto dell'inclusione? Anche le risposte (automatiche) ai comandi più comuni risultano tradotte in italiano.

Chapter: Creare testi

Naturalmente un'avventura che si limiti ai comportamenti di base è davvero poco interessante. Un autore deve scrivere molti messaggi in risposta alle varie azioni del giocatore. La release 6L02 (e successive) prevede gli "adaptive text", cioè testi che, scritti in un modo particolare, si adattano a varie situazioni, come diversi punti di vista o differenti tempi verbali.

Section: Articoli e preposizioni articolate

L'estensione definisce gli articoli italiani e le preposizioni articolate. Per ottenerli è sufficiente descrivere un oggetto in questo modo:

	The gabbie is a plural-named feminine gender container.
	The sedia is a feminine gender supporter.
			
"Plural-named" serve per specificare che il nome è plurale (il default è singolare) e "feminine gender" specifica il femminile (il default è il maschile). A questo punto, i seguenti testi generano i risultati riportati a fianco:

	"vedo [the sedia] e [the gabbie]" (vedo la sedia e le gabbie)
	"vedo [a sedia] e [some gabbie]" (vedo una sedia e delle gabbie)
	"le sbarre [dip the gabbie]" (le sbarre delle gabbie)
	"[ap the gabbie]" (alle gabbie)
	"uscire [dap the gabbie]" (uscire dalle gabbie)
	"mettere [inp the gabbie]" (mettere nelle gabbie)
	"[conp the gabbie]" (con le gabbie)
	"[sup the gabbie]" (sulle gabbie)
	"[perp the gabbie]" (per le gabbie)
	"[trap the gabbie]" (tra le gabbie)
	"[frap the gabbie]" (fra le gabbie)
											
Questi non sono esempi molto significativi, perché un autore avrebbe potuto scrivere direttamente il testo corrispondente, ma spesso non si conosce in anticipo il nome dell'oggetto sul quale il comando è applicato, come in questo caso:

	Instead of entering a container (called contenitore):
		say "Non puoi entrare [inp the contenitore] perché è proibito."
		
Quando il giocatore ordinerà "entra nelle gabbie", la risposta sarà "Non puoi entrare nelle gabbie perché è proibito", ma la risposta a "entra in acqua" (se "acqua" fosse definita come un oggetto contenitore di genere femminile) sarà "Non puoi entrare nell'aqua perché è proibito". In questo consiste la potenza degli "adaptive texts". 

Section: Il punto di vista e i tempi verbali

Normalmente un'avventura testuale risponde ai comandi riferendosi al giocatore (o meglio, al suo personaggio) con la seconda persona singolare e declinando i verbi al tempo presente, come è stato fatto negli esempi precedenti. Ora questo comportamento può essere cambiato. Nel proprio programma si può scrivere:

	When play begins: 
		now the story viewpoint is second person plural;
		now the story tense is past tense.
		
Quel "second person plural" significa che il programma non darà del "tu" al giocatore, ma del "voi". Ci sono situazioni in cui questa possibilità, per quanto insolita, potrebbe tornare utile. Ovviamente si potrebbe specificare una qualunque delle tre persone singolari o delle tre plurali, e ciò può essere anche cambiato nel corso del gioco. Inoltre, quel "past tense" significa che i tempi verbali verranno declinati al passato e non al presente, ma si potrebbe specificare anche una terza possibilità, e cioè il "future tense". 

Come può un autore sfruttare questa funzionalità? È sufficiente che, quando ci si riferisce al giocatore, nei testi tra virgolette si utilizzino dei costrutti particolari, sempre riferiti (per quanto riguarda l'italiano) alla seconda persona singolare.

Riproponendo l'esempio precedente:

	Instead of entering a container (called contenitore):
		say "[Tu] non [puoi] entrare [inp the contenitore] perché [regarding the contenitore][sei] [infetto]."

Cosa verrebbe risposto al comando "entra nelle gabbie" con il tempo al futuro e la seconda persona plurale?

	Voi non potrete entrare nelle gabbie perché sono infette.
	
Invece cosa verrebbe risposto al comando "entra in acqua" con il tempo al passato e la prima persona singolare?

	Io non potevo entrare nell'acqua perché era infetta.
	
Prima di analizzare l'esempio nel dettaglio, bisogna specificare che gli esempi non funzionerebbero con l'estensione "Italian Language" così come sono, perché l'aggettivo "infetto" è ignoto al sistema.
Ci sono molti verbi e aggettivi predefiniti (vedi sezione 3.1.1 -- si tratta di verbi e aggettivi utili per le risposte standard), ma "infetto" non è uno di questi. Per aggiungerlo alla lista, basta inserire nel proprio programma le linee:

	To say infetto:
		say "infett[o-agg]".

Se l'aggettivo terminasse con "e", come "mangiabile", si dovrebbe usare "e-agg". In questo modo l'aggettivo si adatta al genere e al numero del nome (noun) specificato nel comando.

Passiamo ora ad analizzare i vari "adaptive texts" presenti nell'esempio.

"Tu": si adatta con lo "story viewpoint" specificato (nell'esempio diventa perciò "Voi" e "Io" a seconda dei casi). Altre particelle disponibili sono "tu" (per il minuscolo), "te", "ti" ecc.
"puoi": si adatta con lo "story viewpoint" (poiché segue il "Tu") e con lo "story tense". Può essere utilizzato perché il verbo "potere" (così come tanti altri -- vedi sezione 3.1.1) è definito nell'estensione.
"sei": si comporta come "puoi", ma dato che non deve seguire il numero del "Tu", ma quello del contenitore, prima dev'essere specificato "regarding the contenitore" che fa comprendere al sistema qual è il soggetto. Tutto ciò che segue in "regarding" si accorda col numero e il genere dell'oggetto specificato.

Ovviamente quel soggetto (Tu) a inizio frase suona piuttosto innaturale. Per toglierlo si può procedere in questo modo:
 
	Instead of entering a container (called contenitore):
		say "Non [regarding the player][puoi] entrare [inp the contenitore] perché [sei] [infetto]."
		
Dato che il "Tu" è sparito, occorre specificare chi è il soggetto con "regarding the player", mentre il "[sei] [infetto]" si riferisce al contenitore.

Inoltre, se la prima parola del testo non fosse "Non" (già maiuscolo), ma direttamente il verbo "puoi", non funzionerebbe scrivere:

	say "[regarding the player][Puoi] entrare...".
	
perché il "puoi" verrebbe comunque stampato minuscolo. Perché? L'unica spiegazione che mi sono dato per una mancanza simile è che in inglese un verbo è sempre preceduto dal soggetto, e quindi, probabilmente, il programmatore di Inform 7 non ha pensato che per le altre lingue sarebbe stato utile prevedere un diverso comportamento, che tenesse conto della maiuscola.
Cosa possiamo fare? Purtroppo l'unico modo è ricorrere all'estensione "Text Capture", che viene inclusa automaticamente. Serve per leggere un testo prima che venga stampato per elaborarlo e, solo alla fine, mostrarlo sullo schermo. Per l'autore di avventure, non comporta grandi disagi. È sufficiente ricordarsi di scrivere il testo in questo modo:

	say "[regarding the player][maiuscolo][puoi][maiuscolo] entrare...".
	
La frase che deve essere scritta con l'iniziale maiuscola va contornata da due "maiuscolo".

Chapter: Conclusione
			
Queste sono solo alcune note utili per comprendere il funzionamento dell'estensione e dei nuovi meccanismi che riguardano gli "adaptive texts". Per approfondire, è utile leggere il sorgente dell'estensione che mostra in se stesso numerosi esempi di come possa essere utilizzata.

Per segnalare bug, porre qualsiasi domanda e avere chiarimenti, potete contattare l'autore all'indirizzo:

	leonardo.boselli@istruzione.it
	
