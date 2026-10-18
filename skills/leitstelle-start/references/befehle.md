# Befehle

Jeder Befehl ist eine Zeile, die der Nutzer in ein frisches Terminal kopiert. Die Startzeile steht als erstes Argument direkt hinter `claude`. Hinter `--disallowedTools` darf nichts mehr kommen außer Werkzeugen, weil die Option alle folgenden Wörter als Werkzeug nimmt.

Platzhalter: `<repo>` und `<ablage>` aus `references/projekte.md`, `<Projekt>`, `<präfix>`, `<n>`, `<leitstelle>` (eigener Name aus `ListAgents`), `<modus>` (Permission-Mode der Leitstelle). Pfade mit `~` schreibt die Leitstelle in `cd "..."` und in der Startzeile als `$HOME/...`, denn in Anführungszeichen löst die Shell eine Tilde nicht auf. In `--disallowedTools` bleiben die Muster so, wie `vorlagen.md` sie vorgibt (`~/...` oder `//absoluter/pfad`), nie `$HOME`.

## Session

```bash
cd "<repo>" && claude "Du bist Session <n> (<präfix>-session<n>) im Projekt <Projekt>. Leitstelle ist <leitstelle>. Warte auf die Nachricht LEITSTELLE-START der Leitstelle und fang vorher nichts an." --name <präfix>-session<n> --permission-mode <modus>
```

Mit Advisor steht in der Startzeile vor „Warte“ zusätzlich: „Lade den Skill leitstelle-advisor (Rolle Session).“

## Advisor

Startbefehl und Startzeile kommen aus `~/.claude/skills/leitstelle-advisor/references/vorlagen.md`, Abschnitt „Startbefehl und Startzeile“, dort ist ihr Owner. Für diesen Skill wird daraus eine Zeile:

- `cd "<ablage>" && claude "<Startzeile>" <Optionen aus vorlagen.md>`
- In den Optionen aus vorlagen.md werden `<präfix>`, `<Projekt>`, die Pfade und der Modus eingesetzt; `--name` und `--permission-mode` stehen dort schon, beide vor `--disallowedTools`. Hat Teil 1 den Namen wegen einer Kollision verlängert, steht der verlängerte Name dort.
- In der Startzeile: Leitstelle `<leitstelle>`, Sessions `S1 (<präfix>-session1)` bis `S<n> (<präfix>-session<n>)`, Repo und Fragenbuch des Projekts.

## Beispiel: Kompass, zwei Sessions, ohne Advisor, Leitstelle kompass-leitstelle, Modus auto

Terminal 1, Session 1:

```bash
cd "$HOME/code/kompass" && claude "Du bist Session 1 (kompass-session1) im Projekt Kompass. Leitstelle ist kompass-leitstelle. Warte auf die Nachricht LEITSTELLE-START der Leitstelle und fang vorher nichts an." --name kompass-session1 --permission-mode auto
```

Terminal 2, Session 2:

```bash
cd "$HOME/code/kompass" && claude "Du bist Session 2 (kompass-session2) im Projekt Kompass. Leitstelle ist kompass-leitstelle. Warte auf die Nachricht LEITSTELLE-START der Leitstelle und fang vorher nichts an." --name kompass-session2 --permission-mode auto
```
