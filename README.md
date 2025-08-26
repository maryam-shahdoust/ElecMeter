# ElecMeter

# An Example of Calculating the Dissaisfaction of the results of voting using ElecMeter Index:
Suppose there is population with size 10000. The vo


## Dissatisfaction Distribution Simulation

This repository provides R code to simulate dissatisfaction distributions in ranking/voting scenarios with multiple candidates. The main function SimPopulation() generates dissatisfaction profiles for simulated populations under probabilistic models.

📖 **Scenario:**

Imagine we have K candidates in an election (or ranking system). Every population produces rankings of candidates. Since different voting methods may yield different winners, we want to compute the dissatisfaction distribution for all possible winners.

Dissatisfaction of a candidate = distance of that candidate’s position from the top in a ranking (0 = first place, 1 = second place, …).

By simulating multiple populations, we obtain the distribution of dissatisfaction levels under different possible outcomes.
⚙️ Methodology

The simulation follows these steps:

Generate all possible rankings (permutations):

For K candidates, there are K! permutations.

Example: with K = 5, we get 120 permutations.

Simulate ranking frequencies per population:

Populations of size N are simulated using a multinomial distribution.

The probability vector for the multinomial is drawn from a Dirichlet distribution.

Randomize Dirichlet parameter (α):

Each run uses a random α chosen from {0.05, 0.01, 0.25, 0.5, 1, 2, 3}
Calculate dissatisfaction scores:

For each permutation, dissatisfaction of a candidate = rank position − 1.

Assign winners & aggregate dissatisfaction:

Each candidate is considered as the winner.

Dissatisfaction values are weighted by permutation frequencies.

Build dissatisfaction distributions:

For each candidate and each population, we compute how often each dissatisfaction level (0 to K-1) appears.

📦 Requirements
library(dplyr)
library(combinat)
library(dirmult)
library(HMP)
Usage
results <- SimPopulation(number_candidates = 5,
                         groups = 10,
                         population_size = 1000)

📊 Output

The function returns a list with:

candidates → Candidate labels.

PP → All candidate permutations.

freqs → Frequencies of permutations per population.

info → Dissatisfaction values and frequencies per population.

Diss → Dissatisfaction scores for each candidate in each permutation.

dist → Final dissatisfaction distributions (per candidate, per population).


