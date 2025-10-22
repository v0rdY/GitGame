#!/bin/bash

# Крестики-нолики в Git Bash

draw_board() {
    echo ""
    echo "    ${board[0]} | ${board[1]} | ${board[2]}"
    echo "   -----------"
    echo "    ${board[3]} | ${board[4]} | ${board[5]}"
    echo "   -----------"
    echo "    ${board[6]} | ${board[7]} | ${board[8]}"
    echo ""
}

check_winner() {
    # Горизонтальные линии
    for i in 0 3 6; do
        if [[ ${board[$i]} != " " && ${board[$i]} == ${board[$((i+1))]} && ${board[$i]} == ${board[$((i+2))]} ]]; then
            return 0
        fi
    done
    
    # Вертикальные линии
    for i in 0 1 2; do
        if [[ ${board[$i]} != " " && ${board[$i]} == ${board[$((i+3))]} && ${board[$i]} == ${board[$((i+6))]} ]]; then
            return 0
        fi
    done
    
    # Диагонали
    if [[ ${board[0]} != " " && ${board[0]} == ${board[4]} && ${board[0]} == ${board[8]} ]]; then
        return 0
    fi
    if [[ ${board[2]} != " " && ${board[2]} == ${board[4]} && ${board[2]} == ${board[6]} ]]; then
        return 0
    fi
    
    return 1
}

is_board_full() {
    for cell in "${board[@]}"; do
        if [[ $cell == " " ]]; then
            return 1
        fi
    done
    return 0
}

computer_move() {
    local available_moves=()
    
    # Собираем доступные ходы
    for i in "${!board[@]}"; do
        if [[ ${board[$i]} == " " ]]; then
            available_moves+=($i)
        fi
    done
    
    # Случайный ход
    local random_index=$((RANDOM % ${#available_moves[@]}))
    board[${available_moves[$random_index]}]="⭕"
}

# Главная функция игры
play_game() {
    echo -e "\033[1;35m"
    echo "   🎮 Крестики-нолики 🎮"
    echo "   ===================="
    echo -e "\033[0m"
    echo "Ты играешь: ❌"
    echo "Компьютер:  ⭕"
    echo ""
    echo "Выбери клетку (1-9):"
    echo ""
    echo "    1 | 2 | 3"
    echo "   -----------"
    echo "    4 | 5 | 6"
    echo "   -----------"
    echo "    7 | 8 | 9"
    echo ""

    # Инициализация доски
    board=(" " " " " " " " " " " " " " " " " ")
    current_player="❌"
    
    while true; do
        draw_board
        
        if [[ $current_player == "❌" ]]; then
            # Ход игрока
            while true; do
                read -p "Твой ход (1-9 или 'q' для выхода): " input
                
                if [[ $input == "q" ]]; then
                    echo "Выход из игры..."
                    return
                fi
                
                if ! [[ $input =~ ^[1-9]$ ]]; then
                    echo "Введи число от 1 до 9!"
                    continue
                fi
                
                local index=$((input-1))
                
                if [[ ${board[$index]} != " " ]]; then
                    echo "Эта клетка уже занята!"
                    continue
                fi
                
                board[$index]="❌"
                break
            done
        else
            # Ход компьютера
            echo "Компьютер думает..."
            sleep 1
            computer_move
        fi
        
        # Проверка победы
        if check_winner; then
            draw_board
            if [[ $current_player == "❌" ]]; then
                echo -e "\033[1;32m🎉 Ты победил! Поздравляю! 🎉\033[0m"
            else
                echo -e "\033[1;31m🤖 Компьютер победил! Попробуй ещё! 🤖\033[0m"
            fi
            break
        fi
        
        # Проверка ничьи
        if is_board_full; then
            draw_board
            echo -e "\033[1;33m🤝 Ничья! Хорошая игра! 🤝\033[0m"
            break
        fi
        
        # Смена игрока
        if [[ $current_player == "❌" ]]; then
            current_player="⭕"
        else
            current_player="❌"
        fi
    done
    
    # Предложение сыграть ещё
    echo ""
    read -p "Хочешь сыграть ещё? (y/n): " play_again
    if [[ $play_again == "y" || $play_again == "Y" ]]; then
        play_game
    else
        echo -e "\033[1;35mСпасибо за игру! 💜\033[0m"
    fi
}

# Запуск игры
play_game
