#!/bin/bash

# Единый файл со всеми играми BASH
# Запуск: bash all_games.sh

# Цвета для оформления
PURPLE_DARK="\033[38;5;54m"
PURPLE_MEDIUM="\033[38;5;93m"
PURPLE_LIGHT="\033[38;5;129m"
PURPLE_NEON="\033[38;5;165m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

# =============================================================================
# ГЛАВНОЕ МЕНЮ
# =============================================================================

show_main_menu() {
    clear
    echo -e "${PURPLE_DARK}"
    echo "   ╔══════════════════════════╗"
    echo "   ║        🎮 ИГРЫ BASH     ║"
    echo "   ║       💜 ФИОЛЕТОВЫЕ     ║"
    echo "   ╚══════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${PURPLE_MEDIUM}Выбери игру:${RESET}"
    echo -e "  ${CYAN}1${RESET} - Змейка 🐍"
    echo -e "  ${GREEN}2${RESET} - Виселица 🎯"
    echo -e "  ${BLUE}3${RESET} - Кости 🎲"
    echo -e "  ${PURPLE_LIGHT}4${RESET} - Лабиринт 🧩"
    echo -e "  ${PURPLE_NEON}5${RESET} - Крестики-нолики ❌⭕"
    echo -e "  ${RED}6${RESET} - Выход 🚪"
    echo
}

# =============================================================================
# ИГРА 1: ЗМЕЙКА
# =============================================================================

snake_game() {
    local width=20
    local height=15
    local snake_x=10
    local snake_y=7
    local food_x=5
    local food_y=5
    local score=0
    local game_over=0
    local direction=right
    local snake_size=1
    declare -a snake_body=("$snake_x:$snake_y")
    
    # Цвета и символы
    local border_color="\033[1;36m"
    local score_color="\033[1;33m"
    local game_over_color="\033[1;31m"
    local snake_head="🟢"
    local snake_body_char="🟩"
    local food_char="🍎"
    local empty_char="  "
    local border_char="▓▓"

    draw_border() {
        echo -ne "${border_color}"
        for ((i=0; i<width+2; i++)); do
            echo -n "$border_char"
        done
        echo -e "\033[0m"
    }

    draw_game() {
        clear
        echo -e "\033[1;35m🎮 ЗМЕЙКА 🎮\033[0m"
        echo -e "${score_color}Счёт: $score\033[0m"
        echo
        
        draw_border
        
        for ((y=0; y<height; y++)); do
            echo -ne "${border_color}${border_char}\033[0m"
            
            for ((x=0; x<width; x++)); do
                local cell_empty=1
                local is_head=0
                
                if [[ $x -eq $snake_x && $y -eq $snake_y ]]; then
                    echo -n "$snake_head"
                    cell_empty=0
                    is_head=1
                elif [[ $x -eq $food_x && $y -eq $food_y ]]; then
                    echo -n "$food_char"
                    cell_empty=0
                else
                    for ((i=1; i<${#snake_body[@]}; i++)); do
                        IFS=':' read -r seg_x seg_y <<< "${snake_body[i]}"
                        if [[ $x -eq $seg_x && $y -eq $seg_y ]]; then
                            echo -n "$snake_body_char"
                            cell_empty=0
                            if [[ $is_head -eq 1 ]]; then
                                game_over=1
                            fi
                            break
                        fi
                    done
                fi
                
                [[ $cell_empty -eq 1 ]] && echo -n "$empty_char"
            done
            
            echo -ne "${border_color}${border_char}\033[0m"
            echo
        done
        
        draw_border
        echo
        echo -e "\033[1;37mУправление: W,A,S,D - движение, Q - выход\033[0m"
    }

    place_food() {
        local valid_position=0
        while [[ $valid_position -eq 0 ]]; do
            food_x=$((RANDOM % width))
            food_y=$((RANDOM % height))
            valid_position=1
            
            for segment in "${snake_body[@]}"; do
                IFS=':' read -r seg_x seg_y <<< "$segment"
                if [[ $food_x -eq $seg_x && $food_y -eq $seg_y ]]; then
                    valid_position=0
                    break
                fi
            done
        done
    }

    place_food

    while [[ $game_over -eq 0 ]]; do
        draw_game
        
        read -rsn1 -t 0.2 input
        case $input in
            w|W) [[ $direction != "down" ]] && direction=up ;;
            s|S) [[ $direction != "up" ]] && direction=down ;;
            a|A) [[ $direction != "right" ]] && direction=left ;;
            d|D) [[ $direction != "left" ]] && direction=right ;;
            q|Q) game_over=1 ;;
        esac

        local prev_x=$snake_x
        local prev_y=$snake_y

        case $direction in
            up) ((snake_y--)) ;;
            down) ((snake_y++)) ;;
            left) ((snake_x--)) ;;
            right) ((snake_x++)) ;;
        esac

        if [[ $snake_x -lt 0 || $snake_x -ge $width || $snake_y -lt 0 || $snake_y -ge $height ]]; then
            game_over=1
        fi

        for ((i=1; i<${#snake_body[@]}; i++)); do
            IFS=':' read -r seg_x seg_y <<< "${snake_body[i]}"
            if [[ $snake_x -eq $seg_x && $snake_y -eq $seg_y ]]; then
                game_over=1
                break
            fi
        done

        if [[ $snake_x -eq $food_x && $snake_y -eq $food_y ]]; then
            ((score+=5))
            ((snake_size++))
            snake_body=("$snake_x:$snake_y" "${snake_body[@]}")
            place_food
        else
            snake_body=("$snake_x:$snake_y" "${snake_body[@]:0:$(($snake_size-1))}")
        fi
        
        sleep 0.1
    done

    echo -e "${game_over_color}"
    echo "╔══════════════════════════╗"
    echo "║       ИГРА ОКОНЧЕНА!     ║"
    echo "║     Ваш счёт: $score$(printf '%*s' $((7-${#score})) ' ')║"
    echo "╚══════════════════════════╝"
    echo -e "\033[0m"
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# =============================================================================
# ИГРА 2: ВИСЕЛИЦА
# =============================================================================

draw_hangman() {
    local attempts=$1
    case $attempts in
        6) echo "      ┌─────┐"; echo "      │     │"; echo "      │"; echo "      │"; echo "      │"; echo "      │"; echo "┌─────┴─────┐" ;;
        5) echo "      ┌─────┐"; echo "      │     │"; echo "      │     😮"; echo "      │"; echo "      │"; echo "      │"; echo "┌─────┴─────┐" ;;
        4) echo "      ┌─────┐"; echo "      │     │"; echo "      │     😮"; echo "      │     │"; echo "      │"; echo "      │"; echo "┌─────┴─────┐" ;;
        3) echo "      ┌─────┐"; echo "      │     │"; echo "      │     😮"; echo "      │    /│"; echo "      │"; echo "      │"; echo "┌─────┴─────┐" ;;
        2) echo "      ┌─────┐"; echo "      │     │"; echo "      │     😮"; echo "      │    /│\\"; echo "      │"; echo "      │"; echo "┌─────┴─────┐" ;;
        1) echo "      ┌─────┐"; echo "      │     │"; echo "      │     😮"; echo "      │    /│\\"; echo "      │    /"; echo "      │"; echo "┌─────┴─────┐" ;;
        0) echo "      ┌─────┐"; echo "      │     │"; echo "      │     💀"; echo "      │    /│\\"; echo "      │    / \\"; echo "      │"; echo "┌─────┴─────┐" ;;
    esac
}

show_word_progress() {
    local word=$1
    local guessed=($2)
    
    echo -n "Слово: "
    for ((i=0; i<${#word}; i++)); do
        letter=${word:$i:1}
        if [[ " ${guessed[@]} " =~ " $letter " ]]; then
            echo -e -n "\033[1;32m$letter \033[0m"
        else
            echo -n "_ "
        fi
    done
    echo
}

get_random_word() {
    local words=("компьютер" "программа" "алгоритм" "терминал" "скрипт" "баш" 
                 "гит" "консоль" "виселица" "игра" "разработка" "кодирование"
                 "переменная" "функция" "массив" "цикл" "условие" "строка")
    echo "${words[$((RANDOM % ${#words[@]}))]}"
}

hangman_game() {
    local word=$1
    local guessed=()
    local attempts=6
    local correct=0
    local used_letters=()
    
    clear
    echo -e "\033[1;35m🎯 ВИСЕЛИЦА С ЧЕЛОВЕЧКОМ 🎯\033[0m"
    echo "Угадай слово по буквам!"
    echo "У тебя 6 попыток!"
    
    while [[ $attempts -gt 0 && $correct -lt ${#word} ]]; do
        echo
        draw_hangman $attempts
        echo
        
        show_word_progress "$word" "${guessed[*]}"
        
        echo
        echo -e "Осталось попыток: \033[1;33m$attempts\033[0m"
        
        if [[ ${#used_letters[@]} -gt 0 ]]; then
            echo -n "Использованные буквы: "
            for letter in "${used_letters[@]}"; do
                if [[ " ${guessed[@]} " =~ " $letter " ]]; then
                    echo -e -n "\033[1;32m$letter \033[0m"
                else
                    echo -e -n "\033[1;31m$letter \033[0m"
                fi
            done
            echo
        fi
        
        echo
        read -p "Введи букву или 'quit' для выхода: " guess
        
        if [[ "$guess" == "quit" || "$guess" == "exit" ]]; then
            echo -e "\033[1;35mВыход из игры...\033[0m"
            return
        fi
        
        if [[ ${#guess} -ne 1 ]]; then
            echo -e "\033[1;31mВведи только одну букву!\033[0m"
            sleep 1
            continue
        fi
        
        guess=$(echo "$guess" | tr '[:upper:]' '[:lower:]')
        
        if [[ ! "$guess" =~ [а-яa-z] ]]; then
            echo -e "\033[1;31mЭто не буква! Используй только буквы.\033[0m"
            sleep 1
            continue
        fi
        
        if [[ " ${used_letters[@]} " =~ " $guess " ]]; then
            echo -e "\033[1;33mТы уже пробовал эту букву!\033[0m"
            sleep 1
            continue
        fi
        
        used_letters+=("$guess")
        
        if [[ $word == *"$guess"* ]]; then
            echo -e "\033[1;32m✅ Правильно! Буква '$guess' есть в слове!\033[0m"
            guessed+=("$guess")
            local count=0
            for ((i=0; i<${#word}; i++)); do
                if [[ ${word:$i:1} == "$guess" ]]; then
                    ((count++))
                fi
            done
            ((correct += count))
            sleep 1
        else
            echo -e "\033[1;31m❌ Неправильно! Буквы '$guess' нет в слове.\033[0m"
            ((attempts--))
            sleep 1
        fi
    done
    
    echo
    draw_hangman $attempts
    echo
    
    if [[ $correct -eq ${#word} ]]; then
        echo -e "\033[1;32m"
        echo "🎉🎉🎉 ПОЗДРАВЛЯЮ! 🎉🎉🎉"
        echo "Ты угадал слово: $word"
        echo -e "\033[0m"
    else
        echo -e "\033[1;31m"
        echo "💀 ИГРА ОКОНЧЕНА! 💀"
        echo "Загаданное слово: $word"
        echo -e "\033[0m"
    fi
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# =============================================================================
# ИГРА 3: КОСТИ
# =============================================================================

dice_animation() {
    local frames=(
"
┌───────┐
│       │
│   ●   │
│       │
└───────┘
"
"
┌───────┐
│ ●     │
│       │
│     ● │
└───────┘
"
"
┌───────┐
│ ●   ● │
│       │
│ ●   ● │
└───────┘
"
"
┌───────┐
│ ●   ● │
│   ●   │
│ ●   ● │
└───────┘
"
    )
    
    echo -e "\033[1;36mБросаем кости...\033[0m"
    
    for i in {1..8}; do
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo
        frame_index=$(( (i-1) % 4 ))
        echo -e "\033[1;33m${frames[frame_index]}\033[0m"
        sleep 0.2
    done
}

show_dice() {
    local value=$1
    case $value in
        1) echo "┌───────┐"; echo "│       │"; echo "│   ●   │"; echo "│       │"; echo "└───────┘" ;;
        2) echo "┌───────┐"; echo "│ ●     │"; echo "│       │"; echo "│     ● │"; echo "└───────┘" ;;
        3) echo "┌───────┐"; echo "│ ●     │"; echo "│   ●   │"; echo "│     ● │"; echo "└───────┘" ;;
        4) echo "┌───────┐"; echo "│ ●   ● │"; echo "│       │"; echo "│ ●   ● │"; echo "└───────┘" ;;
        5) echo "┌───────┐"; echo "│ ●   ● │"; echo "│   ●   │"; echo "│ ●   ● │"; echo "└───────┘" ;;
        6) echo "┌───────┐"; echo "│ ●   ● │"; echo "│ ●   ● │"; echo "│ ●   ● │"; echo "└───────┘" ;;
    esac
}

show_roll_result() {
    local roll1=$1
    local roll2=$2
    local total=$3
    local player_name=$4

    echo -e "\033[1;36m$player_name бросает:\033[0m"
    echo -e "\033[1;33mКость 1:\033[0m"
    show_dice $roll1
    echo -e "\033[1;33mКость 2:\033[0m"
    show_dice $roll2
    echo -e "\033[1;32mСумма: $roll1 + $roll2 = $total\033[0m"
    echo
}

dice_game() {
    player_score=0
    computer_score=0
    rounds=3
    
    clear
    echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
    echo "Брось кости и побей компьютер!"
    
    for ((round=1; round<=rounds; round++)); do
        echo
        echo -e "\033[1;36mРаунд $round\033[0m"
        read -p "Нажми Enter чтобы бросить кости..."
        
        dice_animation
        
        player_roll1=$((RANDOM % 6 + 1))
        player_roll2=$((RANDOM % 6 + 1))
        computer_roll1=$((RANDOM % 6 + 1))
        computer_roll2=$((RANDOM % 6 + 1))
        
        player_total=$((player_roll1 + player_roll2))
        computer_total=$((computer_roll1 + computer_roll2))
        
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo -e "\033[1;36mРаунд $round\033[0m"
        echo
        
        show_roll_result $player_roll1 $player_roll2 $player_total "Ты"
        show_roll_result $computer_roll1 $computer_roll2 $computer_total "Компьютер"
        
        if [[ $player_total -gt $computer_total ]]; then
            echo -e "\033[1;32mТы выиграл раунд!\033[0m"
            ((player_score++))
        elif [[ $computer_total -gt $player_total ]]; then
            echo -e "\033[1;31mКомпьютер выиграл раунд!\033[0m"
            ((computer_score++))
        else
            echo -e "\033[1;33mНичья в раунде!\033[0m"
        fi
    done
    
    echo
    echo -e "\033[1;35m=== РЕЗУЛЬТАТ ===\033[0m"
    echo "Твой счёт: $player_score"
    echo "Счёт компьютера: $computer_score"
    
    if [[ $player_score -gt $computer_score ]]; then
        echo -e "\033[1;32m🎉 Ты победил в игре! 🎉\033[0m"
    elif [[ $computer_score -gt $player_score ]]; then
        echo -e "\033[1;31m🤖 Компьютер победил! 🤖\033[0m"
    else
        echo -e "\033[1;33m🤝 Ничья! 🤝\033[0m"
    fi
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# =============================================================================
# ИГРА 4: ЛАБИРИНТ
# =============================================================================

maze_game() {
    declare -a maps=(
        "
####################
#@.................#
#.#####.#####.#####.#
#.#...#.#...#.#...#.#
#.#.###.#.###.#.###.#
#.#.#.....#.........#
#.#.#.#####.#######.#
#...#...........#...#
#####.#####.###.#.#.#
#.........#.....#.#.#
#.#######.#####.#.#.#
#.#.....#.#.....#.#.#
#.#.###.#.#.#####.#.#
#.#.#...#.#.......#.#
#.#.#.###.#######.#.#
#...#.............#.#
###.#.###########.#.#
#.....#...........#.X#
####################
"
    )

    current_level=0
    total_levels=${#maps[@]}
    game_over=0
    player_x=0
    player_y=0
    exit_x=0
    exit_y=0
    
    load_map() {
        local level=$1
        IFS=$'\n' read -d '' -r -a map <<< "${maps[level]}"
        
        for ((y=0; y<${#map[@]}; y++)); do
            line="${map[y]}"
            for ((x=0; x<${#line}; x++)); do
                if [[ ${line:$x:1} == "@" ]]; then
                    player_x=$x
                    player_y=$y
                elif [[ ${line:$x:1} == "X" ]]; then
                    exit_x=$x
                    exit_y=$y
                fi
            done
        done
    }
    
    draw_maze() {
        clear
        echo -e "\033[1;35m🧩 ЛАБИРИНТ 🧩\033[0m"
        echo -e "\033[1;36mУровень: $((current_level+1))/$total_levels\033[0m"
        echo -e "\033[1;33mИспользуй WASD для движения. Найди выход X!\033[0m"
        echo -e "\033[1;32mQ - выход, R - перезапуск уровня\033[0m"
        echo
        
        for ((y=0; y<${#map[@]}; y++)); do
            line="${map[y]}"
            for ((x=0; x<${#line}; x++)); do
                char="${line:$x:1}"
                if [[ $x -eq $player_x && $y -eq $player_y ]]; then
                    echo -n "😊"
                else
                    case $char in
                        "#") echo -n "🧱" ;;
                        "."|"@") echo -n "  " ;;
                        "X") echo -n "🚪" ;;
                        *) echo -n "  " ;;
                    esac
                fi
            done
            echo
        done
    }
    
    load_map $current_level
    
    local level_complete=0
    while [[ $level_complete -eq 0 && $game_over -eq 0 ]]; do
        draw_maze
        
        if [[ $player_x -eq $exit_x && $player_y -eq $exit_y ]]; then
            level_complete=1
            continue
        fi
        
        read -rsn1 direction
        new_x=$player_x
        new_y=$player_y
        
        case $direction in
            w) ((new_y--)) ;;
            s) ((new_y++)) ;;
            a) ((new_x--)) ;;
            d) ((new_x++)) ;;
            r|R)
                echo -e "\033[1;33mПерезапуск уровня...\033[0m"
                sleep 1
                load_map $current_level
                continue
                ;;
            q|Q)
                echo -e "\033[1;31mВыход из игры...\033[0m"
                game_over=1
                break
                ;;
        esac
        
        if [[ $new_y -ge 0 && $new_y -lt ${#map[@]} && $new_x -ge 0 && $new_x -lt ${#map[$new_y]} ]]; then
            if [[ ${map[$new_y]:$new_x:1} != "#" ]]; then
                player_x=$new_x
                player_y=$new_y
            fi
        fi
    done
    
    if [[ $level_complete -eq 1 ]]; then
        clear
        echo -e "\033[1;32m"
        echo "  ╔══════════════════════════╗"
        echo "  ║       УРОВЕНЬ ПРОЙДЕН!   ║"
        echo "  ║         Уровень $((current_level+1))         ║"
        echo "  ╚══════════════════════════╝"
        echo -e "\033[0m"
    fi
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# =============================================================================
# ИГРА 5: КРЕСТИКИ-НОЛИКИ
# =============================================================================

PLAYER1="❌"
PLAYER2="⭕"

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
    
    for i in 0 3 6; do
        if [[ ${board[$i]} == $symbol && ${board[$i]} == ${board[$((i+1))]} && ${board[$i]} == ${board[$((i+2))]} ]]; then
            return 0
        fi
    done
    
    for i in 0 1 2; do
        if [[ ${board[$i]} == $symbol && ${board[$i]} == ${board[$((i+3))]} && ${board[$i]} == ${board[$((i+6))]} ]]; then
            return 0
        fi
    done
    
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
    
    for i in "${!board[@]}"; do
        if [[ ${board[$i]} == " " ]]; then
            available_moves+=($i)
        fi
    done
    
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

tictactoe_game() {
    echo -e "${PURPLE_MEDIUM}Ты играешь: ${CYAN}$PLAYER1${RESET}"
    echo -e "${PURPLE_MEDIUM}Компьютер:  ${PURPLE_NEON}$PLAYER2${RESET}"
    echo -e "${YELLOW}Подсказка: в пустых клетках отображаются их номера${RESET}"
    
    board=(" " " " " " " " " " " " " " " " " ")
    current_player="$PLAYER1"
    
    while true; do
        draw_board
        
        if [[ $current_player == "$PLAYER1" ]]; then
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
            echo -e "${PURPLE_NEON}Компьютер думает...${RESET}"
            sleep 1
            computer_move
        fi
        
        if check_winner "$current_player"; then
            draw_board
            if [[ $current_player == "$PLAYER1" ]]; then
                echo -e "${GREEN}🎉 Ты победил! Поздравляю! 🎉${RESET}"
            else
                echo -e "${RED}🤖 Компьютер победил! Попробуй ещё! 🤖${RESET}"
            fi
            break
        fi
        
        if is_board_full; then
            draw_board
            echo -e "${YELLOW}🤝 Ничья! Хорошая игра! 🤝${RESET}"
            break
        fi
        
        if [[ $current_player == "$PLAYER1" ]]; then
            current_player="$PLAYER2"
        else
            current_player="$PLAYER1"
        fi
    done
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# =============================================================================
# ГЛАВНЫЙ ЦИКЛ ПРОГРАММЫ
# =============================================================================

while true; do
    show_main_menu
    read -p "Твой выбор (1-6): " choice
    
    case $choice in
        1) snake_game ;;
        2) 
            word=$(get_random_word)
            hangman_game "$word" 
            ;;
        3) dice_game ;;
        4) maze_game ;;
        5) tictactoe_game ;;
        6) 
            echo -e "${PURPLE_MEDIUM}До новых игр! 💜${RESET}"
            exit 0
            ;;
        *) 
            echo -e "${RED}Неверный выбор! Попробуй ещё раз.${RESET}"
            sleep 1
            ;;
    esac
done
