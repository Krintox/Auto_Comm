COMPILER_DIR="./compilers"  # Modify this path as needed
RESULTS_DIR="./results"
TEST_CASES_DIR="./test_cases"  # Modify if test cases are in a different directory

# Create results directory if it doesn’t exist
mkdir -p "$RESULTS_DIR"

# Run tests for each compiler
find "$COMPILER_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r compiler; do
    echo "Checking compiler path: $compiler"  # Debug output
    
    COMPILER_NAME=$(basename "$compiler")
    OUTPUT_DIR="$RESULTS_DIR/$COMPILER_NAME"
    mkdir -p "$OUTPUT_DIR"
    
    echo "Running tests with $COMPILER_NAME..."
    
    for test_file in "$TEST_CASES_DIR"/*.cpp; do
        if [ -f "$test_file" ]; then
            TEST_NAME=$(basename "$test_file" .cpp)
            EXECUTABLE="$OUTPUT_DIR/$TEST_NAME.out"
            LOG_FILE="$OUTPUT_DIR/$TEST_NAME.log"
            
            # Check if using CUDA compiler
            if [[ $COMPILER_NAME == "compiler_v1" ]] || [[ $COMPILER_NAME == "compiler_v2" ]]; then
                COMPILER_EXEC="$compiler/nvcc"
            else
                COMPILER_EXEC="$compiler/g++"
            fi
            
            # Compile the test file if the compiler exists
            if [ -x "$COMPILER_EXEC" ]; then
                "$COMPILER_EXEC" "$test_file" -o "$EXECUTABLE"
                
                # Run the test and capture time
                /usr/bin/time -f "%e" -o "$LOG_FILE" "$EXECUTABLE" > /dev/null
                echo "Test $TEST_NAME finished for $COMPILER_NAME."
            else
                echo "Compiler executable not found: $COMPILER_EXEC"
            fi
        else
            echo "No test files found in $TEST_CASES_DIR"
        fi
    done
done
