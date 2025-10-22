#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
    clear
    echo -e "\033[1;35m"
    echo "   ╔══════════════════════════╗"
    echo "   ║        🎮 КОСТИ         ║"
    echo "   ║       💜 ФИОЛЕТОВЫЕ     ║"
    echo "   ╚══════════════════════════╝"
    echo -e "\033[0m"
    
    # Запускаем саму игру
    bash "$SCRIPT_DIR/dice.sh"
    
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
        break
    fi
done

echo ""
echo -e "\033[1;36m💜 Окно можно закрыть 💜\033[0m"
read -p "Нажми Enter чтобы выйти..."
EOF
