# Changelog

## 1.0.0 (2026-10-18)

Erste öffentliche Fassung.

- `leitstelle-start`: fragt in einem Dialog nach der Anzahl der Sessions (1 bis 4), dem Advisor-Modell (Fable 5.1 empfohlen, Opus 5.5 oder ohne) und dessen Effort. Gibt je Terminal einen fertigen Startbefehl mit `--name` aus, meldet sich auf „alles ready“ bei allen Sessions und sammelt ihre Anmeldungen in einer Tabelle.
- `leitstelle-advisor`: Regelwerk für den laufenden Betrieb. Nachrichtenformate (`ADVISOR-FRAGE`, `ADVISOR-ANTWORT` mit Pflichtfeld `Akte`, `ADVISOR-PROBE` und weitere), Fragen-IDs, Fragenbuch, Kontextakten je Session und Fehlerfälle. Der Advisor arbeitet lesend, ohne Bash und ohne Schreibrechte in den Repos. Steht mit `user-invocable: false` nicht im Slash-Menü.
- Prüfskript `pruefe-skill.sh` mit Test für beide Skills.
- README mit Schritt-für-Schritt-Anleitung und Erklärvideo (74 s, mit Sprecher), gebaut mit HyperFrames, Quelle unter `video/`.
