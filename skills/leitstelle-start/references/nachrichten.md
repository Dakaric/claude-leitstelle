# Nachrichten beim Start

Beide gehen per `SendMessage` an den Namen aus `ListAgents`. Die erste Zeile ist selbsterklärend, sie ist die einzige Vorschau im Fenster. Pfade stehen ausgeschrieben im Text, ein `@Pfad` hängt bei `SendMessage` nichts an.

## LEITSTELLE-START

Von: Leitstelle. An: jede Session, auf das „alles ready“ des Nutzers. `notify_when_idle`: ja. Die Zeile in eckigen Klammern nur mit Advisor.

```text
LEITSTELLE-START: Hier ist Leitstelle <leitstelle>, Setup <Projekt> mit <n> Sessions<, Advisor <präfix>-advisor>. Du bist S<k> (<präfix>-session<k>).
So läuft es:
- Aufträge kommen nur von mir. Fang nichts an, was ich nicht verteilt habe.
- Fertig, Blocker und Fragen meldest du mir per SendMessage, Pfade ausgeschrieben, Belege als Pfad:Zeile.
- Was der Nutzer entscheiden muss, sammle ich und lege es ihm gebündelt vor. Du fragst ihn nicht direkt über mich hinweg.
- Andere Sessions sprichst du nicht direkt an. Geteilte Ressourcen (Dev-Stack, Test-DB, volle Suite) teile ich zu.
- Gebaut wird nur in dem Worktree, den ich dir mit dem Auftrag nenne. Im Haupt-Checkout änderst du nichts, kein checkout, kein stash.
- Pause und Übergabe meldest du mir. Ein eigener Handoff-Skill darf das übernehmen.
[- Entscheidungsfragen gehen als ADVISOR-FRAGE an mich, Format im Skill leitstelle-advisor. Deine Fragen-ID kommt mit ADVISOR-BEREIT, sobald der Advisor bereit ist.]
Schick mir jetzt per SendMessage genau eine Zeile, nicht als Text in deinem Terminal: ANMELDUNG S<k> (<präfix>-session<k>): bereit, Verzeichnis <pwd>, Zweig <branch>, HEAD <kurz-sha>
```

## ANMELDUNG

Von: Session. An: Leitstelle, als Antwort auf `LEITSTELLE-START`. `notify_when_idle`: nein.

```text
ANMELDUNG S<k> (<präfix>-session<k>): bereit, Verzeichnis <pwd>, Zweig <branch>, HEAD <kurz-sha>
```

Der Advisor meldet sich nicht mit `ANMELDUNG`. Seine Anmeldung ist `ADVISOR-PROBE OK` aus dem Skill `leitstelle-advisor`.
