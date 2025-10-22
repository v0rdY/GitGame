#!/bin/bash
# dice.sh

# Функция для отображения анимации костей
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
    
    # Анимация вращения
    for i in {1..8}; do
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo
        frame_index=$(( (i-1) % 4 ))
        echo -e "\033[1;33m${frames[frame_index]}\033[0m"
        sleep 0.2
    done
}

# Функция для отображения конкретной кости
show_dice() {
    local value=$1
    case $value in
        1)
            echo "
┌───────┐
│       │
│   ●   │
│       │
└───────┘"
            ;;
        2)
            echo "
┌───────┐
│ ●     │
│       │
│     ● │
└───────┘"
            ;;
        3)
            echo "
┌───────┐
│ ●     │
│   ●   │
│     ● │
└───────┘"
            ;;
        4)
            echo "
┌───────┐
│ ●   ● │
│       │
│ ●   ● │
└───────┘"
            ;;
        5)
            echo "
┌───────┐
│ ●   ● │
│   ●   │
│ ●   ● │
└───────┘"
            ;;
        6)
            echo "
┌───────┐
│ ●   ● │
│ ●   ● │
│ ●   ● │
└───────┘"
            ;;
    esac
}

# Функция для отображения результата броска
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

# Функция выбора режима игры
choose_game_mode() {
    clear
    echo -e "\033[1;35m
    ╔══════════════════════════╗
    ║       🎲 ИГРА В КОСТИ 🎲      ║
    ╚══════════════════════════╝
    \033[0m"
    
    echo -e "\033[1;36mВыберите режим игры:\033[0m"
    echo -e "1. \033[1;32m🎮 Игра против компьютера\033[0m"
    echo -e "2. \033[1;34m👥 Игра для двух игроков\033[0m"
    echo -e "3. \033[1;31m🚪 Выход\033[0m"
    echo
    
    while true; do
        read -p "Введите номер выбора (1-3): " choice
        case $choice in
            1) 
                echo -e "\033[1;32mВыбран режим: Против компьютера\033[0m"
                sleep 1
                return 1
                ;;
            2)
                echo -e "\033[1;34mВыбран режим: Два игрока\033[0m"
                sleep 1
                return 2
                ;;
            3)
                echo -e "\033[1;33mДо свидания!\033[0m"
                exit 0
                ;;
            *)
                echo -e "\033[1;31mНеверный выбор. Попробуйте снова.\033[0m"
                ;;
        esac
    done
}

# Функция для ввода имен игроков
get_player_names() {
    local mode=$1
    declare -g player1_name player2_name
    
    if [[ $mode -eq 1 ]]; then
        read -p "Введите ваше имя: " player1_name
        player1_name=${player1_name:-"Игрок 1"}
        player2_name="Компьютер"
    else
        read -p "Введите имя первого игрока: " player1_name
        player1_name=${player1_name:-"Игрок 1"}
        read -p "Введите имя второго игрока: " player2_name
        player2_name=${player2_name:-"Игрок 2"}
    fi
}

# Функция игры против компьютера
single_player_game() {
    local player_score=0
    local computer_score=0
    local rounds=3
    
    clear
    echo -e "\033[1;35m
    ╔══════════════════════════╗
    ║     🎮 РЕЖИМ: ПРОТИВ     ║
    ║         КОМПЬЮТЕРА       ║
    ╚══════════════════════════╝
    \033[0m"
    
    echo -e "Игрок: \033[1;32m$player1_name\033[0m"
    echo -e "Противник: \033[1;31m$player2_name\033[0m"
    echo
    
    for ((round=1; round<=rounds; round++)); do
        echo
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        echo -e "\033[1;36m          Раунд $round\033[0m"
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        
        # Ход игрока
        read -p "Нажми Enter чтобы бросить кости..."
        
        # Анимация броска игрока
        dice_animation
        
        player_roll1=$((RANDOM % 6 + 1))
        player_roll2=$((RANDOM % 6 + 1))
        player_total=$((player_roll1 + player_roll2))
        
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo -e "\033[1;36mРаунд $round | Режим: Против компьютера\033[0m"
        echo
        
        show_roll_result $player_roll1 $player_roll2 $player_total "$player1_name"
        
        # Ход компьютера
        echo -e "\033[1;35mХод компьютера...\033[0m"
        sleep 2
        
        computer_roll1=$((RANDOM % 6 + 1))
        computer_roll2=$((RANDOM % 6 + 1))
        computer_total=$((computer_roll1 + computer_roll2))
        
        show_roll_result $computer_roll1 $computer_roll2 $computer_total "$player2_name"
        
        # Определение победителя раунда
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        if [[ $player_total -gt $computer_total ]]; then
            echo -e "\033[1;32m🎉 $player1_name выиграл раунд!\033[0m"
            ((player_score++))
        elif [[ $computer_total -gt $player_total ]]; then
            echo -e "\033[1;31m🤖 $player2_name выиграл раунд!\033[0m"
            ((computer_score++))
        else
            echo -e "\033[1;33m🤝 Ничья в раунде!\033[0m"
        fi
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        
        # Текущий счет
        echo -e "\033[1;35mТекущий счёт:\033[0m"
        echo -e "$player1_name: \033[1;32m$player_score\033[0m | $player2_name: \033[1;31m$computer_score\033[0m"
        
        if [[ $round -lt $rounds ]]; then
            sleep 3
        fi
    done
    
    show_final_results $player_score $computer_score
}

# Функция игры для двух игроков
two_player_game() {
    local player1_score=0
    local player2_score=0
    local rounds=3
    
    clear
    echo -e "\033[1;35m
    ╔══════════════════════════╗
    ║     👥 РЕЖИМ: ДВА        ║
    ║         ИГРОКА          ║
    ╚══════════════════════════╝
    \033[0m"
    
    echo -e "Игрок 1: \033[1;32m$player1_name\033[0m"
    echo -e "Игрок 2: \033[1;34m$player2_name\033[0m"
    echo
    
    for ((round=1; round<=rounds; round++)); do
        echo
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        echo -e "\033[1;36m          Раунд $round\033[0m"
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        
        # Ход первого игрока
        echo -e "\033[1;32mХод $player1_name\033[0m"
        read -p "Нажми Enter чтобы бросить кости..."
        
        dice_animation
        
        player1_roll1=$((RANDOM % 6 + 1))
        player1_roll2=$((RANDOM % 6 + 1))
        player1_total=$((player1_roll1 + player1_roll2))
        
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo -e "\033[1;36mРаунд $round | Режим: Два игрока\033[0m"
        echo
        
        show_roll_result $player1_roll1 $player1_roll2 $player1_total "$player1_name"
        
        # Ход второго игрока
        echo -e "\033[1;34mХод $player2_name\033[0m"
        read -p "Нажми Enter чтобы бросить кости..."
        
        dice_animation
        
        player2_roll1=$((RANDOM % 6 + 1))
        player2_roll2=$((RANDOM % 6 + 1))
        player2_total=$((player2_roll1 + player2_roll2))
        
        clear
        echo -e "\033[1;35m🎲 ИГРА В КОСТИ 🎲\033[0m"
        echo -e "\033[1;36mРаунд $round | Режим: Два игрока\033[0m"
        echo
        
        show_roll_result $player1_roll1 $player1_roll2 $player1_total "$player1_name"
        show_roll_result $player2_roll1 $player2_roll2 $player2_total "$player2_name"
        
        # Определение победителя раунда
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        if [[ $player1_total -gt $player2_total ]]; then
            echo -e "\033[1;32m🎉 $player1_name выиграл раунд!\033[0m"
            ((player1_score++))
        elif [[ $player2_total -gt $player1_total ]]; then
            echo -e "\033[1;34m🎉 $player2_name выиграл раунд!\033[0m"
            ((player2_score++))
        else
            echo -e "\033[1;33m🤝 Ничья в раунде!\033[0m"
        fi
        echo -e "\033[1;34m═══════════════════════════════\033[0m"
        
        # Текущий счет
        echo -e "\033[1;35mТекущий счёт:\033[0m"
        echo -e "$player1_name: \033[1;32m$player1_score\033[0m | $player2_name: \033[1;34m$player2_score\033[0m"
        
        if [[ $round -lt $rounds ]]; then
            sleep 3
        fi
    done
    
    show_final_results $player1_score $player2_score
}

# Функция отображения финальных результатов
show_final_results() {
    local score1=$1
    local score2=$2
    
    echo
    echo -e "\033[1;35m
    ╔══════════════════════════╗
    ║        РЕЗУЛЬТАТЫ        ║
    ╚══════════════════════════╝
    \033[0m"
    
    echo -e "\033[1;36mФинальный счёт:\033[0m"
    echo -e "$player1_name: \033[1;32m$score1\033[0m"
    echo -e "$player2_name: \033[1;31m$score2\033[0m"
    echo
    
    if [[ $score1 -gt $score2 ]]; then
        echo -e "\033[1;32m
    ╔══════════════════════════╗
    ║  🎉 $player1_name ПОБЕДИЛ! 🎉  ║
    ╚══════════════════════════╝
        \033[0m"
    elif [[ $score2 -gt $score1 ]]; then
        echo -e "\033[1;31m
    ╔══════════════════════════╗
    ║  🎉 $player2_name ПОБЕДИЛ! 🎉  ║
    ╚══════════════════════════╝
        \033[0m"
    else
        echo -e "\033[1;33m
    ╔══════════════════════════╗
    ║        🤝 НИЧЬЯ! 🤝       ║
    ╚══════════════════════════╝
        \033[0m"
    fi
    
    echo
    read -p "Нажми Enter чтобы вернуться в меню..."
}

# Главная функция игры
dice_game() {
    while true; do
        # Выбор режима игры
        choose_game_mode
        game_mode=$?
        
        # Ввод имен игроков
        get_player_names $game_mode
        
        # Запуск выбранного режима
        if [[ $game_mode -eq 1 ]]; then
            single_player_game
        else
            two_player_game
        fi
    done
}

# Запуск игры
dice_game
