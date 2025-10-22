#!/bin/bash

# Фиолетовые крестики-нолики для двух игроков с цифрами в клетках

# Фиолетовые цвета
PURPLE_DARK="\033[38;5;54m"
PURPLE_MEDIUM="\033[38;5;93m"
PURPLE_LIGHT="\033[38;5;129m"
PURPLE_NEON="\033[38;5;165m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Символы игроков
PLAYER1="❌"
PLAYER2="⭕"

# Функция для отображения клетки (цифра или символ игрока)
get_cell_display() {
    local index=$1
    local cell=$2
    if [[ $cell == " " ]]; then
        echo -e "${PURPLE_LIGHT}$((index+1))${RESET}"
    else
        echo -e "$cell"
    fi
}

draw_board() {
    echo ""
    echo -e "${PURPLE_LIGHT}    $(get_cell_display 0 "${board[0]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 1 "${board[1]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 2 "${board[2]}")${RESET}"
    echo -e "${PURPLE_DARK}   -----------${RESET}"
    echo -e "${PURPLE_LIGHT}    $(get_cell_display 3 "${board[3]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 4 "${board[4]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 5 "${board[5]}")${RESET}"
    echo -e "${PURPLE_DARK}   -----------${RESET}"
    echo -e "${PURPLE_LIGHT}    $(get_cell_display 6 "${board[6]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 7 "${board[7]}") ${PURPLE_DARK}|${PURPLE_LIGHT} $(get_cell_display 8 "${board[8]}")${RESET}"
    echo ""
}

check_winner() {
    local symbol=$1
    
    # Горизонтальные линии
    for i in 0 3 6; do
        if [[ ${board[$i]} == $symbol && ${board[$i]} == ${board[$((i+1))]} && ${board[$i]} == ${board[$((i+2))]} ]]; then
            return 0
        fi
    done
    
    # Вертикальные линии
    for i in 0 1 2; do
        if [[ ${board[$i]} == $symbol && ${board[$i]} == ${board[$((i+3))]} && ${board[$i]} == ${board[$((i+6))]} ]]; then
            return 0
        fi
    done
    
    # Диагонали
    if [[ ${board[0]} == $symbol && ${board[0]} == ${board[4]} && ${board[0]} == ${board[8]} ]]; then
        return 0
    fi
    if [[ ${board[2]} == $symbol && ${board[2]} == ${board[4]} && ${board[2]} == ${board[6]} ]]; then
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
    board[${available_moves[$random_index]}]="$PLAYER2"
}

get_player_color() {
    local player=$1
    if [[ $player == "$PLAYER1" ]]; then
        echo -e "${CYAN}"
    else
        echo -e "${PURPLE_NEON}"
    fi
}

# Игра против компьютера
play_vs_computer() {
    echo -e "${PURPLE_MEDIUM}Ты играешь: ${CYAN}$PLAYER1${RESET}"
    echo -e "${PURPLE_MEDIUM}Компьютер:  ${PURPLE_NEON}$PLAYER2${RESET}"
    echo -e "${YELLOW}Подсказка: в пустых клетках отображаются их номера${RESET}"
    
    board=(" " " " " " " " " " " " " " " " " ")
    current_player="$PLAYER1"
    
    while true; do
        draw_board
        
        if [[ $current_player == "$PLAYER1" ]]; then
            # Ход игрока
            while true; do
                echo -e "$(get_player_color $current_player)Ход игрока $current_player$RESET"
                read -p "Выбери клетку (1-9, 'q' - выход): " input
                
                case $input in
                    q|Q)
                        echo -e "${PURPLE_MEDIUM}Выход из игры...${RESET}"
                        return
                        ;;
                esac
                
                if ! [[ $input =~ ^[1-9]$ ]]; then
                    echo -e "${RED}Введи число от 1 до 9!${RESET}"
                    continue
                fi
                
                local index=$((input-1))
                
                if [[ ${board[$index]} != " " ]]; then
                    echo -e "${YELLOW}Эта клетка уже занята!${RESET}"
                    continue
                fi
                
                board[$index]="$PLAYER1"
                break
            done
        else
            # Ход компьютера
            echo -e "${PURPLE_NEON}Компьютер думает...${RESET}"
            sleep 1
            computer_move
        fi
        
        # Проверка победы
        if check_winner "$current_player"; then
            draw_board
            if [[ $current_player == "$PLAYER1" ]]; then
                echo -e "${GREEN}🎉 Ты победил! Поздравляю! 🎉${RESET}"
            else
                echo -e "${RED}🤖 Компьютер победил! Попробуй ещё! 🤖${RESET}"
            fi
            break
        fi
        
        # Проверка ничьи
        if is_board_full; then
            draw_board
            echo -e "${YELLOW}🤝 Ничья! Хорошая игра! 🤝${RESET}"
            break
        fi
        
        # Смена игрока
        if [[ $current_player == "$PLAYER1" ]]; then
            current_player="$PLAYER2"
        else
            current_player="$PLAYER1"
        fi
    done
}

# Игра для двух игроков
play_two_players() {
    echo -e "${PURPLE_MEDIUM}Игрок 1: ${CYAN}$PLAYER1${RESET}"
    echo -e "${PURPLE_MEDIUM}Игрок 2: ${PURPLE_NEON}$PLAYER2${RESET}"
    echo -e "${YELLOW}Подсказка: в пустых клетках отображаются их номера${RESET}"
    
    board=(" " " " " " " " " " " " " " " " " ")
    current_player="$PLAYER1"
    
    while true; do
        draw_board
        
        # Ход текущего игрока
        while true; do
            echo -e "$(get_player_color $current_player)Ход игрока $current_player$RESET"
            read -p "Выбери клетку (1-9, 'q' - выход): " input
            
            case $input in
                q|Q)
                    echo -e "${PURPLE_MEDIUM}Выход из игры...${RESET}"
                    return
                    ;;
            esac
            
            if ! [[ $input =~ ^[1-9]$ ]]; then
                echo -e "${RED}Введи число от 1 до 9!${RESET}"
                continue
            fi
            
            local index=$((input-1))
            
            if [[ ${board[$index]} != " " ]]; then
                echo -e "${YELLOW}Эта клетка уже занята!${RESET}"
                continue
            fi
            
            board[$index]="$current_player"
            break
        done
        
        # Проверка победы
        if check_winner "$current_player"; then
            draw_board
            echo -e "$(get_player_color $current_player)🎉 Игрок $current_player победил! Поздравляю! 🎉${RESET}"
            break
        fi
        
        # Проверка ничьи
        if is_board_full; then
            draw_board
            echo -e "${YELLOW}🤝 Ничья! Хорошая игра! 🤝${RESET}"
            break
        fi
        
        # Смена игрока
        if [[ $current_player == "$PLAYER1" ]]; then
            current_player="$PLAYER2"
        else
            current_player="$PLAYER1"
        fi
    done
}

# Функция выбора режима игры
choose_game_mode() {
    echo -e "${PURPLE_DARK}"
    echo "   ╔══════════════════════════╗"
    echo "   ║     🎮 КРЕСТИКИ-НОЛИКИ  ║"
    echo "   ║        💜 ФИОЛЕТОВЫЕ    ║"
    echo "   ╚══════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${PURPLE_MEDIUM}Выбери режим игры:${RESET}"
    echo -e "  ${CYAN}1${RESET} - Игра против компьютера"
    echo -e "  ${PURPLE_NEON}2${RESET} - Два игрока"
    echo -e "  ${RED}3${RESET} - Выход из игры"
    echo ""
    
    while true; do
        read -p "Твой выбор (1-3): " choice
        
        case $choice in
            1)
                play_vs_computer
                break
                ;;
            2)
                play_two_players
                break
                ;;
            3)
                echo -e "${PURPLE_MEDIUM}Выход из игры... 💜${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Неверный выбор! Введи 1, 2 или 3.${RESET}"
                ;;
        esac
    done
}

# Запуск игры
choose_game_mode
