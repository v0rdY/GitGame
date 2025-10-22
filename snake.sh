#!/bin/bash
# snake.sh

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
        # Верхняя граница
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
            # Левая граница
            echo -ne "${border_color}${border_char}\033[0m"
            
            for ((x=0; x<width; x++)); do
                local cell_empty=1
                local is_head=0
                
                # Проверка головы змейки
                if [[ $x -eq $snake_x && $y -eq $snake_y ]]; then
                    echo -n "$snake_head"
                    cell_empty=0
                    is_head=1
                # Проверка еды
                elif [[ $x -eq $food_x && $y -eq $food_y ]]; then
                    echo -n "$food_char"
                    cell_empty=0
                else
                    # Проверка тела змейки
                    for ((i=1; i<${#snake_body[@]}; i++)); do
                        IFS=':' read -r seg_x seg_y <<< "${snake_body[i]}"
                        if [[ $x -eq $seg_x && $y -eq $seg_y ]]; then
                            echo -n "$snake_body_char"
                            cell_empty=0
                            
                            # Проверка столкновения головы с телом
                            if [[ $is_head -eq 1 ]]; then
                                game_over=1
                            fi
                            break
                        fi
                    done
                fi
                
                # Пустая клетка
                [[ $cell_empty -eq 1 ]] && echo -n "$empty_char"
            done
            
            # Правая граница
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
            
            # Проверяем, чтобы еда не появилась на змейке
            for segment in "${snake_body[@]}"; do
                IFS=':' read -r seg_x seg_y <<< "$segment"
                if [[ $food_x -eq $seg_x && $food_y -eq $seg_y ]]; then
                    valid_position=0
                    break
                fi
            done
        done
    }

    # Начальная расстановка еды
    place_food

    while [[ $game_over -eq 0 ]]; do
        draw_game
        
        # Управление с более быстрым откликом
        read -rsn1 -t 0.2 input
        case $input in
            w|W) [[ $direction != "down" ]] && direction=up ;;
            s|S) [[ $direction != "up" ]] && direction=down ;;
            a|A) [[ $direction != "right" ]] && direction=left ;;
            d|D) [[ $direction != "left" ]] && direction=right ;;
            q|Q) game_over=1 ;;
        esac

        # Сохраняем предыдущую позицию головы
        local prev_x=$snake_x
        local prev_y=$snake_y

        # Движение змейки
        case $direction in
            up) ((snake_y--)) ;;
            down) ((snake_y++)) ;;
            left) ((snake_x--)) ;;
            right) ((snake_x++)) ;;
        esac

        # Проверка столкновений со стенками
        if [[ $snake_x -lt 0 || $snake_x -ge $width || $snake_y -lt 0 || $snake_y -ge $height ]]; then
            game_over=1
        fi

        # Проверка столкновения головы с телом
        for ((i=1; i<${#snake_body[@]}; i++)); do
            IFS=':' read -r seg_x seg_y <<< "${snake_body[i]}"
            if [[ $snake_x -eq $seg_x && $snake_y -eq $seg_y ]]; then
                game_over=1
                break
            fi
        done

        # Проверка еды
        if [[ $snake_x -eq $food_x && $snake_y -eq $food_y ]]; then
            ((score+=5))
            ((snake_size++))
            snake_body=("$snake_x:$snake_y" "${snake_body[@]}")
            place_food
        else
            # Обновление тела змейки
            snake_body=("$snake_x:$snake_y" "${snake_body[@]:0:$(($snake_size-1))}")
        fi
        
        # Небольшая задержка для плавности
        sleep 0.1
    done

    echo -e "${game_over_color}"
    echo "╔══════════════════════════╗"
    echo "║       ИГРА ОКОНЧЕНА!     ║"
    echo "║     Ваш счёт: $score$(printf '%*s' $((7-${#score})) ' ')║"
    echo "╚══════════════════════════╝"
    echo -e "\033[0m"
}

# Проверка поддержки UTF-8
if [[ $(locale charmap) != "UTF-8" ]]; then
    echo "Внимание: для правильного отображения символов рекомендуется использовать UTF-8"
fi

snake_game
