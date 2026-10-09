#!/bin/bash

fmt="txt"
gen_sql=0

while getopts ":f:g" opt; do
    case "$opt" in
        f) fmt="$OPTARG" ;;
        g) gen_sql=1 ;;
        \?) echo "Неизвестная опция: -$OPTARG" >&2; exit 1 ;;
        :)  echo "Опция -$OPTARG требует аргумент" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
    echo "Использование: $0 [-f csv] [-g] <file.csv>" >&2
    exit 1
fi

CSV="$1"

#метрики
read total avg count max < <(awk -F, ' 
    NR > 1 && $3 != "" {
        sum += $3
        n++
        if ($3 > max) max = $3
    }
    END {
        if (n > 0) printf "%.2f %.2f %d %.2f\n", sum, sum/n, n, max
        else       printf "0 0 0 0\n"
    }
' "$CSV")


if [ "$fmt" = "csv" ]; then #отчет
    {
        echo "total,avg,max,count"
        printf "%s,%.2f,%.2f,%s\n" "$total" "$avg" "$max" "$count"
    } | tee sales_report.csv
else
    {
        echo "Общая сумма продаж: $total"
        echo "Средняя стоимость продажи: $avg"
        echo "Самая дорогая продажа: $max"
        echo "Количество продаж: $count"
    } | tee sales_report.txt
fi


if [ "$gen_sql" -eq 1 ]; then
    cat > sales_report.sql <<EOF
CREATE TABLE IF NOT EXISTS sales_report (
    total NUMERIC(12,2),
    avg   NUMERIC(12,2),
    max   NUMERIC(12,2),
    count INTEGER
);
\\copy sales_report(total, avg, max, count) FROM 'sales_report.csv' WITH (FORMAT csv, HEADER true);
EOF
    echo "SQL сохранён: sales_report.sql" >&2
fi

exit 0