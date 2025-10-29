#!/bin/bash

# Prostszy skrypt do zwiększania wersji

# Odczytaj wersję
CURRENT_VERSION=$(grep '"version"' version.json | awk -F'"' '{print $4}')

echo "📌 Aktualna wersja: $CURRENT_VERSION"

# Sprawdź czy wersja jest poprawna
if [ -z "$CURRENT_VERSION" ] || [ "$CURRENT_VERSION" = "null" ]; then
    echo "❌ Błąd: Nie można odczytać wersji. Ustawiam domyślnie 1.01"
    CURRENT_VERSION="1.01"
fi

# Podziel na major.minor
IFS='.' read -r MAJOR MINOR <<< "$CURRENT_VERSION"

# Jeśli któraś część jest pusta, użyj domyślnej
if [ -z "$MAJOR" ]; then
    MAJOR=1
fi

if [ -z "$MINOR" ]; then
    MINOR=0
fi

# Usuń zera wiodące
MAJOR=$((10#$MAJOR))
MINOR=$((10#$MINOR))

# Zwiększ minor
MINOR=$((MINOR + 1))

# Jeśli minor > 99, zwiększ major
if [ $MINOR -gt 99 ]; then
    MAJOR=$((MAJOR + 1))
    MINOR=1
fi

# Sformatuj nową wersję
NEW_VERSION=$(printf "%d.%02d" $MAJOR $MINOR)

# Data
CURRENT_DATE=$(date +%Y-%m-%d)

# Zapisz
cat > version.json << EOF
{
  "version": "$NEW_VERSION",
  "updated": "$CURRENT_DATE"
}
EOF

echo "✅ Wersja zwiększona: $CURRENT_VERSION -> $NEW_VERSION"

# Dodaj do git
git add version.json

exit 0
