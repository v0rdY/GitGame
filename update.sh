#!/bin/bash

# Цветовые коды
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${PURPLE}🔄 Обновление конфигурации игр...${RESET}"

# Функция для определения ОС
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

OS_TYPE=$(detect_os)
GAMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}🔍 Обнаружена система: $OS_TYPE${RESET}"
echo -e "${CYAN}📁 Директория с играми: $GAMES_DIR${RESET}"

# Обновляем права доступа
echo -e "${PURPLE}⚙️  Обновляю права доступа...${RESET}"
chmod +x *.sh

# Запускаем setup.sh для пересоздания games.sh
if [[ -f "./setup.sh" ]]; then
    echo -e "${PURPLE}📝 Пересоздаю games.sh для $OS_TYPE...${RESET}"
    ./setup.sh
else
    echo -e "${PURPLE}❌ setup.sh не найден, создаю базовую конфигурацию...${RESET}"
    # Создаем базовый games.sh если setup.sh отсутствует
    cat > "$GAMES_DIR/games.sh" << 'EOF'
#!/bin/bash
echo "⚠️  Запустите setup.sh для настройки игр"
echo "📁 Текущая директория: $(pwd)"
echo "🎮 Доступные игры:"
ls *.sh 2>/dev/null | grep -v "games.sh" | grep -v "setup.sh" | grep -v "update.sh" || echo "   Игры не найдены"
EOF
    chmod +x "$GAMES_DIR/games.sh"
fi

# Обновляем алиас
echo -e "${PURPLE}🔧 Обновляю алиас games...${RESET}"

# Определяем shell и конфиг файл
detect_shell_config() {
    if [[ -n "$BASH_VERSION" ]]; then
        if [[ "$OS_TYPE" == "windows" ]]; then
            echo "$HOME/.bashrc"
        else
            echo "$HOME/.bashrc"
        fi
    elif [[ -n "$ZSH_VERSION" ]]; then
        echo "$HOME/.zshrc"
    else
        echo "$HOME/.bashrc"
    fi
}

SHELL_CONFIG=$(detect_shell_config)

# Создаем алиас с учетом ОС
if [[ "$OS_TYPE" == "windows" ]]; then
    ALIAS_CMD="alias games='cd \"$GAMES_DIR\" && bash games.sh'"
    echo -e "${CYAN}🪟 Создаю алиас для Windows Git Bash${RESET}"
else
    ALIAS_CMD="alias games='cd \"$GAMES_DIR\" && bash games.sh'"
    echo -e "${CYAN}💻 Создаю алиас для $OS_TYPE${RESET}"
fi

echo -e "${CYAN}📍 Путь к играм: $GAMES_DIR${RESET}"

# Проверяем существует ли конфиг файл
if [[ ! -f "$SHELL_CONFIG" ]]; then
    echo -e "${PURPLE}📝 Создаю новый файл конфигурации: $SHELL_CONFIG${RESET}"
    touch "$SHELL_CONFIG"
fi

# Удаляем старый алиас games если есть
if grep -q "alias games=" "$SHELL_CONFIG"; then
    echo -e "${PURPLE}🔄 Обновляю существующий алиас...${RESET}"
    # Создаем backup и удаляем старый алиас
    sed -i.bak '/alias games=/d' "$SHELL_CONFIG" 2>/dev/null
else
    echo -e "${PURPLE}➕ Добавляю новый алиас...${RESET}"
fi

# Добавляем новый алиас
echo "$ALIAS_CMD" >> "$SHELL_CONFIG"

echo ""
echo -e "${PURPLE}✅ Конфигурация успешно обновлена!${RESET}"
echo ""
echo -e "${CYAN}🎮 Команда 'games' теперь запускает игры из:${RESET}"
echo -e "${CYAN}   $GAMES_DIR${RESET}"
echo ""
echo -e "${CYAN}💻 Система: $OS_TYPE${RESET}"
echo -e "${CYAN}📝 Конфиг: $SHELL_CONFIG${RESET}"
echo ""
echo -e "${PURPLE}🔁 Чтобы изменения вступили в силу, выполни:${RESET}"
echo -e "${PURPLE}   source $SHELL_CONFIG${RESET}"
echo -e "${PURPLE}   или перезапусти терминал${RESET}"
echo ""
echo -e "${PURPLE}🚀 Запустить игры:${RESET}"
echo -e "${PURPLE}   games${RESET}"
echo ""
echo -e "${PURPLE}📋 Проверить алиас:${RESET}"
echo -e "${PURPLE}   type games${RESET}"
