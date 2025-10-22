#!/bin/bash

pacman_game() {
    # Размеры поля
    local width=20
    local height=10
    local pacman_x=1
    local pacman_y=1
    local score=0
    local lives=3
    local game_over=0
    local dots_count=0
    local ghost_x=(5 15 8 12)
    local ghost_y=(3 3 7 7)
    local ghost_direction=("right" "left" "up" "down")
    
    # Создаем карту
    declare -a map
    initialize_map() {
        map=(
            "####################"
            "#..................#"
            "#.###.#..###.#..###.#"
            "#.#...#..#...#..#...#"
            "#.#.###.#.###.#.###.#"
            "#..................#"
            "#.#.###.#.###.#.###.#"
            "#.#...#..#...#..#...#"
            "#.###.#..###.#..###.#"
            "####################"
        )
        
        # Считаем точки
        dots_count=0
        for ((y=0; y<height; y++)); do
            for ((x=0; x<width; x++)); do
                if [[ ${map[y]:$x:1} == "." ]]; then
                    ((dots_count++))
                fi
            done
        done
    }
    
    # Функция отрисовки
    draw_game() {
        clear
        echo -e "\033[1;33m🎮 ПАКМАН 🎮\033[0m"
        echo -e "\033[1;32mСчёт: $score\033[0m"
        echo -e "\033[1;31mЖизни: $lives\033[0m"
        echo -e "\033[1;36mОсталось точек: $dots_count\033[0m"
        echo
        
        for ((y=0; y<height; y++)); do
            for ((x=0; x<width; x++)); do
                local cell="${map[y]:$x:1}"
                local is_ghost=0
                
                # Проверка призраков
                for ((i=0; i<4; i++)); do
                    if [[ $x -eq ${ghost_x[i]} && $y -eq ${ghost_y[i]} ]]; then
                        echo -n "👻"
                        is_ghost=1
                        break
                    fi
                done
                
                if [[ $is_ghost -eq 1 ]]; then
                    continue
                fi
                
                # Пакман
                if [[ $x -eq $pacman_x && $y -eq $pacman_y ]]; then
                    echo -n "😃"
                else
                    case $cell in
                        "#") echo -n "🧱" ;;
                        ".") echo -n "⚪" ;;
                        " ") echo -n "  " ;;
                        *) echo -n "  " ;;
                    esac
                fi
            done
            echo
        done
        
        echo
        echo -e "\033[1;37mУправление: WASD - движение, Q - выход\033[0m"
    }
    
    # Движение призраков
    move_ghosts() {
        for ((i=0; i<4; i++)); do
            local new_x=${ghost_x[i]}
            local new_y=${ghost_y[i]}
            
            # Случайное изменение направления (исправленная строка)
            if [[ $((RANDOM % 5)) -eq 0 ]]; then
                local directions=("right" "left" "up" "down")
                ghost_direction[i]=${directions[$((RANDOM % 4))]}
            fi
            
            case ${ghost_direction[i]} in
                "right") ((new_x++)) ;;
                "left") ((new_x--)) ;;
                "up") ((new_y--)) ;;
                "down") ((new_y++)) ;;
            esac
            
            # Проверка стены
            if [[ $new_x -ge 0 && $new_x -lt $width && $new_y -ge 0 && $new_y -lt $height ]]; then
                if [[ ${map[$new_y]:$new_x:1} != "#" ]]; then
                    ghost_x[i]=$new_x
                    ghost_y[i]=$new_y
                else
                    # Если уперлись в стену - меняем направление
                    local directions=("right" "left" "up" "down")
                    ghost_direction[i]=${directions[$((RANDOM % 4))]}
                fi
            fi
            
            # Проверка столкновения с пакманом
            if [[ ${ghost_x[i]} -eq $pacman_x && ${ghost_y[i]} -eq $pacman_y ]]; then
                ((lives--))
                if [[ $lives -le 0 ]]; then
                    game_over=1
                else
                    # Респавн пакмана
                    pacman_x=1
                    pacman_y=1
                    echo -e "\033[1;31mПакман пойман! Осталось жизней: $lives\033[0m"
                    sleep 1
                fi
            fi
        done
    }
    
    # Основная игровая логика
    initialize_map
    
    while [[ $game_over -eq 0 && $dots_count -gt 0 ]]; do
        draw_game
        
        # Проверка победы
        if [[ $dots_count -eq 0 ]]; then
            echo -e "\033[1;32m🎉 Поздравляю! Вы собрали все точки! 🎉\033[0m"
            break
        fi
        
        # Управление
        read -rsn1 -t 0.3 input
        local new_x=$pacman_x
        local new_y=$pacman_y
        
        case $input in
            w|W) ((new_y--)) ;;
            s|S) ((new_y++)) ;;
            a|A) ((new_x--)) ;;
            d|D) ((new_x++)) ;;
            q|Q) game_over=1 ;;
        esac
        
        # Проверка движения пакмана
        if [[ $new_x -ge 0 && $new_x -lt $width && $new_y -ge 0 && $new_y -lt $height ]]; then
            if [[ ${map[$new_y]:$new_x:1} != "#" ]]; then
                pacman_x=$new_x
                pacman_y=$new_y
                
                # Сбор точек
                if [[ ${map[$pacman_y]:$pacman_x:1} == "." ]]; then
                    map[$pacman_y]="${map[$pacman_y]:0:$pacman_x} ${map[$pacman_y]:$((pacman_x+1))}"
                    ((score += 10))
                    ((dots_count--))
                fi
            fi
        fi
        
        # Движение призраков
        move_ghosts
        
        # Быстрая проверка столкновения после движения призраков
        for ((i=0; i<4; i++)); do
            if [[ ${ghost_x[i]} -eq $pacman_x && ${ghost_y[i]} -eq $pacman_y ]]; then
                ((lives--))
                if [[ $lives -le 0 ]]; then
                    game_over=1
                else
                    pacman_x=1
                    pacman_y=1
                    echo -e "\033[1;31mПакман пойман! Осталось жизней: $lives\033[0m"
                    sleep 1
                fi
                break
            fi
        done
    done
    
    # Финальное сообщение
    if [[ $lives -le 0 ]]; then
        echo -e "\033[1;31m"
        echo "╔══════════════════════════╗"
        echo "║      ИГРА ОКОНЧЕНА!     ║"
        echo "║   Пакман был побеждён!  ║"
        echo "║   Ваш счёт: $score$(printf '%*s' $((10-${#score})) ' ')║"
        echo "╚══════════════════════════╝"
        echo -e "\033[0m"
    else
        echo -e "\033[1;32m"
        echo "╔══════════════════════════╗"
        echo "║       ПОБЕДА! 🎉        ║"
        echo "║  Все точки собраны!     ║"
        echo "║   Ваш счёт: $score$(printf '%*s' $((10-${#score})) ' ')║"
        echo "╚══════════════════════════╝"
        echo -e "\033[0m"
    fi
}

# Проверка поддержки UTF-8
if [[ $(locale charmap) != "UTF-8" ]]; then
    echo "Внимание: для правильного отображения символов рекомендуется использовать UTF-8"
    sleep 2
fi

pacman_game
