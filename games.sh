#!/bin/bash
# games.sh

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
        1) start bash -c "cd /c/giit/game; ./run_snake.sh" ;;
        2) start bash -c "cd /c/giit/game; ./run_hangman.sh" ;;
        3) start bash -c "cd /c/giit/game; ./run_dice.sh" ;;
        4) start bash -c "cd /c/giit/game; ./run_maze.sh" ;;
        5) start bash -c "cd /c/giit/game; ./run_tictactoe.sh" ;;
        6) start bash -c "cd /c/giit/game; ./run_pacman.sh" ;;
        7) 
            echo -e "\033[1;35mДо новых игр! 💜\033[0m"
            exit 0
            ;;
        *) 
            echo -e "\033[1;31mНеверный выбор! Попробуй ещё раз.\033[0m"
            sleep 1
            ;;
    esac
    
    echo -e "\033[1;32m🎮 Игра запускается в новом окне...\033[0m"
    sleep 1
done
