#!/bin/bash

# This script runs a suite of difficult test cases for the 'bakery' C program.
# It automatically verifies output where possible and provides a final score.
#
# Assumes the compiled 'bakery' executable is in the current directory.
# MODIFIED: This version writes test data to 'input.txt' for each run,
# instead of using standard input redirection.

# --- Configuration ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
TIMEOUT_SECONDS=90

# --- State ---
passed_count=0
failed_count=0
total_tests=0
passed_tests=()
failed_tests=()

# --- Setup ---
if [ ! -f "./bakery" ]; then
    echo -e "${RED}Error: The './bakery' executable was not found."
    echo -e "Please compile your C program first (e.g., gcc bakery.c -o bakery -lpthread)${NC}"
    exit 1
fi

# --- Test Runner Function ---
run_test() {
    local test_num=$1
    local description=$2
    local input_data=$3
    local verify_cmd=$4
    local manual_verify_prompt=$5
    # The output file is still unique for each test's log
    local output_file="output${test_num}.log"

    total_tests=$((total_tests + 1))
    echo -e "${YELLOW}--- Running Test Case ${test_num}: ${description} ---${NC}"
    
    # --- MODIFICATION START ---
    # Always write to a fixed 'input.txt' file, which your program will read.
    echo -e "$input_data" > "input.txt"
    # --- MODIFICATION END ---

    # --- MODIFICATION START ---
    # Run the program without input redirection ('<'). Your program is expected
    # to open and read 'input.txt' on its own. Output is still captured.
    timeout $TIMEOUT_SECONDS ./bakery > "$output_file" 2>&1
    # --- MODIFICATION END ---
    local exit_code=$?

    local success=0

    if [ $exit_code -eq 124 ]; then
        echo -e "Result: ${RED}FAILED (Timeout - Potential Deadlock)${NC}"
    elif [ $exit_code -ne 0 ]; then
        echo -e "Result: ${RED}FAILED (Program Crashed - Exit Code $exit_code)${NC}"
    else
        # Execute the verification command
        if eval "$verify_cmd"; then
            echo -e "Result: ${GREEN}PASSED (Automated Check)${NC}"
            success=1
        else
            echo -e "Result: ${RED}FAILED (Automated Check)${NC}"
        fi
    fi

    if [ $success -eq 1 ]; then
        passed_count=$((passed_count + 1))
        passed_tests+=("Test ${test_num}: ${description}")
    else
        failed_count=$((failed_count + 1))
        failed_tests+=("Test ${test_num}: ${description}")
        echo -e "${YELLOW}--- Failure Details for Test ${test_num} ---${NC}"
        echo "Verification command failed: [ $verify_cmd ]"
        echo "--- Full Output (output${test_num}.log) ---"
        cat "${output_file}"
        echo -e "${YELLOW}--------------------------------------${NC}"
    fi

    echo -e "Manual Verification: ${manual_verify_prompt}"
    echo -e "See '${output_file}' for full output.\n"
    sleep 1 # Small delay between tests
}

# --- Test Case Definitions ---

run_test 1 "Overload Capacity" \
"$(for i in {1..30}; do echo "1 Customer 1$i"; done)
<EOF>" \
"enters_count=\$(grep -c 'enters' output1.log || echo 0); leaves_count=\$(grep -c 'leaves' output1.log || echo 0); [ \"\$enters_count\" -eq 25 ] && [ \"\$leaves_count\" -eq 25 ]" \
"Ensure exactly 25 customers enter and are served. The rest are rejected."

run_test 2 "Sofa and Standing Logic" \
"1 Customer 201
1 Customer 202
1 Customer 203
1 Customer 204
2 Customer 205
2 Customer 206
<EOF>" \
"sits_count=\$(grep -c 'sits' output2.log || echo 0); [ \"\$sits_count\" -eq 6 ]" \
"Verify the 5th and 6th customers 'sit' only after the first customers leave."

run_test 3 "FIFO Sofa Service" \
"1 Customer 301
1 Customer 302
1 Customer 303
1 Customer 304
5 Customer 305
<EOF>" \
"first_bake_ts=\$(grep 'bakes for Customer 30[1-4]' output3.log | awk '{print \$1}' | sort -n | head -n1); bake_for_305_ts=\$(grep 'bakes for Customer 305' output3.log | awk '{print \$1}'); [ -z \"\$bake_for_305_ts\" ] || [ \"\$bake_for_305_ts\" -gt \"\$first_bake_ts\" ]" \
"Verify that C305 (who arrives later) is baked for *after* the initial batch."

run_test 4 "Staggered Arrival and Continuous Flow" \
"1 Customer 401
2 Customer 402
3 Customer 403
4 Customer 404
5 Customer 405
<EOF>" \
"leaves_count=\$(grep -c 'leaves' output4.log || echo 0); [ \"\$leaves_count\" -eq 5 ]" \
"Check for smooth, sequential processing without deadlocks on staggered arrivals."

# ** THIS TEST CASE IS NOW CORRECTED **
run_test 5 "Payment Bottleneck Stress Test" \
"1 Customer 501
1 Customer 502
1 Customer 503
1 Customer 504
<EOF>" \
"[ \$(grep 'accepts payment' output5.log | awk '{print \$1}' | uniq -c | awk '\$1 > 1' | wc -l) -eq 0 ]" \
"Verify no two 'accepts payment' actions occur at the same timestamp, proving mutex."

run_test 6 "Sofa Reservation Lock" \
"1 Customer 601
1 Customer 602
1 Customer 603
1 Customer 604
2 Customer 605
<EOF>" \
"first_leave_ts=\$(grep 'Customer 60[1-4] leaves' output6.log | awk '{print \$1}' | sort -n | head -n1); sit_ts=\$(grep 'Customer 605 sits' output6.log | awk '{print \$1}'); [ -n \"\$first_leave_ts\" ] && [ -n \"\$sit_ts\" ] && [ \"\$sit_ts\" -ge \"\$first_leave_ts\" ]" \
"Verify Customer 605 does not 'sit' until *after* one of the original four 'leaves'."

run_test 7 "Boundary Capacity Race Condition" \
"$(for i in {1..24}; do echo "1 Customer 8$i"; done)
10 Customer 825
10 Customer 826
<EOF>" \
"enters_count=\$(grep -c 'enters' output7.log || echo 0); leaves_count=\$(grep -c 'leaves' output7.log || echo 0); [ \"\$enters_count\" -eq 25 ] && [ \"\$leaves_count\" -eq 25 ]" \
"With one spot left, two customers arrive. Verify only one enters, preventing a race."

run_test 8 "High Churn" \
"1 Customer 901
1 Customer 902
1 Customer 903
1 Customer 904
8 Customer 905
8 Customer 906
8 Customer 907
8 Customer 908
<EOF>" \
"leaves_count=\$(grep -c 'leaves' output8.log || echo 0); [ \"\$leaves_count\" -eq 8 ]" \
"Tests smooth operation as the first wave of customers leaves and the second arrives."

run_test 9 "Idle Period (The Lull)" \
"1 Customer 1001
1 Customer 1002
20 Customer 1003
20 Customer 1004
<EOF>" \
"leaves_count=\$(grep -c 'leaves' output9.log || echo 0); [ \"\$leaves_count\" -eq 4 ]" \
"Tests if the system handles a long idle period and resumes without deadlock."

run_test 10 "The Flash Crowd" \
"$(for i in {1..25}; do echo "1 Customer 11$i"; done)
10 Customer 1126
10 Customer 1127
<EOF>" \
"enters_count=\$(grep -c 'enters' output10.log || echo 0); leaves_count=\$(grep -c 'leaves' output10.log || echo 0); [ \"\$enters_count\" -eq 25 ] && [ \"\$leaves_count\" -eq 25 ]" \
"Fills bakery to capacity instantly, tests stability and subsequent rejections."

run_test 11 "Strict Chef Priority (Payment vs. Bake)" \
"1 Customer 1201
# Wait for 1201 to finish baking and need payment
3 Customer 1202
<EOF>" \
"payment_ts=\$(grep 'accepts payment for Customer 1201' output11.log | awk '{print \$1}'); bake_ts=\$(grep 'bakes for Customer 1202' output11.log | awk '{print \$1}'); [ -n \"\$payment_ts\" ] && [ -n \"\$bake_ts\" ] && [ \"\$payment_ts\" -le \"\$bake_ts\" ]" \
"At t=3, a chef is free. C1201 needs payment, C1202 needs baking. Verify payment is prioritized."

run_test 12 "Resource Cycling Hell" \
"$(for i in {1..4}; do echo "$i Customer 140$i"; done)
$(for i in {8..11}; do echo "$i Customer 141$i"; done)
$(for i in {12..15}; do echo "$i Customer 142$i"; done)
<EOF>" \
"leaves_count=\$(grep -c 'leaves' output12.log || echo 0); [ \"\$leaves_count\" -eq 12 ]" \
"Tests stability under high resource turnover (sofas, capacity, ovens all cycling rapidly)."

run_test 13 "Max Concurrent Baking" \
"$(for i in {1..8}; do echo "1 Customer 13$((i))"; done)\n<EOF>" \
"max_bakes=\$(awk '/bakes for Customer/ {c[\$1]++} END {m=0; for(i in c) if(c[i]>m) m=c[i]; print m+0}' output13.log || echo 0); [ \"\$max_bakes\" -le 4 ]" \
"Verify no more than 4 bakes start at the same timestamp (oven limit)."

run_test 14 "Pay Before Accept" \
"1 Customer 1401
1 Customer 1402
<EOF>" \
"pay1=\$(grep -m1 'Customer 1401 pays' output14.log | awk '{print \$1}' || true); acc1=\$(grep -m1 'accepts payment for Customer 1401' output14.log | awk '{print \$1}' || true); pay2=\$(grep -m1 'Customer 1402 pays' output14.log | awk '{print \$1}' || true); acc2=\$(grep -m1 'accepts payment for Customer 1402' output14.log | awk '{print \$1}' || true); [ -n \"\$pay1\" ] && [ -n \"\$acc1\" ] && [ \"\$pay1\" -le \"\$acc1\" ] && [ -n \"\$pay2\" ] && [ -n \"\$acc2\" ] && [ \"\$pay2\" -le \"\$acc2\" ]" \
"Verify each customer 'pays' (initiates payment) before a chef 'accepts payment' for them."

run_test 15 "Sofa Capacity Enforcement" \
"$(for i in {1..10}; do echo "1 Customer 15$((i))"; done)\n<EOF>" \
"max_sits=\$(awk '/sits/ {c[\$1]++} END {m=0; for(i in c) if(c[i]>m) m=c[i]; print m+0}' output15.log || echo 0); [ \"\$max_sits\" -le 4 ]" \
"Verify no more than 4 customers 'sit' at the same timestamp (sofa size)."


# --- Final Report ---
echo -e "\n${YELLOW}--- Test Suite Complete ---${NC}\n--- Summary ---"
echo "Total Tests: ${total_tests}"
echo -e "${GREEN}Passed: ${passed_count}${NC}"
echo -e "${RED}Failed: ${failed_count}${NC}"

if [ $total_tests -gt 0 ]; then
    score=$(echo "scale=2; ($passed_count / $total_tests) * 100" | bc)
    echo -e "Final Score: ${score}%"
fi
echo

if [ ${#passed_tests[@]} -gt 0 ]; then
    echo -e "${GREEN}Passing Tests:${NC}"; for test in "${passed_tests[@]}"; do echo "  - ${test}"; done
fi

if [ ${#failed_tests[@]} -gt 0 ]; then
    echo -e "${RED}Failing Tests:${NC}"; for test in "${failed_tests[@]}"; do echo "  - ${test}"; done
fi
echo

# --- Cleanup ---
echo "Done."
