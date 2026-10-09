<<'Разработать сценарий, который для всех файлов с расширением txt в домашнем каталоге пользователz
-выведет список таких файлов
-выведет суммарный размер в байтах и строках для файлов с расширением txt'

#!/bin/bash

HOME_DIR="$HOME" 

total_files=0
total_bytes=0
total_lines=0

for i in "$HOME_DIR"/*.txt; do
    echo "$i"

    bytes=$(wc -c < "$f")  
    lines=$(wc -l < "$f")  

    total_files=$((total_files + 1))
    total_bytes=$((total_bytes + bytes))
    total_lines=$((total_lines + lines))
done

echo "Всего файлов: $total_files"
echo "Суммарный размер: $total_bytes байт"
echo "Суммарное количество строк: $total_lines"