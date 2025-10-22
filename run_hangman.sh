#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
    clear
    echo -e "\033[1;35m"
    echo "   ╔══════════════════════════╗"
    echo "   ║      🎮 ВИСЕЛИЦА        ║"
    echo "   ║       💜 ФИОЛЕТОВЫЕ     ║"
    echo "   ╚══════════════════════════╝"
    echo -e "\033[0m"
    
    # Запускаем саму игру
    bash "$SCRIPT_DIR/hangman.sh"
    
    echo ""
    echo "════════════════════════════════"
    read -p "Хочешь сыграть ещё раз? (y/n): " play_again
    
    if [[ $play_again != "y" && $play_again != "Y" ]]; then
        echo -e "\033[1;35m"
        echo "   ╔══════════════════════════╗"
        echo "   ║     СПАСИБО ЗА ИГРУ!    ║"
        echo "   ║         💜 💜 💜        ║"
        echo "   ╚══════════════════════════╝"
        echo -e "\033[0m"
        sleep 1
        exit 0
    fi
done
