#!/bin/bash

echo "🔄 Обновление алиаса games..."

# Определяем shell и конфиг файл
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

# Получаем абсолютный путь к текущей папке
GAMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Создаем новый алиас
NEW_ALIAS="alias games='cd \"$GAMES_DIR\" && bash games.sh'"

echo "📍 Новый путь к играм: $GAMES_DIR"

# Проверяем существует ли конфиг файл
if [[ ! -f "$SHELL_CONFIG" ]]; then
    echo "❌ Файл конфигурации $SHELL_CONFIG не найден"
    echo "📝 Создаю новый файл..."
    touch "$SHELL_CONFIG"
fi

# Удаляем старый алиас games если есть
if grep -q "alias games=" "$SHELL_CONFIG"; then
    echo "🔄 Обновляю существующий алиас..."
    # Создаем backup и удаляем старый алиас
    sed -i.bak '/alias games=/d' "$SHELL_CONFIG"
else
    echo "➕ Добавляю новый алиас..."
fi

# Добавляем новый алиас
echo "$NEW_ALIAS" >> "$SHELL_CONFIG"

echo ""
echo "✅ Алиас успешно обновлен!"
echo ""
echo "🎮 Теперь команда 'games' будет запускать игры из:"
echo "   $GAMES_DIR"
echo ""
echo "🔁 Чтобы изменения вступили в силу, выполни:"
echo "   source $SHELL_CONFIG"
echo "   или перезапусти терминал"
echo ""
echo "📝 Проверить алиас можно командой:"
echo "   type games"
echo ""
echo "🚀 Запустить игры:"
echo "   games"
EOF

chmod +x update.sh
