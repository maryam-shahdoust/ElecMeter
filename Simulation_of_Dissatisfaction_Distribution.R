
## -----------------------------------------------------------------------------
## Function: SimPopulation 
## Purpose:  simulation the dissatisfaction distribution based on frequency of possible permutations
## Simulation idea:
# We have K candidates in an election (or ranking system). Each population produces
# rankings of candidates. Since different voting rules may yield different winners,
# we compute the dissatisfaction distribution for all possible winners.
#
# Dissatisfaction of a candidate = distance from the top position
# (0 = first place, 1 = second place, ...).
# By simulating multiple populations, we obtain the distribution of dissatisfaction
# levels under different possible outcomes.
#*****NOTE : For more explanation see ReadMe.md in GitHub: https://github.com/maryam-shahdoust/ElecMeter

## Inputs:
#          -  K              : number of candidates
#          -  groups         : number of simulated Population(number of individuals)
#          -  population_size : size of simulated population

### Outputs:
#          - PP    : possible permutation for K candidates
#          - freqs : simulated frequencies for each permutation
#          - info  : dis-Satisfactions value and corresponding frequencies due to different winners in each permutations.
#          - dist  : distribution of dissatisfaction in each group

## -----------------------------------------------------------------------------
SimPopulation <- function(c,groups,population_size) {
#-------------------------------------------------------------------------------  
  # define candidates
  candidates <- LETTERS[1:K]
  
  ##----------------------------------------------------------------------------
  ## 1. Generate all possible rankings (permutations) for K candidates 
  ##----------------------------------------------------------------------------
  
  library(combinat)
  PP <- permn(candidates)
  PP <- matrix(unlist(PP),length(PP),length(candidates),byrow=T)
  PP <- PP[order(PP[,1], decreasing = FALSE),]
  
  ### Generate the number of permutations per sample : multinomial sample
  require(dirmult)
  require(HMP)
  ###  In Multinomial code : The first number is the number of reads and the second is the number of subjects
    # The probability vector for the multinomial is drawn from a Dirichlet distribution. 
    # The para,eter of Dirichlet distribution is randomized.
  
  #ِDirichlet Distribution
  set.seed(100000)
  freqs<-c()
  for(i in 1:groups){
    nrs    <- population_size
    #select the Driclet distribution parameter
    alpha <- sample(c(0.05,0.01,0.25,0.5,1,2,3),replace=FALSE,size=1,rep(0.15,7))
    P      <- rdirichlet(1,rep(alpha,dim(PP)[1]))
    freqs  <- rbind(freqs,Multinomial(nrs,P))
  }
  
  names <- cbind(sort(rep(LETTERS[1:K],times=dim(PP)[1]/K)),rep(1:(dim(PP)[1]/K),times=K))
  colnames(freqs) <- paste(names[,1],names[,2])
  rownames(freqs) <- c(paste("pop",1:groups,sep=''))
  ## ---------------------------------------------------------------------------
  ## 2. Calculate dissatisfaction scores:  rank position − 1.
  ## --------------------------------------------------------------------------- 
  #Diss indicates the distance of each candidate to the top position in each permutation
  Diss <- data.frame()
  for ( i in 1:dim(PP)[1]){
    for ( j in 1:length(candidates)){
      Diss[i,j] <- which(PP[i,]== candidates[j])-1
    }}
  
  colnames(Diss) <- LETTERS[1:K]
  
  
  # each column represents a winner candidate.
  x    <- list()
  info <- array(x,groups)
  
  for ( i in 1:groups) {
    info[[i]]           <- cbind(freqs[i,],Diss[,1:length(candidates)])
    colnames(info[[i]]) <- c('freq',LETTERS[1:K])
  }
  
  ## ---------------------------------------------------------------------------
  ## 3. Assign winners & aggregate dissatisfaction
  ## ---------------------------------------------------------------------------
  
  ###Distribution of DisSatisfaction
  dist <- array(0,c(c,c,groups))
  colnames(dist) <- LETTERS[1:K]
  rownames(dist) <- seq(0,K-1)
  
  for (i in 1:groups){
    for (j in 1:length(candidates)) {
      dist[,j,i] <- aggregate(.~info[[i]][,j+1],data=info[[i]][,c(1,j+1)],FUN=sum)[,2]
    }
  }
  
  ## ---------------------------------------------------------------------------
  ## 4. Get the outputs
  ## ---------------------------------------------------------------------------
  
  sim_results <- list(candidates,PP,freqs,info,Diss,dist)
  return(sim_results)
}







