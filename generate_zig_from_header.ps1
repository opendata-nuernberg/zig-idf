C:\Tools\zig-relsafe-x86_64-windows-baseline\zig.exe translate-c `
    -lc `
    -target xtensa-freestanding-none `
    -mcpu=esp32 `
    -D ESP_PLATFORM `
    -I ../build/config `
    -I $env:IDF_PATH\components\esp_common\include `
    -I $env:IDF_PATH\components\freertos\esp_additions\include `
    -I $env:IDF_PATH\components\freertos\FreeRTOS-Kernel\include `
    -I $env:IDF_PATH\components\freertos\config\include\freertos `
    -I $env:IDF_PATH\components\freertos\config\xtensa\include `
    -I $env:IDF_PATH\components\xtensa\include `
    -I $env:IDF_PATH\components\xtensa\esp32\include `
    -I $env:IDF_PATH\components\newlib\platform_include `
    -I $env:ESP_ROM_ELF_DIR\..\..\xtensa-esp-elf\esp-14.2.0_20240906\xtensa-esp-elf\xtensa-esp-elf\include `
    -I $env:IDF_PATH\components\freertos\FreeRTOS-Kernel\portable\xtensa\include\freertos `
    -I $env:IDF_PATH\components\esp_hw_support\include `
    -I $env:IDF_PATH\components\soc\esp32\include `
    -I $env:IDF_PATH\components\esp_system\include `
    -I $env:IDF_PATH\components\soc\esp32\register `
    -I $env:IDF_PATH\components\heap\include `
    -I $env:IDF_PATH\components\esp_rom\include `
    -D __XTENSA__=true `
    $env:IDF_PATH\components\esp_event\include\esp_event.h `
    > .\imports\event.zig