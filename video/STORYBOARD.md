# Storyboard: Leitstelle für Claude Code

Konzept: Ein Tower im Terminal. Die Leitstelle schickt bernsteinfarbene Funksprüche an ihre Sessions, jeder Funkspruch ist als Paket zu sehen, das von Pane zu Pane fliegt.

Aufbau: `index.html` montiert vier Sub-Kompositionen: Hook, Terminal (eine durchgehende Oberfläche für die Szenen 2 bis 8, weil sie Zustände desselben Fensters sind), Kopfzeile mit Fortschritt und Abschluss. Kernaussage jeder Szene steht groß in der Kopfzeile, Terminaltext darf klein sein.

Palette: Hintergrund #0f0d0a, Vordergrund #ece4d3, Akzent Bernstein #f2a93b. Schrift: Montserrat (Titel, 900/400), JetBrains Mono (Terminal).

## Frame 1
status: animated
src: compositions/hook.html
time: 0–5.3
rules: kinetic-beat-slam, svg-path-draw, ambient-glow-bloom
beat: Hook. „Eine Leitstelle verteilt, vier Sessions bauen, ein Advisor berät.“ Rechts eine Miniatur des Layouts, Pakete fliegen von der Leitstelle zu den Sessions.

## Frame 2
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 5–14
rules: anchored-layout-expand (Masken-Variante über clip-path), press-release-spring
beat: Terminal-App mit Projekt-Seitenleiste. Fünf Teilungen, Einblendung ⌘D (nach rechts teilen) und ⌘⇧D (nach unten teilen). Endlayout: Leitstelle links oben, Advisor links unten, vier Sessions rechts im 2×2-Raster.

## Frame 3
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 14–24
rules: viewport-change, discrete-text-sequence
beat: Kamera fährt auf die Leitstelle. `claude`, dann `/leitstelle-start`, Dialog „Wie viele Sessions?“ 4, „Mit Advisor?“ mit. Startbefehle je Terminal mit `--name`.

## Frame 4
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 24–33
rules: discrete-text-sequence, control-target-sync
beat: Befehle werden in die Panes eingefügt (⌘V), jede Session startet und wartet. Der Advisor-Befehl bringt seine Startzeile mit, im Pane wird nichts getippt.

## Frame 5
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 33–43
rules: svg-path-draw, spring-pop-entrance
beat: „alles ready“. LEITSTELLE-START fliegt an jede Session, ANMELDUNG kommt zurück, Tabelle „alle angemeldet“.

## Frame 6
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 43–50
rules: svg-path-draw, spring-pop-entrance
beat: ADVISOR-PROBE an den Advisor, ADVISOR-PROBE OK zurück, ADVISOR-BEREIT an alle Sessions.

## Frame 7
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 50–60
rules: svg-path-draw, asr-keyword-glow
beat: Session 2 stellt ADVISOR-FRAGE F-S2-01, die Leitstelle legt die Akte bei, der Advisor antwortet direkt an Session 2 mit Kopie an die Leitstelle.

## Frame 8
status: animated
src: compositions/terminal.html (Kopfzeile: compositions/headlines.html)
time: 60–67
rules: svg-path-draw, viewport-change
beat: F-S2-02 mit „An Nutzer: ja“. Die Leitstelle legt die Frage gebündelt dem Menschen vor.

## Frame 9
status: animated
src: compositions/close.html
time: 67–74
rules: spring-pop-entrance, ambient-glow-bloom
beat: Abschluss: `/leitstelle-start` und github.com/Dakaric/claude-leitstelle.
