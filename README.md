# ElecMeter

# An Example of Calculating the Dissaisfaction of the results of voting using ElecMeter Index:
Suppose there is population with size 10000. The vo


## Dissatisfaction Distribution Simulation

This repository provides R code to simulate dissatisfaction distributions in ranking/voting scenarios with multiple candidates. The main function SimPopulation() generates dissatisfaction profiles for simulated populations under probabilistic models.

📖 Scenario

Imagine we have K candidates in an election (or ranking system). Every population produces rankings of candidates. Since different voting methods may yield different winners, we want to compute the dissatisfaction distribution for all possible winners.

Dissatisfaction of a candidate = distance of that candidate’s position from the top in a ranking (0 = first place, 1 = second place, …).

By simulating multiple populations, we obtain the distribution of dissatisfaction levels under different possible outcomes.
