---
name: leitstelle-advisor
description: "Betreibt eine Fable-Session als Advisor neben Leitstelle und Bau-Sessions S1 bis Sx: Sessions fragen bei Entscheidungen zuerst den Advisor über die Leitstelle, die Kontext beilegt. Nutze, wenn ein Advisor oder Fable als Advisor gestartet werden soll, wenn eine Leitstelle oder ein Leitstand mit Advisor läuft, wenn eine Startzeile „Du bist der Advisor“ nennt oder wenn eine Nachricht mit ADVISOR- beginnt."
---

# Leitstelle mit Advisor

Neben der Leitstelle und den Bau-Sessions läuft eine eigene Session auf Claude Fable 5.1 als Advisor. Er berät nur und arbeitet lesend, die Sessions bauen. Leitstand ist dasselbe wie Leitstelle. Das Modell ist der Standard und lässt sich beim Start ändern: Im Startbefehl steht es hinter `--model`.

Eine Frage läuft so: Session an Leitstelle, Leitstelle legt die Kontextakte bei und leitet an den Advisor weiter, der Advisor antwortet direkt an die Session und schickt der Leitstelle eine Kopie.

## Rolle bestimmen

Die Tabelle gilt von oben nach unten, der erste Treffer zählt:

| Signal | Rolle |
|---|---|
| Startzeile nennt „Du bist der Advisor“ | Advisor |
| Die Session verteilt Aufträge an andere Sessions oder wurde als Leitstelle gestartet | Leitstelle |
| Startzeile nennt „Leitstelle ist“ und nicht „Du bist der Advisor“, oder Aufträge oder ein `ADVISOR-BEREIT` kamen per SendMessage von einer Leitstelle | Session |

Unklar: einmal beim Nutzer nachfragen.

## Was jede Rolle liest

| Rolle | Datei |
|---|---|
| Leitstelle | `references/leitstelle.md` |
| Session | `references/session.md` |
| Advisor | `references/advisor.md` |

Vor jeder Nachricht `references/nachrichten.md` lesen, dort stehen alle Formate. Wer Kontextakten, Fragenbuch, Startbefehl oder Startzeile braucht, liest `references/vorlagen.md`.

## Was beim Nutzer bleibt

Kein Advisor und keine Leitstelle entscheidet:

- Merge
- Produktfragen
- das Hinnehmen von Befunden ab MEDIUM ohne Fix
- Schreibzugriffe auf deployte Instanzen
- alles, was einer Session verweigert wurde

## Ablage

Kontextakten und Fragenbuch liegen unter `<Ablage>/advisor/`, als `kontext-s<n>.md` und `fragen.md`. Die Ablage steht pro Projekt in der Tabelle von `leitstelle-start` (`~/.claude/skills/leitstelle-start/references/projekte.md`), die der einzige Owner dafür ist. Nie im Scratchpad oder in `/tmp`, macOS räumt `/private/tmp` beim Boot.

## Prüfen nach Änderungen am Skill

```bash
bash ~/.claude/skills/leitstelle-advisor/scripts/test-pruefe-skill.sh
bash ~/.claude/skills/leitstelle-advisor/scripts/pruefe-skill.sh ~/.claude/skills/leitstelle-advisor
```
