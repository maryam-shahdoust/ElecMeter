# ElecMeter

# An Example of Calculating the Dissaisfaction of the results of voting using ElecMeter Index:
Suppose there is population with size 10000. The vo


## Dissatisfaction Distribution Simulation

This repository provides R code to simulate dissatisfaction distributions in ranking/voting scenarios with multiple candidates. The main function SimPopulation() generates dissatisfaction profiles for simulated populations under probabilistic models.

📖 Scenario

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

Each run uses a random α chosen from
