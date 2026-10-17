
#!/usr/bin/env bash

set -u
cd "$(dirname "$0")"

RTL=(rtl/*.sv)
TEST_DIR="tb"
BUILD_DIR="build/tests"

mkdir -p "$BUILD_DIR"

total=0
passed=0
failed=0
incomplete=0

echo "========================================"
echo "       ARC-01 REGRESSION TESTS"
echo "========================================"
echo

if ! command -v iverilog >/dev/null 2>&1 ||
   ! command -v vvp >/dev/null 2>&1; then
    echo "ERROR: Install Icarus Verilog and ensure it is in PATH."
    exit 1
fi

for tb in "$TEST_DIR"/*_tb.sv; do
    [[ -f "$tb" ]] || continue

    filename="${tb##*/}"
    top="${filename%.sv}"
    if [[ "$filename" == "arc01_tb.sv" ]]; then top="alu_tb"; fi
    binary="$BUILD_DIR/$top"
    total=$((total + 1))

    echo "----------------------------------------"
    echo "TEST: $top"

    # Compile this testbench with the processor RTL.
    if ! compile_output=$(
        iverilog -g2012 -s "$top" \
            -o "$binary" "${RTL[@]}" "$tb" 2>&1
    ); then
        echo "$compile_output"
        echo "RESULT: FAIL (compilation)"
        failed=$((failed + 1))
        continue
    fi

    # Run the compiled simulation.
    if output=$(vvp "$binary" 2>&1); then
        :
    else
        status=$?
        echo "$output"
        echo "Simulation exited with status $status"
        echo "RESULT: FAIL (simulation)"
        failed=$((failed + 1))
        continue
    fi

    echo "$output"

    # A test must explicitly report PASS to count as verified.
    if grep -Eiq '(^|[^[:alpha:]])(FAIL|ERROR)([^[:alpha:]]|$)' \
        <<< "$output"; then
        echo "RESULT: FAIL"
        failed=$((failed + 1))
    elif grep -Eiq '(^|[^[:alpha:]])PASS([^[:alpha:]]|$)' \
        <<< "$output"; then
        echo "RESULT: PASS"
        passed=$((passed + 1))
    else
        echo "RESULT: INCOMPLETE (no PASS marker)"
        incomplete=$((incomplete + 1))
    fi

    echo
done

echo "========================================"
echo "       ARC-01 TEST SUMMARY"
echo "========================================"
echo "Total:      $total"
echo "Passed:     $passed"
echo "Failed:     $failed"
echo "Incomplete: $incomplete"
echo

if (( total == 0 )); then
    echo "ERROR: No testbenches found in $TEST_DIR/"
    exit 1
fi

if (( failed == 0 && incomplete == 0 )); then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "CHECK FAILED OR INCOMPLETE TESTS"
    exit 1
fi
