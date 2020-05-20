@echo off

cls
:MENU
echo ======================
echo      KNIGHT GAME
echo ======================
echo Aim of the game - defeat 3 Orcs with your custom character.
echo.
echo.
echo ======================
echo  Name your character:
set /p NAME=
echo ======================
echo   Choose your hero:
echo     1. Warrior
echo     2. Tank
echo     3. Balanced
echo     4. Random
echo ======================
choice /c 1234 /n

if ERRORLEVEL 1 (
    SET /a HP=30
    SET /a DAMAGE=35
    SET /a DEFENCE=3
    SET /a SPEED=25
    SET HERO=Warrior
)

if ERRORLEVEL 2 (
    SET /a HP=45
    SET /a DAMAGE=15
    SET /a DEFENCE=11
    SET /a SPEED=10
    SET HERO=Tank
)

if ERRORLEVEL 3 (
    SET /a HP=37
    SET /a DAMAGE=25
    SET /a DEFENCE=4
    SET /a SPEED=15
    SET HERO=Balanced
)

if ERRORLEVEL 4 (
    SET /a HP=%RANDOM%*85/32768+1
    SET /a DAMAGE=%RANDOM%*35/32768+1
    SET /a DEFENCE=%RANDOM%*13/32768+1
    SET /a SPEED=%RANDOM%*20/32768+1
    SET HERO=Random
)

SET CURRENT_LEVEL=1
SET /a RUNS_LEFT=1

:ORC_GENERATOR
SET /a ORC_HP[1]=%RANDOM%*30/32768+1
SET /a ORC_HP[2]=%RANDOM%*55/32768+1
SET /a ORC_HP[3]=%RANDOM%*70/32768+1

SET /a ORC_DAMAGE[1]=%RANDOM%*10/32768+1
SET /a ORC_DAMAGE[2]=%RANDOM%*23/32768+1
SET /a ORC_DAMAGE[3]=%RANDOM%*45/32768+1

SET /a ORC_DEFENCE[1]=%RANDOM%*5/32768+1
SET /a ORC_DEFENCE[2]=%RANDOM%*7/32768+1
SET /a ORC_DEFENCE[3]=%RANDOM%*15/32768+1

SET /a ORC_SPEED[1]=%RANDOM%*15/32768+1
SET /a ORC_SPEED[2]=%RANDOM%*25/32768+1
SET /a ORC_SPEED[3]=%RANDOM%*35/32768+1


setlocal enabledelayedexpansion
:GAME
for /l %%i in (%CURRENT_LEVEL%, 1, 3) do (
    cls
    echo LVL: %%i
    echo.
    echo ======================
    echo         %NAME%
    echo         %HERO%
    echo ======================
    call echo   HP ----------- !HP!
    echo   DAMAGE ------- %DAMAGE%
    echo   DEFENCE ------ %DEFENCE%
    echo   SPEED -------- %SPEED%
    echo ======================

    echo.
    echo           VS
    echo.

    echo ======================
    echo          ORC
    echo ======================
    call echo   HP ----------- %%ORC_HP[%%i]%%
    call echo   DAMAGE ------- %%ORC_DAMAGE[%%i]%%
    call echo   DEFENCE ------ %%ORC_DEFENCE[%%i]%%
    call echo   SPEED -------- %%ORC_SPEED[%%i]%%
    echo ======================

    echo.
    echo ======================
    echo     Your options:
    echo       1. Fight
    echo       2. Run; left - %RUNS_LEFT%
    echo ======================
    echo Your choice:
    choice /c 12 /n

    if !ERRORLEVEL!==1 (
        call SET /a HEROES_DEFENCE=%%ORC_DEFENCE[%%i]%%-%DEFENCE%
        call SET /a HP-=%%ORC_DAMAGE[%%i]%%-!HEROES_DEFENCE!

        if !HP! LEQ 0 (
            echo.
            echo ======================
            echo You lose. Try again!
            echo ======================
            PAUSE
            cls
            goto MENU
        )
    )

    if !ERRORLEVEL!==2 (
        if !RUNS_LEFT! NEQ 0 (
            if !SPEED! GTR !ORC_SPEED[%%i]! (
                SET /a RUNS_LEFT-=1
                SET CURRENT_LEVEL=%%i
                goto ORC_GENERATOR
            ) else (
                echo.
                echo ======================
                echo You lose. Orc catch you.
                echo ======================
                PAUSE
                cls
                goto MENU
            )
        ) else (
            goto GAME
        )
    )
)

echo.
echo ======================
echo YOU WIN! Good job.
echo ======================
PAUSE
