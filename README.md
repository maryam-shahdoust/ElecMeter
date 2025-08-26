# ElecMeter

# An Example of Calculating the Dissaisfaction of the results of voting using ElecMeter Index:
Suppose there is population with size 10000. The vo

## 🔄 Workflow

```mermaid
flowchart TD
    A[Define K candidates] --> B[Generate all permutations (K! rankings)]
    B --> C[Select α randomly from {0.05, 0.01, 0.25, 0.5, 1, 2, 3}]
    C --> D[Sample probability vector from Dirichlet distribution]
    D --> E[Simulate frequencies of permutations using Multinomial distribution]
    E --> F[Compute dissatisfaction scores (rank position - 1)]
    F --> G[Assign each candidate as winner]
    G --> H[Aggregate dissatisfaction by population]
    H --> I[Build dissatisfaction distribution per candidate]

When rendered on GitHub, it will look like a clean flowchart showing your simulation steps.  



