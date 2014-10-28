# rprog assignment 3
# Take two character abbreviated state, an outcome, and a rank num
# Return the name of the numth hospital for that outcome
rankhospital <- function(state, outcome, num = "best") {
  
  # Read outcome data
  measures <- read.csv("outcome-of-care-measures.csv", 
                       stringsAsFactors = FALSE)
  
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
  
  # Sort hospitals in the state with lowest 30-day death rate
  sorted <- hospital_outcomes[with(hospital_outcomes, 
                                   order(mortality, 
                                         hospital.name, 
                                         na.last = NA)),]  
  sorted <- sorted[complete.cases(sorted),]
  
  # If we're looking for the "best" state in df we want the first row, 
  # if we want the "worst" state we want to index the last row in df
  if (num == "best") {
    num = 1
  }
  if (num == "worst") {
    num = length(sorted$hospital.name)
  }
  # Return numth hospital
  sorted[num,1]
}