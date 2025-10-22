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
