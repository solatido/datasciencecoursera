# rprog assignment 3
# Take an outcome and a rank num
# Return a (hospital, state) data frame containing the name of the numth hospital
# by lowest mortality for that outcome for each state
rankall <- function(outcome, num = "best") {
  
  # Read outcome data
  measures <- read.csv("outcome-of-care-measures.csv", stringsAsFactors = FALSE)
  
  valid_outcomes <-  c("heart attack", "heart failure", "pneumonia")
  
  # Check that outcome is valid
  if (!(outcome %in% valid_outcomes)) {
    stop("invalid outcome")
  }
  
  # Filter by state and outcome
  if (outcome == "heart failure") {
    mortality <- measures$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  } else if (outcome == "heart attack") {
    mortality <- measures$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  } else {
    mortality <- measures$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  }
  hospital_outcomes <- data.frame(state = measures$State,
                                  hospital.name = measures$Hospital.Name,
                                  mortality = as.numeric(mortality),
                                  stringsAsFactors = FALSE)
  
  # Take a (state, hospital.name, mortality) data frame
  # Return the nth best hospital by lowest mortality rate
  # as a (hospital, state) data frame
  numthHospitals <- function(df, n) {
    
    # Order df by mortality rate and remove NAs
    df <- df[with(df, order(mortality,
                            hospital.name,
                            na.last = NA)),]
    
    # If we're looking for the "best" state in df we want the first row, 
    # if we want the "worst" state we want to index the last row in df
    # if we want an out of bounds value we should return (state, NA)
    if (n == "best") {
      n = 1
    }
    else if (n == "worst") {
      n = dim(df)[1]
    }
    if (n > dim(df)[1]) {
      return(data.frame(hospital = NA, state = df$state[1]))
    }
    
    # Filter for nth best hospital by mortality
    df <- df[n,]
    
    # Return (hospital, state) data frame
    return(data.frame(hospital = df$hospital.name, state = df$state, stringsAsFactors = FALSE))
  }
  ranked <- ddply(hospital_outcomes, "state", .fun = numthHospitals, num, .inform = TRUE)
}