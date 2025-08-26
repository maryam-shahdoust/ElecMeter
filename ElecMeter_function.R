## -----------------------------------------------------------------------------
## Function: calculate_dissatisfaction_index1
## Purpose:  Compute components of the ElecMeter dissatisfaction index 
##           (replacing Survival with normalized average dissatisfaction S).
## Inputs:
##   - population_size: number of voters
##   - observed_frequencies: vector of counts of voters at each dissatisfaction level 
##       (0 = fully satisfied, K-1 = fully dissatisfied)
##   - number_candidates: number of candidates (K)
##   - p : the power parameter in ElecMeter formula
##
## Outputs: A named vector including:
##   - Average dissatisfaction (S) and normalized S
##   - Entropy (distributional disorder)
##   - Jensen–Shannon divergences (from ideal, max, neutral, polarized states)
##   - Relative divergence ratios (normalized indexes)
##   - ElecMeter index
## -----------------------------------------------------------------------------

ElecMeter_index <- function(population_size, observed_frequencies, number_candidates,p) {
  
  ## Define dissatisfaction levels (0 = fully satisfied, K-1 = fully dissatisfied)
  dissatisfaction_levels <- 0:(number_candidates-1)
  
  ## ---------------------------------------------------------------------------
  ## 1. Average Dissatisfaction Score (S)
  ## ---------------------------------------------------------------------------
  ## Weighted average dissatisfaction = mean rank of winner across voters
  avg_dissatisfaction <- sum(1 - (cumsum(observed_frequencies) / population_size)) #S in paper
  
  ## Normalize S to [0,1]
  Avg_Dissatisfaction_norm <- avg_dissatisfaction / (number_candidates - 1) #S_norm in paper
  
  ## ---------------------------------------------------------------------------
  ## 2. Entropy Component: Shannon entropy measures heterogeneity (disorder) in the distribution
  ## ---------------------------------------------------------------------------
  calculate_entropy <- function(observed_frequencies) {
    total <- sum(observed_frequencies)
    probabilities <- observed_frequencies / total
    entropy <- -sum(probabilities * log2(probabilities), na.rm = TRUE)
    return(entropy)
  }
  
  entropy_result <- calculate_entropy(observed_frequencies)
  
  ## ---------------------------------------------------------------------------
  ## 3. Jensen–Shannon Divergences from Benchmark Distributions
  ## ---------------------------------------------------------------------------
  ideal_frequencies <- c(population_size, rep(0, length(dissatisfaction_levels)-1))          # all fully satisfied
  max_dissatisfaction_frequencies <- c(rep(0, length(dissatisfaction_levels)-1), population_size) # all fully dissatisfied
  pol_frequencies <- c((population_size/2), rep(0,length(dissatisfaction_levels)-2),(population_size/2)) # polarized
  neutral_frequencies <- rep(population_size / length(dissatisfaction_levels), length(dissatisfaction_levels)) # neutral
  
  total_observed <- sum(observed_frequencies)
  if (total_observed == 0) total_observed <- 1
  observed_probs <- observed_frequencies / total_observed
  
  ideal_probs <- ideal_frequencies / sum(ideal_frequencies)
  max_dissatisfaction_probs <- max_dissatisfaction_frequencies / sum(max_dissatisfaction_frequencies)
  neutral_probs <- neutral_frequencies / sum(neutral_frequencies)
  polarized_probs <-  pol_frequencies / sum(pol_frequencies)
  
  calculate_js_divergence <- function(prob1, prob2) {
    mixture_probs <- 0.5 * (prob1 + prob2)
    kl1 <- sum(ifelse(prob1 == 0, 0, prob1 * log(prob1 / mixture_probs, 2)), na.rm = TRUE)
    kl2 <- sum(ifelse(prob2 == 0, 0, prob2 * log(prob2 / mixture_probs, 2)), na.rm = TRUE)
    js_divergence <- 0.5 * (kl1 + kl2)
    return(js_divergence)
  }
  
  js_observed_ideal <- calculate_js_divergence(observed_probs, ideal_probs)
  js_observed_max_dissatisfaction <- calculate_js_divergence(observed_probs, max_dissatisfaction_probs)
  js_observed_neutral <- calculate_js_divergence(observed_probs, neutral_probs)
  js_observed_polarized <- calculate_js_divergence(observed_probs, polarized_probs)
  
  ## ---------------------------------------------------------------------------
  ## 4. Divergence-based Ratios
  ## ---------------------------------------------------------------------------
  I1  <- js_observed_ideal / (js_observed_ideal + js_observed_max_dissatisfaction) # Ideal vs Max (I1 in the paper)
  I2  <- js_observed_ideal / (js_observed_ideal + js_observed_neutral)             # Ideal vs Neutral(I2 in the paper)
  I3  <- js_observed_ideal / (js_observed_ideal + js_observed_polarized)           # Ideal vs Polarized (I3 in the paper)
  
  I_max <- max(I1,I2,I3) 
  
  ## ---------------------------------------------------------------------------
  ## 5. ElecMeter
  
  ElecMeter_p <- ((((Avg_Dissatisfaction_norm)^p + (I_max)^p))^(1/p))/(2^(1/p))
  
  ## ---------------------------------------------------------------------------
  ## 6. Return results
  ## ---------------------------------------------------------------------------
  return(c(
    Avg_Dissatisfaction = avg_dissatisfaction,   
    Avg_Dissatisfaction_norm = Avg_Dissatisfaction_norm,           
    Entropy = entropy_result,
    js_observed_ideal = js_observed_ideal,
    js_observed_max_dissatisfaction = js_observed_max_dissatisfaction,
    js_observed_neutral = js_observed_neutral,
    js_observed_polarized = js_observed_polarized,
    Ideal_vs_Max  = I1,
    Ideal_vs_Neut = I2,
    Ideal_vs_pol  = I3,
    
    Elecmeter_index = ElecMeter_p
  ))
}
