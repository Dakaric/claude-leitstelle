# Vorlagen

Alle Dateien liegen unter `<Ablage>/advisor/`. Die Ablage steht pro Projekt in `~/.claude/skills/leitstelle-start/references/projekte.md`, dort ist ihr einziger Owner (Standard `~/.claude/leitstelle/<präfix>/`). Wer die Dateien anlegt und pflegt, steht in `references/leitstelle.md`.

## Kontextakte

Datei `kontext-s<n>.md`, eine pro Session. Sie führt nur, was sich langsam ändert. Kein Zweig, kein HEAD, keine aktuelle Aufgabe: Die stehen in jeder Frage unter `Lokal:` und sind dort beim Absenden aktuell.

```markdown
# Kontextakte Session <n> (<Sessionname>)

Stand: <JJJJ-MM-TT HH:MM>

## Ziel
<Ziel der Session in Worten des Nutzers>
Auftrag: <absoluter Pfad zum Auftrag oder Handoff>

## Worktree und Plan
Worktree: <absoluter Pfad>
Plan: <absoluter Pfad>

## Entscheidungen
- F-S<n>-<nn>: <Entscheidung in einer Zeile>

## Vorgaben des Nutzers
- <Vorgabe oder Grenze für diese Session>
- Verweigert: <Aktion, von wem, wann>

## Querbezüge
- <andere Session, geteilte Datei, Test-DB oder Dev-Stack>
```

## Fragenbuch

Datei `fragen.md`, eine pro Leitstelle. Eine Zeile pro Frage, Status-Übergänge in `references/leitstelle.md`.

```markdown
# Fragenbuch <Projekt>

| ID | Session | Art | Frage | Antwort | An Nutzer | Status |
|---|---|---|---|---|---|---|
| F-S2-03 | S2 (kompass-session2) | Entscheidung | Suchfilter in Service oder Repository? | Repository | nein | beantwortet |
```

Status-Werte: `offen`, `Rückfrage offen`, `beantwortet`, `beim Nutzer`, `erledigt`.

## Startbefehl und Startzeile

Der Nutzer startet den Advisor selbst, aus der Ablage des Projekts. `--setting-sources local` lädt keine Allow-Regeln (weder aus `~/.claude/settings.json` noch aus Projekt-Settings), `--disallowedTools` nimmt Bash weg und sperrt das Schreiben in Repos, `~/.claude` und `advisor/`. Lesen bleibt überall erlaubt. `--restricted` taugt nicht: Damit läuft der Advisor nur über Remote Control, ohne seinen Namen und ohne `notify_when_idle`.

Pfadmuster in `--disallowedTools`: Ein Pfad unter dem Home-Verzeichnis beginnt mit `~/`, jeder andere mit `//` und dem absoluten Pfad ohne führenden Schrägstrich. Pro Repo ein Paar `Edit` und `Write`. Der Beispielbefehl gilt für das Projekt Kompass mit Repo `~/code/kompass`, Leitstelle in `auto`:

```bash
cd "$HOME/.claude/leitstelle/kompass" && claude "<Startzeile>" --setting-sources local --model claude-fable-5-1 --effort high --name kompass-advisor --permission-mode auto --disallowedTools Bash NotebookEdit "Edit(~/code/kompass/**)" "Write(~/code/kompass/**)" "Edit(~/.claude/**)" "Write(~/.claude/**)" "Edit(~/.claude/leitstelle/kompass/advisor/**)" "Write(~/.claude/leitstelle/kompass/advisor/**)"
```

Als Vorlage mit Platzhaltern: `cd "<ablage>"`, `--model <modell, Standard claude-fable-5-1>`, `--effort <effort, Standard high>`, `--name <präfix>-advisor`, `--permission-mode <wie die Sessions, nie bypassPermissions>`, je Repo `"Edit(<repo>/**)" "Write(<repo>/**)"` und `"Edit(<ablage>/advisor/**)" "Write(<ablage>/advisor/**)"`, Pfade nach dem Muster oben.

Ohne die Nutzer-Settings findet die Session den Skill nicht über das Skill-Werkzeug. Deshalb nennt die Startzeile die Dateien, die der Advisor selbst liest.

Die Startzeile darf als erstes Argument direkt hinter `claude` stehen, dann beginnt der Advisor ohne Einfügen. Nie hinter `--disallowedTools`: Die Option nimmt alle folgenden Wörter als Werkzeug. `leitstelle-start` baut den Befehl so.

```text
Du bist der Advisor für <Projekt>. Leitstelle ist <name>. Lies zuerst $HOME/.claude/skills/leitstelle-advisor/SKILL.md, $HOME/.claude/skills/leitstelle-advisor/references/advisor.md und $HOME/.claude/skills/leitstelle-advisor/references/nachrichten.md und handle danach. Sessions: S1 (<name>), S2 (<name>). Repos: <Repo 1>, <Repo 2>. Fragenbuch: <absoluter Pfad fragen.md>.
```
