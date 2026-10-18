---
workflow: general-video
flow: automation
storyboard: no
mode: autonomous
destination: GitHub-README und Weitergabe an Entwickler (LinkedIn, Chat)
aspect: 1920x1080
length: 60–80 s
language: Deutsch (nur Bildschirmtext)
narration: yes (ElevenLabs, Stimme Arnold, eleven_multilingual_v2, Tempo 1,08, ein Clip je Szene unter assets/vo/)
audience: Entwickler, die Claude Code schon nutzen
---

# Brief: Leitstelle für Claude Code

## Botschaft

Eine Leitstelle verteilt die Arbeit, mehrere Claude-Code-Sessions bauen parallel, ein Advisor berät lesend, und gestartet wird das Ganze mit dem Skill /leitstelle-start.

## Ablauf, den das Video zeigt

1. Hook: mehrere Sessions, eine Leitstelle.
2. Terminal-App mit einem Fenster, Panes werden geteilt (⌘D nach rechts, ⌘⇧D nach unten), Endlayout: Leitstelle links oben groß, Advisor links unten, vier Sessions rechts im 2×2-Raster.
3. In der Leitstelle: `/leitstelle-start`, Dialog mit drei Fragen: Sessions 4, Advisor Fable 5.1, Effort high. Der Advisor-Befehl trägt `--model claude-fable-5-1 --effort high`. Die Leitstelle gibt je Terminal einen Startbefehl mit `--name` aus.
4. Befehle in die Panes, jede Session startet und wartet.
5. „alles ready“ in der Leitstelle: LEITSTELLE-START fliegt an jede Session, ANMELDUNG kommt zurück, Tabelle „alle angemeldet“.
6. Advisor: ADVISOR-PROBE → ADVISOR-PROBE OK, danach ADVISOR-BEREIT an alle Sessions.
7. Arbeiten: Session 2 stellt eine ADVISOR-FRAGE an die Leitstelle, die Leitstelle legt die Kontextakte bei und leitet weiter, der Advisor antwortet direkt an Session 2 mit Kopie an die Leitstelle. Eine Frage, die nur der Mensch entscheiden kann, landet gebündelt bei ihm.
8. Abschluss: `/leitstelle-start` und github.com/Dakaric/claude-leitstelle.

## Fiktiver Inhalt (Pflicht)

Kein echtes Projekt, kein echter Name, keine echten Pfade. Projekt „Kompass“, eine erfundene Reiseplaner-Web-App, Repo `~/code/kompass`, Präfix `kompass`. Namen: `kompass-leitstelle`, `kompass-session1` bis `kompass-session4`, `kompass-advisor`.

Aufgaben der Sessions: S1 Suche mit Filter nach Region, S2 Gutscheincodes im Checkout, S3 Abmeldelink im Newsletter, S4 Ladezeit der Kartenansicht.

## Gestaltung

Dunkles Terminal-Layout, angelehnt an eine Terminal-App mit Projekt-Seitenleiste und geteilten Panes. Monospace für Terminalinhalt, klare Sans für Titel. Bildschirmtext auf Deutsch mit echten Umlauten, kein Gedankenstrich als Einschub, keine Emojis.
