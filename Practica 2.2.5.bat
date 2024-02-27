@echo off
:menu
cls
echo.
echo ============MENU PRINCIPAL============
echo 1. Registro
echo 2. Inicio de sesion
echo 3. Salir
echo =======================================
echo.

set /p opcion=Ingrese la operacion que quiera realizar:

if "%opcion%"=="1" goto register
if "%opcion%"=="2" goto login
if "%opcion%"=="3" goto exit

echo Opcion invalida, intente de nuevo, pulsa cualquier tecla para volver al menu.
pause
    goto menu


:register
cls
echo Registrarse:
set /p usuario=Ingrese su nombre de usuario:
set /p contrasena=Ingrese su contrasena:
set /p contrasena1=Ingrese de nuevo su contrasena:

if "%contrasena%" NEQ "%contrasena1%" (
	echo Las contrasenas no coinciden. Vuelva a intentarlo.
    timeout /nobreak /t 2 >nul
	goto register
)

echo %usuario%:%contrasena% >> usuarios.txt
echo Usuario registrado con exito.
pause
goto menu

:login
cls
echo Iniciar Sesion:
set /p usuario_ingresado=Ingrese su nombre de usuario: 
findstr /i /c:"%usuario_ingresado%:" usuarios.txt >nul
if %errorlevel% equ 0 (
    goto contra
) else (
    echo El nombre de usuario no se encuentra.
    goto errorinicio
    timeout /nobreak /t 2>nul
)
:errorinicio
    echo ***************************************
    echo 1. Regresar al menu principal
    echo 2. Volver a intentarlo
    echo ***************************************
    set /p decision= ¿Que desea hacer?:
    if "%decision%"=="1" goto menu
    if "%decision%"=="2" goto login

:contra
set /p contrasena2=Ingrese su contrasena: 

findstr /i /c:"%contrasena2%" usuarios.txt >nul
if %errorlevel% equ 0 (
    goto user_menu_options
) else (  
    echo La contrasena es incorrecta.
    timeout /nobreak /t 2 >nul 
    call :menu

)

:user_menu
set username=%1

:user_menu_options
cls
echo Opciones para %usuario%:
echo a. Modificar contrasena
echo b. Eliminar usuario
echo c. Cerrar sesion

set /p user_option=Seleccione una opcion: 

if /i "%user_option%"=="a" (
    call :change_password %usuario%
) else if /i "%user_option%"=="b" (
    call :delete_user %usuario%
    goto menu
) else if /i "%user_option%"=="c" (
    goto menu
) else (
    echo Opción no válida. Inténtelo de nuevo.
    timeout /nobreak /t 2 >nul
    goto user_menu_options
)

:change_password
set username=%1
cls
echo Modificar contrasena para %usuario%:
set /p new_password=Ingrese la nueva contrasena: 

rem Actualizar la contraseña en el archivo usuarios.txt
(for /f "tokens=1,* delims=:" %%a in (usuarios.txt) do (
    if %usuario% equ %%a (
        echo %usuario%:%newpassword% >> usuarios.txt
    ) ))
move /y usuarios_temp.txt usuarios.txt

echo La contrasena modificada con exito.
timeout /nobreak /t 2 >nul
goto user_menu

:delete_user
set username=%1

rem Eliminar al usuario del archivo usuarios.txt
findstr /v /c:%usuario%:%contrasena% usuarios.txt > usuarios.tmp
move /y usuarios.tmp usuarios.txt
echo Usuario eliminado correctamente.
pause
goto menu 
:exit
echo Gracias por usar el programa
pause
timeout /nobreak /t 1>nul
