@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Цветовые коды (используем для совместимости)
set "PURPLE="
set "CYAN="
set "GREEN="
set "RED="
set "RESET="

title 🎮 Настройка коллекции игр

echo.
echo 🎮 Настройка коллекции игр...
echo.

:: Определяем тип окружения
set "OS_TYPE=windows"
set "TERMINAL_TYPE=native"
set "GIT_BASH_EXISTS=false"

:: Проверяем наличие Git Bash
where git >nul 2>&1
if !errorlevel! equ 0 (
    where bash >nul 2>&1
    if !errorlevel! equ 0 (
        set "TERMINAL_TYPE=git"
        set "GIT_BASH_EXISTS=true"
    )
)

:: Получаем текущую директорию
set "GAMES_DIR=%~dp0"
set "GAMES_DIR=%GAMES_DIR:~0,-1%"

echo 🔍 Обнаружена система: %OS_TYPE%
echo 🔧 Тип терминала: %TERMINAL_TYPE%
echo 📁 Директория с играми: %GAMES_DIR%
echo.

:: Проверяем наличие bash
where bash >nul 2>&1
if !errorlevel! equ 1 (
    echo ❌ Ошибка: bash не найден!
    echo 💡 Для работы игр необходимо установить Git Bash
    echo    Скачать: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo ⚙️  Настраиваю права доступа...
:: В Windows права доступа настраиваются по-другому
attrib -R *.sh >nul 2>&1

echo 📝 Создаю главный менеджер игр...
echo.

:: Создаем games.sh
(
echo #!/bin/bash

echo.
echo # Фиолетовые цветовые коды
echo PURPLE='\033[0;35m'
echo LIGHT_PURPLE='\033[1;35m'
echo DARK_PURPLE='\033[0;34m'
echo CYAN='\033[0;36m'
echo RESET='\033[0m'
echo BOLD='\033[1m'

echo.
echo # Определяем директорию где находится скрипт
echo SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" ^&^& pwd)"

echo.
echo # Функция для красивого вывода
echo print_purple\(\) {
echo     echo -e "\${PURPLE}\$1\${RESET}"
echo }

echo.
echo print_light_purple\(\) {
echo     echo -e "\${LIGHT_PURPLE}\$1\${RESET}"
echo }

echo.
echo print_banner\(\) {
echo     clear
echo     echo -e "\${PURPLE}╔═════════════════════════════════════════════╗"
echo     echo -e "║          🐀 \${BOLD}ИГРЫ BASH\${RESET}\${PURPLE} ● \${BOLD}ФИОЛЕТОВЫЕ\${RESET}\${PURPLE}          ║"
echo     echo -e "║             🔍 \${CYAN}ПРЕМИУМ КОЛЛЕКЦИЯ\${RESET}\${PURPLE}            ║"
echo     echo -e "╚═════════════════════════════════════════════╝\${RESET}"
echo     echo
echo }
) > "%GAMES_DIR%\games.sh"

:: Добавляем OS-специфичный код
if "%TERMINAL_TYPE%"=="git" (
    echo 🪟 Настраиваю для Windows ^(Git Bash^)...
    (
        echo.
        echo # Функция для запуска игры в Windows системном терминале
        echo run_game_windows\(\) {
        echo     local run_script="\$1"
        echo     local game_name="\$2"
        echo.
        echo     echo -e "\${CYAN}🐀 Запускаем \$game_name в системном терминале Windows...\${RESET}"
        echo.
        echo     # Запускаем в новом окне Windows Terminal или Command Prompt
        echo     if command -v wt ^&^> /dev/null; then
        echo         # Используем Windows Terminal если доступен
        echo         wt bash -c "cd '\$SCRIPT_DIR' ^&^& ./'\$run_script'"
        echo     else
        echo         # Используем стандартный Command Prompt
        echo         cmd //c start "Bash Game: \$game_name" bash -c "cd '\$SCRIPT_DIR' ^&^& ./'\$run_script'"
        echo     fi
        echo }
        echo.
        echo # Функция для определения ОС и запуска игры
        echo run_game\(\) {
        echo     local run_script="\$1"
        echo     local game_name="\$2"
        echo     local emoji="\$3"
        echo.
        echo     echo -e "\${LIGHT_PURPLE}🎮 Запускаем \$emoji \$game_name...\${RESET}"
        echo.
        echo     # Проверяем существование скрипта игры
        echo     if [[ ! -f "\$SCRIPT_DIR/\$run_script" ]]; then
        echo         echo -e "\${PURPLE}❌ Скрипт запуска \$run_script не найден!\${RESET}"
        echo         echo -e "\${PURPLE}📁 Убедитесь что файл существует в директории: \$SCRIPT_DIR/\${RESET}"
        echo         return 1
        echo     fi
        echo.
        echo     # Даем права на выполнение
        echo     chmod +x "\$SCRIPT_DIR/\$run_script" 2^>/dev/null
        echo.
        echo     # Проверяем успешность chmod
        echo     if [[ ! -x "\$SCRIPT_DIR/\$run_script" ]]; then
        echo         echo -e "\${PURPLE}❌ Не удалось сделать скрипт исполняемым!\${RESET}"
        echo         return 1
        echo     fi
        echo.
        echo     # Для Windows используем системный терминал
        echo     run_game_windows "\$run_script" "\$game_name"
        echo }
    ) >> "%GAMES_DIR%\games.sh"
) else (
    echo 🪟 Настраиваю для Windows ^(нативный терминал^)...
    (
        echo.
        echo # Функция для запуска игры в Windows нативном терминале
        echo run_game_windows_native\(\) {
        echo     local run_script="\$1"
        echo     local game_name="\$2"
        echo.
        echo     echo -e "\${CYAN}🐀 Запускаем \$game_name в новом окне...\${RESET}"
        echo.
        echo     # Для нативного Windows терминала используем start
        echo     start "Bash Game: \$game_name" bash -c "
        echo         cd '\$SCRIPT_DIR'
        echo         echo 'Запуск \$game_name...'
        echo         ./'\$run_script'
        echo         echo ''
        echo         echo 'Игра завершена. Окно закроется автоматически через 3 секунды...'
        echo         sleep 3
        echo     "
        echo }
        echo.
        echo # Функция для определения ОС и запуска игры
        echo run_game\(\) {
        echo     local run_script="\$1"
        echo     local game_name="\$2"
        echo     local emoji="\$3"
        echo.
        echo     echo -e "\${LIGHT_PURPLE}🎮 Запускаем \$emoji \$game_name...\${RESET}"
        echo.
        echo     # Проверяем существование скрипта игры
        echo     if [[ ! -f "\$SCRIPT_DIR/\$run_script" ]]; then
        echo         echo -e "\${PURPLE}❌ Скрипт запуска \$run_script не найден!\${RESET}"
        echo         echo -e "\${PURPLE}📁 Убедитесь что файл существует в директории: \$SCRIPT_DIR/\${RESET}"
        echo         return 1
        echo     fi
        echo.
        echo     # Для нативного Windows chmod может не работать, но пробуем
        echo     chmod +x "\$SCRIPT_DIR/\$run_script" 2^>/dev/null
        echo.
        echo     # Для Windows нативного терминала
        echo     run_game_windows_native "\$run_script" "\$game_name"
        echo }
    ) >> "%GAMES_DIR%\games.sh"
)

:: Добавляем общую часть которая одинакова для всех ОС
(
    echo.
    echo # Анимация загрузки
    echo show_loading\(\) {
    echo     echo -ne "\${PURPLE}⏳ Загрузка игры...\${RESET}"
    echo     local frames=^("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"^)
    echo     for i in {1..2}; do
    echo         for frame in "\${frames[@]}"; do
    echo             echo -ne "\${PURPLE}\r\${frame} Загрузка игры...\${RESET}"
    echo             sleep 0.1
    echo         done
    echo     done
    echo     echo -e "\r✅ Готово!          "
    echo }
    echo.
    echo # Проверяем зависимости
    echo check_dependencies\(\) {
    echo     local deps=^("bash" "clear"^)
    echo     for dep in "\${deps[@]}"; do
    echo         if ! command -v "\$dep" ^&^> /dev/null; then
    echo             echo -e "\${PURPLE}❌ Ошибка: \$dep не найден!\${RESET}"
    echo             return 1
    echo         fi
    echo     done
    echo     return 0
    echo }
    echo.
    echo # Главное меню
    echo main_menu\(\) {
    echo     while true; do
    echo         print_banner
    echo.
    echo         echo -e "\${LIGHT_PURPLE}🎯 Выбери игру:\${RESET}"
    echo         echo
    echo         echo -e "  \${PURPLE}1\${RESET} – \${CYAN}Змейка\${RESET} \${PURPLE}🐍\${RESET}"
    echo         echo -e "  \${PURPLE}2\${RESET} – \${CYAN}Виселица\${RESET} \${PURPLE}🎭\${RESET}"
    echo         echo -e "  \${PURPLE}3\${RESET} – \${CYAN}Кости\${RESET} \${PURPLE}🎲\${RESET}"
    echo         echo -e "  \${PURPLE}4\${RESET} – \${CYAN}Лабиринт\${RESET} \${PURPLE}🏰\${RESET}"
    echo         echo -e "  \${PURPLE}5\${RESET} – \${CYAN}Крестики-нолики\${RESET} \${PURPLE}❌⭕\${RESET}"
    echo         echo -e "  \${PURPLE}6\${RESET} – \${CYAN}Пакман\${RESET} \${PURPLE}👻\${RESET}"
    echo         echo -e "  \${PURPLE}7\${RESET} – \${CYAN}Выход\${RESET} \${PURPLE}🚪\${RESET}"
    echo         echo
    echo         echo -e "\${DARK_PURPLE}═════════════════════════════════════════\${RESET}"
    echo         echo -ne "\${BOLD}\${LIGHT_PURPLE}🎮 Твой выбор ^(1–7^): \${RESET}"
    echo         read choice
    echo.
    echo         case \$choice in
    echo             1^)
    echo                 show_loading
    echo                 run_game "run_snake.sh" "Змейка" "🐍"
    echo                 ;;
    echo             2^)
    echo                 show_loading
    echo                 run_game "run_hangman.sh" "Виселица" "🎭"
    echo                 ;;
    echo             3^)
    echo                 show_loading
    echo                 run_game "run_dice.sh" "Кости" "🎲"
    echo                 ;;
    echo             4^)
    echo                 show_loading
    echo                 run_game "run_maze.sh" "Лабиринт" "🏰"
    echo                 ;;
    echo             5^)
    echo                 show_loading
    echo                 run_game "run_tictactoe.sh" "Крестики-нолики" "❌⭕"
    echo                 ;;
    echo             6^)
    echo                 show_loading
    echo                 run_game "run_pacman.sh" "Пакман" "👻"
    echo                 ;;
    echo             7^)
    echo                 echo
    echo                 echo -e "\${LIGHT_PURPLE}👋 До встречи! Спасибо за игру! 🎮\${RESET}"
    echo                 echo -e "\${PURPLE}✨ ФИОЛЕТОВЫЕ ИГРЫ BASH ✨\${RESET}"
    echo                 sleep 2
    echo                 exit 0
    echo                 ;;
    echo             *^)
    echo                 echo
    echo                 echo -e "\${PURPLE}❌ Неверный выбор! Введите число от 1 до 7.\${RESET}"
    echo                 sleep 2
    echo                 ;;
    echo         esac
    echo.
    echo         echo
    echo         echo -e "\${DARK_PURPLE}═════════════════════════════════════════\${RESET}"
    echo         echo -ne "\${PURPLE}Нажми Enter чтобы продолжить...\${RESET}"
    echo         read -r
    echo     done
    echo }
    echo.
    echo # Основная программа
    echo main\(\) {
    echo     # Проверяем зависимости
    echo     if ! check_dependencies; then
    echo         echo -e "\${PURPLE}❌ Необходимые зависимости отсутствуют!\${RESET}"
    echo         exit 1
    echo     fi
    echo.
    echo     # Запускаем главное меню
    echo     main_menu
    echo }
    echo.
    echo # Запускаем основную программу
    echo main
) >> "%GAMES_DIR%\games.sh"

:: Делаем games.sh исполняемым (в Windows это не обязательно, но для совместимости)
echo ✅ Настройка завершена!
echo.
echo 🚀 Запускайте игры командой: bash games.sh
echo 💻 Операционная система: %OS_TYPE%
echo 🔧 Тип терминала: %TERMINAL_TYPE%
echo.

if "%TERMINAL_TYPE%"=="native" (
    echo 💡 Подсказка: Для лучшего опыта установите Git Bash
    echo    Скачать: https://git-scm.com/download/win
    echo.
)

echo Нажмите любую клавишу для выхода...
pause >nul
