#!/bin/bash
# games.sh

# Получаем путь к директории где находится скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_menu() {
    echo -e "\033[1;35m"
    echo "   ╔══════════════════════╗"
    echo "   ║     🎮 ИГРЫ BASH    ║"
    echo "   ║      💜 ФИОЛЕТОВЫЕ  ║"
    echo "   ╚══════════════════════╝"
    echo -e "\033[0m"
    echo -e "\033[1;36mВыбери игру:\033[0m"
    echo -e "  \033[1;32m1\033[0m - Змейка 🐍"
    echo -e "  \033[1;33m2\033[0m - Виселица 🎯"
    echo -e "  \033[1;34m3\033[0m - Кости 🎲"
    echo -e "  \033[1;35m4\033[0m - Лабиринт 🧩"
    echo -e "  \033[1;31m5\033[0m - Крестики-нолики ❌⭕"
    echo -e "  \033[1;36m6\033[0m - Пакман 👻"
    echo -e "  \033[1;30m7\033[0m - Выход 🚪"
    echo
}

while true; do
    show_menu
    read -p "Твой выбор (1-7): " choice
    
    case $choice in
        1) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_snake.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_snake.sh" || echo "Не удалось открыть новое окно терминала" ;;
        2) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_hangman.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_hangman.sh" || echo "Не удалось открыть новое окно терминала" ;;
        3) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_dice.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_dice.sh" || echo "Не удалось открыть новое окно терминала" ;;
        4) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_maze.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_maze.sh" || echo "Не удалось открыть новое окно терминала" ;;
        5) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_tictactoe.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_tictactoe.sh" || echo "Не удалось открыть новое окно терминала" ;;
        6) gnome-terminal -- bash -c "cd '$SCRIPT_DIR'; bash run_pacman.sh; exec bash" || xterm -e "cd '$SCRIPT_DIR'; bash run_pacman.sh" || echo "Не удалось открыть новое окно терминала" ;;
        7) 
            echo -e "\033[1;35mДо новых игр! 💜\033[0m"
            exit 0
            ;;
        *) 
            echo -e "\033[1;31mНеверный выбор! Попробуй ещё раз.\033[0m"
            sleep 1
            ;;
    esac
    
    echo -e "\033[1;32m🎮 Игра запускается в новом окне терминала...\033[0m"
    sleep 1
done
EOF
