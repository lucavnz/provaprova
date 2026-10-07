Ecco le risposte esatte a entrambe le tue domande, punto per punto e con la fisica che ci sta dietro.

---

### PARTE 1: Perché il loro (Paper 2) non funziona su silicio e il tuo invece funziona?

Il problema del Paper 2 si riassume in una parola: **INCOSCIENZA DI PROGETTAZIONE**.

#### Cosa succede nel loro circuito (Paper 2):
1. **Lavorano a una tensione estrema: $V_{DD} = 0.2\text{ V}$ ($200\text{ mV}$)**.  
   A 28 nm, per la legge di Pelgrom sul mismatch litografico:
   $$\sigma_{\Delta V_{th}} = \frac{A_{V_{th}}}{\sqrt{W \cdot L}}$$
   la tensione di soglia di due transistor vicini fluttua casualmente di circa **$\pm 25\text{ mV}$**.
2. **Su 200 mV di alimentazione, 25 mV è un'enormità: è oltre il $12.5\%$ dell'intera alimentazione!**
3. Poiché in debole inversione (*subthreshold*) la corrente dipende esponenzialmente dalla soglia:
   $$I_D \propto \exp\left(-\frac{V_{th}}{n U_T}\right)$$
   uno sbalzo di soli 25 mV fa variare la corrente da un chip all'altro di **oltre il $300\%$** ($\times 0.48$ nei chip lenti SS, $\times 2.1$ nei chip veloci FF).
4. **Il disastro:** Con un'alimentazione così bassa (200 mV), gli inverter hanno un guadagno minuscolo. Se su un chip l'NMOS capita un po' più debole del PMOS per colpa di Pelgrom, la soglia di scatto dell'inverter sale sopra il massimo potenziale raggiungibile dalla membrana. Il neurone **non riesce più a commutare e resta permanentemente bloccato e muto**!  
   E cosa hanno fatto gli autori di Paper 2 per risolvere questo? **Assolutamente nulla.** Non hanno messo nessun circuito di taratura.

#### Perché invece il TUO circuito funziona?
1. **Hai introdotto l'Innovazione 3: Calibrazione via Bulk-Biasing ($V_{bulk}$ tuning):**  
   Non hai lasciato il circuito in balia del silicio. Hai portato fuori il terminale di substrato (**bulk**) dell'NMOS del comparatore (M3). Sfruttando l'effetto body:
   * Se il chip esce dalla fonderia "lento" (corner SS) e la soglia è troppo alta, applichi un Forward Body Bias ($V_{bulk} > 0$) e **abbassi artificialmente la soglia**, riportando il neurone al punto esatto nominale!
   * Se il chip esce "veloce" (corner FF), applichi Reverse Body Bias e alzi la soglia.  
   Nelle simulazioni Monte Carlo su 100 chip, la dispersione di frequenza crolla dal **$32.7\%$ all'$8.0\%$**!
2. **Lavori a tensioni sicure ($1.8\text{ V}$ o $0.6\div 1.0\text{ V}$):**  
   Una fluttuazione di $20\text{ mV}$ su $1.8\text{ V}$ è appena l'**$1\%$** dell'alimentazione, non il $13\%$. Il circuito ha margini di rumore e dinamica ampi e stabili.
3. **Hai la compensazione termica CTAT (Innovazione 1):**  
   La corrente subthreshold varia esponenzialmente anche con la temperatura. Il loro circuito al primo sbalzo termico smette di funzionare; il tuo ha la cella CTAT che blocca la deriva entro $\pm 14\%$ tra $-40^\circ\text{C}$ e $+125^\circ\text{C}$.

---

### PARTE 2: Perché siamo partiti dal Paper 1 e non dal Paper 2?

Ci sono **4 ragioni ingegneristiche fondamentali**:

#### 1. L'eleganza e la compattezza dell'idea di base del Paper 1 (5T vs 8T + 2 Condensatori)
* **Paper 1** aveva un'intuizione architetturale geniale: usare **un solo transistor (M1)** che fa sia da resistenza di scarica biologica a riposo (*leak*) sia da interruttore di scarica rapida (*reset*), con **1 solo condensatore**.
* **Paper 2** invece è molto più ingombrante: usa 8 transistori e soprattutto **2 CONDENSATORI INTEGRATI ($C_{mem}$ e $C_{res}$)**.  
  👉 *Regola d'oro del layout microelettronico:* **I condensatori integrati occupano un'enormità di area di silicio rispetto ai transistor!** Avere due condensatori per neurone significa raddoppiare l'area del chip. Se vuoi mettere $100.000$ neuroni su un chip neuromorfico, l'architettura di Paper 2 occupa troppo silicio.

#### 2. Paper 1 aveva falle enormi ma un potenziale altissimo (perfetto per una Tesi Magistrale)
In una tesi magistrale di ricerca, il tuo obiettivo è fare una scoperta scientifica e risolvere un problema reale della letteratura.
* Paper 1 pretendeva di aver fatto il neurone perfetto a 130 nm, ma:
  * Aveva nascosto il consumo reale (dichiarava $35\text{ fJ}$, ma in realtà consuma $7.73\text{ pJ}$ per il corto-circuito crowbar);
  * Aveva inventato 6 pagine di formule per un leak che in realtà si cancella;
  * Iniettava rumore nel substrato (undershoot);
  * Non aveva refrattarietà e deragliava con la temperatura.
* **Prendere quel circuito "zoppo" ed evolverlo con 4 innovazioni brevettabili** ha permesso di creare una tesi con un contributo scientifico e industriale eccezionale.

#### 3. Paper 2 si basava su presupposti fisici falsi
Non si può costruire un'architettura partendo da un paper (Besrour) che scrive le equazioni quadratiche di forte inversione per dispositivi alimentati a 200 mV. Partire da quel modello avrebbe significato ereditare fondamenta matematiche palesemente scorrette.

#### 4. Interfacciamento reale con il mondo esterno (1.8 V vs 0.2 V)
Un neurone deve pilotare memorie (RRAM/memristori) o circuiti logici digitali CMOS standard:
* Lo spike del **Paper 1 esce a $1.8\text{ V}$ (full-swing)**: può pilotare direttamente porte logiche e memorie senza bisogno di circuiti intermedi.
* Lo spike del **Paper 2 esce a soli $0.2\text{ V}$**: per usarlo saresti costretto a mettere dopo ogni neurone un amplificatore/level-shifter, che consumerebbe molta più area e potenza del neurone stesso!

---

### Il riassunto in 20 secondi (da tenere a mente):
> *"Siamo partiti dal **Paper 1** perché la sua idea di core compatto (M1 con doppio ruolo leak/reset) è la più efficiente come area di silicio (ha un solo condensatore, contro i due del Paper 2) ed esce a una tensione ($1.8\text{ V}$) subito compatibile con la logica digitale.*  
> *Paper 2 a 200 mV non funziona nella realtà industriale perché il mismatch di Pelgrom manda i transistor fuori specifica e blocca il circuito.*  
> *Noi abbiamo preso la topologia compatta del Paper 1, ne abbiamo corretto gli errori e abbiamo introdotto la **taratura di bulk**, la **stabilità termica CTAT** e il **controllo di refrattarietà**, rendendolo finalmente un circuito affidabile e producibile per STMicroelectronics."*

Ecco le risposte esatte a entrambe le tue domande, punto per punto e con la fisica che ci sta dietro.

---

### PARTE 1: Perché il loro (Paper 2) non funziona su silicio e il tuo invece funziona?

Il problema del Paper 2 si riassume in una parola: **INCOSCIENZA DI PROGETTAZIONE**.

#### Cosa succede nel loro circuito (Paper 2):
1. **Lavorano a una tensione estrema: $V_{DD} = 0.2\text{ V}$ ($200\text{ mV}$)**.  
   A 28 nm, per la legge di Pelgrom sul mismatch litografico:
   $$\sigma_{\Delta V_{th}} = \frac{A_{V_{th}}}{\sqrt{W \cdot L}}$$
   la tensione di soglia di due transistor vicini fluttua casualmente di circa **$\pm 25\text{ mV}$**.
2. **Su 200 mV di alimentazione, 25 mV è un'enormità: è oltre il $12.5\%$ dell'intera alimentazione!**
3. Poiché in debole inversione (*subthreshold*) la corrente dipende esponenzialmente dalla soglia:
   $$I_D \propto \exp\left(-\frac{V_{th}}{n U_T}\right)$$
   uno sbalzo di soli 25 mV fa variare la corrente da un chip all'altro di **oltre il $300\%$** ($\times 0.48$ nei chip lenti SS, $\times 2.1$ nei chip veloci FF).
4. **Il disastro:** Con un'alimentazione così bassa (200 mV), gli inverter hanno un guadagno minuscolo. Se su un chip l'NMOS capita un po' più debole del PMOS per colpa di Pelgrom, la soglia di scatto dell'inverter sale sopra il massimo potenziale raggiungibile dalla membrana. Il neurone **non riesce più a commutare e resta permanentemente bloccato e muto**!  
   E cosa hanno fatto gli autori di Paper 2 per risolvere questo? **Assolutamente nulla.** Non hanno messo nessun circuito di taratura.

#### Perché invece il TUO circuito funziona?
1. **Hai introdotto l'Innovazione 3: Calibrazione via Bulk-Biasing ($V_{bulk}$ tuning):**  
   Non hai lasciato il circuito in balia del silicio. Hai portato fuori il terminale di substrato (**bulk**) dell'NMOS del comparatore (M3). Sfruttando l'effetto body:
   * Se il chip esce dalla fonderia "lento" (corner SS) e la soglia è troppo alta, applichi un Forward Body Bias ($V_{bulk} > 0$) e **abbassi artificialmente la soglia**, riportando il neurone al punto esatto nominale!
   * Se il chip esce "veloce" (corner FF), applichi Reverse Body Bias e alzi la soglia.  
   Nelle simulazioni Monte Carlo su 100 chip, la dispersione di frequenza crolla dal **$32.7\%$ all'$8.0\%$**!
2. **Lavori a tensioni sicure ($1.8\text{ V}$ o $0.6\div 1.0\text{ V}$):**  
   Una fluttuazione di $20\text{ mV}$ su $1.8\text{ V}$ è appena l'**$1\%$** dell'alimentazione, non il $13\%$. Il circuito ha margini di rumore e dinamica ampi e stabili.
3. **Hai la compensazione termica CTAT (Innovazione 1):**  
   La corrente subthreshold varia esponenzialmente anche con la temperatura. Il loro circuito al primo sbalzo termico smette di funzionare; il tuo ha la cella CTAT che blocca la deriva entro $\pm 14\%$ tra $-40^\circ\text{C}$ e $+125^\circ\text{C}$.

---

### PARTE 2: Perché siamo partiti dal Paper 1 e non dal Paper 2?

Ci sono **4 ragioni ingegneristiche fondamentali**:

#### 1. L'eleganza e la compattezza dell'idea di base del Paper 1 (5T vs 8T + 2 Condensatori)
* **Paper 1** aveva un'intuizione architetturale geniale: usare **un solo transistor (M1)** che fa sia da resistenza di scarica biologica a riposo (*leak*) sia da interruttore di scarica rapida (*reset*), con **1 solo condensatore**.
* **Paper 2** invece è molto più ingombrante: usa 8 transistori e soprattutto **2 CONDENSATORI INTEGRATI ($C_{mem}$ e $C_{res}$)**.  
  👉 *Regola d'oro del layout microelettronico:* **I condensatori integrati occupano un'enormità di area di silicio rispetto ai transistor!** Avere due condensatori per neurone significa raddoppiare l'area del chip. Se vuoi mettere $100.000$ neuroni su un chip neuromorfico, l'architettura di Paper 2 occupa troppo silicio.

#### 2. Paper 1 aveva falle enormi ma un potenziale altissimo (perfetto per una Tesi Magistrale)
In una tesi magistrale di ricerca, il tuo obiettivo è fare una scoperta scientifica e risolvere un problema reale della letteratura.
* Paper 1 pretendeva di aver fatto il neurone perfetto a 130 nm, ma:
  * Aveva nascosto il consumo reale (dichiarava $35\text{ fJ}$, ma in realtà consuma $7.73\text{ pJ}$ per il corto-circuito crowbar);
  * Aveva inventato 6 pagine di formule per un leak che in realtà si cancella;
  * Iniettava rumore nel substrato (undershoot);
  * Non aveva refrattarietà e deragliava con la temperatura.
* **Prendere quel circuito "zoppo" ed evolverlo con 4 innovazioni brevettabili** ha permesso di creare una tesi con un contributo scientifico e industriale eccezionale.

#### 3. Paper 2 si basava su presupposti fisici falsi
Non si può costruire un'architettura partendo da un paper (Besrour) che scrive le equazioni quadratiche di forte inversione per dispositivi alimentati a 200 mV. Partire da quel modello avrebbe significato ereditare fondamenta matematiche palesemente scorrette.

#### 4. Interfacciamento reale con il mondo esterno (1.8 V vs 0.2 V)
Un neurone deve pilotare memorie (RRAM/memristori) o circuiti logici digitali CMOS standard:
* Lo spike del **Paper 1 esce a $1.8\text{ V}$ (full-swing)**: può pilotare direttamente porte logiche e memorie senza bisogno di circuiti intermedi.
* Lo spike del **Paper 2 esce a soli $0.2\text{ V}$**: per usarlo saresti costretto a mettere dopo ogni neurone un amplificatore/level-shifter, che consumerebbe molta più area e potenza del neurone stesso!

---

### Il riassunto in 20 secondi (da tenere a mente):
> *"Siamo partiti dal **Paper 1** perché la sua idea di core compatto (M1 con doppio ruolo leak/reset) è la più efficiente come area di silicio (ha un solo condensatore, contro i due del Paper 2) ed esce a una tensione ($1.8\text{ V}$) subito compatibile con la logica digitale.*  
> *Paper 2 a 200 mV non funziona nella realtà industriale perché il mismatch di Pelgrom manda i transistor fuori specifica e blocca il circuito.*  
> *Noi abbiamo preso la topologia compatta del Paper 1, ne abbiamo corretto gli errori e abbiamo introdotto la **taratura di bulk**, la **stabilità termica CTAT** e il **controllo di refrattarietà**, rendendolo finalmente un circuito affidabile e producibile per STMicroelectronics."*

**Sì, i due circuiti dei due paper sono completamente diversi!**  
E tra i due, **quello che abbiamo preso come base di partenza e riprogettato per la tesi è il PAPER 1 (Salazar-Hernandez et al.)**.

Ecco come stanno le cose e qual è il ruolo di ciascuno:

---

### 1. I due circuiti a confronto: sono molto diversi!

#### A. Il circuito del **Paper 1 (Salazar-Hernandez et al. - 130 nm)**:
* **Architettura:** A soli **5 transistori (5T)** o **6 transistori (6T)** e **1 solo condensatore**.
* **Come funziona:**
  * Ha un unico transistor chiave, **M1**, che fa un "doppio lavoro": a riposo fa da finta resistenza biologica (*leak*), e quando il neurone spara, il gate di M1 (collegato direttamente all'uscita $V_{out}$) si accende al massimo e scarica la membrana a massa (funzione di *reset*).
  * Ha poi due semplici inverter CMOS in cascata (M2-M3 e M4-M5) che fanno da comparatore e generano lo spike di uscita a $1.8\text{ V}$.
* **Perché era attraente:** È un'idea concettualmente minimalista ed elegante (pochissimi transistor).
* **I suoi difetti enormi:** M1 collegato direttamente all'uscita crea undershoot negativo, non ha nessun controllo del periodo refrattario, assorbe picchi di corto-circuito da $3.95\text{ mA}$ (crowbar) e deraglia con la temperatura ($+250\%$).

#### B. Il circuito del **Paper 2 (Besrour et al. - 28 nm)**:
* **Architettura:** A **8 transistori (8T)** e **2 condensatori distinti** ($C_{mem}$ per la membrana e $C_{res}$ per il reset), alimentato a $0.2\text{ V}$.
* **Come funziona:**
  * Non usa un transistor con doppio ruolo come M1.
  * Riceve la corrente tramite uno specchio di corrente (M1-M2), ha un circuito di reset separato e ha un condensatore dedicato ($C_{res}$) per ritardare la carica e creare un minimo di tempo refrattario fisso.
* **I suoi difetti:** Formule teoriche sbagliate (hanno usato la forte inversione a 200 mV), $V_{DD}$ troppo basso per pilotare alcunché nel mondo reale, e totale assenza di difese contro il mismatch di processo (Pelgrom).

---

### 2. Quale abbiamo usato noi nella tesi?

👉 **Noi siamo partiti dal circuito del PAPER 1 (Salazar-Hernandez)**, perché l'idea del core a doppio uso (M1 + inverter) era geniale come compattezza, ma era stata implementata in modo acerbo, fragile e pieno di errori.

Nella tua tesi, **hai preso lo scheletro di Paper 1 e lo hai trasformato nel "Neurone Unificato a 9 Transistori + Sinapsi"**, inserendo 4 innovazioni che ne hanno curato tutti i mali:

```
[ PAPER 1 (Baseline - 5T/6T) ]                [ LA TUA TESI (ST Core - 9T + Sinapsi) ]
- Gate di M1 attaccato a Vout   -------->   - Disconnesso e inserito stadio STARVED
  (nessun controllo refrattario)               (M_up, M_dn, M_starv) a refrattarietà regolabile.
                                            
- Corrente iniettata ideale      -------->   - Aggiunta Cella di BIAS CTAT (Mb1, Mb2, Rbias, M6)
  (deriva termica > 250%)                      per cancellare la deriva termica (ora entro ±14%).
                                            
- Nessuna taratura litografica   -------->   - Portato fuori il BULK di M3 per la calibrazione
  (mismatch Pelgrom CV > 30%)                  post-fabbricazione via substrato (CV crolla all'8%).
                                            
- Ingresso a corrente continua   -------->   - Aggiunto FRONT-END SINAPTICO (Msyn_w, Msyn_sw)
                                               a iniezione di carica quantizzata a pacchetti.
```

---

### 3. E allora il Paper 2 (Besrour) a cosa serve nella tesi?

Il Paper 2 nella tua tesi ha un ruolo fondamentale di **confronto critico dello stato dell'arte (Capitolo 2 e Capitolo 4)**:
1. **Per smascherare gli errori della letteratura:** Serve a dimostrare che chi ha tentato di fare neuroni in **28 nm** (Besrour) ha commesso gravi errori fisici (formule quadratiche a 0.2 V) e ha prodotto un chip inutilizzabile industrialmente per il mismatch di Pelgrom.
2. **Come benchmark di scaling per STMicroelectronics:** Dimostri che, se si vuole scendere al nodo nanometrico **28 nm di STMicroelectronics (28 nm FD-SOI)**, la strada giusta non è il design sgangherato a 0.2 V di Besrour, ma **portare la TUA architettura a 9 transistor a 0.6 V con calibrazione via back-gate**, ottenendo veri consumi a femtojoule ($2.09\text{ fJ/spike}$) e piena robustezza industriale.

Edited asddsadd.md
Viewed asddsadd.md:41-54

Viewed TESI_MAGISTRALE_NEURONE_SPIKING_SUBTHRESHOLD.md:1-200
Viewed TESI_MAGISTRALE_NEURONE_SPIKING_SUBTHRESHOLD.md:201-400
Viewed TESI_MAGISTRALE_NEURONE_SPIKING_SUBTHRESHOLD.md:401-650

Ecco la spiegazione chiara, diretta e completa per sciogliere ogni dubbio.

---

### 1. La questione delle tensioni: 0.2 V o 1.8 V? Chi usa cosa?

La confusione nasce dal fatto che **i due paper usano due tensioni completamente diverse e opposte**:

| Parametro | **Paper 1: Salazar-Hernandez et al. (2026)** | **Paper 2: Besrour et al. (2026)** | **La Tesi (Matteo Luca / Target ST)** |
| :--- | :--- | :--- | :--- |
| **Tensione ($V_{DD}$)** | **$1.8\text{ V}$** | **$0.2\text{ V}$ ($200\text{ mV}$)** | **$1.8\text{ V}$** (baseline 130 nm) <br> **$1.0\text{ V}$** (Near-Threshold 130 nm) <br> **$0.6\text{ V}$** (Target ST 28 nm FD-SOI) |
| **Tecnologia** | SkyWater **130 nm** CMOS | TSMC **28 nm** CMOS | SkyWater **130 nm** / ST **28 nm FD-SOI** |
| **Motivazione dichiarata** | Uscita ad ampia escursione (*Dual-Mode*): per pilotare memristori/RRAM ($>1\text{ V}$) e logica standard senza level-shifter. | *Ultra-low-voltage*: abbattere al minimo la potenza dinamica ($P \propto C V_{DD}^2 f$) e millantare consumi sub-femtojoule. | **Compromesso industriale ottimale:** né l'energivoro 1.8V, né l'instabile 0.2V, ma *Near-Threshold scaling* con calibrazione. |

---

### 2. Cosa fanno i due Paper e quali errori contengono?

#### **Paper 1: Salazar-Hernandez et al. (IEEE Access 2026)**
* **Cosa fa:**  
  Propone un neurone compatto a **5 transistori (5T)** o **6 transistori (6T)** e 1 capacità integrata ($C_m = 123.5\text{ fF}$) a **$V_{DD} = 1.8\text{ V}$**.
  * Ha un NMOS (M1) sul nodo di membrana $V_m$ pilotato dall'uscita $V_{out}$. A riposo ($V_{out}=0$), M1 è a $V_{GS}=0$ e lavora in debole inversione (*subthreshold*), fungendo da resistenza di perdita biologica ($R_{leak}$).
  * Due inverter in serie fanno da comparatore di soglia e generano lo spike di uscita (da $0$ a $1.8\text{ V}$).
  * Quando esce lo spike, $V_{out} = 1.8\text{ V}$ accende M1 in forte conduzione per resettare (scaricare a terra) la membrana $V_m$.
* **I gravi problemi scoperti:**
  1. **Il Paradosso di $R_{leak}$:** Gli autori scrivono 6 pagine di formule complesse per calcolare la resistenza media $R_{leak}$ di M1. Ma a $V_{GS}=0$, la corrente di perdita di M1 è di soli $\sim 10\text{ pA}$, mentre la corrente iniettata in ingresso è $2.3 \div 118\text{ nA}$ (oltre 1000 volte più grande!). La matematica dimostra che **$R_{leak}$ si cancella asintoticamente dalle equazioni**: il loro neurone non fa alcun leak biologico, è per il 99.9% un **semplice condensatore lineare ideale** ($I = C \frac{dV}{dt}$).
  2. **L'inganno dei $35.9\text{ fJ/spike}$:** Gli autori dichiarano un consumo record di $35.9\text{ fJ}$, ma hanno calcolato solo l'energia immagazzinata sulla capacità ($\frac{1}{2} C_m V_{th}^2$)! Hanno ignorato la massiccia corrente di corto-circuito (**crowbar current**) degli inverter durante la lenta rampa di soglia. Simulando il circuito reale, il picco di corrente tocca **$3.95\text{ mA}$** e l'energia reale è di **$7.73\text{ pJ/spike}$** (**oltre 180 volte superiore** a quanto dichiarato!).
  3. **Undershoot negativo:** Quando l'uscita ricade a 0 V, l'accoppiamento capacitivo trascina la membrana sotto terra ($V_m = -0.16\text{ V}$), accendendo le giunzioni parassite del substrato di silicio.
  4. **Instabilità termica:** Senza compensazione, la frequenza tra $-40^\circ\text{C}$ e $+125^\circ\text{C}$ sballa di oltre il $+250\%$.

---

#### **Paper 2: Besrour et al. (IEEE 2026)**
* **Cosa fa:**  
  Propone un neurone a **8 transistori (8T)** e 2 condensatori ($C_{mem} = 3.4\text{ fF}$ e $C_{res}$ per il reset) in tecnologia avanzata **28 nm** alimentato a bassissima tensione: **$V_{DD} = 0.2\text{ V}$ ($200\text{ mV}$)**.
  * Riceve corrente tramite uno specchio di corrente M1-M2 che carica $C_{mem}$, e usa inverter a 200 mV per produrre spike a bassissima energia ($1.2\text{ fJ/spike}$).
* **I gravi problemi scoperti:**
  1. **L'errore fisico madornale:** Gli autori descrivono i transistor con l'equazione classica di **saturazione forte quadratica**:
     $$I_D \propto (V_{GS} - V_{th})^2$$
     Ma a $28\text{ nm}$ la soglia $V_{th}$ è di circa $0.35 \div 0.45\text{ V}$. Se l'intero circuito è alimentato a $0.2\text{ V}$, $V_{GS}$ non può mai superare $0.2\text{ V}$! L'overdrive è negativo: $V_{GS} - V_{th} < -0.15\text{ V}$. I transistor sono **tutti in debole inversione profonda (*deep subthreshold*)**, dove la corrente è puramente esponenziale e governata dalla diffusione termica, non quadratica! Usare la formula quadratica a 200 mV è un palese errore teorico.
  2. **Inutilizzabile in fabbrica per variabilità (Mismatch di Pelgrom):** A 28 nm, le variazioni litografiche casuali ($\sigma_{Vth} \approx 20\div 30\text{ mV}$) pesano per oltre il $15\%$ dell'intera alimentazione ($200\text{ mV}$). Poiché in subthreshold la corrente varia esponenzialmente con la soglia, da un chip all'altro la corrente varia di oltre il **$300\%$**: molti neuroni resterebbero completamente spenti o permanentemente bloccati.
  3. **Uscita a soli 200 mV:** Uno spike di ampiezza 200 mV non può pilotare né memorie né circuiti logici digitali senza stadi di amplificazione ausiliari che consumerebbero molto più del neurone stesso.

---

### 3. E invece nella soluzione della tua tesi?

La tua tesi prende le distanze dalle semplificazioni irrealistiche dei paper accademici e progetta un **IP-core industriale producibile per STMicroelectronics** (per i sensori intelligenti **ISPU** e i microcontrollori **STM32**).

#### A. Che tensione si usa nella tesi?
La tesi dimostra che né l'estremo energivoro ($1.8\text{ V}$) né l'estremo ingestibile ($0.2\text{ V}$) sono validi industrialmente. Viene quindi analizzato e validato:
1. **$V_{DD} = 1.8\text{ V}$** per la tecnologia baseline **SkyWater 130 nm**: serve come confronto equo "ad armi pari" con Paper 1, per correggere i suoi difetti architetturali.
2. **$V_{DD} = 1.0\text{ V}$ (*Near-Threshold Scaling* in 130 nm):** riducendo $V_{DD}$ vicino a $V_{thn}+|V_{thp}|$ e usando $C_m = 20\text{ fF}$, la corrente crowbar crolla e il consumo reale scende da $7.73\text{ pJ}$ a soli **$94\text{ fJ/spike}$** (82x più efficiente!).
3. **$V_{DD} = 0.6\text{ V}$ su tecnologia ST 28 nm FD-SOI:** rappresenta il target ideale definitivo per STMicroelectronics. A 0.6 V i transistor operano in sicurezza, l'energia scende a soli **$2.09\text{ fJ/spike}$** (3700x più efficiente del baseline di Paper 1) e si sfruttano i vantaggi del silicio isolato (FD-SOI).

---

#### B. Quali sono le 4 Innovazioni Circuitali introdotte nella tesi?
Viene creata un'architettura a **9 transistori con Front-End Sinaptico** che risolve uno per uno tutti i colli di bottiglia:

1. **Innovazione 1: Cella di Polarizzazione CTAT-Tracking (Compensazione Termica)**
   * **Problema risolto:** La deriva termica esponenziale della debole inversione.
   * **Come funziona:** Una cella ausiliaria locale genera una tensione di polarizzazione $V_{bias\_ctat}(T)$ con coefficiente CTAT che traccia esattamente la deriva della tensione di soglia $|V_{thp}(T)|$. La dipendenza termica al primo ordine si cancella per sottrazione.
   * **Risultato:** Su tutto il range automotive ($-40^\circ\text{C} \div +125^\circ\text{C}$), la deriva di frequenza viene schiacciata entro **$\pm 14\%$** (contro il $+250\%$ del baseline non compensato), rispettando le stringenti specifiche industriali di ST.

2. **Innovazione 2: Reset a Conduzione Strozzata (*Starved*) con Refrattarietà Programmabile**
   * **Problema risolto:** Il firing caotico incontrollato e l'assenza di refrattarietà biologica.
   * **Come funziona:** Il gate del transistor di reset M1 non è più collegato direttamente all'uscita, ma a uno stadio intermedio *starved* controllato da una tensione analogica $V_{ctrl\_refr}$.
   * **Risultato:** Permette di regolare in modo continuo il periodo refrattario assoluto da **$20\text{ ns}$ fino a oltre $5\text{ \mu s}$**, ponendo un tetto massimo invalicabile alla frequenza di scarica ($f_{max} = 1/T_{refr}$) ed evitando oscillazioni distruttive.

3. **Innovazione 3: Calibrazione del Mismatch di Processo via Bulk-Biasing ($V_{bulk}$ tuning)**
   * **Problema risolto:** La dispersione litografica casuale di Pelgrom (corner FF, SS, TT) che a 28 nm o 130 nm blocca i circuiti subthreshold.
   * **Come funziona:** Il terminale di body (*bulk*) dell'NMOS del comparatore viene pilotato da una linea di calibrazione $V_{bulk}$. Sfruttando l'effetto body, si sposta la soglia di scatto post-fabbricazione (Forward Body Bias per chip lenti SS, Reverse Body Bias per chip veloci FF).
   * **Risultato:** Nelle simulazioni Monte Carlo su 100 iterazioni, il Coefficiente di Variazione ($CV$) crolla dal **$32.7\%$ all'$8.0\%$** (un miglioramento di oltre 4 volte!), garantendo alta resa di produzione su wafer (*high yield*). È la soluzione perfetta per la tecnologia di punta di STMicroelectronics a Crolles: il **28 nm FD-SOI**, dove il bulk tuning è 4 volte più potente del bulk tradizionale.

4. **Innovazione 4: Front-End Sinaptico Integrato a 2 Transistori**
   * **Problema risolto:** Nei paper usavano un generatore di corrente ideale continuo, che non esiste nelle reti reali.
   * **Come funziona:** Un circuito sinaptico a 2 PMOS inietta pacchetti discretizzati di carica ($\Delta Q = I_{syn} \cdot T_{pulse}$) a ogni spike presinaptico in arrivo.
   * **Risultato:** Il neurone esegue una reale somma spazio-temporale a gradini di potenziale di membrana prima di sparare lo spike post-sinaptico.

---

### Schema Riassuntivo Mentale per la Tesi

* **Paper 1 (Salazar-Hernandez):** $1.8\text{ V}$, 130 nm. Sbaglia a calcolare il consumo (ignora il crowbar milliamperometrico, consuma 180x di più), fa formule inutili per un leak che in realtà si cancella, ed è instabile in temperatura.
* **Paper 2 (Besrour):** $0.2\text{ V}$, 28 nm. Sbaglia la fisica (usa formule quadratiche di saturazione a 200 mV, mentre è in subthreshold profondo), ha un mismatch ingestibile e un'uscita troppo bassa per essere utile.
* **La tua Tesi:** Spiega e dimostra gli errori dei due paper, e propone un'architettura robusta con **compensazione termica CTAT**, **refrattarietà programmabile**, **calibrazione via bulk bias** e **scaling di tensione a 0.6–1.0 V (Near-Threshold / 28 nm FD-SOI)**, riducendo l'energia reale a **femtojoule autentici** e rendendo il circuito industrialmente producibile per **STMicroelectronics**.

Edited asddsadd.md
Viewed asddsadd.md:80-93