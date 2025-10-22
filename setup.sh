#!/bin/bash

# Цветовые коды
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${PURPLE}🎮 Настройка коллекции игр...${RESET}"

# Функция для определения ОС и проверки Git
detect_environment() {
    case "$(uname -s)" in
        Darwin*)    
            echo "macos"
            if command -v git &> /dev/null; then
                echo "git"
            else
                echo "native"
            fi
            ;;
        Linux*)     
            echo "linux" 
            if command -v git &> /dev/null; then
                echo "git"
            else
                echo "native"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            # Проверяем, запущено ли в Git Bash
            if command -v git &> /dev/null && [[ "$SHELL" == *"bash"* ]]; then
                echo "git"
            else
                echo "native"
            fi
            ;;
        *)          
            echo "unknown"
            echo "native"
            ;;
    esac
}

# Получаем информацию о среде
ENV_INFO=($(detect_environment))
OS_TYPE="${ENV_INFO[0]}"
TERMINAL_TYPE="${ENV_INFO[1]}"

GAMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}🔍 Обнаружена система: $OS_TYPE${RESET}"
echo -e "${CYAN}🔧 Тип терминала: $TERMINAL_TYPE${RESET}"
echo -e "${CYAN}📁 Директория с играми: $GAMES_DIR${RESET}"

# Проверяем наличие bash
if ! command -v bash &> /dev/null; then
    echo -e "${RED}❌ Ошибка: bash не найден!${RESET}"
    echo -e "${PURPLE}💡 Для Windows установите Git Bash или WSL${RESET}"
    exit 1
fi

# Делаем все скрипты исполняемыми
echo -e "${PURPLE}⚙️  Настраиваю права доступа...${RESET}"
chmod +x *.sh 2>/dev/null || echo -e "${CYAN}⚠️  Невозможно изменить права доступа (возможно Windows CMD)${RESET}"

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
        if [[ "$TERMINAL_TYPE" == "git" ]]; then
            echo -e "${GREEN}🪟 Настраиваю для Windows (Git Bash)...${RESET}"
            cat >> "$GAMES_DIR/games.sh" << 'WINDOWS_GIT_EOF'

# Функция для запуска игры в Windows системном терминале
run_game_windows() {
    local run_script="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в системном терминале Windows...${RESET}"
    
    # Запускаем в новом окне Windows Terminal или Command Prompt
    if command -v wt &> /dev/null; then
        # Используем Windows Terminal если доступен
        wt bash -c "cd '$SCRIPT_DIR' && ./'$run_script'"
    else
        # Используем стандартный Command Prompt
        cmd //c start "Bash Game: $game_name" bash -c "cd '$SCRIPT_DIR' && ./'$run_script'"
    fi
}

# Функция для определения ОС и запуска игры
run_game() {
    local run_script="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    # Проверяем существование скрипта игры
    if [[ ! -f "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Скрипт запуска $run_script не найден!${RESET}"
        echo -e "${PURPLE}📁 Убедитесь что файл существует в директории: $SCRIPT_DIR/${RESET}"
        return 1
    fi
    
    # Даем права на выполнение
    chmod +x "$SCRIPT_DIR/$run_script" 2>/dev/null
    
    # Проверяем успешность chmod
    if [[ ! -x "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Не удалось сделать скрипт исполняемым!${RESET}"
        return 1
    fi
    
    # Для Windows используем системный терминал
    run_game_windows "$run_script" "$game_name"
}
WINDOWS_GIT_EOF
        else
            echo -e "${CYAN}🪟 Настраиваю для Windows (нативный терминал)...${RESET}"
            cat >> "$GAMES_DIR/games.sh" << 'WINDOWS_NATIVE_EOF'

# Функция для запуска игры в Windows нативном терминале
run_game_windows_native() {
    local run_script="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне...${RESET}"
    
    # Для нативного Windows терминала используем start
    start "Bash Game: $game_name" bash -c "
        cd '$SCRIPT_DIR' 
        echo 'Запуск $game_name...'
        ./'$run_script'
        echo ''
        echo 'Игра завершена. Окно закроется автоматически через 3 секунды...'
        sleep 3
    "
}

# Функция для определения ОС и запуска игры
run_game() {
    local run_script="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    # Проверяем существование скрипта игры
    if [[ ! -f "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Скрипт запуска $run_script не найден!${RESET}"
        echo -e "${PURPLE}📁 Убедитесь что файл существует в директории: $SCRIPT_DIR/${RESET}"
        return 1
    fi
    
    # Для нативного Windows chmod может не работать, но пробуем
    chmod +x "$SCRIPT_DIR/$run_script" 2>/dev/null
    
    # Для Windows нативного терминала
    run_game_windows_native "$run_script" "$game_name"
}
WINDOWS_NATIVE_EOF
        fi
        ;;

    linux)
        echo -e "${PURPLE}🐧 Настраиваю для Linux...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'LINUX_EOF'

# Функция для запуска игры в Linux
run_game_linux() {
    local run_script="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне терминала...${RESET}"
    
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="$game_name" -- bash -c "cd '$SCRIPT_DIR' && ./'$run_script'; exec bash"
    elif command -v konsole &> /dev/null; then
        konsole --title "$game_name" -e bash -c "cd '$SCRIPT_DIR' && ./'$run_script'; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -title "$game_name" -e bash -c "cd '$SCRIPT_DIR' && ./'$run_script'; exec bash"
    else
        echo -e "${PURPLE}📱 Запускаем в текущем окне...${RESET}"
        cd "$SCRIPT_DIR" && ./"$run_script"
    fi
}

# Главная функция запуска игры
run_game() {
    local run_script="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Файл игры $run_script не найден!${RESET}"
        return 1
    fi
    
    chmod +x "$SCRIPT_DIR/$run_script" 2>/dev/null
    run_game_linux "$run_script" "$game_name"
}
LINUX_EOF
        ;;

    macos)
        echo -e "${PURPLE}🍎 Настраиваю для macOS...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'MACOS_EOF'

# Функция для запуска игры в macOS
run_game_macos() {
    local run_script="$1"
    local game_name="$2"
    
    echo -e "${CYAN}🐀 Запускаем $game_name в новом окне Terminal...${RESET}"
    
    if command -v osascript &> /dev/null; then
        osascript <<EOF
tell application "Terminal"
    do script "cd '$SCRIPT_DIR' && ./'$run_script'"
    activate
end tell
EOF
    else
        echo -e "${PURPLE}📱 Запускаем в текущем окне...${RESET}"
        cd "$SCRIPT_DIR" && ./"$run_script"
    fi
}

# Главная функция запуска игры
run_game() {
    local run_script="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Файл игры $run_script не найден!${RESET}"
        return 1
    fi
    
    chmod +x "$SCRIPT_DIR/$run_script" 2>/dev/null
    run_game_macos "$run_script" "$game_name"
}
MACOS_EOF
        ;;

    *)
        echo -e "${PURPLE}❓ Неизвестная ОС, использую универсальный метод...${RESET}"
        cat >> "$GAMES_DIR/games.sh" << 'UNKNOWN_EOF'

# Универсальная функция запуска игры
run_game() {
    local run_script="$1"
    local game_name="$2"
    local emoji="$3"
    
    echo -e "${LIGHT_PURPLE}🎮 Запускаем $emoji $game_name...${RESET}"
    
    if [[ ! -f "$SCRIPT_DIR/$run_script" ]]; then
        echo -e "${PURPLE}❌ Файл игры $run_script не найден!${RESET}"
        return 1
    fi
    
    echo -e "${CYAN}🐀 Запускаем в текущем окне терминала...${RESET}"
    chmod +x "$SCRIPT_DIR/$run_script" 2>/dev/null
    cd "$SCRIPT_DIR" && ./"$run_script"
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

# Проверяем зависимости
check_dependencies() {
    local deps=("bash" "clear")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${PURPLE}❌ Ошибка: $dep не найден!${RESET}"
            return 1
        fi
    done
    return 0
}

# Главное меню
main_menu() {
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
        read -r choice

        case $choice in
            1)
                show_loading
                run_game "run_snake.sh" "Змейка" "🐍"
                ;;
            2)
                show_loading
                run_game "run_hangman.sh" "Виселица" "🎭"
                ;;
            3)
                show_loading
                run_game "run_dice.sh" "Кости" "🎲"
                ;;
            4)
                show_loading
                run_game "run_maze.sh" "Лабиринт" "🏰"
                ;;
            5)
                show_loading
                run_game "run_tictactoe.sh" "Крестики-нолики" "❌⭕"
                ;;
            6)
                show_loading
                run_game "run_pacman.sh" "Пакман" "👻"
                ;;
            7)
                echo
                echo -e "${LIGHT_PURPLE}👋 До встречи! Спасибо за игру! 🎮${RESET}"
                echo -e "${PURPLE}✨ ФИОЛЕТОВЫЕ ИГРЫ BASH ✨${RESET}"
                sleep 2
                exit 0
                ;;
            *)
                echo
                echo -e "${PURPLE}❌ Неверный выбор! Введите число от 1 до 7.${RESET}"
                sleep 2
                ;;
        esac
        
        echo
        echo -e "${DARK_PURPLE}═════════════════════════════════════════${RESET}"
        echo -ne "${PURPLE}Нажми Enter чтобы продолжить...${RESET}"
        read -r
    done
}

# Основная программа
main() {
    # Проверяем зависимости
    if ! check_dependencies; then
        echo -e "${PURPLE}❌ Необходимые зависимости отсутствуют!${RESET}"
        exit 1
    fi
    
    # Запускаем главное меню
    main_menu
}

# Запускаем основную программу
main
COMMON_EOF

# Делаем games.sh исполняемым
chmod +x "$GAMES_DIR/games.sh" 2>/dev/null || echo -e "${CYAN}⚠️  Невозможно сделать games.sh исполняемым${RESET}"

echo -e "${GREEN}✅ Настройка завершена!${RESET}"
echo -e "${CYAN}🚀 Запускайте игры командой: ./games.sh${RESET}"
echo -e "${CYAN}💻 Операционная система: $OS_TYPE${RESET}"
echo -e "${CYAN}🔧 Тип терминала: $TERMINAL_TYPE${RESET}"

if [[ "$OS_TYPE" == "windows" && "$TERMINAL_TYPE" == "native" ]]; then
    echo -e "${PURPLE}💡 Подсказка: Для лучшего опыта установите Git Bash${RESET}"
    echo -e "${PURPLE}   Скачать: https://git-scm.com/download/win${RESET}"
fi
