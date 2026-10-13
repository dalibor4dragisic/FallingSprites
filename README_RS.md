# The Nose Picker (FallingSprites)

*[English version](README.md)*

Jednostavna arkadna pucačina, prvobitno napravljena u Adobe Flex 4.5 / ActionScript 3 (decembar 2013), a sada prebačena u HTML5/JavaScript.

Logoi kompanija padaju i okreću se. Igrač pomera ruku ("nose picker") levo-desno, puca na logoe i izbegava njihove metke. Na raspolaganju su četiri oružja i štit, a usput se mogu pokupiti srca za dodatni život.

## Sadržaj foldera

| Putanja | Opis |
|---|---|
| `html5/` | **HTML5/JS verzija igre**, može da se pokrene u svakom modernom browseru |
| `as3-decompiled/` | ActionScript 3 kod dekompajliran iz `FallingSprites.swf` |
| `FallingSprites.swf`, `FallingSprites.html`, `*.swz`, `swfobject.js`, `history/`, `playerProductInstall.swf` | Originalna Flash verzija (zahteva Flash Player) |
| `sounds/` | Originalni zvuci (`.mp` su zapravo MP3 fajlovi) |
| `logos/`, `pictures/` | Originalne slike |

## Pokretanje HTML5 verzije

Otvori `html5/index.html` u browseru. Server nije potreban, a igra radi i preko `file://`.

Ako želiš da je hostuješ, dovoljno je da postaviš ceo folder `html5/` na bilo koji statički web server.

```
html5/
├── index.html          # stranica sa <canvas> elementom
├── game.js             # kompletna igra (čist JavaScript, bez biblioteka)
└── assets/
    ├── img/            # slike izvučene iz SWF-a
    └── sound/          # explosion.mp3, shot.mp3
```

## Kontrole

### Tastatura

| Taster | Akcija |
|---|---|
| `S` | Start igre / nastavak posle pauze |
| `P` | Pauza |
| `←` / `→` | Pomeranje levo/desno |
| `Space` | Pucanje (držanje = rafal, otpuštanje = jedan metak) |
| `1`–`4` | Izbor oružja |
| `Ctrl` (držati) | Štit |

Klik na polje igre takođe pokreće igru (ili je nastavlja posle pauze). Dugmad **Start game** i **Pause game** mogu i da se kliknu mišem. Klik mišem na logo ga uklanja, ali ne donosi poen, kao u originalu.

### Touch (telefon/tablet)

Touch režim se uključuje sam pri prvom dodiru ekrana, a pritisak na neki taster za igru vraća tastaturu.

- **Dodir bilo gde na polju igre**: start igre, nova igra posle Game Over-a ili nastavak posle pauze
- **Povlačenje prstom**: pomeranje ruke
- **SHIELD** (dole levo, držati): štit
- **1–4** (dole desno): izbor oružja
- Pucanje je automatsko

## Pravila igre

- Igrač počinje sa **3 života**. Život se gubi kada te pogodi logo ili neprijateljski metak. Kada broj života padne na 0, igra je gotova.
- Svaki logo pri pojavi ispaljuje dva metka nadole.
- Na svakih **5 ubijenih** logoa raste opseg brzine kojom padaju.
- **Oružja:**
  1. jedan metak (žuti)
  2. dva paralelna metka (zeleni)
  3. tri metka, od kojih dva lete ukoso (plavi)
  4. veliki laser koji probija sve mete na putu (ljubičasti)
- Puške koje padaju (na svakih 5–10 s) menjaju oružje kada ih dodirneš.
- Srce (na svakih 20–40 s) donosi +1 život.
- Štit blokira i logoe i metke.

## Tehničke napomene o portu

- **Verna logika**: kod je prepisan 1:1 iz dekompajliranog AS3. Brzine, tajmeri, pozicije, nivoi težine i kolizije (presek bounding box-ova, kao Flash `hitTestObject`) su isti kao u originalu.
- **Fiksni korak od 24 Hz**: SWF je radio na 24 fps i sva kretanja su po frejmu, pa logika i dalje radi na 24 koraka u sekundi.
- **Glatko iscrtavanje**: crta se na punoj brzini ekrana (60/120/144 Hz), a pozicije i rotacije se interpoliraju između logičkih koraka.
- **Skaliranje**: logička scena je 976×805 (info traka 80 px + razmak 5 px + polje igre 976×720) i skalira se na veličinu prozora uz oštar prikaz na HiDPI ekranima.
- **Zvuk**: koristi se pool `<audio>` elemenata, tako da se zvuci mogu preklapati i rade preko `file://`.

### Razlike u odnosu na original

1. Tokom pauze se zaustavljaju i neprijateljski metci. U originalu su nastavljali da lete i mogli su da oduzmu život.
2. Običan metak nestaje na prvom pogotku. Laser i dalje probija sve.
3. Kada prozor izgubi fokus, pritisnuti tasteri se otpuštaju.
4. Blokirani su browser prečice `Ctrl+S` i `Ctrl+P`, jer se u igri koriste `S`, `P` i `Ctrl`.
5. Nove touch kontrole: povlačenje, dugme za štit i dugmad za oružje umesto dva dugmeta za levo i desno.
6. Igra je centrirana u prozoru.
7. Kada metak pogodi logo, prikazuje se eksplozija: logo se "naduva" i nestane, pa sledi blesak, talas koji se širi i varnice. Efekat je čisto vizuelan, ne utiče na kolizije i zamrzava se tokom pauze.
8. Dodir ili klik na polje igre pokreće igru (ili je nastavlja), uz trepćući natpis "TAP TO START". Posle Game Over-a dodiri se ignorišu 1 s, da se nova igra ne bi pokrenula slučajno.

Namerno su zadržane neke originalne čudnosti: oblik ponekad dobije brzinu 0 i ostane na vrhu ekrana, a puška posle dodira nastavlja da pada.

## Dekompajlirani ActionScript (`as3-decompiled/`)

Dobijen je alatom [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler) iz `FallingSprites.swf`.

| Putanja | Opis |
|---|---|
| `src/FallingSprites.as` | Glavna klasa sa celom logikom igre |
| `src/model/` | Oblici (`GeometricShape`, `Rectangle`, `Ellipse`), puške, municija, srce (`Live`), štit, dugmad |
| `src/utility/LoanShark.as` | Object pool za municiju |
| `src/interfaces/GeometricInterface.as` | Interfejs za oblike |
| `flex-generated/` | Klase koje je Flex kompajler sam generisao (stilovi, SystemManager, resource bundle-ovi) |
| `embedded-images/` | Slike koje su bile ugrađene u SWF |

Ograničenja dekompajliranog koda:

- Lokalne promenljive i parametri imaju generička imena (`_loc2_`, `param1`).
- Komentari ne postoje.
- Originalni MXML je pretvoren u AS3.
- `[Embed]` metapodaci su zamenjeni klasama `*_Bitmap` / `FallingSprites_*`.

Kod je kompletan i čitljiv, ali se ne može ponovo kompajlirati bez ručnog sređivanja.
