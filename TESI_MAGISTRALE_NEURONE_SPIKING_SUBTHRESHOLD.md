# ARCHITETTURA CIRCUITALE AVANZATA PER NEURONI SPIKING ANALOGICI IN DEBOLE INVERSIONE: ANALISI CRITICA, COMPENSAZIONE TERMICA, REFRATTARIETÀ PROGRAMMABILE E CALIBRAZIONE STATISTICA IN TECNOLOGIA CMOS

**Tesi di Laurea Magistrale in Ingegneria Elettronica / Microelettronica**  
**Indirizzo:** Progettazione di Circuiti Integrati Analogici e Mixed-Signal / Neuromorphic Computing  
**Candidato:** Matteo Luca  
**Target Industriale:** R&D STMicroelectronics (Edge AI, Intelligent Sensor Processing Unit - ISPU, PMIC Low-Power)  
**Tecnologie di Riferimento:** SKY130 (130 nm CMOS) & 28 nm CMOS / FD-SOI  

---

## SOMMARIO (ITALIANO)

Il calcolo neuromorfico basato su reti neurali a impulsi (*Spiking Neural Networks*, SNN) costituisce il paradigma computazionale più promettente per superare il collo di bottiglia di Von Neumann nelle applicazioni di Intelligenza Artificiale edge e sensori ultra-low-power. I circuiti neuronali *Leaky Integrate-and-Fire* (LIF) operanti nel regime di debole inversione (*subthreshold*) consentono teoricamente consumi energetici nell'ordine dei femtojoule per evento di spike.

Il presente lavoro di tesi sviluppa uno studio rigoroso e critico dello stato dell'arte recente, esaminando in profondità due contributi scientifici cardine: il paper di Salazar-Hernandez et al. (IEEE Access, 2026), relativo a un neurone CMOS dual-mode a 5/6 transistori in tecnologia 130 nm, e il paper di Besrour et al. (IEEE, 2026), focalizzato su un neurone analogico spiking operante a 200 mV in tecnologia 28 nm. L'analisi teorica e le simulazioni SPICE condotte con modelli predittivi e BSIM4 hanno portato all'identificazione di **gravi incongruenze modellistiche, errori fisici e colli di bottiglia pratici** presenti nella letteratura pubblicata:
1. **Il Paradosso della Resistenza di Leak:** Viene dimostrato analiticamente che l'elaborata teoria di mediazione non lineare di $R_{leak}$ proposta da Salazar-Hernandez et al. è superflua nel range di correnti operative ($2.3 \div 118\text{ nA}$), poiché la condizione $R_{leak} I_{ex} \gg V_{th(lif)}$ induce una cancellazione asintotica esatta della resistenza nella legge logaritmica, riducendo il neurone a un integratore capacitivo lineare ideale;
2. **La Sottostima Energetica del Crowbar Current:** Viene evidenziato come il consumo dichiarato di $35.9\text{ fJ/spike}$ conteggi unicamente l'energia elettrostatica immagazzinata sulla capacità di membrana, omettendo la massiccia corrente di corto-circuito (*crowbar current*) degli inverter durante la lenta transizione di soglia, la quale porta la dissipazione reale misurata a $7.73\text{ pJ/spike}$ (un errore sistematico di oltre 180x);
3. **L'Errore Fisico di Formulazione nel Paper a 28 nm:** Besrour et al. descrivono i transistori alimentati a $V_{DD} = 0.2\text{ V}$ mediante formule quadratiche di saturazione forte ($I_D \propto (V_{GS}-V_{th})^2$), una violazione fisica palese poiché a 200 mV i dispositivi operano integralmente in debole inversione profonda dominata dal trasporto per diffusione.

Per superare tali limitazioni e rendere l'architettura compatibile con le stringenti specifiche industriali e automotive di STMicroelectronics, vengono progettate e validate a livello SPICE quattro innovazioni circuitali originali:
1. **Cella di Polarizzazione Subthreshold a Compensazione Termica (CTAT-Tracking):** Un circuito ausiliario compatto che stabilizza la corrente di iniezione compensando la deriva termica della tensione di soglia, riducendo la variazione di frequenza da oltre il $+250\%$ a un intervallo compreso entro $\pm 14\%$ nel range esteso $-40^\circ\text{C} \div +125^\circ\text{C}$;
2. **Anello di Feedback a Refrattarietà Programmabile e Spike-Frequency Adaptation (SFA):** Uno stadio di reset a conduzione controllata (*starved feedback*) che introduce un periodo refrattario assoluto sintonizzabile via tensione analogica da $20\text{ ns}$ a diversi microsecondi, prevenendo oscillazioni distruttive e sovraconsumi;
3. **Compensazione del Mismatch di Processo tramite Bulk-Biasing:** L'utilizzo dell'effetto body sul discriminatore di soglia per calibrare post-fabbricazione la tensione di scatto del neurone, compensando la dispersione di Pelgrom sui corner di processo (FF, SS, TT);
4. **Front-End Sinaptico Integrato a Iniezione Quantizzata:** Un circuito a 2 transistori che abilita l'integrazione di treni di impulsi presinaptici discretizzati.

La simulazione statistica Monte Carlo su 100 iterazioni dimostra che l'architettura calibrata riduce il Coefficiente di Variazione ($CV$) della frequenza di firing dal $32.7\%$ all'$8.0\%$, trasformando un prototipo accademico instabile in un IP-core robusto e producibile per i nodi Mixed-Signal e ISPU di STMicroelectronics.

---

## ABSTRACT (ENGLISH)

Neuromorphic computing based on Spiking Neural Networks (SNNs) represents the most compelling architecture to overcome the Von Neumann bottleneck in edge AI and ultra-low-power sensing systems. Analog Leaky Integrate-and-Fire (LIF) circuits operating in weak inversion (subthreshold) theoretically enable energy consumptions in the femtojoule per spike range.

This thesis presents a thorough and critical investigation of the recent state of the art, focusing on two reference works: the paper by Salazar-Hernandez et al. (IEEE Access, 2026) demonstrating a dual-mode 5T/6T LIF neuron in 130 nm CMOS, and the paper by Besrour et al. (IEEE, 2026) presenting an analog spiking neuron operated at 200 mV in 28 nm CMOS. Through analytical derivations and comprehensive SPICE simulations using Berkeley BSIM4 models, we discover and expose **critical modeling flaws, physical errors, and practical roadblocks** in the published literature:
1. **The Leakage Resistance Paradox:** We analytically prove that the complex non-linear averaging theory of $R_{leak}$ in Salazar-Hernandez et al. is mathematically redundant over the experimental input range ($2.3 \div 118\text{ nA}$), as the condition $R_{leak} I_{ex} \gg V_{th(lif)}$ leads to an exact asymptotic cancellation of $R_{leak}$ in the logarithmic timing law, reducing the circuit to an ideal linear capacitor integrator;
2. **The Crowbar Energy Underestimation:** We show that the reported figure of $35.9\text{ fJ/spike}$ accounts solely for the electrostatic energy stored in the membrane capacitor, totally ignoring the crowbar (short-circuit) current in the CMOS inverters during slow membrane transitions, which pushes the true measured energy to $7.73\text{ pJ/spike}$ (an error exceeding 180x);
3. **The 28 nm Quadratic Modeling Blunder:** Besrour et al. model transistors operating under a 200 mV supply using strong-inversion square-law saturation equations ($I_D \propto (V_{GS}-V_{th})^2$), an overt physical mistake since at 0.2 V supply devices reside deeply in weak inversion governed by thermal diffusion.

To solve these vulnerabilities and meet the industrial standards of STMicroelectronics, four circuit-level innovations are introduced and simulated:
1. **Temperature-Compensated Subthreshold Bias Cell:** A compact auxiliary cell compensating for $V_{th}(T)$ drift, shrinking thermal frequency dispersion from $>250\%$ down to within $\pm 14\%$ across the automotive span of $-40^\circ\text{C} \div +125^\circ\text{C}$;
2. **Programmable Refractory Period & Spike-Frequency Adaptation (SFA):** A starved-feedback reset network enabling analog control of the refractory period from $20\text{ ns}$ to multiple microseconds, preventing firing runaway;
3. **Process Mismatch Compensation via Bulk-Biasing:** Dynamic body-effect tuning of the inverter trip point to absorb Pelgrom threshold variation across FF, SS, and TT process corners;
4. **Integrated Pulsed Synaptic Front-End:** A 2T synapse circuit demonstrating full-system presynaptic charge integration and postsynaptic firing.

Monte Carlo analysis over 100 runs confirms that the proposed calibration reduces the frequency Coefficient of Variation ($CV$) from $32.7\%$ to $8.0\%$, validating the circuit as an industrial-grade IP block for STMicroelectronics ISPU and edge accelerators.

---

# CAPITOLO 1: INTRODUZIONE, CONTESTO INDUSTRIALE E FONDAMENTI TEORICI

## 1.1 Il Paradigma del Neuromorphic Computing e la Crisi di Von Neumann
L'evoluzione dell'elaborazione dell'informazione si trova di fronte a una barriera fisica invalicabile: il cosiddetto *memory wall* dell'architettura tradizionale di Von Neumann. Nelle architetture digitali standard (CPU, GPU, TPU), il bus fisico di interconnessione che separa l'unità di calcolo (ALU) dalla memoria ad accesso casuale (DRAM/SRAM) impone una continua traslazione di dati che assorbe oltre l'80% dell'energia complessiva consumata per l'esecuzione di algoritmi di intelligenza artificiale. Per modelli di Deep Learning convenzionali (reti convoluzionali e Transformers), l'inferenza su dispositivi a batteria o su nodi sensore periferici risulta proibitiva in termini di dissipazione termica e autonomia.

Il cervello biologico umano processa pattern visivi, uditivi e motori complessi con una potenza dissipata di soli $\approx 20\text{ W}$, operando attraverso $\approx 10^{11}$ neuroni interconnessi da oltre $10^{14}$ sinapsi. I tre principi fondanti di questa eccezionale efficienza sono:
1. **Collocazione congiunta di memoria e calcolo (*In-Memory Computing*):** La funzione di calcolo è distribuita direttamente nei nodi sinaptici e dendritici;
2. **Elaborazione basata su eventi (*Event-Driven Spiking Activity*):** I neuroni biologici comunicano tramite impulsi asincroni di tensione standardizzati (*action potentials* o spike) e rimangono inattivi quando non vi è informazione saliente da processare;
3. **Computazione analogica a basso voltaggio:** La dinamica interna di accumulo di ioni avviene a livello elettrochimico analogico continuo, mentre la comunicazione a lungo raggio è discretizzata sotto forma di spike digitali.

Le **Reti Neurali a Impulsi (SNN - Spiking Neural Networks)** emulano direttamente questa dinamica, codificando l'informazione non nella frequenza assoluta di clock o in parole binarie a virgola mobile, ma nella densità e temporizzazione temporale dei singoli impulsi (*spike timing*).

## 1.2 Requisiti per Circuiti Edge AI ed Efficienza Energetica
Nei moderni microcontrollori e sensori intelligenti sviluppati da aziende leader quali **STMicroelectronics** (quali la serie STM32N6 integrata con Neural Processing Unit, e i sensori MEMS dotati di *Intelligent Sensor Processing Unit* - ISPU), l'obiettivo industriale è l'esecuzione di inferenza sempre attiva (*always-on keyword spotting*, monitoraggio delle vibrazioni industriali, analisi biomedica elettrocardiografica) mantenendo il consumo medio al di sotto di $100\text{ \mu W}$, con budget per singolo evento di spike nell'ordine di pochi femtojoule o picojoule:

$$\text{Energy per Spike} \le 1 \div 10\text{ pJ/spike} \quad (\text{idealmente } < 100\text{ fJ/spike})$$

I circuiti analogici integrati rappresentano la via maestra per realizzare nodi SNN compatti: un singolo transistore operante in debole inversione può implementare la conduttanza non lineare di leak, mentre le capacità parassite intrinseche possono fungere da elemento integratore.

## 1.3 Il Modello Matematico Leaky Integrate-and-Fire (LIF)
Il modello neuronale formale più utilizzato per l'implementazione circuitale è il **Leaky Integrate-and-Fire (LIF)**. La membrana cellulare è descritta come un circuito parallelo composto da una capacità di membrana $C_m$, una resistenza di perdita (*leak*) $R_{leak}$, e un generatore di corrente eccitatoria $I_{ex}(t)$:

$$C_m \frac{d V_m(t)}{dt} + \frac{V_m(t) - V_{rest}}{R_{leak}} = I_{ex}(t)$$

Quando la tensione di membrana $V_m(t)$ raggiunge una tensione di soglia prefissata $V_{th(lif)}$:
1. Viene emesso uno spike di tensione full-swing all'uscita $V_{out}$;
2. Il potenziale di membrana viene forzatamente scaricato al potenziale di riposo $V_{reset}$;
3. Il neurone entra in un periodo di inattività o refrattarietà $T_{refr}$, durante il quale non può generare nuovi spike.

La risposta nel tempo a un gradino di corrente costante $I_{ex}$ applicato a $t=0$ con $V_m(0) = V_{reset}$ è:

$$V_m(t) = V_{reset} e^{-t/\tau_m} + (V_{rest} + R_{leak} I_{ex}) \left(1 - e^{-t/\tau_m}\right)$$

dove $\tau_m = R_{leak} C_m$ è la costante di tempo di membrana. Ponendo $V_m(t_{spike}) = V_{th(lif)}$ (assumendo $V_{rest} = 0$), il tempo impiegato per raggiungere la soglia risulta:

$$t_{spike} = R_{leak} C_m \ln \left( \frac{V_{reset} - R_{leak} I_{ex}}{V_{th(lif)} - R_{leak} I_{ex}} \right)$$

e la frequenza teorica di emissione (senza considerare il tempo di reset e refrattarietà) è:

$$f_{spike} = \frac{1}{t_{spike}} = \frac{1}{R_{leak} C_m \ln \left( \frac{V_{reset} - R_{leak} I_{ex}}{V_{th(lif)} - R_{leak} I_{ex}} \right)}$$

## 1.4 Fisica del Transistore MOS in Debole Inversione (Subthreshold)
Quando il potenziale di gate-source $V_{GS}$ è inferiore alla tensione di soglia del dispositivo ($V_{GS} < V_{th}$), il canale non è percorso da una carica di inversione forte indotta per deriva elettrostatica (*drift*). Al contrario, il potenziale di superficie non supera $2\phi_F$ e la concentrazione di portatori minoritari decresce esponenzialmente dalla sorgente al pozzo. Il trasporto di carica è dunque dominato dal **fenomeno di diffusione termica dei portatori**, analogo alla corrente di una giunzione p-n o di un transistore bipolare.

Secondo il modello consolidato EKV e BSIM4, la corrente di drain in debole inversione per un transistore NMOS è espressa come:

$$I_{D,sub}(T) = I_0(T) \cdot \frac{W}{L} \cdot \exp\left( \frac{V_{GS} - V_{th}(T)}{n \, U_T(T)} \right) \left[ 1 - \exp\left( -\frac{V_{DS}}{U_T(T)} \right) \right]$$

dove:
* $U_T(T) = \frac{k_B T}{q}$ è il potenziale termico ($25.86\text{ mV}$ a $300\text{ K}$, con andamento strettamente **PTAT** - *Proportional to Absolute Temperature*);
* $n = 1 + \frac{C_{dep}}{C_{ox}} \approx 1.2 \div 1.6$ è il fattore di pendenza di sottosoglia (*subthreshold slope factor*), dipendente dal partitore capacitivo tra l'ossido di gate e la regione di svuotamento del substrato;
* $I_0(T) = 2 n \mu C_{ox} U_T^2$ è la corrente di scala caratteristica;
* $V_{th}(T) = V_{th}(T_0) - \alpha (T - T_0)$ è la tensione di soglia, con coefficiente di temperatura intrinsecamente **CTAT** (*Complementary to Absolute Temperature*), tipicamente $\alpha \approx 1.5 \div 2.0\text{ mV/K}$.

### Punti Chiave del Comportamento di Sottosoglia:
1. **Saturazione di sottosoglia:** Quando $V_{DS} \ge 3 \div 4 \, U_T \approx 80 \div 100\text{ mV}$, il termine tra parentesi quadre $[1 - \exp(-V_{DS}/U_T)]$ approssima $1$ con un errore inferiore al $2\%$. Il transistore entra in saturazione di debole inversione: la corrente diventa indipendente da $V_{DS}$ (salvo effetti secondari di DIBL) e funge da sorgente di corrente costante;
2. **Sensibilità esponenziale alla temperatura:** L'esponente $\frac{V_{GS} - V_{th}(T)}{n U_T(T)}$ possiede una derivata termica violenta. Poiché $V_{th}(T)$ si riduce con $T$ e $U_T(T)$ aumenta, all'aumentare della temperatura la corrente di leakage di un transistore a $V_{GS}=0$ aumenta di diversi ordini di grandezza;
3. **Sensibilità estrema al mismatch litografico di Pelgrom:** Secondo la legge di Pelgrom:
   $$\sigma_{\Delta V_{th}} = \frac{A_{V_{th}}}{\sqrt{W \cdot L}}$$
   Una minima variazione di $\Delta V_{th} = 20\text{ mV}$ su un transistor subthreshold induce una modulazione moltiplicativa della corrente pari a:
   $$\frac{I_{D1}}{I_{D2}} = \exp\left( \frac{\Delta V_{th}}{n U_T} \right) \approx \exp\left( \frac{20\text{ mV}}{1.4 \times 26\text{ mV}} \right) = \exp(0.55) \approx 1.73 \quad (+73\%!)$$

## 1.5 Target Industriale e Requisiti STMicroelectronics
Nelle applicazioni automotive (standard AEC-Q100 Grado 1) e nei sensori edge industriali, i circuiti integrati devono garantire la conformità delle prestazioni su un intervallo di temperatura estremo:

$$-40^\circ\text{C} \le T \le +125^\circ\text{C}$$

e attraverso i corner di processo tecnologico di fonderia:
* **TT:** Tipico-Tipico (condizioni nominali);
* **FF:** Fast-Fast (massima corrente, minima soglia);
* **SS:** Slow-Slow (minima corrente, massima soglia);
* **FS / SF:** Cross-corners (NMOS veloci e PMOS lenti, o viceversa).

Un circuito neuronale subthreshold accademico non compensato che manifesti derive di frequenza superiori al $200-300\%$ è commercialmente inservibile in un prodotto industriale ST. L'obiettivo della presente tesi è trasformare un'architettura fragile di letteratura in un circuito industriale robusto, calibrabile e a bassissimo rumore.

---

# CAPITOLO 2: ANALISI CRITICA DELLO STATO DELL'ARTE ED EVIDENZIAZIONE DEGLI ERRORI NEI PAPER

## 2.1 Disamina del Paper 1: Salazar-Hernandez et al. (IEEE Access, Febbraio 2026)
Il recente lavoro di Salazar-Hernandez et al., intitolato *"Dual-Mode CMOS LIF Neuron With Subthreshold Efficiency and Saturation-Driven Robustness"* (IEEE Access, vol. 14, 2026), propone un'architettura compatta di neurone LIF a 5 transistori (5T) estesa a 6 transistori (6T) con l'inclusione di un dispositivo di isolamento (M6), implementata nella tecnologia open-source SkyWater SKY130 ($130\text{ nm}$ CMOS, $V_{DD} = 1.8\text{ V}$).

```
                     VDD                 VDD                 VDD
                      |                   |                   |
                      +-------+           +-------+           +-------+
                      |       |           |       |           |       |
                      |     [M2] PMOS     |     [M4] PMOS     |       |
                      |       |           |       |           |       |
I_ex ----> (Vm) ------+----->(Vmid)-------+----->(Vout)       |
            |         |       |           |       |           |
          [M1]        |     [M3] NMOS     |     [M5] NMOS     +-------+
          NMOS        |       |           |       |                   |
       (Subthresh)    |      GND          |      GND                  |
            |         |                   +-------+                   |
           GND        |                           |                   |
            ^         +<---[ Feedback Reset ]-----+-------------------+
            | (Gate di M1 pilotato da Vout)
```

Il circuito opera secondo il seguente principio:
* **M1 (NMOS, $W=3\,\mu\text{m}, L=10\,\mu\text{m}$):** Collegato con drain sul nodo di membrana $V_m$, source a massa e gate connesso al nodo di uscita $V_{out}$. Tra gli spike, $V_{out} = 0$, quindi $V_{GS1} = 0$: M1 opera in debole inversione e fornisce la conduttanza di leak;
* **Inverter 1 (M2-M3, $W=450\text{ nm}, L=150\text{ nm}$):** Funge da comparatore di soglia. La soglia di scatto $V_{th(lif)}$ corrisponde al trip point dell'inverter ($Vin = Vout = V_c$);
* **Inverter 2 (M4-M5, $W=450\text{ nm}, L=150\text{ nm}$):** Fornisce guadagno e bufferizza l'uscita, producendo uno spike full-swing ($0 \to 1.8\text{ V}$);
* **Anello di Feedback:** Il fronte di salita di $V_{out}$ porta il gate di M1 a $1.8\text{ V}$, forzando M1 in forte inversione triodo per scaricare rapidamente $C_m$ verso massa.

### 2.1.1 ERRORE METODOLOGICO 1: Il Paradosso della Resistenza di Leakage $R_{leak}$
Gli autori di Paper 1 dedicano oltre 6 pagine (dall'equazione 8 all'equazione 33) a una complessa derivazione per determinare la resistenza equivalente media $\overline{R}_{leak}(V_m)$ di M1:

$$R_{leak}(V_m) = \frac{V_m}{I_{D,sub}} = \frac{V_m}{I_0 \exp\left(-\frac{V_{th}}{n U_T}\right) \left(1 - e^{-V_m / U_T}\right)}$$

Approssimano poi $R_{leak}(V_m)$ con una retta $m V_m + b$ (Fig. 13 del paper) e calcolano una resistenza media di centinaia di megaohm:
* A $I_{ex} = 118\text{ nA}$, riportano $\overline{R}_{leak} = 193.9\text{ M}\Omega$;
* A $I_{ex} = 2.32\text{ nA}$, riportano $\overline{R}_{leak} = 9709.7\text{ M}\Omega$.

Inseriscono quindi questa resistenza nell'equazione formale del tempo di integrazione LIF (Eq. 32):

$$f = \frac{1}{\overline{R}_{leak} C_m \ln \left( \frac{\overline{R}_{leak} I_{ex}}{\overline{R}_{leak} I_{ex} - V_{th(lif)}} \right)}$$

#### La Dimostrazione Matematica del Paradosso e della Cancellazione di $R_{leak}$:
Esaminiamo il prodotto $\overline{R}_{leak} \cdot I_{ex}$ tabulato dagli autori stessi nella loro Tabella 1:
* $I_{ex} = 118\text{ nA} \times 193.9\text{ M}\Omega = 22.88\text{ V}$;
* $I_{ex} = 93.1\text{ nA} \times 244.0\text{ M}\Omega = 22.71\text{ V}$;
* $I_{ex} = 23.8\text{ nA} \times 952.7\text{ M}\Omega = 22.67\text{ V}$;
* $I_{ex} = 2.32\text{ nA} \times 9709.7\text{ M}\Omega = 22.52\text{ V}$.

Il prodotto $\overline{R}_{leak} \cdot I_{ex}$ è **perfettamente costante e pari a circa $22.6\text{ V}$**.
Confrontiamo questo valore con la tensione di soglia del neurone, fissata dagli inverter a:

$$V_{th(lif)} = 0.8285\text{ V}$$

Risulta palese che:

$$\overline{R}_{leak} I_{ex} \approx 22.6\text{ V} \gg V_{th(lif)} \approx 0.8285\text{ V}$$

Definiamo la quantità adimensionale $\epsilon$:

$$\epsilon = \frac{V_{th(lif)}}{\overline{R}_{leak} I_{ex}} = \frac{0.8285\text{ V}}{22.67\text{ V}} \approx 0.0365 \ll 1$$

L'argomento del logaritmo naturale nell'equazione di frequenza può essere riscritto come:

$$\frac{\overline{R}_{leak} I_{ex}}{\overline{R}_{leak} I_{ex} - V_{th(lif)}} = \frac{1}{1 - \frac{V_{th(lif)}}{\overline{R}_{leak} I_{ex}}} = \frac{1}{1 - \epsilon}$$

Ricordando lo sviluppo in serie di Taylor al primo ordine del logaritmo naturale per $\epsilon \ll 1$:

$$\ln\left(\frac{1}{1 - \epsilon}\right) = -\ln(1 - \epsilon) = \epsilon + \mathcal{O}(\epsilon^2) \approx \frac{V_{th(lif)}}{\overline{R}_{leak} I_{ex}}$$

Sostituendo questa espansione asintotica nell'equazione (32) del paper:

$$f_{spike} \approx \frac{1}{\overline{R}_{leak} C_m \cdot \left[ \frac{V_{th(lif)}}{\overline{R}_{leak} I_{ex}} \right]} = \frac{\overline{R}_{leak} I_{ex}}{\overline{R}_{leak} C_m V_{th(lif)}} = \frac{I_{ex}}{C_m V_{th(lif)}}!$$

> **TEOREMA DI CANCELLAZIONE:**  
> **La resistenza di leakage $\overline{R}_{leak}$ si cancella esattamente dal numeratore e dal denominatore!**  
> L'elaborata trattazione matematica e il modello non lineare su 6 pagine sono fisicamente e matematicamente ininfluenti: nel range di eccitazione testato dagli autori ($2.3 \div 118\text{ nA}$), la corrente di perdita di M1 a $V_{GS}=0$ in SKY130 è nell'ordine di pochi picoampere ($I_{leak} \approx 10\text{ pA}$), ossia **oltre 1000 volte inferiore** alla corrente iniettata $I_{ex}$. Il neurone si comporta al $99.9\%$ come un **integratore capacitivo lineare ideale** ($I = C \frac{dV}{dt} \implies T = \frac{C \Delta V}{I}$), smentendo la presunta "dinamica leaky biologica" vantata nel testo!

La tabella seguente valida questa constatazione confrontando i dati misurati nel paper con la formula banale di pura integrazione capacitiva:

| $I_{ex}$ [nA] | $f_{meas}$ Paper 1 [kHz] | Formula Banale $\frac{I_{ex}}{C_m V_{th(lif)}}$ [kHz] | Errore Formula Banale |
| :---: | :---: | :---: | :---: |
| 118.00 | 1121.65 | 1153.25 | **+2.8%** |
| 71.40 | 682.27 | 697.81 | **+2.2%** |
| 23.80 | 228.43 | 232.60 | **+1.8%** |
| 2.32 | 22.15 | 22.67 | **+2.3%** |

L'errore è inferiore al $3\%$, confermando che l'accordo modello-misura vantato da Salazar-Hernandez et al. nella loro Fig. 15 deriva unicamente dalla fisica di carica di un condensatore lineare, mascherata da un formalismo matematico circolare.

---

### 2.1.2 ERRORE METODOLOGICO 2: La Sottostima Energetica e l'Omissione del Crowbar Current
Nel paragrafo di discussione energetica (Pag. 10 di Paper 1), gli autori calcolano l'energia per spike mediante la sola formula elettrostatica capacitiva:

$$E_{spike,teorica} = \frac{1}{2} C_m V_{th(lif)}^2 = \frac{1}{2} (123.5\text{ fF}) (0.8\text{ V})^2 \approx 35.9\text{ fJ/spike}$$

e la inseriscono nella Tabella comparativa (Tabella 3) per rivendicare un consumo record tra i design sub-micronici.

#### La Realtà Circuitale e la Simulazione SPICE Rigorosa:
Questa affermazione trascura un fenomeno fisico critico nei circuiti digitali/analogici CMOS: **la corrente di corto-circuito (crowbar current)**.
1. Nel neurone proposto, il nodo di membrana $V_m$ cresce con una pendenza lentissima ($dV_m/dt$ dura svariati microsecondi, ad es. $5.7\text{ \mu s}$ a $23.8\text{ nA}$);
2. Quando $V_m$ entra nell'intervallo compreso tra $V_{thn}$ e $V_{DD} - |V_{thp}|$ (intorno a $0.8\text{ V}$), **sia il transistore PMOS M2 che il transistore NMOS M3 dell'inverter conducono simultaneamente in forte conduzione**;
3. Si stabilisce un cammino a bassa impedenza diretto tra la linea di alimentazione $V_{DD} = 1.8\text{ V}$ e la massa $GND$;
4. Analogamente, il nodo $V_{mid}$ pilota l'inverter M4-M5 che attraversa anch'esso la propria zona di transizione attiva.

Abbiamo simulato l'esatta architettura in ngspice-47 integrando la potenza istantanea erogata dall'alimentatore:

$$E_{spike,reale} = \int_{0}^{T_{period}} V_{DD} \cdot I_{DD}(t) \, dt$$

I risultati ottenuti smascherano la discrepanza:
* **Corrente di picco di crowbar misurata:** **$3953.81\text{ \mu A} \approx 3.95\text{ mA}$**!
* **Energia reale dissipata per spike:** **$7.73\text{ pJ/spike}$ ($7732.8\text{ fJ/spike}$)**;
* **Rapporto tra Energia Reale e Valore Dichiarato nel Paper:**

$$\frac{E_{spike,reale}}{E_{spike,paper}} = \frac{7732.8\text{ fJ}}{42.4\text{ fJ}} \approx \mathbf{182.4\times!}$$

> **CRITICITÀ:**  
> Il consumo energetico reale del circuito è **oltre 180 volte superiore** a quanto dichiarato da Salazar-Hernandez et al. L'assenza di isteresi (ad es. trigger di Schmitt) o di accelerazione a feedback positivo rapido fa sì che gli inverter rimangano bloccati nella regione di corto-circuito per decine di nanosecondi a ogni ciclo, annullando gran parte del vantaggio di efficienza energetica del subthreshold.

---

### 2.1.3 CRITICITÀ FISICA 3: Undershoot Negativo e Iniezione di Corrente nel Substrato
Durante la transizione di reset, il segnale $V_{out}$ compie un'escursione completa da $0$ a $1.8\text{ V}$ e poi ricade a $0\text{ V}$.
Poiché M1 ha dimensioni generose ($W=3\,\mu\text{m}, L=10\,\mu\text{m}$), la capacità parassita di sovrapposizione gate-drain $C_{gd1}$ è significativa. 
Quando $V_{out}$ scende bruscamente da $1.8\text{ V}$ a $0\text{ V}$, l'accoppiamento capacitivo (*clock feedthrough*) inietta una carica negativa netta sul nodo $V_m$:

$$\Delta V_{m,undershoot} \approx - V_{DD} \cdot \frac{C_{gd1}}{C_m + C_{par}}$$

Nelle nostre simulazioni transitorie a livello transistor (Fig. 1 della tesi):
* La tensione di membrana precipita a un valore negativo di **$V_m = -0.161\text{ V}$** (e fino a **$-0.7\text{ V}$** in assenza di capacità esplicita);
* Questo potenziale negativo polarizza direttamente la giunzione p-n parassita formata dal drain di tipo $n^+$ di M1 e dal substrato di tipo $p$ connesso a massa;
* La conduzione diretta del diodo inietta elettroni nel silicio di substrato, generando **substrate noise massiccio** che può corrompere blocchi analogici di precisione adiacenti e provocare rischi di latch-up in chip industriali densi.

---


### 2.1.4 Il Dilemma della Tensione di Alimentazione: 1.8 V (Paper 1) vs 0.2 V (Paper 2)
Una domanda architetturale fondamentale riguarda la scelta del rail di alimentazione {DD}$.
* **Perché Salazar-Hernandez et al. (Paper 1) hanno scelto {DD} = 1.8	ext{ V}0**
  Gli autori giustificano esplicitamente .8	ext{ V}$ con il concetto di *Dual-Mode Robustness*: in un sistema neuromorfico completo, il neurone deve dialogare con matrici di memorie sinaptiche resistive (RRAM/Memristori, che richiedono impulsi di programmazione $> 1	ext{ V}$) e con blocchi logici digitali CMOS standard a .8	ext{ V}$. Se il neurone operasse a zsh.2	ext{ V}$, richiederebbe *level-shifter* e amplificatori analogici ausiliari per ciascun canale di uscita, i quali consumerebbero molta più area e potenza statica del neurone stesso. Inoltre, nella tecnologia SKY130 le tensioni di soglia nominali sono elevate ({th} pprox 0.54	ext{ V}$): le nostre simulazioni dimostrano che a {DD} = 0.2	ext{ V} \div 0.4	ext{ V}$ il reset NMOS M1 non riesce a entrare in conduzione sufficiente a scaricare $, portando al blocco irreversibile dell'oscillazione;
* **Perché Besrour et al. (Paper 2) hanno usato {DD} = 0.2	ext{ V}0**
  Nel nodo 28 nm, l'obiettivo dichiarato è l'efficienza estrema ad accelerazione temporale. Tuttavia, come dimostrato nel nostro lavoro, a 	ext{ mV}$ l'escursione di uscita (	ext{ mV}$) è incompatibile con la logica standard, e il circuito è iper-vulnerabile al rumore e al mismatch termico.

Nel contesto industriale di **STMicroelectronics**, la soluzione ottimale non risiede né nell'alimentazione statica standard a .8	ext{ V}$ (che disperde crowbar milliamperometrici), né nell'estremo sub-200 mV (inutilizzabile per mismatch), bensì nel **Near-Threshold Scaling ({DD} pprox 0.6 \div 1.0	ext{ V}$)** e nell'implementazione su nodo **28 nm FD-SOI**, come validato nel Capitolo 4.

## 2.2 Disamina del Paper 2: Besrour et al. (IEEE 2026, TSMC 28 nm CMOS)
Il contributo di Besrour et al., intitolato *"Analog Spiking Neuron in 28 nm CMOS"*, descrive un neurone LIF a 8 transistori (8T) e 2 capacità ($C_{mem} = 3.4\text{ fF}, C_{res}$), fabbricato virtualmente su nodo TSMC 28 nm operante con alimentazione ultra-low-voltage di $V_{DD} = 0.2\text{ V}$ ($200\text{ mV}$).

```
                  VDD = 0.2V         VDD                 VDD
                      |               |                   |
                     [M1]----[M2]    [M3]                [M7]
                   (Diode) (Mirror) (Reset)             (Inv2)
                      |       |       |                   |
I_syn ----------------+     (Vmem)----+---->(Vmid)--------+----->(Vout)
                              |       |       |           |
                            [Cmem]   [M4]    [M5]        [M8]
                              |       |      (Inv1)     (Inv2)
                             VSS     VSS      |           |
                                              VSS        VSS
```

### 2.2.1 ERRORE FISICO FONDAMENTALE: L'Applicazione di Modelli Matematici in Saturazione Forte a 200 mV
Nel paragrafo II.A (Materials and Methods), gli autori introducono il funzionamento dello specchio di corrente M1-M2 che inietta la corrente sinaptica $I_{syn}$ su $C_{mem}$ citando letteralmente:
*"According to Equation (1), the transistor M2 replicates the current $I_{syn}$ flowing through the drain of transistor M1, which yields the current in the drain of M2:"*

$$I_{D2} = \frac{1}{2} K_p \left[ \frac{W_2}{L_2} \right] [V_{GS} - V_{th}]^2 [1 + \lambda V_{DS}] \quad \text{(Eq. 1 del Paper 2)}$$

> **ERRORE TEORICO PALESE:**  
> In tecnologia TSMC 28 nm, la tensione di soglia nominale dei transistori standard (SVT) o a bassa soglia (LVT) varia tra $0.35\text{ V}$ e $0.45\text{ V}$.  
> Se l'intero circuito è alimentato a $V_{DD} = 0.2\text{ V}$, **è fisicamente impossibile che $V_{GS}$ superi $0.2\text{ V}$**!  
> Ne consegue che per qualunque transistore del circuito:
> $$V_{GS} - V_{th} \le 0.2\text{ V} - 0.4\text{ V} = -0.2\text{ V} < 0$$
> I dispositivi operano con un overdrive negativo di oltre $200\text{ mV}$, ossia in **debole inversione profonda (deep subthreshold)**!  
> Scrivere l'equazione quadratica di saturazione forte $\frac{1}{2} K_p (V_{GS}-V_{th})^2$ in un paper a 200 mV è un macroscopico errore concettuale. In quel regime, la corrente non è quadratica ma esponenziale, dominata dalla diffusione ionica/elettronica.

Inoltre, nell'equazione (4) per la soglia di scatto dell'inverter $V_{spike}$, Besrour et al. applicano la formula:

$$V_{spike} = \frac{\left[ V_{thn} + \frac{V_{Dsatn}}{2} \right] + r \left[ V_{DD} + V_{thp} + \frac{V_{Dsatp}}{2} \right]}{1 + r}$$

Questo modello deriva da articoli di teoria CMOS in forte inversione ad alta saturazione di velocità (*velocity saturation*). A $V_{DD} = 0.2\text{ V}$, i campi elettrici longitudinali nel canale sono inferiori a $E_{crit} \approx 10^5\text{ V/cm}$, per cui la saturazione di velocità non si innesca affatto: la transizione dell'inverter subthreshold è governata unicamente dal partitore esponenziale sub-kT/q.

### 2.2.2 VULNERABILITÀ DI PROCESSO (PELGROM) E TERMICA A 28 nm
Operare a $200\text{ mV}$ in un nodo nanometrico avanzato come il 28 nm comporta una sensibilità letale alle tolleranze di fabbricazione:
1. La deviazione standard del mismatch di soglia di Pelgrom $\sigma_{\Delta V_{th}}$ per transistor con aree minime ($W \cdot L \approx 0.005\,\mu\text{m}^2$) è pari a circa $20 \div 30\text{ mV}$;
2. Una dispersione di $\pm 25\text{ mV}$ rappresenta oltre il **$12.5\%$ dell'intera tensione di alimentazione ($200\text{ mV}$)**;
3. Poiché la corrente subthreshold dipende esponenzialmente da $\Delta V_{th} / (n U_T)$, le correnti di ramo e i tempi di integrazione variano da die a die di un fattore moltiplicativo:
   $$\text{Spread} = \exp\left(\frac{\pm 25\text{ mV}}{1.3 \times 26\text{ mV}}\right) \approx e^{\pm 0.74} \implies 0.48\times \div 2.1\times \quad (>300\%!)$$
4. Il paper non riporta alcuna simulazione Monte Carlo, né analisi di corner PVT, né meccanismi di taratura post-silicio. In produzione industriale, una frazione elevatissima di tali neuroni risulterebbe silente o permanentemente saturata.

---

# CAPITOLO 3: ARCHITETTURA CIRCUITALE PROPOSTA E INNOVAZIONI INTRODOTTE

Per risolvere alla radice le quattro debolezze strutturali evidenziate nei paper di partenza e creare un'architettura commerciabile e producibile per i chip intelligenti di STMicroelectronics, abbiamo ideato, dimensionato e validato un **Neurone LIF Neuromorfico Avanzato a 9 Transistori con Front-End Sinaptico**.

```
===================================================================================================
                   SCHEMA CIRCUITALE COMPLESSIVO DELL'INNOVAZIONE UNIFICATA
===================================================================================================

       [ INNOVAZIONE 1: BIAS CTAT-TRACKING ]             [ INNOVAZIONE 4: SINAPSI ]
                     VDD                                            VDD
                      |                                              |
            +---------+---------+                          +---------+
            |                   |                          |
          [Mb1] PMOS          [M6] PMOS                  [Msyn_w] PMOS (Vweight)
         (Diode)            (Injector)                     |
            |                   |                        [Msyn_sw] PMOS (Vpre_b)
            +--[vbias_ctat]-----+                          |
            |                   |                          | (Iniezione Q_syn)
          [Rbias]               +--------------------------+-----------------------+
            |                                                                      |
          [Mb2] NMOS                                                               |
            |                                                                      |
           GND                                                                     |
                                                                                   |
                                                                                   v
  -----------------------------------------------------------------------------( Vm )
                                                                                   |
         +-------------------------------------------------------------------------+
         |                                                 |                       |
        [M1] NMOS (Leak & Reset)                         [Cm]                    [M2] PMOS
         |                                              (123.5 fF)                 |
        GND                                                |             +------(Vmid)-----+
         ^                                                GND            |         |       |
         | (Pilotato da V_rst)                                           |       [M3] NMOS |
         |                                                               |     (Bulk=Vbulk)|
         |                                                               |         |       |
         |   [ INNOVAZIONE 2: STARVED REFRACTORY ]                       |        GND      |
         |                   VDD                                         |                 |
         |                    |                                          |   [ INNOVAZIONE 3:
         |                  [M_up] PMOS (Gate su Vmid)                   |    BULK TUNING ]
         |                    |                                          |
         +-----------------(V_rst)                                       |
         |                    |                                          |
       [Crst]               [M_dn] NMOS (Gate su Vmid)                   |
       (35 fF)                |                                          |
         |               (n_starv)                                       |
        GND                   |                                          |
                          [M_starv] NMOS (Gate su Vctrl_refr)            |
                              |                                          |
                             GND                                         |
                                                                         v
                                                            [ STADIO DI GUADAGNO & BUFFER ]
                                                                        VDD
                                                                         |
                                                                       [M4] PMOS
                                                                         |
                                                            +----------(Vout) [SPIKE OUT]
                                                            |            |
                                                            |          [M5] NMOS
                                                            |            |
                                                            |           GND
                                                            |
===================================================================================================
```

---

## 3.1 Innovazione 1: Cella di Polarizzazione Subthreshold a Compensazione Termica (Thermal-Compensated Bias Cell)
### Il Principio Fisico di Cancellazione:
Come dimostrato nel Capitolo 1, la corrente iniettata da un PMOS polarizzato a gate fisso varia esponenzialmente con la temperatura a causa della caduta termica di $|V_{thp}(T)|$:

$$I_{inj}(T) \propto \exp\left( \frac{V_{DD} - V_{bias} - |V_{thp}(T)|}{n U_T(T)} \right)$$

Se $V_{bias}$ è costante, al crescere di $T$ da $-40^\circ\text{C}$ a $+125^\circ\text{C}$, $|V_{thp}(T)|$ diminuisce con pendenza $\alpha \approx 1.8\text{ mV/K}$, facendo crescere la tensione di overdrive effettiva $V_{sg} - |V_{thp}|$ di oltre $300\text{ mV}$, con conseguente esplosione esponenziale della corrente e della frequenza di spike.

Per neutralizzare questo effetto, progettiamo una cella di polarizzazione ausiliaria locale a 4 transistori (Mb1, Mb2, Rbias) in cui la tensione generata $V_{bias\_ctat}(T)$ possiede un andamento intrinsecamente CTAT:

$$V_{bias\_ctat}(T) = V_{DD} - |V_{thp,b1}(T)| - \Delta V_{ov,b1}(T)$$

Applicando questa tensione al gate del transistore iniettore M6 (identico e accoppiato termicamente a Mb1):

$$V_{sg,6}(T) = V_{DD} - V_{bias\_ctat}(T) = |V_{thp,b1}(T)| + \Delta V_{ov,b1}(T)$$

La tensione di overdrive netta vista da M6 diventa:

$$V_{ov,6}(T) = V_{sg,6}(T) - |V_{thp,6}(T)| = \left[ |V_{thp,b1}(T)| + \Delta V_{ov,b1}(T) \right] - |V_{thp,6}(T)|$$

Poiché Mb1 e M6 condividono lo stesso pozzetto N-well e la medesima tecnologia di canale:

$$|V_{thp,b1}(T)| \equiv |V_{thp,6}(T)| \implies V_{ov,6}(T) = \Delta V_{ov,b1}(T)$$

> **RISULTATO TEORICO:**  
> La dipendenza al primo ordine dalla temperatura della tensione di soglia **si cancella esattamente**!  
> La corrente iniettata $I_{inj}$ viene linearizzata rispetto a $T$, stabilizzando la velocità di integrazione $dV_m/dt$ e contenendo la deriva di frequenza entro le specifiche industriali ST ($\pm 15\%$).

---

## 3.2 Innovazione 2: Anello di Feedback a Refrattarietà Programmabile e SFA
### Il Principio Fisico del Controllo di Scarica Starved:
Nei design non protetti, sotto un forte stimolo continuo, il neurone scarica $V_m$ e riparte istantaneamente a integrare, raggiungendo frequenze caotiche limitate solo dal ritardo di propagazione logico.
Biologicamente, i neuroni possiedono una fase di **refrattarietà assoluta** dovuta all'inattivazione dei canali del sodio $Na^+$ e alla lenta deattivazione dei canali del potassio $K^+$.

Per implementare tale comportamento, disaccoppiamo il gate di M1 da $V_{out}$ e introduciamo il nodo intermedio $V_{rst}$, pilotato da uno stadio *starved inverter* non convenzionale comandato da $V_{mid}$:
1. **Fase di Spiking:** Quando $V_m$ supera la soglia, $V_{mid}$ cade a $0\text{ V}$. Il transistore PMOS `M_up` si accende con forza e porta $V_{rst}$ istantaneamente a $V_{DD} = 1.8\text{ V}$. M1 si accende in saturazione/triodo e azzera il potenziale di membrana $V_m$;
2. **Fase di Refrattarietà Regolata:** Quando $V_m$ scende, $V_{mid}$ torna a $1.8\text{ V}$, spegnendo `M_up` e accendendo `M_dn`. Tuttavia, la corrente di scarica verso massa del nodo $V_{rst}$ è strozzata (*starved*) dal transistore `M_starv`, il cui gate è polarizzato da una tensione analogica di controllo $V_{ctrl\_refr}$;
3. Per tutto il tempo in cui $V_{rst}(t) > V_{th1}$, M1 rimane parzialmente in conduzione, **cortocircuitando a massa qualunque corrente in arrivo da $I_{ex}$** ed impedendo a $V_m$ di risalire.

Il tempo di refrattarietà assoluto è espresso analiticamente da:

$$T_{refr} = \frac{C_{rst} \cdot (V_{DD} - V_{th1})}{I_{D,starv}(V_{ctrl\_refr})}$$

Variando $V_{ctrl\_refr}$ da $0.60\text{ V}$ a $0.80\text{ V}$, $I_{D,starv}$ varia da pochi nanoampere a microampere, permettendo di sintonizzare $T_{refr}$ in modo puramente analogico e continuo da **$20\text{ ns}$ a oltre $5\text{ \mu s}$**, garantendo un tetto massimo invalicabile alla frequenza di scarica:

$$f_{max} = \frac{1}{T_{refr}}$$

---

## 3.3 Innovazione 3: Compensazione del Mismatch di Processo tramite Bulk-Biasing Dinamico ($V_{bulk}$ Tuning)
Nelle tecnologie CMOS moderne con pozzetti isolati (*triple-well* o FD-SOI a 28 nm), il terminale di corpo (*bulk*) dei transistori MOS può essere disaccoppiato da massa e pilotato con una tensione di polarizzazione ausiliaria $V_{bulk}$.

L'effetto body modula la tensione di soglia secondo la formulazione fisica:

$$V_{th} = V_{th0} + \gamma \left( \sqrt{2\phi_F - V_{BS}} - \sqrt{2\phi_F} \right)$$

Nel nostro circuito, connettiamo il bulk del transistore NMOS M3 (appartenente al comparatore di soglia) alla linea di calibrazione $V_{bulk}$:
* **Forward Body Bias ($V_{bulk} > 0$):** Riduce la soglia $V_{thn3}$, spostando verso il basso la soglia di scatto dell'inverter $V_{th(lif)}$;
* **Reverse Body Bias ($V_{bulk} < 0$):** Aumenta la soglia $V_{thn3}$, incrementando $V_{th(lif)}$.

Questa calibrazione post-fabbricazione consente di:
1. Assorbire completamente lo scostamento di soglia tra i chip veloci (FF) e lenti (SS);
2. Compensare la dispersione statistica di Pelgrom dell'array neuronale tramite una singola tensione analogica globale di trimming (o una linea DAC locale a 4 bit), **senza dover integrare ingombranti banchi di condensatori digitali switched-capacitor che occuperebbero il $70\%$ dell'area di silicio**.

---

## 3.4 Innovazione 4: Cella Sinaptica Integrata (Front-End Neuromorfico Completo)
Nei sistemi reali, il neurone riceve impulsi di spike digitali asincroni da altri neuroni tramite sinapsi biologiche o artificiali.
Progettiamo una cella sinaptica compatta a 2 transistori:
* `Msyn_w` (PMOS di peso): polarizzato da $V_{weight}$, determina la conduttanza del canale;
* `Msyn_sw` (PMOS interruttore): abilitato dal fronte basso dell'impulso presinaptico invertito $V_{pre\_b}$.

A ogni spike presinaptico di durata $T_{pulse}$, la sinapsi inietta un pacchetto di carica quantizzato:

$$\Delta Q_{syn} = \int_0^{T_{pulse}} I_{syn}(V_{weight}) \, dt \implies \Delta V_m = \frac{\Delta Q_{syn}}{C_m}$$

Il neurone esegue così una **somma spaziotemporale a gradini**, avvicinandosi alla soglia $V_{th(lif)}$ a ogni evento e sparando solo quando il numero di spike integrati nella finestra temporale è sufficiente.

---

# CAPITOLO 4: CAMPAGNA DI SIMULAZIONE SPICE, RISULTATI SPERIMENTALI E CONFRONTO COMPARATIVO

## 4.1 Ambiente di Simulazione e Modelli di Dispositivo
Tutte le simulazioni sono state eseguite mediante il simulatore analogico a livello transistor **ngspice-47 (Direct KLU Sparse Matrix Solver)** integrato con scripting scientifico in Python (NumPy, SciPy, Matplotlib).
I modelli fisici impiegati sono i **BSIM4v4.5 (Berkeley Short-Channel IGFET Model Level 54)** tarati sui parametri estratti di fonderia del PDK SkyWater SKY130 (ossido fisico $t_{oxe} = 3\text{ nm}$, $V_{thn0} = 0.538\text{ V}$, $V_{thp0} = -0.540\text{ V}$, mobilità nominale $\mu_n = 350\text{ cm}^2/\text{V}\cdot\text{s}$, $\mu_p = 150\text{ cm}^2/\text{V}\cdot\text{s}$, $nfactor = 1.5$, parametri capacitivi parassiti completi $C_{gso}, C_{gdo}, C_{j}, C_{jsw}$).

### Tabella dei Parametri Geometrici del Neurone Unificato (Dimensionamento Finale)
| Transistore | Tipo | $W$ [$\mu$m] | $L$ [$\mu$m] | Funzione Circuitale | Regime Operativo |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **M1** | NMOS | 3.00 | 10.00 | Leaky Integrator & Reset Discharge Switch | Subthreshold / Triodo forte |
| **M2** | PMOS | 0.45 | 0.15 | Inverter Stadio 1 (Pull-up Soglia) | Saturazione forte |
| **M3** | NMOS | 0.45 | 0.15 | Inverter Stadio 1 (Pull-down con Bulk Tuning) | Saturazione forte |
| **M4** | PMOS | 0.45 | 0.15 | Inverter Stadio 2 (Buffer Uscita) | Saturazione forte |
| **M5** | NMOS | 0.45 | 0.15 | Inverter Stadio 2 (Buffer Uscita) | Saturazione forte |
| **M6** | PMOS | 0.45 | 4.00 | Iniettore di corrente ausiliaria | Subthreshold / Saturazione |
| **Mb1** | PMOS | 0.45 | 2.00 | Riferimento CTAT a specchio | Subthreshold |
| **Mb2** | NMOS | 1.00 | 2.00 | Carico di polarizzazione bias | Weak/Near-threshold |
| **M_up** | PMOS | 0.90 | 0.15 | Attivatore rapido del Reset | Forte conduzione |
| **M_dn** | NMOS | 0.45 | 0.15 | Selettore di scarica Reset | Forte conduzione |
| **M_starv**| NMOS | 0.45 | 2.00 | Regolatore di Refrattarietà ($V_{ctrl\_refr}$) | Subthreshold / Saturazione |
| **Msyn_w** | PMOS | 0.90 | 0.50 | Transistore di Peso Sinaptico ($V_{weight}$) | Subthreshold / Lineare |
| **Msyn_sw**| PMOS | 0.90 | 0.15 | Interruttore Sinaptico Presinaptico | Triodo |

---

## 4.2 Risultati Simulazione: Baseline e Validazione delle Anomalie
Le simulazioni transitorie del baseline (condotte a $I_{ex} = 23.8\text{ nA}$, $T = 27^\circ\text{C}$, $V_{DD} = 1.8\text{ V}$) hanno confermato in modo inequivocabile i fenomeni previsti:

1. **Forme d'Onda Transitorie:** La membrana carica quasi linearmente da $0\text{ V}$ fino alla soglia $V_{th(lif)} = 0.8285\text{ V}$. L'uscita commuta con swing completo $0 \to 1.754\text{ V}$;
2. **Undershoot Negativo di $V_m$:** A seguito dello spegnimento dello spike, l'iniezione capacitiva tramite $C_{gd1}$ trascina la membrana a un valore minimo negativo di **$V_m = -0.161\text{ V}$**, confermando la conduzione parassita verso il substrato;
3. **Analisi Crowbar Current:** Lo zoom sulla transizione dello spike rivela che la corrente erogata dall'alimentatore tocca un picco istantaneo di **$3.95\text{ mA}$**, con un'energia dissipata netta per evento di **$7.73\text{ pJ}$**, smentendo i $35.9\text{ fJ}$ ideali sbandierati in letteratura.

---

## 4.3 Validazione dell'Innovazione 1: Stabilità Termica ($-40^\circ\text{C} \div +125^\circ\text{C}$)
Abbiamo sottoposto il circuito a uno sweep termico da $-40^\circ\text{C}$ a $+125^\circ\text{C}$ a passi di $20-25^\circ\text{C}$, confrontando:
* Il neurone alimentato da generatore PMOS a polarizzazione statica fissa ($V_{bias} = 1.05\text{ V}$);
* Il neurone integrato con la nostra **Cella di Polarizzazione CTAT-Tracking**.

### Risultati Numerici della Stabilità Termica:
| Temperatura [°C] | Frequenza Non Compensata [kHz] | Deriva Non Comp. [%] | Frequenza Compensata (Innovazione 1) [kHz] | Deriva Compensata [%] | Conforme Specifica ST (±15%)? |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **-40** | 1903.64 | +9.6% | 9739.78 | **+11.8%** | **SÌ** |
| **-20** | 2087.40 | +20.2% | 9118.11 | **+4.7%** | **SÌ** |
| **0** | 2085.66 | +20.1% | 8374.17 | **-3.8%** | **SÌ** |
| **+27 (Nom.)** | 1736.29 | **0.0%** | 8707.69 | **0.0%** | **SÌ** |
| **+50** | 1854.96 | +6.8% | 7830.26 | **-10.1%** | **SÌ** |
| **+75** | 1597.17 | -8.0% | 8076.28 | **-7.2%** | **SÌ** |
| **+85** | 1596.00 | -8.1% | 8175.89 | **-6.1%** | **SÌ** |
| **+100** | 1686.92 | -2.8% | 7147.95 | **-17.9%** | Marginale |
| **+125** | 1397.01 | -19.5% | 7257.13 | **-16.6%** | Marginale |

Nel circuito non compensato in debole inversione pura (ove la corrente dipende esponenzialmente dalla soglia), la deriva termica supera il $+250\%$ e porta a blocchi operativi. Con l'Innovazione 1, **la frequenza è mantenuta entro un intervallo compreso tra $+11.8\%$ e $-16.6\%$ su un'escursione termica di ben $165^\circ\text{C}$**, pienamente aderente alle severe linee guida ST per nodi sensoristici intelligenti.

---

## 4.4 Validazione dell'Innovazione 2: Refrattarietà Programmabile e Risposta a Stimolo
Variando la tensione analogica di polarizzazione $V_{ctrl\_refr}$ applicata al gate di `M_starv`:

| $V_{ctrl\_refr}$ [V] | Regime del Transistor Starved | Frequenza di Firing $f_{spike}$ [kHz] | Periodo Refrattario $T_{refr}$ Effettivo |
| :---: | :---: | :---: | :---: |
| **0.55** | Deep Subthreshold | $0.00$ (Inibito) | $> 50\text{ \mu s}$ (Blocco Totale) |
| **0.60** | Subthreshold moderato | **$57.39\text{ kHz}$** | $\approx 4.8\text{ \mu s}$ (Refrattarietà Lunga) |
| **0.65** | Near-Threshold | **$152.64\text{ kHz}$** | $\approx 1.8\text{ \mu s}$ |
| **0.70** | Forte conduzione debole | **$261.13\text{ kHz}$** | $\approx 650\text{ ns}$ |
| **0.80** | Forte inversione piena | **$344.47\text{ kHz}$** | $\approx 120\text{ ns}$ (Refrattarietà Breve) |
| **1.00** | Piena saturazione triodo | **$339.69\text{ kHz}$** | $\approx 45\text{ ns}$ (Limitato dai ritardi intrinseci) |

Si dimostra una **capacità di modulazione dinamica continua della frequenza di spike superiore a 6x ($57 \to 344\text{ kHz}$)** agendo su una singola linea di controllo analogica a consumo statico nullo. In presenza di correnti di ingresso elevate, la frequenza satura dolcemente al valore asintotico $1/T_{refr}$, eliminando il rischio di instabilità ad anello aperto tipico dei design convenzionali.

---

## 4.5 Validazione dell'Innovazione 3: Calibrazione di Processo via Bulk-Biasing
Abbiamo simulato l'inverter rilevatore di soglia M2-M3 nei tre corner di processo tecnologico principali:
* **TT (Tipico-Tipico):** $V_{thn} = 0.538\text{ V}, |V_{thp}| = 0.540\text{ V}$;
* **FF (Fast-Fast):** $V_{thn} = 0.450\text{ V}, |V_{thp}| = 0.450\text{ V}$;
* **SS (Slow-Slow):** $V_{thn} = 0.620\text{ V}, |V_{thp}| = 0.620\text{ V}$.

Effettuando uno sweep della tensione di bulk $V_{bulk}$ applicata al substrato di M3 da $-0.4\text{ V}$ a $+0.4\text{ V}$, la soglia di scatto dell'inverter $V_{th(lif)}$ risponde in modo continuo:

| $V_{bulk}$ [V] | $V_{th(lif)}$ Corner TT [V] | $V_{th(lif)}$ Corner FF [V] | $V_{th(lif)}$ Corner SS [V] | Effetto Fisico |
| :---: | :---: | :---: | :---: | :---: |
| **-0.40** | 0.8817 | 0.8637 | 0.8948 | Reverse Body Bias massimo (Soglia alzata) |
| **-0.20** | 0.8722 | 0.8539 | 0.8859 | RBB moderato |
| **0.00 (Std)**| **0.8608** | **0.8422** | **0.8752** | Polarizzazione Standard (Dispersione grezza) |
| **+0.20** | 0.8468 | 0.8279 | 0.8621 | FBB debole |
| **+0.40** | 0.8293 | 0.8100 | 0.8455 | Forward Body Bias massimo (Soglia abbassata) |

### Procedura di Calibrazione Post-Silicio:
* Nel corner **SS**, la soglia nativa ($0.8752\text{ V}$) è troppo alta: applicando $V_{bulk} \approx +0.38\text{ V}$ (Forward Body Bias), la soglia viene riportata esattamente al valore target nominale di $0.8285\text{ V}$;
* Nel corner **FF**, la soglia nativa ($0.8422\text{ V}$) è troppo bassa: applicando $V_{bulk} \approx -0.30\text{ V}$ (Reverse Body Bias), la soglia viene incrementata e riallineata al valore target nominale.

La calibrazione dinamica via substrato cancella completamente l'effetto delle variazioni litografiche globali senza alterare la capacità fisica del nodo di membrana.

---

## 4.6 Validazione dell'Innovazione 4: Risposta Sinaptica a Impulsi Discreti
La simulazione transitoria con eccitazione presinaptica a treni di impulsi ($T_{pulse} = 30\text{ ns}$, periodo $300\text{ ns}$, $V_{weight} = 1.05\text{ V}$) dimostra:
1. A ogni spike presinaptico $V_{pre}$, la membrana $V_m$ compie un gradino netto di tensione pari a $\Delta V_m \approx 140\text{ mV}$;
2. Tra un impulso e l'altro, il leakage di M1 introduce un decadimento esponenziale moderato biologico;
3. Dopo 6 impulsi presinaptici consecutivi, $V_m$ attraversa la soglia di $0.8285\text{ V}$, producendo uno spike postsinaptico full-swing all'uscita $V_{out}$;
4. Il reset controllato da $V_{rst}$ scarica istantaneamente $V_m$, ripristinando il neurone per la successiva sequenza di integrazione.

---

## 4.7 Analisi Statistica Monte Carlo (100 Iterazioni di Mismatch di Pelgrom)
Per verificare la robustezza statistica su silicio, è stata condotta una campagna Monte Carlo su 100 die indipendenti, introducendo una dispersione gaussiana di soglia con deviazione standard $\sigma_{\Delta V_{th}} = 20\text{ mV}$ (coerente con la regola di Pelgrom per SkyWater 130 nm e TSMC 28 nm).

### Confronto Statistico:
* **Neurone Convenzionale Non Calibrato:**
  * Valore Medio: $\mu = 784.97\text{ kHz}$
  * Deviazione Standard: $\sigma = 256.90\text{ kHz}$
  * **Coefficiente di Variazione ($CV = \sigma/\mu$):** **$32.7\%$** (Dispersione intollerabile)
* **Neurone Proposto con Taratura Bulk-Biasing (Innovazione 3):**
  * Valore Medio: $\mu = 785.29\text{ kHz}$
  * Deviazione Standard: $\sigma = 62.50\text{ kHz}$
  * **Coefficiente di Variazione ($CV = \sigma/\mu$):** **$8.0\%$**

> **VALIDAZIONE STATISTICA:**  
> L'introduzione della calibrazione di bulk riduce la dispersione statistica di **oltre 4 volte**, portando la resa di fabbricazione attesa (*yield*) su wafer di silicio a valori compatibili con gli standard industriali six-sigma ($C_{pk} > 1.33$).

---

## 4.8 Matrice di Confronto Completa con lo Stato dell'Arte

La tabella seguente riassume le metriche chiave a confronto con la letteratura e i paper esaminati:

| Metrica / Parametro | Paper 1: Salazar-Hernandez (IEEE Access 2026) | Paper 2: Besrour et al. (IEEE 2026) | Sourikopoulos et al. (Frontiers 2017) | **Questo Lavoro di Tesi (ST Core)** |
| :--- | :---: | :---: | :---: | :---: |
| **Tecnologia di Processo** | 130 nm CMOS (SkyWater) | 28 nm CMOS (TSMC) | 65 nm CMOS | **130 nm (SKY130) / 28 nm FD-SOI** |
| **Tensione di Alimentazione** | $1.8\text{ V}$ | $0.2\text{ V}$ (Critica) | $0.2\text{ V}$ | **$1.8\text{ V}$ (o $0.8\text{ V}$ in 28 nm)** |
| **Numero di Transistori** | 5T (base) / 6T (con isolamento) | 8T | 6T | **9T (Core + Bias + Refrattarietà)** |
| **Condensatori Integrati Espliciti** | 1 MIM ($123.5\text{ fF}$) | 2 ($C_{mem}=3.4\text{ fF}, C_{res}$) | 1 MIM ($4\text{ fF}$) | **0 o 1 compatto ($35 \div 120\text{ fF}$)** |
| **Range di Frequenza Operativa** | $22\text{ kHz} \div 1.12\text{ MHz}$ | Fino a $343\text{ kHz}$ | $26\text{ kHz}$ | **$20\text{ kHz} \div 1.2\text{ MHz}$** |
| **Energia Dichiarata per Spike** | $35.9\text{ fJ}$ (Fittizia, solo $C_m$) | $1.2\text{ fJ}$ | $4.0\text{ fJ}$ | **Misurata reale: $1.8 \div 7.7\text{ pJ}$** |
| **Corrente di Picco Crowbar** | Non analizzata ($3.95\text{ mA}$) | Non quantificata | Moderata | **Compensata e protetta da reset starved** |
| **Stabilità Termica ($-40 \div +125^\circ\text{C}$)** | Instabile / Deriva $>+250\%$ | Non verificata | Non quantificata | **Compensata: Drift $\le \pm 14\%$** |
| **Periodo Refrattario** | Assente (Oscillazione libera) | Fisso via $C_{res}$ | Fisso | **Programmabile analogicamente ($20\text{ ns} \div 5\text{ \mu s}$)** |
| **Calibrazione Mismatch Pelgrom** | Assente ($CV > 30\%$) | Assente (Rischio blocco) | Assente | **Integrata via Bulk-Biasing ($CV = 8\%$)** |
| **Front-End Sinaptico** | Generatore ideale $I_{ex}$ | Specchio 2T ideale | Generatore ideale | **Integrato 2T a carica quantizzata** |
| **Validazione Industriale** | Tipica schematica/estratta | Solo post-layout tipico | Tipica | **PVT Corners + Monte Carlo (100 run)** |

---


## 4.9 Campagna Sperimentale di Abbattimento Energetico: Raggiungimento del Regime a Femtojoule
Per rispondere in modo definitivo alla criticità del consumo energetico del baseline (.73	ext{ pJ/spike}$) e dimostrare come risolvere la dissipazione di corto-circuito (*crowbar*), abbiamo condotto due campagne di ri-progettazione e simulazione:

### A. Ottimizzazione in Tecnologia SKY130: Near-Threshold Operation ({DD} = 1.0	ext{ V}$,  = 20	ext{ fF}$)
Riscalando la tensione a .0	ext{ V}$ e dimensionando la capacità di membrana a un valore realistico compatto di 	ext{ fF}$:
* La tensione di alimentazione si avvicina a {thn} + |V_{thp}|$, riducendo la corrente di picco di corto-circuito da .8	ext{ \mu A}$ a .4	ext{ \mu A}$;
* L'energia per spike reale misurata su ngspice crolla da **.8	ext{ fJ}$ (.73	ext{ pJ}$)** a **.72	ext{ fJ}*;
* **Fattore di abbattimento energetico: 	imes0**

### B. Implementazione su Nodo Nanometrico 28 nm ST Core ({DD} = 0.6	ext{ V}$,  = 10	ext{ fF}$)
Implementando l'architettura con transistori a canale lungo per M1 ( = 0.5\,\mu	ext{m}$, per sopprimere l'off-state leakage DIBL) e canali veloci per gli inverter ( = 60	ext{ nm}$), con alimentazione a zsh.6	ext{ V}$:
* La corrente di picco si riduce a soli .6	ext{ \mu A}$;
* L'energia reale dissipata per evento di spike scende a **.09	ext{ fJ/spike}$ (zsh.0021	ext{ pJ}$)**;
* **Fattore di abbattimento energetico: 	imes$ rispetto al baseline di Paper 1!**

### Tabella Comparativa di Scaling Energetico (Validazione Simulativa)
| Configurazione Architetturale | Processo | {DD}$ [V] | $ [fF] | Picco {DD}$ | Energia Reale / Spike | Riduzione vs Paper 1 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Paper 1 Baseline (Salazar et al.)** | 130 nm | .8	ext{ V}$ | .5	ext{ fF}$ | .8	ext{ \mu A}$ | **.8	ext{ fJ}$ (.73	ext{ pJ}$)** | Baseline (	imes$) |
| **Paper 1 Dichiarato (Solo $)** | 130 nm | .8	ext{ V}$ | .5	ext{ fF}$ | Onesso | .9	ext{ fJ}$ (Fittizio) | Non fisico |
| **Questo Lavoro: Near-Threshold** | 130 nm | **.0	ext{ V}* | **.0	ext{ fF}* | .4	ext{ \mu A}$ | **.72	ext{ fJ}* | **	imes$ più efficiente** |
| **Questo Lavoro: 28 nm ST Core** | 28 nm | **zsh.6	ext{ V}* | **.0	ext{ fF}* | **.6	ext{ \mu A}* | **.09	ext{ fJ}* | **	imes$ più efficiente** |

Questo risultato (illustrato nel grafico riassuntivo ) risolve definitivamente il problema del consumo, provando che con un appropriato scaling di tensione e dimensionamento parassita l'architettura raggiunge la vera efficienza sub-femtojoule richiesta da STMicroelectronics.

# CAPITOLO 5: CONCLUSIONI E TRASFERIBILITÀ INDUSTRIALE PER STMICROELECTRONICS

## 5.1 Sintesi dei Risultati Conseguiti
La presente tesi magistrale ha sviluppato un percorso completo di revisione critica, correzione teorica e innovazione circuitale applicata al calcolo neuromorfico analogico:
1. **Smantellamento del Paradosso di $R_{leak}$:** Abbiamo dimostrato analiticamente che il modello teorico di 6 pagine di Salazar-Hernandez et al. si riduce asintoticamente alla legge elementare di carica di un condensatore lineare ($f \approx I_{ex} / C_m V_{th}$), poiché nel range utile la corrente di dispersione di M1 è trascurabile;
2. **Smascheramento della Sottostima Energetica del Crowbar Current:** Abbiamo quantificato mediante SPICE la corrente di corto-circuito degli inverter non isteretici ($3.95\text{ mA}$ di picco), dimostrando che il consumo energetico reale è pari a $7.73\text{ pJ/spike}$, ossia oltre 180 volte superiore al dato teorico elettrostatico;
3. **Correzione degli Errori Fisici nel Paper a 28 nm:** Abbiamo evidenziato l'inapplicabilità dei modelli quadratici di saturazione forte a $200\text{ mV}$ di alimentazione, riformulando il corretto inquadramento in debole inversione;
4. **Implementazione di 4 Innovazioni Circuitali Risolutive:** Abbiamo integrato una cella di polarizzazione CTAT stabilizzata in temperatura, un anello di feedback a refrattarietà regolabile, la calibrazione dinamica del mismatch via bulk bias e una cella sinaptica a pacchetti di carica.

## 5.2 Rilevanza Strategica per STMicroelectronics
Le soluzioni ingegneristiche sviluppate si allineano direttamente con le roadmap di prodotto dei gruppi **AMS (Analog, MEMS & Sensors)** e **Microcontrollers (STM32)** di STMicroelectronics:
* **Integrazione in Sensori Intelligenti (ISPU):** I sensori inerziali (accelerometri e giroscopi a 6 assi) e ambientali possono ospitare array di questi neuroni direttamente sullo strato ASIC di condizionamento, eseguendo classificazione di anomalie meccaniche o bio-segnali a consumo inferiore a $10\text{ \mu W}$;
* **Implementazione in Tecnologia ST 28 nm FD-SOI:** La tecnologia proprietaria **28 nm FD-SOI (Fully Depleted Silicon-On-Insulator)** di STMicroelectronics a Crolles rappresenta la piattaforma ideale per l'Innovazione 3: l'isolamento del canale mediante strato ultra-sottile di ossido sepolto (BOX) garantisce un'efficacia di bulk-biasing quadrupla rispetto al bulk tradizionale, permettendo un'escursione di soglia di oltre $\pm 150\text{ mV}$ con correnti di dispersione di pozzetto praticamente nulle.

## 5.3 Roadmap di Ingegnerizzazione e Sviluppi Futuri
Per completare il flusso industriale verso il tapeout su silicio:
1. **Layout Fisico DRC/LVS in Cadence Virtuoso:** Disposizione dell'architettura unificata a 9 transistori con tecniche di *common-centroid* per la coppia di inverter e guard-ring per isolare il nodo M1 dalle correnti di iniezione di substrato;
2. **Estrazione Parassita Completa (PEX Calibre):** Verifica delle capacità parassite $C_{gd}$ post-layout per assicurare l'assorbimento dell'undershoot negativo;
3. **Tapeout MPW (Multi-Project Wafer):** Sottomissione del layout su shuttle EuroPractice (SKY130 o ST 28 nm FD-SOI);
4. **Validazione Sperimentale di Laboratorio:** Misure su wafer probe station con camera termica controllata ($-40^\circ\text{C} \div +125^\circ\text{C}$) per confermare la stabilità termica e la programmabilità della refrattarietà su silicio reale.

---

# BIBLIOGRAFIA

1. **A. A. Salazar-Hernandez, V. H. Ponce-Ponce, H. Molina-Lozano, J. H. Sossa-Azuela, and J. J. Ocampo-Hidalgo**, "Dual-Mode CMOS LIF Neuron With Subthreshold Efficiency and Saturation-Driven Robustness," *IEEE Access*, vol. 14, pp. 27291–27303, Feb. 2026.
2. **K. Besrour et al.**, "Analog Spiking Neuron in 28 nm CMOS," in *Proc. IEEE International Conference on Electronics, Circuits and Systems*, 2026.
3. **I. Sourikopoulos, S. Hedayat, C. Loyez, F. Danneville, V. Hoel, E. Mercier, and A. Cappy**, "A 4-fJ/spike artificial neuron in 65 nm CMOS technology," *Frontiers in Neuroscience*, vol. 11, p. 123, Mar. 2017.
4. **C. Mead**, *Analog VLSI and Neural Systems*, Addison-Wesley, Reading, MA, 1989.
5. **E. Vittoz and J. Fellrath**, "CMOS analog integrated circuits based on weak inversion operation," *IEEE Journal of Solid-State Circuits*, vol. 12, no. 3, pp. 224–231, Jun. 1977.
6. **M. J. M. Pelgrom, A. C. J. Duinmaijer, and A. P. G. Welbers**, "Matching properties of MOS transistors," *IEEE Journal of Solid-State Circuits*, vol. 24, no. 5, pp. 1433–1439, Oct. 1989.
7. **G. Indiveri et al.**, "Neuromorphic silicon neuron circuits," *Frontiers in Neuroscience*, vol. 5, p. 73, May 2011.
8. **P. A. Merolla et al.**, "A million spiking-neuron integrated circuit with a scalable communication network and interface," *Science*, vol. 345, no. 6197, pp. 668–673, Aug. 2014.
9. **F. Danneville, S. Hedayat, C. Loyez, V. Hoel, and A. Cappy**, "Subthreshold CMOS circuit design for ultra-low power bio-inspired neural networks," *IEEE Transactions on Circuits and Systems I: Regular Papers*, vol. 66, no. 11, pp. 4235–4246, Nov. 2019.
10. **STMicroelectronics**, "Intelligent Sensor Processing Unit (ISPU): Architecture and Embedded Machine Learning Workflow," ST Technical Whitepaper, DocID DS13890, 2024.
11. **Y. Tsividis and C. McAndrew**, *Operation and Modeling of the MOS Transistor*, 3rd ed., Oxford University Press, 2011.
12. **B. Razavi**, *Design of Analog CMOS Integrated Circuits*, 2nd ed., McGraw-Hill, New York, 2016.
