:: Name:     0_lasinfo_lotes.bat
:: Author:   rpinho@dgterritorio.pt
:: Revision: 2025.05.29
:: License: This code is distributed under AGPL-3.0 (GNU AFFERO GENERAL PUBLIC LICENSE Version 3)
::
:: Script para executar o comando lasinfo64 do lastools em multiplos ficheiros numa lista de pastas/caminhos
:: https://downloads.rapidlasso.de/html/lasinfo_README.html
::
:: Objetivo: Este script executa o relatório lasinfo para cada ficheiro laz num conjunto de pasta (lotes) indicadas numa lista de caminhos.
:: Ficheiro de texto CSV com a lista de um conjunto de nomes e caminhos, na variável: %lotelist%
:: Na pasta %lasinfodir%, são criados os ficheiros txt resultado do lasinfo numa subpasta para cada conjunto de ficheiros (caminho)
:: Pode ser aplicacado um filtro de classe, de inclusão ou exclusão
::
:: Mede o tempo de execução com o utilitario timer: https://www.gammadyne.com/timer.htm


@echo off
setlocal enabledelayedexpansion

set lasinfodir=0_lasinfo_lotes
set ncores=16
set lotelist=0_lasinfo_lotes_caminho.csv
REM opções de filtragem de classes: -keep_cass ou -drop_class
REM opção de -v verbose, relatar a execução de cada ficheiro
set opcoes=-keep_class 2 -v

IF EXIST %lasinfodir% (echo done) ELSE ( 
  mkdir %lasinfodir%
)

for /f "skip=1 usebackq tokens=1,2 delims=," %%a in (%lotelist%) do (
  echo %%a
  echo %%b
  
  IF EXIST %lasinfodir%\%%a_lasinfo (echo done) ELSE ( 
    mkdir %lasinfodir%\%%a_lasinfo
  )
  REM -keep_class 2 - manter só classe 2 = ground
  lasinfo64 -i %%b\*.laz -otxt -odir %lasinfodir%\%%a_lasinfo -odix _info %opcoes% -cores %ncores%
)

