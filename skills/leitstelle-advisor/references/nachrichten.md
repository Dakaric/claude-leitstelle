# Nachrichten

Jede Nachricht zu einer Advisor-Frage geht per `SendMessage` an den Namen aus `ListAgents` und hat genau eines der Formate unten. Diese Datei ist der einzige Ort, an dem die Formate stehen.

Für alle gilt:

- Die erste Zeile ist selbsterklärend. Sie ist die einzige Vorschau, die der Nutzer im Fenster sieht.
- Kontext geht als absoluter Pfad im Text. Ein `@Pfad` hängt bei `SendMessage` nichts an.
- Der Sessionname ist immer der aktuelle Name aus `ListAgents`, nie der aus einer alten Startzeile. Ohne `--name` ändert er sich bei jedem Start. Mit `--name` bleibt er über Neustarts gleich, dann gilt die Kollisionsregel aus `leitstelle-start`.
- Eine Kopie ist dieselbe Nachricht, wörtlich, als zweiter `SendMessage` an den Kopie-Empfänger.

Die Fragen-ID hat die Form `F-S<Sessionnummer>-<laufende Nummer, zweistellig>`, etwa `F-S2-03`. Die nächste freie ID nennt die Leitstelle der Session in `ADVISOR-BEREIT`. Alle Nachrichten zu einer Frage tragen dieselbe ID.

## ADVISOR-FRAGE (Session an Leitstelle)

Von: Session. An: Leitstelle. Kopie: keine. `notify_when_idle`: nein.

```text
ADVISOR-FRAGE F-S2-03 (Session 2, <Sessionname aus ListAgents>): <Frage in einer Zeile>
Art: Entscheidung | Nutzer-Frage
Blockiert: ja | nein, arbeite derweil an <Aufgabe>
Lokal: Zweig <branch>, HEAD <sha>, Plan <absoluter Pfad> Aufgabe <n>
Verweigert: keine | <Aktion>, verweigert von <Nutzer oder Klassifizierer>
Was ich sehe: <2–5 Zeilen, Belege als Pfad:Zeile>
Optionen: A …, B …, meine Neigung: <Option>, weil …
```

## ADVISOR-FRAGE (Leitstelle an Advisor)

Von: Leitstelle. An: Advisor. Kopie: keine. `notify_when_idle`: ja.

```text
ADVISOR-FRAGE F-S2-03 von Session 2 (<Sessionname aus ListAgents>), weitergeleitet von Leitstelle <name>
Zustellung: erste | erneut
Kontext: <absoluter Pfad kontext-s2.md>, Stand <HH:MM>
Leitstelle ergänzt: <0–3 Zeilen Querbezüge, etwa andere Sessions am selben Code oder Vorgaben des Nutzers>
--- Original ---
<Frage der Session, unverändert>
```

## ADVISOR-ANTWORT

Von: Advisor. An: fragende Session. Kopie: Leitstelle. `notify_when_idle`: nein.

```text
ADVISOR-ANTWORT F-S2-03: <Empfehlung in einer Zeile>
Begründung: <kurz, mit Belegen als Pfad:Zeile>
Akte: stimmt | weicht ab bei <Stelle>: Akte <Wert>, Frage <Wert>
Sicherheit: hoch | mittel | gering, kippt wenn <Bedingung>
An Nutzer: nein | ja: <die eine Frage, die nur der Nutzer beantworten kann>
```

`Akte:` ist Pflicht und vergleicht Worktree und Plan-Pfad sowie alles, was die Frage über Ziel, Entscheidungen und Vorgaben behauptet. Bei mehreren Abweichungen steht jede mit Stelle und beiden Werten, durch Semikolon getrennt.

Nach einem `ADVISOR-KONFLIKT` trägt die erste Zeile beide IDs (`ADVISOR-ANTWORT F-S1-04 und F-S2-03: …`), und die Antwort geht an beide Sessions.

## ADVISOR-RÜCKFRAGE

Von: Advisor. An: fragende Session. Kopie: Leitstelle. `notify_when_idle`: nein.

```text
ADVISOR-RÜCKFRAGE F-S2-03: <was fehlt, in einer Zeile>
Brauche: <konkrete Angabe, etwa Datei, Messung, Testausgabe>
```

## ADVISOR-NACHTRAG

Von: Session. An: Advisor. Kopie: Leitstelle. `notify_when_idle`: ja. Antwort auf eine Rückfrage oder der einmalige Widerspruch gegen eine Antwort.

```text
ADVISOR-NACHTRAG F-S2-03 (Session 2, <Sessionname aus ListAgents>): <Kern in einer Zeile>
Anlass: Rückfrage | Widerspruch
Inhalt: <die verlangte Angabe oder der Grund des Widerspruchs, mit Belegen>
```

## ADVISOR-PROBE

Von: Leitstelle. An: Advisor, vor dem ersten `ADVISOR-BEREIT` und nach jedem Neustart des Advisors. Kopie: keine. `notify_when_idle`: ja. Der Advisor antwortet der Leitstelle mit der zweiten Zeile.

```text
ADVISOR-PROBE: Leitstelle <name> prüft die Zustellung. Antworte nur mit ADVISOR-PROBE OK.
```

```text
ADVISOR-PROBE OK
```

## ADVISOR-BEREIT

Von: Leitstelle. An: jede Session, nach bestandener Probe, an jede später gestartete Session, an jede Session nach ihrem `/clear` und an alle nach jedem Neustart des Advisors. Kopie: keine. `notify_when_idle`: nein.

```text
ADVISOR-BEREIT: Advisor ist <Name aus ListAgents>. Fragen ab jetzt als ADVISOR-FRAGE an mich (Leitstelle <name>), Format im Skill leitstelle-advisor. Deine nächste Fragen-ID: F-S<n>-<nn>.
```

## ADVISOR-NUTZER

Von: Leitstelle. An: fragende Session, sobald der Nutzer entschieden hat. Kopie: keine. `notify_when_idle`: nein.

```text
ADVISOR-NUTZER F-S2-03: <Entscheidung des Nutzers in einer Zeile>
Dazu: <was der Nutzer sonst gesagt hat, oder "nichts">
```

## ADVISOR-AUSFALL

Von: Leitstelle. An: fragende Session. Kopie: keine. `notify_when_idle`: nein.

```text
ADVISOR-AUSFALL F-S2-03: Advisor nicht erreichbar (<Grund>). Frag wie bisher mich oder den Nutzer.
```

## ADVISOR-KONFLIKT

Von: Leitstelle. An: Advisor. Kopie: keine. `notify_when_idle`: ja.

```text
ADVISOR-KONFLIKT F-S1-04 und F-S2-03: <worin sich die Antworten widersprechen>. Bitte eine Antwort für beide.
```
