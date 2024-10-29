import os

def read_results(results_dir):
    results = {}
    for compiler_version in os.listdir(results_dir):
        version_dir = os.path.join(results_dir, compiler_version)
        if os.path.isdir(version_dir):
            results[compiler_version] = {}
            for log_file in os.listdir(version_dir):
                test_name = log_file.split(".")[0]
                with open(os.path.join(version_dir, log_file), 'r') as f:
                    results[compiler_version][test_name] = float(f.read().strip())
    return results

def analyze_performance(results):
    base_version = list(results.keys())[0]
    for compiler, tests in results.items():
        if compiler == base_version:
            continue
        print(f"\nComparing {compiler} to {base_version}:")
        for test, base_time in results[base_version].items():
            if test in tests:
                regression = (tests[test] - base_time) / base_time * 100
                status = "Regression" if regression > 0 else "Improvement"
                print(f"{test}: {status} of {regression:.2f}%")

if __name__ == "__main__":
    results_dir = "../results"
    results = read_results(results_dir)
    analyze_performance(results)
