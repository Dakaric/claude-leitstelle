# Projekte

Die Tabelle ist der einzige Ort, an dem Projekte, Präfixe und Ablageorte stehen. `leitstelle-start` liest sie beim Start, `leitstelle-advisor` verweist für die Ablage hierher.

- **Präfix:** Maschinen-Schlüssel für die Sessionnamen. Kleinbuchstaben, Ziffern und Bindestrich, keine Umlaute.
- **Repo:** Verzeichnis, in dem die Sessions starten.
- **Ablage:** Ordner für Fragenbuch und Kontextakten. Frei wählbar, Standard `~/.claude/leitstelle/<präfix>/`. Der Advisor liest und die Leitstelle schreibt unter `<Ablage>/advisor/`, als `fragen.md` und `kontext-s<n>.md`. Die Ablage liegt dauerhaft auf der Platte, nie in `/tmp` und nie im Scratchpad, weil macOS `/private/tmp` beim Boot räumt.

| Projekt | Präfix | Repo | Ablage |
|---|---|---|---|
| Kompass (Reiseplaner-Web-App) | `kompass` | `~/code/kompass` | `~/.claude/leitstelle/kompass/` |

## Eigenes Projekt eintragen

Nenne der Leitstelle Projektname und Repo, sie leitet den Rest ab und ergänzt die Tabelle. Von Hand geht es genauso: eine Zeile mit den vier Spalten, Beispielzeile ersetzen oder darunter anfügen. In `cd "..."` und in der Startzeile setzt die Leitstelle `$HOME` statt `~` ein, weil eine Tilde in Anführungszeichen nicht aufgelöst wird. In `--disallowedTools` bleiben die Muster so, wie `vorlagen.md` sie vorgibt, nie `$HOME`.
