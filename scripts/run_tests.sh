# Run tests for each compiler
for compiler in "$COMPILER_DIR"/*; do
    COMPILER_NAME=$(basename "$compiler")
    OUTPUT_DIR="$RESULTS_DIR/$COMPILER_NAME"
    mkdir -p "$OUTPUT_DIR"
    
    echo "Running tests with $COMPILER_NAME..."
    
    for test_file in "$TEST_DIR"/*.cpp; do
        TEST_NAME=$(basename "$test_file" .cpp)
        EXECUTABLE="$OUTPUT_DIR/$TEST_NAME.out"
        LOG_FILE="$OUTPUT_DIR/$TEST_NAME.log"
        
        # Check if using CUDA compiler
        if [[ $COMPILER_NAME == "compiler_v1" ]] || [[ $COMPILER_NAME == "compiler_v2" ]]; then
            COMPILER_EXEC="$compiler/nvcc"
        else
            COMPILER_EXEC="$compiler/g++"  # Assuming another compiler is also used
        fi
        
        # Compile the test file
        "$COMPILER_EXEC" "$test_file" -o "$EXECUTABLE"
        
        # Run the test and capture time
        /usr/bin/time -f "%e" -o "$LOG_FILE" "$EXECUTABLE" > /dev/null
        echo "Test $TEST_NAME finished for $COMPILER_NAME."
    done
done
