#!/bin/bash

echo "🎮 Установка коллекции игр..."
echo "💜 Делаю все скрипты исполняемыми..."

# Даем права на выполнение всем .sh файлам
chmod +x *.sh

echo ""
echo "📝 Создаю алиас 'games' для быстрого запуска..."

# Функция для определения конфиг файла
detect_shell_config() {
    if [[ -n "$BASH_VERSION" ]]; then
        echo "$HOME/.bashrc"
    elif [[ -n "$ZSH_VERSION" ]]; then
        echo "$HOME/.zshrc"
    else
        echo "$HOME/.bashrc"
    fi
}

SHELL_CONFIG=$(detect_shell_config)

# Получаем абсолютный путь к папке с играми
GAMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Создаем команду games
GAMES_ALIAS="alias games='cd \"$GAMES_DIR\" && bash games.sh'"

echo "📍 Путь к играм: $GAMES_DIR"

# Проверяем нет ли уже такого алиаса
if grep -q "alias games=" "$SHELL_CONFIG" 2>/dev/null; then
    echo "⚠️  Алиас 'games' уже существует, обновляю..."
    # Удаляем старый алиас
    sed -i.bak '/alias games=/d' "$SHELL_CONFIG"
fi

# Добавляем алиас в конфиг
echo "$GAMES_ALIAS" >> "$SHELL_CONFIG"

echo ""
echo "✅ Установка завершена!"
echo ""
echo "🚀 Теперь можно запускать игры командами:"
echo ""
echo "   games          - Главное меню (новый алиас!)"
echo "   bash games.sh  - Главное меню"
echo ""
echo "🎯 Или отдельные игры:"
echo "   bash snake.sh    - Змейка"
echo "   bash pacman.sh   - Пакман" 
echo "   bash hangman.sh  - Виселица"
echo "   bash dice.sh     - Кости"
echo "   bash maze.sh     - Лабиринт"
echo "   bash purple_tictactoe.sh - Крестики-нолики"
echo ""
echo "🔄 Если переместили папку с играми, выполните:"
echo "   bash update.sh   - Обновит алиас"
echo ""
echo "🔁 Чтобы алиас заработал, выполни одну из команд:"
echo "   source $SHELL_CONFIG"
echo "   или перезапусти терминал"
echo ""
echo "📖 Подробности в README.md"
EOF
