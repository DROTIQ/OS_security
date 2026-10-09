<<'Изучите обработку опций в скрипте с помощью getopt/getopts. Написать
скрипт smart_calc.sh, который:
1.принимает опции:
-h — выводит справку.
-v — включает подробный вывод.
-o <file> — указывает файл для вывода.
2.после опций обрабатывает оставшиеся параметры как числа для
вычисления;
3.выполняет операции сложения, умножения, вычитания, возведения в
степень, деления в зависимости от опции;
4.выводит результат/'

#!/bin/bash

usage() {
    cat <<EOF
Использование: $0 [-h] [-v] [-o file] [-p op] число1 число2 ...
  -h        справка
  -v        подробный вывод
  -o file   файл для вывода результата
  -p op     операция: add | sub | mul | div | pow (по умолчанию add)
EOF
}

verbose=""
outfile=""
op="add"

while getopts ":hvo:p:" opt; do
    case $opt in
        h) usage; exit 0 ;;
        v) verbose=1 ;;
        o) outfile="$OPTARG" ;;
        p) op="$OPTARG" ;;
        \?) echo "Неизвестная опция: -$OPTARG" >&2; exit 1 ;;
        :)  echo "Опция -$OPTARG требует аргумент" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

[ $# -lt 2 ] && { echo "Ошибка: нужно минимум два числа" >&2; exit 1; }

result=$1
shift

case "$op" in
    add) for n in "$@"; do result=$((result + n)); done ;;
    sub) for n in "$@"; do result=$((result - n)); done ;;
    mul) for n in "$@"; do result=$((result * n)); done ;;
    div) for n in "$@"; do
             [ "$n" -eq 0 ] && { echo "Ошибка: деление на ноль" >&2; exit 1; }
             result=$((result / n))
         done ;;
    pow) for n in "$@"; do result=$((result ** n)); done ;;
    *)   echo "Неизвестная операция: $op" >&2; exit 1 ;;
esac

[ -n "$verbose" ] && output="Операция: $op; Результат: $result" || output="$result"
[ -n "$outfile" ] && exec > "$outfile"
echo "$output"