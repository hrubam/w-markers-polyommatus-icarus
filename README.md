# Development of molecular markers for the W chromosome in the blue butterfly *Polyommatus icarus*

Sekvenací genomové DNA na platformě Oxford Nanopore byla získána data ve formátu FAST5. Ta byla zpracována pomocí skriptu „Basecalling.sh“ a získaný výstup byl použit jako vstup pro skript „NanoFilt_NanoPlot.sh“, který umožňuje filtraci dat na minimální délku sekvencí 5000 bp a 10000 bp a následně vyhodnocuje základní statistiky pomocí nástroje NanoPlot. Soubory s filtrovanými daty, vytvořené tímto skriptem, byly použity jako vstupy pro skript „Canu.sh“ pro opravu sekvencí sami sebou. Vytvořený výstup byl použit jako vstup pro skript „Flye.sh“ pro tvorbu genového assembly. Byla tak vytvořena dvě genomová assembly, která byla dále použita jako vstupní data pro skript „PurgeDups.sh“ pro odstranění duplikací. Tento skript tedy vytvoří další dvě genomová assembly. Všechna vytvořená assembly byla zkontrolována na kvalitu pomocí skriptů „BUSCO.sh“ a „Quast.sh“.

Data ve formátu FASTQ.GZ získaná sekvenací na platformě Illumina byla nejprve upravena pomocí skriptu „FASTQC_Trimmomatic_Trimgalore.sh“, který odstraňuje polyG kontaminace, ořízne posledních a prvních 5 bází a filtruje sekvence na minimální délku 50 bp. Výstupy z tohoto skriptu byly použity jako vstup pro skript „KmerGO.sh“. Ten vytvoří dva výstupy: sekvence rozdělené na 21-mery a sekvence rozdělené na 55-mery, s oběma výstupy bylo dále pracováno samostatně. Každý z výstupů sestává z několika tabulek, ze kterých byl proveden náhodný výběr 20000 řádků, které byly následně sloučeny do jednoho souboru, což bylo provedeno příkazem uvedeným v souboru „K-mers_sample.sh“. Výstupem byly dvě tabulky. Jedna s náhodným výběrem pro 21-mery a druhá s náhodným výběrem pro 55-mery. Pro každou z nich bylo vytvořeno k-merové spektrum a stanovena hranice pro odstranění chybových k-merů v prostředí RStudio pomocí skriptu „K-mer_spectrum.R“ Na základě takto stanovené hranice pro odstranění chybových k-merů byly ze všech k-merů vybrány pohlavně specifické 21-mery a 55-mery pomocí skriptu „Sex-specific_K-mers.sh“.

Pohlavně specifické k-mery byly mapovány na nejlepší genomové assembly pomocí skriptu „Bowtie2.sh“. Z výstupů ve formátu BED byly v příkazové řádce vytvořeny dvě tabulky, které obsahovaly specifické k-mery pro obě pohlaví, jedna pro 21-mery a druhá pro 55-mery (viz soubor „Specific_k-mers_both_sexes.sh“). Takto vytvořené tabulky byly dále zpracovány v prostředí RStudio a pomocí skriptu „Female-specific_contigs.R“ byly vybrány kontigy specifické pro samice. Byly použity dvě metody. Jedna založená na průměrném počtu k-merů specifických pro jednotlivá pohlaví a druhá založená na součtu k-merů. 
