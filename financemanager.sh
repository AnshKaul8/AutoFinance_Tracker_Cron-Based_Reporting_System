#!/bin/bash
BASE="/home/ansh-kaul/Desktop/personal_finance_manager"
EXP_FILE="$BASE/expenses.csv"
CAT_FILE="$BASE/categories.txt"
INV_FILE="$BASE/investments.csv"
LOG_FILE="$BASE/logs/finance_log.txt"

mkdir -p "$BASE/logs" 
mkdir -p "$BASE/reports"

daily_report() {
    today=$(date +%Y-%m-%d)
    report_file="$BASE/reports/daily_report.txt"

    echo "===== Daily Report: $today =====" > "$report_file"

    echo "" >> "$report_file"
    echo "----- TODAY'S EXPENSES -----" >> "$report_file"

    awk -F"," -v d="$today" '
    {
        t=$1
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", t)
    }
    t == d {
        printf "%s | %s | %s | ₹%s\n", $1, $2, $3, $4
    }
    ' "$EXP_FILE" >> "$report_file"

    echo "" >> "$report_file"
    echo "Total Spent Today:" >> "$report_file"

    awk -F"," -v d="$today" '
    {
        t=$1; gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", t)
    }
    t == d { total += $4 }
    END { printf "₹%d\n", total }
    ' "$EXP_FILE" >> "$report_file"

    echo "" >> "$report_file"
    echo "Category-wise Spending Today:" >> "$report_file"

    awk -F"," -v d="$today" '
    {
        t=$1; gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", t)
    }
    t == d { arr[$2] += $4 }
    END {
        for(i in arr)
            printf "%s : ₹%d\n", i, arr[i]
    }
    ' "$EXP_FILE" >> "$report_file"

    echo "Daily Report Updated: $report_file"
}

if [[ "$1" == "--daily-report" ]]; then
    daily_report
    exit
fi

graph_generate() {

    OUT="$BASE/reports"
    awk -F"," '{daily[$1] += $4} END {for (d in daily) print d, daily[d]}' \
        "$EXP_FILE" | sort > "$OUT/daily.dat"

    gnuplot -e "
    set terminal png size 1400,700;
    set output '$OUT/daily_spend.png';
    set title 'Daily Spending';
    set xlabel 'Date';
    set ylabel 'Amount (₹)';
    set xtics rotate by -45;
    set style data histograms;
    set style fill solid;
    plot '$OUT/daily.dat' using 2:xtic(1) title 'Amount';
    "

    echo "Graph Generated Successfully!"
}

add_expense() {
    echo "Enter date (YYYY-MM-DD): "; read date

    echo "Select Category:"
    nl -w2 -s". " "$CAT_FILE"
    read -p "Choice: " cno
    category=$(sed -n "${cno}p" "$CAT_FILE")

    echo "Enter Description:"; read desc
    echo "Enter Amount:"; read amount

    echo "$date,$category,$desc,$amount" >> "$EXP_FILE"
    echo "Expense Added Successfully!"
}

default_category_report() {
    echo "----- CATEGORY SPENDING -----"
    awk -F"," '{arr[$2]+=$4} END {for(i in arr) printf "%s : ₹%d\n", i, arr[i]}' "$EXP_FILE"
}

check_budget() {
    echo "Enter Monthly Expense Budget: "
    read mbudget

    echo "Enter Category to set limit (Food/Travel/Bills/...): "
    read cat_limit_name

    echo "Enter Category Limit Amount: "
    read cat_limit_amt

    echo "Enter Investment Budget Limit: "
    read inv_limit

    echo "----- Checking Budget -----"

    total=$(awk -F"," '{sum+=($4+0)} END {print sum+0}' $EXP_FILE)
cat_total=$(awk -F"," -v c="$cat_limit_name" '
        tolower($2)==tolower(c) {sum+=($4+0)}
        END {print sum+0}
    ' $EXP_FILE)

    inv_total=$(awk -F"," '{sum+=($3+0)} END {print sum+0}' $INV_FILE)

    echo "Total Spent: ₹$total"
    echo "$cat_limit_name Spent: ₹$cat_total"
    echo "Total Invested: ₹$inv_total"

    if [ "$cat_total" -gt "$cat_limit_amt" ]; then
        echo "ALERT: $cat_limit_name Category Limit Crossed!"
        echo "$(date) -- Category $cat_limit_name limit exceeded" >> $LOG_FILE
    else
        echo "OK: Category within limit."
    fi
 if [ "$inv_total" -gt "$inv_limit" ]; then
        echo "ALERT: Investment Budget Crossed!"
        echo "$(date) -- Investment budget exceeded" >> $LOG_FILE
    else
        echo "OK: Investment budget under control."
    fi
}


monthly_report() {
    month=$(date +%Y-%m)
    report="$BASE/reports/report_$month.txt"
    total=$(awk -F"," '{s+=$4} END {print s}' "$EXP_FILE")

    echo "===== Monthly Report: $month =====" > "$report"
    echo "Total Spent: ₹$total" >> "$report"

    echo "Saved to $report"
}

show_stats() {
    echo "----- DAILY -----"
    awk -F"," '{arr[$1]+=$4} END {for(i in arr) printf "%s : ₹%d\n", i, arr[i]}' "$EXP_FILE"

    echo "----- CATEGORY -----"
    awk -F"," '{arr[$2]+=$4} END {for(i in arr) printf "%s : ₹%d\n", i, arr[i]}' "$EXP_FILE"
}

investment_manager() {
    echo "Type (FD/Stocks/SIP):"; read t
    echo "Amount:"; read amount
    echo "Notes:"; read notes

    echo "$(date +%Y-%m-%d),$t,$amount,$notes" >> "$INV_FILE"
    echo "Investment Added!"
}

setup_cron() {
    script_path=$(realpath "$0")
    (crontab -l 2>/dev/null; echo "0 0 * * * bash $script_path --daily-report") | crontab -
    echo "Cron Job done"
}

while true; 
do
    clear
    echo "===== PERSONAL FINANCE MANAGER ====="
    echo "1. Add Expense"
    echo "2. Category-wise Report"
    echo "3. Check Budget"
    echo "4. Monthly Report"
    echo "5. Statistics"
    echo "6. Investment Manager"
    echo "7. Daily Cron Job"
    echo "8. Graphs"
    echo "9. Exit"
    echo "Choose option:"
    read ch

    case $ch in
        1) add_expense ;;
        2) default_category_report ;;
        3) check_budget ;;
        4) monthly_report ;;
        5) show_stats ;;
        6) investment_manager ;;
        7) setup_cron ;;
        8) graph_generate ;;
        9) echo "Exited Successfully!"; exit ;;
        *) echo "Invalid Choice!" ;;
    esac

    echo "Press Enter..."
    read dummy
done

