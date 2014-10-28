# rprog assignment 3
# Take two character abbreviated state, and an outcome
# Return the name of the best hospital for that outcome by lowest mortality
best <- function(state, outcome) {
  
  # Read outcome data
  measures <- read.csv("outcome-of-care-measures.csv", stringsAsFactors = FALSE)
  
  valid_outcomes <-  c("heart attack", "heart failure", "pneumonia")
  valid_states <- unique(measures$State)
  
  # Check that state and outcome are valid
  if (!(state %in% valid_states)) {
    stop("invalid state")
  }
  if (!(outcome %in% valid_outcomes)) {
    stop("invalid outcome")
  }
  
  # Filter by state and outcome
  filtered <- measures[measures$State == state,]
  if (outcome == "heart failure") {
    mortality <- filtered$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  } else if (outcome == "heart attack") {
    mortality <- filtered$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  } else {
    mortality <- filtered$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  }
  hospital_outcomes <- data.frame(hospital.name = filtered$Hospital.Name,
                                  mortality = as.numeric(mortality),
                                  stringsAsFactors = FALSE)
  
  # Return hospital name in the state with lowest 30-day death rate
  sorted <- hospital_outcomes[with(hospital_outcomes, 
                                   order(mortality, 
                                         hospital.name, 
                                         na.last = NA)),]  
  sorted[1,1]
  
}