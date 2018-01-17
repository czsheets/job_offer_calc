# job_offer_calc
An algorithm that calculates user input to estimate likely probability of getting single/multiple job offers during an interview season. 

The files include two versions:
* Python, using text input
* R [Shiny app] (https://charles-sheets.shinyapps.io/job_apps/), using sliders

Users are asked to enter:
* the number of primary interviews: those they are most interested in
* the probability of success in each interview (or as an average)
* the total number of interviews planned
* the decay rate: as the interviewer takes on more interviews, fatigue and concentration can decrease the probability of success
* number of offers hoped for: this is only currently available in the Shiny version. The Python version defaults to 3 offers


