# PLAN NOWEJ STRONY - CORNERS PREDICTOR

## 🎯 CEL STRONY

Strona ma na celu **predykcję meczów piłkarskich** z fokusem na **over 9.5 rożnych** (corner kicks). 
Aplikacja analizuje dane historyczne drużyn i oblicza prawdopodobieństwo, że mecz będzie miał więcej niż 9.5 rożnych.

**Strategia:** Zacząć od **TYLKO API-Football** (api-sports.io). Pozostałe API zostawić nietknięte.
Ewentualnie stworzyć 3 osobne strony - każda z własnym API.

**Kryteria akceptacji meczu:**
- Średnia prawdopodobieństwa ≥ 55% (gdy tylko jedno API, nie ma zgodności)
- Albo zgodność między źródłami ≥ 30% + średnia ≥ 55% (gdy wiele API)

---

## ⚠️ WAŻNE: RÓŻNICE MIĘDZY API

### 🔴 KRITICZNE RÓŻNICE - KAŻDE API DZIAŁA INACZEJ!

#### 1. SPOSÓB AUTENTYKACJI
- **Sportmonks:** Klucz w parametrze URL `?api_token={key}`
- **FootyStats:** Klucz w parametrze URL `?key={key}`
- **API-Football:** Klucz w HEADER `x-apisports-key: {key}` ❗

#### 2. ID MECZU
- **Sportmonks:** Używa `fixture.id` lub `match.id` (liczba)
- **FootyStats:** Używa `match.id` lub `match_id` (liczba)
- **API-Football:** Używa `fixture.id` (liczba) ❗

#### 3. ID DRUŻYNY
- **Sportmonks:** Używa `team.id` lub `participant.id`
- **FootyStats:** Używa `homeID` / `awayID` lub `home_id` / `away_id`
- **API-Football:** Używa `teams.home.id` / `teams.away.id` ❗

#### 4. STRUKTURA ODPOWIEDZI
- **Sportmonks:** `{ data: [...], pagination: {...} }`
- **FootyStats:** `{ data: [...] }` lub `{ success: true, data: [...] }`
- **API-Football:** `{ response: [...], results: number }` ❗

#### 5. POLE Z NAZWĄ DRUŻYNY
- **Sportmonks:** `team.name` lub `participant.name`
- **FootyStats:** `home_name` / `away_name` lub `homeName` / `awayName`
- **API-Football:** `teams.home.name` / `teams.away.name` ❗

#### 6. POLE Z NAZWĄ LIGI
- **Sportmonks:** `league.name` (w include)
- **FootyStats:** `competition_name` lub przez mapowanie `competition_id`
- **API-Football:** `league.name` ❗

#### 7. POLE Z ROŻNYMI (CORNERS)
- **Sportmonks:** W statystykach `statistics[].value` gdzie `type.name === 'Corner Kicks'`
- **FootyStats:** `total_corners_count` lub `homeCorners` + `awayCorners`
- **API-Football:** W statystykach `statistics[].value` gdzie `type === 'Corner Kicks'` ❗

#### 8. POLE Z POSIADANIEM
- **Sportmonks:** `statistics[].value` gdzie `type.name === 'Ball Possession'` (liczba %)
- **FootyStats:** `team_a_possession` / `team_b_possession` (liczba %)
- **API-Football:** `statistics[].value` gdzie `type === 'Ball Possession'` (string "45%") ❗

#### 9. ENDPOINT DO HISTORII DRUŻYNY
- **Sportmonks:** `/teams/{id}?include=latest` + osobne zapytania dla statystyk
- **FootyStats:** `/league-matches?comp_id={leagueId}` + filtrowanie po ID drużyny (fallback)
- **API-Football:** `/fixtures?team={teamId}&last={limit}` ❗

#### 10. CORS
- **Sportmonks:** Wymaga proxy (CORS block)
- **FootyStats:** Wymaga proxy (CORS block)
- **API-Football:** Nie wymaga proxy (obsługuje CORS) ✅

#### 11. LIMITY
- **Sportmonks:** Sprawdź w dokumentacji
- **FootyStats:** Rate limiting (HTTP 429)
- **API-Football:** **100 zapytań/dzień** (free plan) ❗

**⚠️ UWAGA:** Zawsze sprawdzać strukturę odpowiedzi w konsoli przed parsowaniem!

---

## 📋 CHECKLISTA WERYFIKACJI PRZED KAŻDĄ POPRAWKĄ

### KROK 1: PRZECZYTANIE PLANU
- [ ] Przeczytałem sekcję "CEL STRONY"
- [ ] Rozumiem jakie API używać (TYLKO API-Football na start)
- [ ] Znam różnice między API (sekcja "WAŻNE: RÓŻNICE MIĘDZY API")
- [ ] Wiem jaki jest cel funkcjonalności którą dodaję/zmieniam

### KROK 2: WERYFIKACJA STRUKTURY DANYCH
- [ ] Sprawdziłem jak API-Football zwraca dane (struktura JSON)
- [ ] Wiem gdzie są ID meczu (`fixture.id`)
- [ ] Wiem gdzie są ID drużyn (`teams.home.id`, `teams.away.id`)
- [ ] Wiem gdzie są nazwy drużyn (`teams.home.name`, `teams.away.name`)
- [ ] Wiem gdzie jest nazwa ligi (`league.name`)
- [ ] Wiem jak pobrać statystyki (endpoint `/fixtures/statistics`)

### KROK 3: WERYFIKACJA ENDPOINTÓW
- [ ] Sprawdziłem dokumentację API-Football dla endpointu
- [ ] Wiem jaki jest prawidłowy URL endpointu
- [ ] Wiem jakie HEADERY są wymagane (`x-apisports-key`)
- [ ] Wiem jakie parametry są wymagane/opcjonalne
- [ ] Sprawdziłem czy endpoint wymaga proxy (API-Football NIE wymaga)

### KROK 4: WERYFIKACJA LIMITÓW
- [ ] Sprawdziłem limit zapytań dla API-Football (100/dzień)
- [ ] Dodałem sprawdzanie limitu przed zapytaniem
- [ ] Dodałem obsługę błędów HTTP 429 (rate limit)
- [ ] Dodałem komunikaty o limicie dla użytkownika

### KROK 5: WERYFIKACJA OBSŁUGI BŁĘDÓW
- [ ] Dodałem sprawdzanie `response.ok`
- [ ] Dodałem sprawdzanie `Content-Type` (czy JSON)
- [ ] Dodałem obsługę błędów HTTP 403, 404, 429
- [ ] Dodałem `try-catch` dla błędów parsowania JSON
- [ ] Dodałem komunikaty błędów dla użytkownika

### KROK 6: WERYFIKACJA FUNKCJONALNOŚCI
- [ ] Funkcja robi dokładnie to co jest w planie
- [ ] Nie mieszam logiki z różnych API
- [ ] Używam prawidłowych nazw pól dla API-Football
- [ ] Nie odwołuję się do nieistniejących funkcji/innych API

### KROK 7: WERYFIKACJA KODU
- [ ] Kod jest czytelny i dobrze skomentowany
- [ ] Nie ma duplikacji kodu
- [ ] Używam prawidłowych nazw zmiennych
- [ ] Sprawdziłem czy nie ma błędów składniowych
- [ ] Sprawdziłem czy wszystkie funkcje są zdefiniowane

### KROK 8: TESTY
- [ ] Przetestowałem funkcję w konsoli przeglądarki
- [ ] Sprawdziłem czy dane są poprawnie parsowane
- [ ] Sprawdziłem czy błędy są poprawnie obsługiwane
- [ ] Sprawdziłem czy limit zapytań jest respektowany

### KROK 9: DOKUMENTACJA
- [ ] Zaktualizowałem plan jeśli dodałem nową funkcjonalność
- [ ] Dodałem komentarze w kodzie wyjaśniające co robi funkcja
- [ ] Zaznaczyłem w checklistzie co zostało zrobione

---

## 📊 CO POWINNO BYĆ POBIERANE (API-FOOTBALL)

### 1. LISTA MECZÓW NA DZIEŃ
**Endpoint:** `GET /fixtures?date={date}&timezone=Europe/Warsaw`
**Headers:** `x-apisports-key: {key}`

**Dane do pobrania:**
- `response[].fixture.id` - ID meczu
- `response[].teams.home.name` - Nazwa drużyny domowej
- `response[].teams.away.name` - Nazwa drużyny wyjazdowej
- `response[].league.name` - Nazwa ligi
- `response[].fixture.date` - Data i godzina meczu
- `response[].fixture.status.short` - Status (NS, LIVE, FT)

### 2. HISTORIA MECZÓW DRUŻYN (ostatnie 5-10 meczów)
**Endpoint:** `GET /fixtures?team={teamId}&last={limit}`
**Headers:** `x-apisports-key: {key}`

**Dane do pobrania:**
- Lista ostatnich meczów drużyny
- Dla każdego meczu: statystyki (rożne, posiadanie, strzały)

### 3. STATYSTYKI MECZU
**Endpoint:** `GET /fixtures/statistics?fixture={fixtureId}`
**Headers:** `x-apisports-key: {key}`

**Dane do pobrania:**
- `response[0].statistics[]` - Statystyki drużyny domowej
- `response[1].statistics[]` - Statystyki drużyny wyjazdowej
- Znajdź `type === 'Corner Kicks'` → `value` (liczba rożnych)
- Znajdź `type === 'Ball Possession'` → `value` (string "45%")
- Znajdź `type === 'Shots on Goal'` → `value` (liczba strzałów)
- Znajdź `type === 'Total Shots'` → `value` (liczba strzałów)
- Znajdź `type === 'Attacks'` → `value` (liczba ataków)
- Znajdź `type === 'Dangerous Attacks'` → `value` (liczba ataków niebezpiecznych)

---

## 🌐 API-FOOTBALL (api-sports.io) - SZCZEGÓŁY

### Klucz dostępu
```
Klucz: fb9b429fc619754e0ce3ad2a9e5be39b
Base URL: https://v3.football.api-sports.io
Header: x-apisports-key: {klucz}
```

### Endpointy do użycia

1. **Pobierz mecze na dzień**
   ```
   GET https://v3.football.api-sports.io/fixtures?date=2025-10-30&timezone=Europe/Warsaw
   Headers: x-apisports-key: fb9b429fc619754e0ce3ad2a9e5be39b
   ```

2. **Pobierz historię drużyny**
   ```
   GET https://v3.football.api-sports.io/fixtures?team={teamId}&last=10
   Headers: x-apisports-key: fb9b429fc619754e0ce3ad2a9e5be39b
   ```

3. **Pobierz statystyki meczu**
   ```
   GET https://v3.football.api-sports.io/fixtures/statistics?fixture={fixtureId}
   Headers: x-apisports-key: fb9b429fc619754e0ce3ad2a9e5be39b
   ```

### Limity
- **100 zapytań/dzień** (free plan)
- Reset o północy UTC
- HTTP 429 gdy limit osiągnięty
- Sprawdź limit przed każdym zapytaniem: `response.headers['x-ratelimit-requests-limit']`

### Brak potrzeby PROXY
- API-Football obsługuje CORS
- Nie wymaga proxy proxy
- Można używać bezpośrednio `fetch()`

---

## 📐 STRUKTURA STRONY (TYLKO API-FOOTBALL)

### 1. NAGŁÓWEK
- Tytuł: "Corners Predictor - API-Football"
- Wersja aplikacji (z version.json)
- Subtitle: "API-Football only"

### 2. PRZYCISKI AKCJI
- **POBIERZ MECZE NA DZIŚ** - tylko API-Football
- Pokazanie limitu zapytań (X/100)

### 3. INFORMACJE O STATUSIE
- Status ładowania
- Informacja o limicie zapytań
- Błędy (HTTP 429, etc.)

### 4. TABELA WYNIKÓW
Kolumny:
- **Mecz** (home vs away)
- **Liga**
- **Średnia %** (prawdopodobieństwo over 9.5)
- **Status** (Oczekuje/LIVE/OVER/UNDER)
- **Analiza** (szczegóły statystyk drużyn)

### 5. STATYSTYKI
- Hit Rate (% trafień)
- ROI (zwrot z inwestycji przy kursie 1.85)
- Wykres (Chart.js) - trafienia vs pudła

---

## 📝 PLAN IMPLEMENTACJI (TYLKO API-FOOTBALL)

### ETAP 1: Podstawowa struktura HTML/CSS ✅
- [ ] Szablon HTML z nagłówkiem, przyciskiem, tabelą
- [ ] Stylowanie (ciemny motyw, responsywność)
- [ ] Podstawowe elementy UI

### ETAP 2: Konfiguracja API-Football ✅
- [ ] Zmienna z kluczem API
- [ ] Funkcja do sprawdzania limitu zapytań
- [ ] Obsługa błędów HTTP (403, 404, 429)
- [ ] **NIE UŻYWAĆ PROXY** (API-Football obsługuje CORS)

### ETAP 3: Pobieranie meczów na dzień ✅
- [ ] Funkcja `getMatchesForToday()` - pobiera mecze z API-Football
- [ ] Parsowanie odpowiedzi JSON (`response[]`)
- [ ] Wyświetlanie listy meczów w tabeli
- [ ] Obsługa błędów i limitów

### ETAP 4: Analiza drużyn ✅
- [ ] Funkcja `getTeamHistory(teamId, limit)` - pobiera ostatnie mecze
- [ ] Funkcja `getMatchStatistics(fixtureId)` - pobiera statystyki meczu
- [ ] Parsowanie statystyk (corners, possession, shots)
- [ ] Obliczanie średnich i wskaźników

### ETAP 5: Obliczanie prawdopodobieństwa ✅
- [ ] Funkcja `calculateProbability(homeTeamId, awayTeamId)` 
- [ ] Analiza ostatnich 10 meczów każdej drużyny
- [ ] Zliczenie meczów z over 9.5 rożnych
- [ ] Obliczenie procentu prawdopodobieństwa

### ETAP 6: Wyświetlanie wyników ✅
- [ ] Formatowanie tabeli
- [ ] Wyświetlanie analizy drużyn (ostatnie 5 meczów, średnie, posiadanie)
- [ ] Filtrowanie meczów (≥ 55% prawdopodobieństwa)
- [ ] Statystyki (Hit Rate, ROI)

### ETAP 7: Weryfikacja wyników ✅
- [ ] Automatyczne sprawdzanie statusu meczu
- [ ] Pobieranie rzeczywistych rożnych po zakończeniu
- [ ] Oznaczenie jako TRAFIENIE/PUDŁO
- [ ] Aktualizacja statystyk

---

## 🔑 KLUCZE DOSTĘPU (POZOSTAŁE API - NIE DOTYKAĆ)

### Sportmonks API (NIE UŻYWAĆ NA START)
```
Klucz: zWSF4VIJJHhBOw4xizgqFPS795qiOdxes0y9B1AhqeBeAKBLrKx8283Ivsks
Base URL: https://api.sportmonks.com/v3/football
Parametr: api_token={klucz}
```

### FootyStats API (NIE UŻYWAĆ NA START)
```
Klucz: 8cdad7757b702fae3b792c0b3328017ee33cc17594b18ea8a2717cdc53162325
Base URL: https://api.football-data-api.com
Parametr: key={klucz}
```

---

## 📄 PLIKI POTRZEBNE

- `index.html` - główny plik aplikacji (TYLKO API-Football)
- `version.json` - wersja aplikacji i data aktualizacji
- `PLAN.md` - ten dokument

---

## 🚀 STRATEGIA IMPLEMENTACJI

1. **Faza 1:** Stwórz działającą stronę TYLKO z API-Football
2. **Faza 2:** Przetestuj czy działa poprawnie
3. **Faza 3:** Jeśli działa dobrze → zostań przy API-Football
4. **Faza 4:** Jeśli nie działa → rozważ inne API (osobne strony)

---

**Data utworzenia planu:** 2025-10-30
**Status:** PLAN GOTOWY - ZACZYNAMY OD API-FOOTBALL TYLKO
**Checklista:** OBOWIĄZKOWA PRZED KAŻDĄ POPRAWKĄ
