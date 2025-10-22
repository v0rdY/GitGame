#!/bin/bash

# Цветовые коды
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${PURPLE}🎮 Настройка коллекции игр...${RESET}"

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

# Делаем все скрипты исполняемыми
echo -e "${PURPLE}⚙️  Настраиваю права доступа...${RESET}"
chmod +x *.sh

# Создаем основную структуру games.sh
echo -e "${PURPLE}📝 Создаю главный менеджер игр...${RESET}"

cat > "$GAMES_DIR/games.sh" << 'EOF'
#!/bin/bash

# Фиолетовые цветовые коды
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
DARK_PURPLE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

# Определяем директорию где находится скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Функция для красивого вывода
print_purple() {
    echo -e "${PURPLE}$1${RESET}"
}

print_light_purple() {
    echo -e "${LIGHT_PURPLE}$1${RESET}"
}

print_banner() {
    clear
    echo -e "${PURPLE}╔═════════════════════════════════════════════╗"
    echo -e "║          🐀 ${BOLD}ИГРЫ BASH${RESET}${PURPLE} ● ${BOLD}ФИОЛЕТОВЫЕ${RESET}${PURPLE}          ║"
    echo -e "║             🔍 ${CYAN}ПРЕМИУМ КОЛЛЕКЦИЯ${RESET}${PURPLE}            ║"  
    echo -e "╚═════════════════════════════════════════════╝${RESET}"
    echo
}
EOF

# Теперь добавляем OS-специфичный код
case "$OS_TYPE" in
    windows)
        echo -e "${PURPLE}🪟 Настраиваю для Windows...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'WINDOWS_EOF'

# Функция для запуска игры в Windows
run_game_windows() {
    local game_file="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне Git Bash...${RESET}"
    
    # Запускаем в новом окне Git Bash
    if command -v mintty &> /dev/null; then
        # Используем mintty для нового окна Git Bash
        mintty -t "$game_name" -h always -e bash -c "cd '$SCRIPT_DIR' && ./'$game_file'; echo 'Нажмите любую клавишу для выхода...'; read -n1" &
    else
        # Альтернативный способ для Git Bash
        start "Bash Game: $game_name" bash -c "cd '$SCRIPT_DIR' && ./'$game_file'; echo 'Нажмите любую клавишу для выхода...'; read -n1"
    fi
}

# Главная функция запуска игры
run_game() {
    local game_file="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$game_file" ]]; then
        echo -e "${PURPLE}❌ Файл игры $game_file не найден!${RESET}"
        return 1
    fi
    
    chmod +x "$SCRIPT_DIR/$game_file" 2>/dev/null
    run_game_windows "$game_file" "$game_name"
}
WINDOWS_EOF
        ;;

    linux)
        echo -e "${PURPLE}🐧 Настраиваю для Linux...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'LINUX_EOF'

# Функция для запуска игры в Linux
run_game_linux() {
    local game_file="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне терминала...${RESET}"
    
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="$game_name" -- bash -c "cd '$SCRIPT_DIR' && ./'$game_file'; exec bash"
    elif command -v konsole &> /dev/null; then
        konsole --title "$game_name" -e bash -c "cd '$SCRIPT_DIR' && ./'$game_file'; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -title "$game_name" -e bash -c "cd '$SCRIPT_DIR' && ./'$game_file'; exec bash"
    else
        echo -e "${PURPLE}📱 Запускаем в текущем окне...${RESET}"
        cd "$SCRIPT_DIR" && ./"$game_file"
    fi
}

# Главная функция запуска игры
run_game() {
    local game_file="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$game_file" ]]; then
        echo -e "${PURPLE}❌ Файл игры $game_file не найден!${RESET}"
        return 1
    fi
    
    chmod +x "$SCRIPT_DIR/$game_file" 2>/dev/null
    run_game_linux "$game_file" "$game_name"
}
LINUX_EOF
        ;;

    macos)
        echo -e "${PURPLE}🍎 Настраиваю для macOS...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'MACOS_EOF'

# Функция для запуска игры в macOS
run_game_macos() {
    local game_file="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне Terminal...${RESET}"
    
    if command -v osascript &> /dev/null; then
        osascript <<EOF
tell application "Terminal"
    do script "cd '$SCRIPT_DIR' && ./'$game_file'"
    activate
end tell
EOF
    else
        echo -e "${PURPLE}📱 Запускаем в текущем окне...${RESET}"
        cd "$SCRIPT_DIR" && ./"$game_file"
    fi
}

# Главная функция запуска игры
run_game() {
    local game_file="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$game_file" ]]; then
        echo -e "${PURPLE}❌ Файл игры $game_file не найден!${RESET}"
        return 1
    fi
    
    chmod +x "$SCRIPT_DIR/$game_file" 2>/dev/null
    run_game_macos "$game_file" "$game_name"
}
MACOS_EOF
        ;;

    *)
        echo -e "${PURPLE}❓ Неизвестная ОС, использую универсальный метод...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'UNKNOWN_EOF'

# Универсальная функция запуска игры
run_game() {
    local game_file="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$game_file" ]]; then
        echo -e "${PURPLE}❌ Файл игры $game_file не найден!${RESET}"
        return 1
    fi
    
    echo -e "${CYAN}🐀 Запускаем в текущем окне терминала...${RESET}"
    chmod +x "$SCRIPT_DIR/$game_file" 2>/dev/null
    cd "$SCRIPT_DIR" && ./"$game_file"
}
UNKNOWN_EOF
        ;;
esac

# Добавляем общую часть которая одинакова для всех ОС
cat >> "$GAMES_DIR/games.sh" << 'COMMON_EOF'

# Анимация загрузки
show_loading() {
    echo -ne "${PURPLE}⏳ Загрузка игры...${RESET}"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    for i in {1..2}; do
        for frame in "${frames[@]}"; do
            echo -ne "${PURPLE}\r${frame} Загрузка игры...${RESET}"
            sleep 0.1
        done
    done
    echo -e "\r✅ Готово!          "
}

# Главное меню
while true; do
    print_banner
    
    echo -e "${LIGHT_PURPLE}🎯 Выбери игру:${RESET}"
    echo
    echo -e "  ${PURPLE}1${RESET} – ${CYAN}Змейка${RESET} ${PURPLE}🐍${RESET}"
    echo -e "  ${PURPLE}2${RESET} – ${CYAN}Виселица${RESET} ${PURPLE}🎭${RESET}" 
    echo -e "  ${PURPLE}3${RESET} – ${CYAN}Кости${RESET} ${PURPLE}🎲${RESET}"
    echo -e "  ${PURPLE}4${RESET} – ${CYAN}Лабиринт${RESET} ${PURPLE}🏰${RESET}"
    echo -e "  ${PURPLE}5${RESET} – ${CYAN}Крестики-нолики${RESET} ${PURPLE}❌⭕${RESET}"
    echo -e "  ${PURPLE}6${RESET} – ${CYAN}Пакман${RESET} ${PURPLE}👻${RESET}"
    echo -e "  ${PURPLE}7${RESET} – ${CYAN}Выход${RESET} ${PURPLE}🚪${RESET}"
    echo
    echo -e "${DARK_PURPLE}═════════════════════════════════════════${RESET}"
    echo -ne "${BOLD}${LIGHT_PURPLE}🎮 Твой выбор (1–7): ${RESET}"
    read choice

    case $choice in
        1)
            show_loading
            run_game "snake.sh" "Змейка" "🐍"
            ;;
        2)
            show_loading
            run_game "hangman.sh" "Виселица" "🎭"
            ;;
        3)
            show_loading
            run_game "dice.sh" "Кости" "🎲"
            ;;
        4)
            show_loading
            run_game "maze.sh" "Лабиринт" "🏰"
            ;;
        5)
            show_loading
            run_game "tictactoe.sh" "Крестики-нолики" "❌⭕"
            ;;
        6)
            show_loading
            run_game "pacman.sh" "Пакман" "👻"
            ;;
        7)
            echo
            echo -e "${LIGHT_PURPLE}👋 До встречи! Спасибо за игру! 🎮${RESET}"
            echo -e "${PURPLE}✨ ФИОЛЕТОВЫЕ ИГРЫ BASH ✨${RESET}"
            sleep 1
            exit 0
            ;;
        *)
            echo
            echo -e "${PURPLE}❌ Неверный выбор! Попробуй снова.${RESET}"
            sleep 2
            ;;
    esac
    
    echo
    echo -e "${DARK_PURPLE}═════════════════════════════════════════${RESET}"
    echo -ne "${PURPLE}Нажми Enter чтобы продолжить...${RESET}"
    read -r
done
COMMON_EOF

# Делаем games.sh исполняемым
chmod +x "$GAMES_DIR/games.sh"

echo -e "${PURPLE}✅ Настройка завершена!${RESET}"
echo -e "${CYAN}🚀 Запускайте игры командой: ./games.sh${RESET}"
echo -e "${CYAN}💻 Определенная ОС: $OS_TYPE${RESET}"
