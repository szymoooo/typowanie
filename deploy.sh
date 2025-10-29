#!/bin/bash

# Skrypt do łatwego deploymentu z automatycznym zwiększaniem wersji

echo "🚀 Rozpoczynam deployment..."

# Zwiększ wersję
echo "📌 Zwiększam numer wersji..."
./increment-version.sh

# Pobierz nową wersję
NEW_VERSION=$(grep '"version"' version.json | awk -F'"' '{print $4}')
echo "✨ Nowa wersja: v$NEW_VERSION"

# Dodaj wszystkie zmiany
echo "📦 Dodaję pliki do Git..."
git add .

# Commit
if [ -z "$1" ]; then
    COMMIT_MSG="Deploy v$NEW_VERSION - automatyczna aktualizacja"
else
    COMMIT_MSG="$1 (v$NEW_VERSION)"
fi

echo "💾 Commit: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# Push
echo "🌐 Wysyłam na GitHub..."
git push

echo ""
echo "✅ GOTOWE! Deployment zakończony"
echo "📌 Wersja: v$NEW_VERSION"
echo "🔗 Za chwilę dostępne na: https://mecze-977nsu8l7-szymoooos-projects.vercel.app"
echo ""
