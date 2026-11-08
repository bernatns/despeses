# despeses//

Aplicació web (PWA) per portar les despeses personals. Un sol `index.html` + Supabase.

## Posada en marxa després d'actualitzar a v5.0

1. **Migració de Supabase (un cop):** obre Supabase → SQL Editor, enganxa
   [`supabase/migracio.sql`](supabase/migracio.sql) i executa-ho.
   - Afegeix la columna `refund` (devolucions). Sense aquesta columna l'app funciona igual,
     però la casella "És una devolució" queda desactivada.
   - Deixa cada taula amb regles d'accés estrictes (cada usuari només veu les seves files).
   - No esborra ni modifica cap dada.
2. **Dades privades:** les nòmines antigues i els valors de la calculadora ja no són al codi
   (el repositori és públic). Restaura un cop el fitxer `despeses-dades-privades.json`
   amb ⚙ → Restaurar backup. No l'afegeixis mai al repositori.

## Funcionalitats

- Mes, anual, gràfics, anàlisi entre anys, historial de nòmines i calculadora de sou
- Importació d'extractes bancaris (cada moviment va al mes de la seva data; detecta duplicats
  i devolucions)
- Cercador de tots els apunts, exportació a CSV (Excel) i backups JSON
- Pressupost mensual per categoria amb avisos
- Mode fosc (automàtic / clar / fosc) i funcionament sense connexió (només lectura)

## Arxius

| Fitxer | Què és |
| --- | --- |
| `index.html` | Tota l'app |
| `sw.js` | Service worker (obrir l'app sense connexió) |
| `manifest.webmanifest`, `icon-*.png` | PWA |
| `supabase/migracio.sql` | Migració i regles d'accés |
| `test.html` | Pàgina de diagnòstic de connexió a Supabase |
