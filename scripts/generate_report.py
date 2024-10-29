import matplotlib.pyplot as plt

def plot_results(results):
    for test in results[next(iter(results))]:
        versions = []
        times = []
        for version, tests in results.items():
            if test in tests:
                versions.append(version)
                times.append(tests[test])
        plt.plot(versions, times, label=test)
    
    plt.xlabel("Compiler Version")
    plt.ylabel("Execution Time (s)")
    plt.title("Performance Comparison Across Compiler Versions")
    plt.legend()
    plt.show()

if __name__ == "__main__":
    results_dir = "../results"
    results = read_results(results_dir)
    plot_results(results)
