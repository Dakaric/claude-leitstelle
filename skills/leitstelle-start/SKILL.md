---
name: leitstelle-start
description: "Startet ein Leitstellen-Setup: fragt nur nach Anzahl der Sessions und ob ein Advisor dazukommt, gibt je Terminal einen fertigen Startbefehl mit --name aus, meldet sich auf das „alles ready“ des Nutzers bei allen Sessions, erklärt ihnen den Ablauf und sammelt ihre Anmeldung ein. Nutze bei /leitstelle-start, wenn der Nutzer Sessions für eine Leitstelle aufsetzen will, „starte das Setup“, „ich brauche drei Sessions“ oder „Leitstelle mit Advisor hochfahren“ sagt."
argument-hint: "[projekt] [anzahl] [mit|ohne advisor]"
---

# Leitstellen-Setup starten

Die Session, in der dieser Skill läuft, ist die Leitstelle. Sie baut nichts. Sie gibt dem Nutzer die Startbefehle, meldet sich bei allen, sobald er „alles ready“ sagt, und sammelt die Anmeldungen ein. Nachrichtenformate: `references/nachrichten.md`. Befehlsvorlagen: `references/befehle.md`. Projekte und Ablageorte: `references/projekte.md`.

## Teil 1: Befehle ausgeben

1. **Projekt bestimmen** aus Argument, Arbeitsverzeichnis, Startzeile oder geladenem Handoff, nachschlagen in `references/projekte.md`. Ist es nicht eindeutig (etwa bei Start aus einem Ordner, der zu keinem Projekt gehört), kommt es als dritte Frage in Schritt 2, mit den Projekten aus der Tabelle als Optionen. Nennt der Nutzer ein neues Projekt, leitet die Leitstelle Präfix, Repo (aus dem Arbeitsverzeichnis oder seiner Angabe) und Ablage (Standard `~/.claude/leitstelle/<präfix>/`) selbst ab, nennt die drei Werte über den Befehlen und trägt sie in die Tabelle ein. Mit `/leitstelle-start kompass` entfällt die Frage.
2. **Fragen**, ein einziger `AskUserQuestion`-Dialog: „Wie viele Sessions?“ (1, 2, 3, 4) und „Mit Advisor?“ (mit, ohne). Was die Argumente schon beantworten, wird nicht gefragt. Sonst nichts fragen.
3. **Namen vergeben:** `ListAgents` liefert den eigenen Namen der Leitstelle. Die neuen Namen sind `<präfix>-session1` bis `<präfix>-session<n>` und `<präfix>-advisor`. Steht ein Name schon in `ListAgents`, gleich in welchem Zustand, hängt die Leitstelle `-b` an (dann `-c`) und sagt dem Nutzer das in einer Zeile.
4. **Mit Advisor:** Skill `leitstelle-advisor` laden, Rolle Leitstelle, und dessen Abschnitt „Start“ in `references/leitstelle.md` befolgen. Ein neues Setup bekommt ein neues Fragenbuch und neue Akten: Vorhandene `fragen.md` und alle `kontext-s*.md` wandern vorher nach `advisor/archiv/` unter der Ablage, mit Datum im Namen (`fragen-<JJJJ-MM-TT>.md`, bei zweitem Mal am Tag `-2`), nichts wird überschrieben. Ziel und Plan in den neuen Akten bleiben „offen, folgt mit dem ersten Auftrag“.
5. **Befehle ausgeben**, je Terminal ein eigener `bash`-Block mit genau einer Zeile. Darüber eine Zeile, welches Terminal welcher Block ist, der Advisor zuletzt. Darunter: „Wenn alle laufen, sag mir ‚alles ready‘.“

Die Sessions starten still und warten. Meldet sich eine trotzdem vorher, bekommt sie sofort ihr `LEITSTELLE-START` und wird in Teil 2 nicht doppelt angeschrieben.

## Teil 2: auf „alles ready“

Auslöser ist das „alles ready“ des Nutzers oder sinngemäß „alle laufen“.

1. `ListAgents` einmal aufrufen.
2. Jeder gelisteten Session schickt die Leitstelle `LEITSTELLE-START` mit Rolle und Spielregeln. Die Session antwortet per `SendMessage` mit `ANMELDUNG`, die Leitstelle notiert Verzeichnis, Zweig und HEAD.
3. Mit Advisor: An den Advisor geht `ADVISOR-PROBE` nach `leitstelle-advisor`. Nach `ADVISOR-PROBE OK` bekommt jede schon angemeldete Session ihr `ADVISOR-BEREIT`, jede spätere direkt nach ihrer Anmeldung.
4. Fehlt ein Name in `ListAgents`, gibt die Leitstelle den Befehl für dieses Terminal noch einmal aus, mit dem Satz „Sag mir ‚<name> läuft‘, wenn es steht.“ Auf diesen Satz ruft sie `ListAgents` einmal auf und schickt `LEITSTELLE-START`, beim Advisor `ADVISOR-PROBE`.
5. Sind alle da, meldet die Leitstelle dem Nutzer „alle angemeldet“ mit einer Tabelle: Name, Rolle, Verzeichnis, Zweig, HEAD. Danach verteilt sie Aufträge, wenn der Nutzer sie nennt.

## Permission-Mode

Alle Befehle tragen `--permission-mode` mit dem Modus, in dem die Leitstelle selbst läuft. Sie erkennt ihn am Systemhinweis, sonst fragt sie in Teil 1, Schritt 2 mit. Bei unterschiedlichen Modi hält Claude Code Nachrichten zwischen den Sessions zur Freigabe zurück, dann bleibt die Anmeldung aus. Läuft die Leitstelle in `bypassPermissions` und soll ein Advisor dazukommen, gibt sie keine Befehle aus, sondern sagt: „Der Advisor läuft nie in bypassPermissions. Starte die Leitstelle in auto neu und ruf /leitstelle-start noch einmal auf, oder nimm das Setup ohne Advisor.“

## Wenn eine Anmeldung ausbleibt

Die Leitstelle fragt nicht in Schleife nach und schickt kein „bist du da?“. `LEITSTELLE-START` geht mit `notify_when_idle: true` raus. Kommt die Leerlauf-Meldung ohne Anmeldung, schickt sie `LEITSTELLE-START` einmal erneut, denn die erste Nachricht kann in den Startturn gefallen sein. Bleibt es still, oder kam eine Zustellwarnung, geht eine Zeile an den Nutzer: Im Fenster `<name>` wartet vermutlich ein Freigabe-Dialog, oder der Permission-Mode weicht ab.

## Prüfen nach Änderungen

```bash
bash ~/.claude/skills/leitstelle-advisor/scripts/pruefe-skill.sh ~/.claude/skills/leitstelle-start
```
