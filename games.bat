@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title 🐀 ФИОЛЕТОВЫЕ ИГРЫ BASH - ГЛАВНОЕ МЕНЮ

:: Определяем директорию где находится скрипт
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Проверяем наличие bash
where bash >nul 2>&1
if !errorlevel! equ 1 (
    echo.
    echo ❌ Ошибка: bash не найден!
    echo 💡 Для работы игр необходимо установить Git Bash
    echo    Скачать: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

:: Главное меню
:menu
cls
echo.
echo    ╔═════════════════════════════════════════════╗
echo    ║          🐀 ИГРЫ BASH ● ФИОЛЕТОВЫЕ          ║
echo    ║             🔍 ПРЕМИУМ КОЛЛЕКЦИЯ            ║
echo    ╚═════════════════════════════════════════════╝
echo.

echo 🎯 Выбери игру:
echo.
echo    1 – Змейка 🐍
echo    2 – Виселица 🎭
echo    3 – Кости 🎲
echo    4 – Лабиринт 🏰
echo    5 – Крестики-нолики ❌⭕
echo    6 – Пакман 👻
echo    7 – Выход 🚪
echo.
echo ═════════════════════════════════════════
set /p choice=🎮 Твой выбор (1–7): 

:: Проверяем валидность выбора
echo !choice! | findstr /r "^[1-7]$" >nul
if !errorlevel! equ 1 (
    echo.
    echo ❌ Неверный выбор! Введите число от 1 до 7.
    timeout /t 2 /nobreak >nul
    goto menu
)

:: Обрабатываем выбор
if "!choice!"=="1" goto game_snake
if "!choice!"=="2" goto game_hangman
if "!choice!"=="3" goto game_dice
if "!choice!"=="4" goto game_maze
if "!choice!"=="5" goto game_tictactoe
if "!choice!"=="6" goto game_pacman
if "!choice!"=="7" goto exit

:game_snake
echo.
echo 🎮 Запускаем 🐍 Змейка...
call :show_loading
if exist "%SCRIPT_DIR%\run_snake.sh" (
    bash "%SCRIPT_DIR%\run_snake.sh"
) else if exist "%SCRIPT_DIR%\snake.sh" (
    bash "%SCRIPT_DIR%\snake.sh"
) else (
    echo ❌ Файл игры Змейка не найден!
)
goto return_to_menu

:game_hangman
echo.
echo 🎮 Запускаем 🎭 Виселица...
call :show_loading
if exist "%SCRIPT_DIR%\run_hangman.sh" (
    bash "%SCRIPT_DIR%\run_hangman.sh"
) else if exist "%SCRIPT_DIR%\hangman.sh" (
    bash "%SCRIPT_DIR%\hangman.sh"
) else (
    echo ❌ Файл игры Виселица не найден!
)
goto return_to_menu

:game_dice
echo.
echo 🎮 Запускаем 🎲 Кости...
call :show_loading
if exist "%SCRIPT_DIR%\run_dice.sh" (
    bash "%SCRIPT_DIR%\run_dice.sh"
) else if exist "%SCRIPT_DIR%\dice.sh" (
    bash "%SCRIPT_DIR%\dice.sh"
) else (
    echo ❌ Файл игры Кости не найден!
)
goto return_to_menu

:game_maze
echo.
echo 🎮 Запускаем 🏰 Лабиринт...
call :show_loading
if exist "%SCRIPT_DIR%\run_maze.sh" (
    bash "%SCRIPT_DIR%\run_maze.sh"
) else if exist "%SCRIPT_DIR%\maze.sh" (
    bash "%SCRIPT_DIR%\maze.sh"
) else (
    echo ❌ Файл игры Лабиринт не найден!
)
goto return_to_menu

:game_tictactoe
echo.
echo 🎮 Запускаем ❌⭕ Крестики-нолики...
call :show_loading
if exist "%SCRIPT_DIR%\run_tictactoe.sh" (
    bash "%SCRIPT_DIR%\run_tictactoe.sh"
) else if exist "%SCRIPT_DIR%\purple_tictactoe.sh" (
    bash "%SCRIPT_DIR%\purple_tictactoe.sh"
) else if exist "%SCRIPT_DIR%\tictactoe.sh" (
    bash "%SCRIPT_DIR%\tictactoe.sh"
) else (
    echo ❌ Файл игры Крестики-нолики не найден!
)
goto return_to_menu

:game_pacman
echo.
echo 🎮 Запускаем 👻 Пакман...
call :show_loading
if exist "%SCRIPT_DIR%\run_pacman.sh" (
    bash "%SCRIPT_DIR%\run_pacman.sh"
) else if exist "%SCRIPT_DIR%\pacman.sh" (
    bash "%SCRIPT_DIR%\pacman.sh"
) else (
    echo ❌ Файл игры Пакман не найден!
)
goto return_to_menu

:return_to_menu
echo.
echo ═════════════════════════════════════════
echo.
set /p continue=Нажми Enter чтобы продолжить... 
goto menu

:exit
echo.
echo 👋 До встречи! Спасибо за игру! 🎮
echo ✨ ФИОЛЕТОВЫЕ ИГРЫ BASH ✨
echo.
timeout /t 2 /nobreak >nul
exit /b 0

:show_loading
echo ⏳ Загрузка игры...
:: Простая анимация загрузки
for /l %%i in (1,1,6) do (
    ping -n 1 127.0.0.1 >nul
    set /a "frame=%%i %% 3"
    if !frame! equ 0 set "char=⠋"
    if !frame! equ 1 set "char=⠙" 
    if !frame! equ 2 set "char=⠹"
    <nul set /p "=!char! Загрузка игры..."
)
echo.
echo ✅ Готово!
goto :eof
