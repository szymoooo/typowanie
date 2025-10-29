#!/bin/bash

# Skrypt do automatycznego zwiększania wersji

# Odczytaj aktualną wersję
CURRENT_VERSION=$(grep -o '"version": "[^"]*"' version.json | grep -o '[0-9.]*')

# Podziel wersję na główną i pomniejszą (np. 1.01 -> 1 i 01)
MAJOR=$(echo $CURRENT_VERSION | cut -d'.' -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d'.' -f2)

# Zwiększ wersję pomniejszą
MINOR=$((MINOR + 1))

# Jeśli przekroczy 99, zwiększ główną
if [ $MINOR -gt 99 ]; then
    MAJOR=$((MAJOR + 1))
    MINOR=1
fi

# Sformatuj z zerem wiodącym
MINOR_PADDED=$(printf "%02d" $MINOR)
NEW_VERSION="${MAJOR}.${MINOR_PADDED}"

# Aktualna data
CURRENT_DATE=$(date +%Y-%m-%d)

# Zaktualizuj plik version.json
cat > version.json << EOF
{
  "version": "$NEW_VERSION",
  "updated": "$CURRENT_DATE"
}
EOF

echo "✅ Wersja zwiększona: $CURRENT_VERSION -> $NEW_VERSION"

# Dodaj plik do gita
git add version.json

exit 0

