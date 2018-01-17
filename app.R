#import packages
library(shiny)
library(formattable)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Title
   titlePanel("Projected Number of offers"),
   
   # Sidebar with a slider input for variables 
   sidebarLayout(
      sidebarPanel(
         sliderInput("primary", "Number of primary interviews (the ones you're most focused on):", min = 1, max = 10, value = 5),
         sliderInput("probability","Average expected probability of offers from primary interviews:",  min = .01, max = 1, value = .15),
         sliderInput("tot_int", "Total number of interviews:",  min = 1, max = 20, value = 10),
         sliderInput("decay", "Decay rate for each interview beyond primary (how much do you think your chances will decrease with each interview beyond your primary interviews):",  min = 0, max = .1, value = .01),
         sliderInput("hoped_jobs", "Number of offers you're hoping for:",  min = 1, max = 10, value = 3)
      ),
      
      # Set up text and plot output
      mainPanel(
         textOutput("tab1"),
         br(), br(),
         textOutput("tab2"),
         br(), br(),
         plotOutput("jobPlot")
      )
   )
)

#Define server logic required to draw a bargraph
server <- function(input, output) {
  
  # Text Box 1 - chances of at least one offer based on initial probability, number of primary interviews 
  output$tab1 <- renderText({
    # generate value of at least one job
    prim_job = 1 - (1 - input$probability)^input$primary
    paste("The chances of getting an offer based on your primary interviews are ", percent(prim_job,0))
  })
  
  # Text Box 2 - chances of at least one offer based on initial probability, total interviews, decay rate
  output$tab2 <- renderText({
    # generate value of at least one job
    all_job_prob = c(rep(input$probability,input$primary-1), cumsum(c(input$probability, rep(-input$decay, input$tot_int - input$primary))))
    all_job_prob = mean(ifelse(all_job_prob < 0,0, all_job_prob))
    #all_job_prob = 1 - all_job_prob
    one_job = 1 - (choose(input$tot_int, 0) * all_job_prob^0 * (1 - all_job_prob)^(input$tot_int - 0))
    #one_job = 1 - cumprod(all_job_prob)[length(all_job_prob)]
    #extra_ints = input$total_int - input$primary
    print(all_job_prob)
    paste("The chances of getting an offer after all interviews are ", percent(one_job,0)[1])
  })
  
  # Plot likelihood of user-inputted expected offers
  output$jobPlot <- renderPlot({
    # generate plot with more than one job
    all_job_prob = c(rep(input$probability,input$primary-1), cumsum(c(input$probability, rep(-input$decay, input$tot_int - input$primary))))
    all_job_prob = mean(ifelse(all_job_prob < 0,0, all_job_prob))
    #print(all_job_prob_2)
    mult_offers = function(hoped_jobs, tot_int, all_job_prob){
      each_level = rep(NA,hoped_jobs)
      for (i in 0:hoped_jobs-1){
        each_level[i+1] = choose(tot_int, i) * all_job_prob^i * (1 - all_job_prob)^(tot_int - i)
      }
      return(1- cumsum(each_level)[length(each_level)])
    }
    bar_offers = rep(NA, length(input$hoped_jobs))
    for (i in 1:input$hoped_jobs){
      bar_offers[i] = mult_offers(i, input$tot_int, all_job_prob)
      print(bar_offers)
    }
    barplot(bar_offers, names = 1:input$hoped_jobs, ylab = "Likelihood", xlab = 'Number of Offers', ylim = c(0,1),
            col = 'dodgerblue', main = "Likelihood of getting at least a certain number of offers \n (based on total number of interviews)")
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)

