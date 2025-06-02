:: Name:     1_boundaries_blocos_shp.bat
:: Author:   rpinho@dgterritorio.pt
:: Revision: 2025.02.22
:: License: This code is distributed under AGPL-3.0 (GNU AFFERO GENERAL PUBLIC LICENSE Version 3)
::
:: Objetivo: Este script cria os limites dos ficheiros laz em shp file no final agrega todos todos num único ficheiro gpkg.
:: Verifica ainda se o ficheiro gpkg já existe na pasta destino, se existir passa à frente.

@echo off
setlocal enabledelayedexpansion

set boundariesdir=1_boundaries_lotes
set ncores=16
set lotelist=1_lasboundaries_lotes_caminho.csv


for /f "skip=1 usebackq tokens=1,2 delims=," %%a in (%lotelist%) do (
  echo %%a
  
  IF EXIST %boundariesdir%\%%a.gpkg (echo done) ELSE (
    
    mkdir %boundariesdir%\boundaries_%%a
	
    lasboundary64 -epsg 3763 -v -labels -labels_file_name_full -only_2d -cores %ncores% -i %%b\*.laz -odir %boundariesdir%\boundaries_%%a
	
    ogrmerge -single -progress -f GPKG -a_srs EPSG:3763 -o %boundariesdir%\%%a.gpkg %boundariesdir%\boundaries_%%a\*.shp
  )
)

ogrmerge -single -progress -overwrite_ds -f GPKG -a_srs EPSG:3763 ^
-o %boundariesdir%\boundaries_lotes.gpkg ^
%boundariesdir%\lote*.gpkg -src_layer_field_name lote -nln boundaries_lote