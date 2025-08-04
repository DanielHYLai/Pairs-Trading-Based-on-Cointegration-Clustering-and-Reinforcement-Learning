# Pairs Trading Based on Cointegration Clustering and Reinforcement Learning

## Project Structure

```
├── main.R                     # Main analysis script
├── requirements/
│   ├── requirements.R         # Package installation script
│   └── requirements.txt       # Required R packages list
└── utils/
    ├── clustering.R           # Clustering utility functions
    └── pair_pool.R            # Pair pool generation utilities
```

## Requirements

### R Packages
The following R packages are required and can be installed automatically:

- `cluster` - Clustering algorithms
- `clusterSim` - Cluster validation measures
- `dplyr` - Data manipulation
- `fpc` - Flexible procedures for clustering
- `ggplot2` - Data visualization
- `readr` - Fast data reading
- `SNFtool` - Similarity network fusion

### Data Files
The project expects the following data files in a `data/` directory:

- `price.rData` - Price data
- `test_result.rData` - Cointegration test results
- `frequency_matrix.rData` - Frequency matrix data
- `voting.rData` - Voting member data
- `train.csv` - Training dataset
- `test.csv` - Test dataset
- `entropy_result.csv` - Entropy results

## Installation

1. Clone or download the project files
2. Install required packages by running:
   ```r
   source("requirements/requirements.R")
   ```

## Usage

Run the main analysis script:
```r
source("main.R")
```


## Output

The analysis produces:

1. **Entropy Plot** - Visualization of entropy values for $q$ parameter selection
2. **Clustering Results** - Optimal cluster numbers $K^{\text{opt}}$ for different configurations
3. **Asset Selection** - Frequency analysis of selected assets
4. **Pair Pool Visualization** - Bar chart showing pair pool

## Notes

- The project uses Windows fonts (Times New Roman) for plotting
- Warning messages are suppressed for cleaner output

## License

Please specify your license terms for this project.