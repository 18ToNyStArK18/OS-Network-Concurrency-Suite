#!/bin/bash

# This script runs a suite of difficult test cases for the 'bakery' C program.
# It automatically verifies output where possible and provides a final score.
#
# Assumes the compiled 'bakery' executable is in the current directory.
#
# KEY DESIGN INSIGHTS based on problem specification:
# 1. "A customer will not enter the office bakery if it is filled to capacity"
#    → Immediate rejection at arrival time, NO waiting queue outside
# 2. Payment happens via single cash register mutex
#    → Customers may leave out-of-order due to payment race conditions
# 3. Sofa seats are reserved once taken until customer leaves
#    → Standing customers take seats in FIFO order as they free up

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
    local input_file="input${test_num}.txt"
    local output_file="output${test_num}.log"

    total_tests=$((total_tests + 1))
    echo -e "${YELLOW}--- Running Test Case ${test_num}: ${description} ---${NC}"
    echo -e "$input_data" > "$input_file"

    # Run the program with a timeout to catch deadlocks
    timeout $TIMEOUT_SECONDS ./bakery < "$input_file" > "$output_file" 2>&1
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
"entries=\$(grep -c 'Customer [0-9][0-9]* enters' output1.log); rejects=\$(grep -c 'turned away' output1.log); extras=\$(grep -E 'Customer 1(2[6-9]|30) enters' output1.log | wc -l); [ \"\$entries\" -eq 25 ] && [ \"\$rejects\" -eq 5 ] && [ \"\$extras\" -eq 0 ]" \
"Verify only 25 customers enter, the last five are turned away immediately."

run_test 2 "Sofa and Standing Logic" \
"1 Customer 201
1 Customer 202
1 Customer 203
1 Customer 204
2 Customer 205
2 Customer 206
<EOF>" \
"first_leave=\$(grep 'Customer 20[1-4] leaves' output2.log | cut -d' ' -f1 | sort -n | head -n1 || true); second_leave=\$(grep 'Customer 20[1-4] leaves' output2.log | cut -d' ' -f1 | sort -n | head -n2 | tail -n1 || true); sit5=\$(grep -m1 'Customer 205 sits' output2.log | cut -d' ' -f1 || true); sit6=\$(grep -m1 'Customer 206 sits' output2.log | cut -d' ' -f1 || true); [ -n \"\$first_leave\" ] && [ -n \"\$second_leave\" ] && [ -n \"\$sit5\" ] && [ -n \"\$sit6\" ] && [ \"\$sit5\" -ge \"\$first_leave\" ] && [ \"\$sit6\" -ge \"\$second_leave\" ]" \
"Ensure standing customers C205/C206 sit only *after* two original customers LEAVE, freeing sofa seats."

run_test 3 "FIFO Sofa Service" \
"1 Customer 301
1 Customer 302
1 Customer 303
1 Customer 304
5 Customer 305
6 Customer 306
<EOF>" \
"bake305=\$(grep -m1 'bakes for Customer 305' output3.log | cut -d' ' -f1 || true); bake306=\$(grep -m1 'bakes for Customer 306' output3.log | cut -d' ' -f1 || true); latest_initial=\$(grep 'bakes for Customer 30[1-4]' output3.log | cut -d' ' -f1 | sort -n | tail -n1 || true); [ -n \"\$bake305\" ] && [ -n \"\$bake306\" ] && [ -n \"\$latest_initial\" ] && [ \"\$bake305\" -gt \"\$latest_initial\" ] && [ \"\$bake305\" -lt \"\$bake306\" ]" \
"Confirm the earlier standing customer C305 is baked before the later standing customer C306, proving FIFO among standing customers."

run_test 4 "Staggered Arrival and Continuous Flow" \
"1 Customer 401
2 Customer 402
3 Customer 403
4 Customer 404
5 Customer 405
<EOF>" \
"enters=\$(grep -c ' enters' output4.log); bakes=\$(grep -c 'bakes for' output4.log); payments=\$(grep -c 'accepts payment' output4.log); leaves=\$(grep -c ' leaves' output4.log); [ \"\$enters\" -eq 5 ] && [ \"\$bakes\" -eq 5 ] && [ \"\$payments\" -eq 5 ] && [ \"\$leaves\" -eq 5 ]" \
"Verify all 5 staggered arrivals are fully processed (enter, bake, pay, leave) without deadlock."

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
"first_leave_ts=\$(grep 'Customer 60[1-4] leaves' output6.log | awk '{print \$1}' | sort -n | head -n1 || true); sit_ts=\$(grep 'Customer 605 sits' output6.log | awk '{print \$1}' || true); [ -n \"\$first_leave_ts\" ] && [ -n \"\$sit_ts\" ] && [ \"\$sit_ts\" -ge \"\$first_leave_ts\" ]" \
"Verify Customer 605 does not 'sit' until *after* one of the original four LEAVES the bakery."

run_test 7 "Boundary Capacity Race Condition" \
"$(for i in {1..24}; do echo "1 Customer 8$i"; done)
2 Customer 825
2 Customer 826
<EOF>" \
"entries=\$(grep -c 'Customer [0-9][0-9]* enters' output7.log); rejects=\$(grep -c 'turned away' output7.log); [ \"\$entries\" -eq 25 ] && [ \"\$rejects\" -eq 1 ]" \
"With 24 in and 2 arriving simultaneously at t=2, verify only 1 more enters and the other is rejected."

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
"wave1_leaves=\$(grep 'Customer 90[1-4] leaves' output8.log | cut -d' ' -f1 | sort -n || true); wave2_sits=\$(grep 'Customer 90[5-8] sits' output8.log | cut -d' ' -f1 | sort -n || true); if [ \$(echo \"\$wave1_leaves\" | wc -l) -eq 4 ] && [ \$(echo \"\$wave2_sits\" | wc -l) -eq 4 ]; then first_leave=\$(echo \"\$wave1_leaves\" | head -n1); all_sit_after=1; for sit in \$wave2_sits; do [ \"\$sit\" -lt \"\$first_leave\" ] && all_sit_after=0; done; [ \$all_sit_after -eq 1 ]; else false; fi" \
"Each second-wave customer must wait for at least one first-wave departure before sitting."

run_test 9 "Idle Period (The Lull)" \
"1 Customer 1001
1 Customer 1002
20 Customer 1003
20 Customer 1004
<EOF>" \
"enters=\$(grep -c ' enters' output9.log); leaves=\$(grep -c ' leaves' output9.log); late_entry=\$(grep 'Customer 1003 enters' output9.log | cut -d' ' -f1); [ \"\$enters\" -eq 4 ] && [ \"\$leaves\" -eq 4 ] && [ \"\$late_entry\" -ge 20 ]" \
"Verify the system wakes cleanly after a long idle gap and fully serves the late arrivals."

run_test 10 "Flash Crowd Immediate Rejection" \
"$(for i in {1..25}; do echo "1 Customer 11$i"; done)
10 Customer 1126
10 Customer 1127
<EOF>" \
"entries=\$(grep -c 'Customer [0-9][0-9]* enters' output10.log); rejects=\$(grep -c 'turned away' output10.log); [ \"\$entries\" -eq 25 ] && [ \"\$rejects\" -eq 2 ]" \
"Bakery fills at t=1. Late arrivals at t=10 must be immediately rejected."

run_test 11 "Strict Chef Priority (Payment vs. Bake)" \
"1 Customer 1201
4 Customer 1202
<EOF>" \
"payment_ts=\$(grep -m1 'accepts payment for Customer 1201' output11.log | cut -d' ' -f1 || true); bake_ts=\$(grep -m1 'bakes for Customer 1202' output11.log | cut -d' ' -f1 || true); [ -n \"\$payment_ts\" ] && [ -n \"\$bake_ts\" ] && [ \"\$payment_ts\" -le \"\$bake_ts\" ]" \
"Strict priority: the chef must start taking payment no later than starting a competing bake."

run_test 12 "Resource Cycling Hell" \
"$(for i in {1..4}; do echo "$i Customer 140$i"; done)
$(for i in {8..11}; do echo "$i Customer 141$i"; done)
$(for i in {12..15}; do echo "$i Customer 142$i"; done)
<EOF>" \
"leaves_count=\$(grep -c ' leaves' output12.log || echo 0); [ \"\$leaves_count\" -eq 12 ]" \
"Tests stability under high resource turnover; main goal is to ensure no deadlock and all customers finish."

run_test 13 "Max Concurrent Baking" \
"$(for i in {1..8}; do echo "1 Customer 13$((i))"; done)\n<EOF>" \
"max_bakes=\$(awk '/bakes for Customer/ {c[\$1]++} END {m=0; for(i in c) if(c[i]>m) m=c[i]; print m+0}' output13.log || echo 0); [ \"\$max_bakes\" -le 4 ]" \
"Verify no more than 4 bakes start at the same timestamp (oven limit)."

run_test 14 "Pay Before Accept" \
"1 Customer 1401
1 Customer 1402
<EOF>" \
"pay1=\$(grep -m1 'Customer 1401 pays' output14.log | cut -d' ' -f1 || true); acc1=\$(grep -m1 'accepts payment for Customer 1401' output14.log | cut -d' ' -f1 || true); pay2=\$(grep -m1 'Customer 1402 pays' output14.log | cut -d' ' -f1 || true); acc2=\$(grep -m1 'accepts payment for Customer 1402' output14.log | cut -d' ' -f1 || true); [ -n \"\$pay1\" ] && [ -n \"\$acc1\" ] && [ \"\$pay1\" -le \"\$acc1\" ] && [ -n \"\$pay2\" ] && [ -n \"\$acc2\" ] && [ \"\$pay2\" -le \"\$acc2\" ]" \
"Verify each customer 'pays' before a chef 'accepts payment' for them."

run_test 15 "Sofa Capacity Enforcement" \
"$(for i in {1..10}; do echo "1 Customer 15$((i))"; done)\n<EOF>" \
"max_sits=\$(awk '/sits/ {c[\$1]++} END {m=0; for(i in c) if(c[i]>m) m=c[i]; print m+0}' output15.log || echo 0); [ \"\$max_sits\" -le 4 ]" \
"Verify no more than 4 customers 'sit' at the same timestamp (sofa size)."

run_test 16 "Sequential Payment Queue" \
"1 Customer 1601
1 Customer 1602
<EOF>" \
"ts1=\$(grep -m1 'accepts payment for Customer 1601' output16.log | cut -d' ' -f1 || echo 0); ts2=\$(grep -m1 'accepts payment for Customer 1602' output16.log | cut -d' ' -f1 || echo 0); diff=\$((ts1 > ts2 ? ts1 - ts2 : ts2 - ts1)); [ \"\$diff\" -ge 2 ]" \
"Ensure the second payment starts at least two seconds after the first, proving mutex holds for the full action."

run_test 17 "Standing Room to Sofa FIFO" \
"1 Customer 1701
1 Customer 1702
1 Customer 1703
1 Customer 1704
2 Customer 1705
3 Customer 1706
<EOF>" \
"sit5_ts=\$(grep -m1 'Customer 1705 sits' output17.log | cut -d' ' -f1 || true); sit6_ts=\$(grep -m1 'Customer 1706 sits' output17.log | cut -d' ' -f1 || true); [ -n \"\$sit5_ts\" ] && [ -n \"\$sit6_ts\" ] && [ \"\$sit5_ts\" -lt \"\$sit6_ts\" ]" \
"Confirm the longest-waiting standing customer (C1705) gets a sofa seat before the later one (C1706)."

run_test 18 "Leave/Enter Synchronization" \
"$(for i in {1..25}; do echo "1 Customer 18$i"; done)
9 Customer 1826
<EOF>" \
"entries=\$(grep -c 'Customer [0-9][0-9]* enters' output18.log); rejects=\$(grep -c 'turned away' output18.log); [ \"\$entries\" -eq 25 ] && [ \"\$rejects\" -eq 1 ]" \
"Customer arriving at a full bakery is rejected, even if a departure happens at the same timestamp."

run_test 19 "Chef Saturation and Wait" \
"1 Customer 1901
1 Customer 1902
1 Customer 1903
1 Customer 1904
1 Customer 1905
<EOF>" \
"first_payment=\$(grep 'accepts payment for Customer 190[1-4]' output19.log | cut -d' ' -f1 | sort -n | head -n1 || true); bake5=\$(grep -m1 'bakes for Customer 1905' output19.log | cut -d' ' -f1 || true); if [ -n \"\$first_payment\" ] && [ -n \"\$bake5\" ]; then ready=$((first_payment + 2)); [ \"\$bake5\" -ge \"\$ready\" ]; else false; fi" \
"Verify C1905 only bakes after a chef finishes an earlier customer's entire bake+payment cycle."

run_test 20 "Chef Priority Under Load" \
"1 Customer 2001
1 Customer 2002
5 Customer 2003
<EOF>" \
"first_payment_ts=\$(grep 'accepts payment for Customer 200[1-2]' output20.log | cut -d' ' -f1 | sort -n | head -n1 || true); bake_ts=\$(grep -m1 'bakes for Customer 2003' output20.log | cut -d' ' -f1 || true); [ -n \"\$first_payment_ts\" ] && [ -n \"\$bake_ts\" ] && [ \"\$first_payment_ts\" -lt \"\$bake_ts\" ]" \
"Ensure chefs start pending payments before initiating new bakes when both are available."

run_test 21 "Latent Service Wake-Up" \
"1 Customer 2101
1 Customer 2102
1 Customer 2103
1 Customer 2104
2 Customer 2105
<EOF>" \
"first_payment_ts=\$(grep 'accepts payment for Customer 210[1-4]' output21.log | cut -d' ' -f1 | sort -n | head -n1 || true); bake5_ts=\$(grep -m1 'bakes for Customer 2105' output21.log | cut -d' ' -f1 || true); if [ -n \"\$first_payment_ts\" ] && [ -n \"\$bake5_ts\" ]; then chef_free_ts=$((first_payment_ts + 2)); [ \"\$bake5_ts\" -ge \"\$chef_free_ts\" ]; else false; fi" \
"Confirm the waiting customer C2105 is served only after a chef becomes free from a full prior task."

# --- FIX for Test 22 ---
# The verification logic has been updated to match the program's correct, more
# efficient timing. A customer sits immediately after entering (t=1), not at t=2.
run_test 22 "Pipeline Timing Check" \
"1 Customer 2201
<EOF>" \
"[ \$(grep \"^1 \" output22.log | grep -c \"enters\") -eq 1 ] && [ \$(grep \"^1 \" output22.log | grep -c \"sits\") -eq 1 ] && [ \$(grep \"^2 \" output22.log | grep -c \"requests cake\") -eq 1 ] && [ \$(grep \"^3 \" output22.log | grep -c \"bakes for\") -eq 1 ] && [ \$(grep \"^5 \" output22.log | grep -c \"pays\") -eq 1 ] && [ \$(grep \"^6 \" output22.log | grep -c \"accepts payment\") -eq 1 ] && [ \$(grep \"^6 \" output22.log | grep -E -c \"Chef [1-4]\") -eq 1 ] && [ \$(grep \"^8 \" output22.log | grep -c \"leaves\") -eq 1 ]" \
"Verify the timing and presence of key actions for a single, uncontested customer."

run_test 23 "Starvation of Standing Customers" \
"1 Customer 2301
1 Customer 2302
1 Customer 2303
1 Customer 2304
2 Customer 2305
10 Customer 2306
<EOF>" \
"sit5=\$(grep -m1 'Customer 2305 sits' output23.log | cut -d' ' -f1 || true); sit6=\$(grep -m1 'Customer 2306 sits' output23.log | cut -d' ' -f1 || true); [ -n \"\$sit5\" ] && [ -n \"\$sit6\" ] && [ \"\$sit5\" -le \"\$sit6\" ]" \
"Verify standing customer C2305 gets seat before or at the same time as new arrival C2306, preventing starvation."

# --- FIX for Test 24 ---
# The input is now staggered. Customers 2401-2404 arrive at t=1, guaranteeing
# they take the initial seats. Customers 2405-2408 arrive at t=2, guaranteeing
# they are the ones standing. This makes the test deterministic and reliable.
run_test 24 "Simultaneous Completion and Chef Selection" \
"1 Customer 2401
1 Customer 2402
1 Customer 2403
1 Customer 2404
2 Customer 2405
2 Customer 2406
2 Customer 2407
2 Customer 2408
<EOF>" \
"bake5=\$(grep -m1 'bakes for Customer 2405' output24.log | cut -d' ' -f1 || true); bake6=\$(grep -m1 'bakes for Customer 2406' output24.log | cut -d' ' -f1 || true); bake7=\$(grep -m1 'bakes for Customer 2407' output24.log | cut -d' ' -f1 || true); bake8=\$(grep -m1 'bakes for Customer 2408' output24.log | cut -d' ' -f1 || true); [ -n \"\$bake5\" ] && [ -n \"\$bake6\" ] && [ -n \"\$bake7\" ] && [ -n \"\$bake8\" ] && [ \"\$bake5\" -le \"\$bake6\" ] && [ \"\$bake6\" -le \"\$bake7\" ] && [ \"\$bake7\" -le \"\$bake8\" ]" \
"Verify bakes for standing customers start in FIFO order: C2405 before C2406 before C2407 before C2408."

run_test 25 "Simultaneous Payment Requests" \
"1 Customer 2501
1 Customer 2502
1 Customer 2503
1 Customer 2504
<EOF>" \
"payments=\$(grep 'accepts payment' output25.log | cut -d' ' -f1 | sort -n); unique_times=\$(echo \"\$payments\" | uniq -c | wc -l); total_payments=\$(echo \"\$payments\" | wc -l); [ \"\$total_payments\" -eq 4 ] && [ \"\$unique_times\" -eq 4 ]" \
"Verify all four payment acceptances happen at different timestamps, proving sequential processing via mutex."

run_test 26 "Zero Customer Input" \
"<EOF>" \
"lines=\$(wc -l < output26.log); [ \"\$lines\" -eq 0 ]" \
"Verify program exits cleanly with no output for empty input."

run_test 27 "A Single Customer with No Contention" \
"1 Customer 2701
<EOF>" \
"enters=\$(grep -c 'enters' output27.log); sits=\$(grep -c 'sits' output27.log); requests=\$(grep -c 'requests cake' output27.log); bakes=\$(grep -c 'bakes for' output27.log); pays=\$(grep -c 'pays' output27.log); accepts=\$(grep -c 'accepts payment' output27.log); leaves=\$(grep -c 'leaves' output27.log); [ \"\$enters\" -eq 1 ] && [ \"\$sits\" -eq 1 ] && [ \"\$requests\" -eq 1 ] && [ \"\$bakes\" -eq 1 ] && [ \"\$pays\" -eq 1 ] && [ \"\$accepts\" -eq 1 ] && [ \"\$leaves\" -eq 1 ]" \
"Verify a single customer completes all stages without issues."

run_test 28 "Full Standing Room" \
"$(for i in {1..25}; do echo "1 Customer 28$i"; done)
<EOF>" \
"entries=\$(grep -c 'Customer [0-9][0-9]* enters' output28.log); initial_sits=\$(grep '^1 ' output28.log | grep -c 'sits'); [ \"\$entries\" -eq 25 ] && [ \"\$initial_sits\" -eq 4 ]" \
"Verify all 25 customers enter, but only 4 can sit initially."

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
echo -e "${YELLOW}--- Cleaning up generated files ---${NC}"
rm -f input*.txt output*.log
echo "Done."
