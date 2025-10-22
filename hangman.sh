#!/bin/bash
# hangman.sh

draw_hangman() {
    local attempts=$1
    case $attempts in
        6)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │"
            echo "      │"
            echo "      │"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        5)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     😮"
            echo "      │"
            echo "      │"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        4)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     😮"
            echo "      │     │"
            echo "      │"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        3)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     😮"
            echo "      │    /│"
            echo "      │"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        2)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     😮"
            echo "      │    /│\\"
            echo "      │"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        1)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     😮"
            echo "      │    /│\\"
            echo "      │    /"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
        0)
            echo "      ┌─────┐"
            echo "      │     │"
            echo "      │     💀"
            echo "      │    /│\\"
            echo "      │    / \\"
            echo "      │"
            echo "┌─────┴─────┐"
            ;;
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

choose_game_mode() {
    echo -e "\033[1;35m🎯 ВИСЕЛИЦА С ЧЕЛОВЕЧКОМ 🎯\033[0m"
    echo
    echo -e "\033[1;36mВыбери режим игры:\033[0m"
    echo -e "  \033[1;32m1\033[0m - Случайное слово"
    echo -e "  \033[1;33m2\033[0m - Своё слово"
    echo
}

get_random_word() {
    local words=("компьютер" "программа" "алгоритм" "терминал" "скрипт" "баш" 
                 "гит" "консоль" "виселица" "игра" "разработка" "кодирование"
                 "переменная" "функция" "массив" "цикл" "условие" "строка")
    echo "${words[$((RANDOM % ${#words[@]}))]}"
}

get_custom_word() {
    while true; do
        read -p "Введи слово для угадывания: " custom_word
        if [[ -z "$custom_word" ]]; then
            echo -e "\033[1;31mСлово не может быть пустым!\033[0m"
            continue
        fi
        if [[ "$custom_word" =~ [^а-яА-Яa-zA-Z] ]]; then
            echo -e "\033[1;31mИспользуй только буквы!\033[0m"
            continue
        fi
        echo "$custom_word" | tr '[:upper:]' '[:lower:]'
        break
    done
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
        read -p "Введи букву: " guess
        
        # Проверка ввода
        if [[ ${#guess} -ne 1 ]]; then
            echo -e "\033[1;31mВведи только одну букву!\033[0m"
            sleep 1
            continue
        fi
        
        # Приведение к нижнему регистру
        guess=$(echo "$guess" | tr '[:upper:]' '[:lower:]')
        
        # Проверка на букву
        if [[ ! "$guess" =~ [а-яa-z] ]]; then
            echo -e "\033[1;31mЭто не буква! Используй только буквы.\033[0m"
            sleep 1
            continue
        fi
        
        # Проверка на повтор
        if [[ " ${used_letters[@]} " =~ " $guess " ]]; then
            echo -e "\033[1;33mТы уже пробовал эту букву!\033[0m"
            sleep 1
            continue
        fi
        
        used_letters+=("$guess")
        
        # Проверка угадывания
        if [[ $word == *"$guess"* ]]; then
            echo -e "\033[1;32m✅ Правильно! Буква '$guess' есть в слове!\033[0m"
            guessed+=("$guess")
            # Считаем сколько раз встречается буква
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
}

main() {
    choose_game_mode
    read -p "Твой выбор (1-2): " mode
    
    case $mode in
        1)
            word=$(get_random_word)
            hangman_game "$word"
            ;;
        2)
            word=$(get_custom_word)
            clear
            hangman_game "$word"
            ;;
        *)
            echo -e "\033[1;31mНеверный выбор! Попробуй ещё раз.\033[0m"
            sleep 1
            ;;
    esac
}

# Запуск игры
main
