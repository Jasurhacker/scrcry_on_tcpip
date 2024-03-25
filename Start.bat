@echo off
chcp=65001
title Screen to TCP/IP by @Jasur_it Tik-Tok

:check_adb
IF EXIST adb.exe (
cls
echo Есть утилита adb
goto check_scrcpy
) ELSE (
cls
echo Чаладой маловек перекиньте меня в папку с adb ибо файл adb отсутствует
pause
goto check_adb
)

:check_scrcpy
IF EXIST scrcpy.exe (
echo Есть утилита scrcpy
goto check_devices
) ELSE (
cls
echo Маладой чаловек перекиньте меня в папку с scrcpy ибо файл scrcpy отсутствует
pause
goto check_scrcpy
)

:check_devices
echo Запуск службы ADB...
adb kill-server 2>NUL
adb start-server 2>NUL
for /f %%a in ('adb devices') do set modelid=%%a
if "%modelid%" == "List" (
cls
echo НЕТ ПОДКЛЮЧЕННЫХ УСТРОЙСТВ!
adb kill-server 2>NUL
echo.
echo Подключите своё устройство с adb
echo.
pause
goto check_adb
) ELSE (
echo Устройство успешно найдено
echo ID: %modelid%
goto start
)


:start
adb shell ip -f inet addr show wlan0 | findstr /R /C:"inet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" > tmp.txt
for /f "tokens=2 delims= " %%a in (tmp.txt) do set ip=%%a
set ip=%ip:~0,-3%
echo IP адрес вашего телефона: %ip%
del tmp.txt
echo.
set /p tcpport=Теперь введите порт на котором хотите запустить.Порт долен быть 4-х значным:
if "%tcpport:~3,1%"=="" (
    echo Порт должен содержать не менее 4 символов
)
if "%tcpport:~4,1%" neq "" (
    echo Порт должен содержать не более 4 символов
) ELSE (
    echo Отлично,начнём подключение
	goto connect
)


:connect
adb tcpip %tcpport%
adb connect %ip%:%tcpport%
echo Пожалуйста отключите устройство
pause
start scrcpy.exe -e
echo Нажмите на любую кнопку чтобы отключится
pause
goto disconnect

:disconnect
adb disconnect %ip%:%tcpport%
pause
