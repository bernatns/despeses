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

## Pendents

- **Neteja final de dades privades a GitHub (opcional).** El 8/11/2026 es va reescriure l'historial
  de Git per treure'n nòmines i dades personals; les branques ja estan netes. GitHub, però,
  conserva còpies dels commits antics (vistes en memòria cau i la PR #1). Per eliminar-les:
  demanar-ho a GitHub Support (support.github.com/contact → "Remove sensitive data / cached views"),
  o bé esborrar i tornar a crear el repositori amb l'historial net (cal tornar a configurar GitHub Pages).
- Qualsevol còpia local del repo descarregada abans del 8/11/2026 s'ha d'esborrar i tornar a clonar
  (si no, un push en tornaria a pujar l'historial antic).
