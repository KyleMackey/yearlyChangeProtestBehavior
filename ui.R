##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Change in Protest Behavior    ##
##                                                              ##
##    File:     ui.R                                            ##
##    Author:   Kyle Mackey                                     ##
##    Purpose:  Reactive plot of each country's change in       ##
##              yearly protest behavior                         ##
##    Updated:  Oct 12, 2018                                    ##
##                                                              ##
##    Requires: mmProtestChange.csv                             ##
##              server.R                                        ##
##                                                              ##
##==============================================================##

##
##  Load in packages
##
library(shiny)
library(foreign)
library(RCurl)

##
##  Set working directory and load in the data
##
url <- "https://raw.githubusercontent.com/KyleMackey/yearlyChangeProtestBehavior/master/data/mmProtestChange.csv"

gitHubData <- getURL(url)                

mm <- read.csv(textConnection(gitHubData), header = TRUE)

##
##  Put MM data in a data frame for plotting,
##  and create a variable that identifies 
##  whether the yearly change was positive
##  or negative
##
yearlyChange <- ifelse(mm$protestnumberchange < 0, 
                       "decrease", "increase")

temp <- data.frame(mm, yearlyChange)

##
##  shinyUI start
##  fluidPage start
##
shinyUI(fluidPage(
  
## 
##  Application title
##
titlePanel(paste("Change in yearly protest behavior, ", 
                 (min(temp$year) + 1), " - ", (max(temp$year)))),

##
##  sidebarPanel start
##
sidebarPanel(
    
##
##  Select the country you want to look at
##
selectInput("country", "Choose country:",
            choices = as.character(unique(mm$country))),
br(),

##
##  Create a link to the replication files, 
##  where the user can download the data and  
##  code used to make the current plot
##
actionButton(inputId = 'ab1', 
             label = "Replication files", 
             icon = icon("th"), 
             onclick = "window.open('https://github.com/KyleMackey', '_blank')"),
br()

), # sidebarPanel end
  
##
##  mainPanel start
##
mainPanel( 
  plotOutput("totalProtests"),
  
  helpText(paste("Note: Blue bars represent an increase in total ",
                 "protests between that year and the previous year; ",
                 "red bars represent a decrease in total protests",
                 "between that year and the previous year; grey line ",
                 "represents the trend in yearly change in total ",
                 "protests. The year 1990 is omitted in the ",
                 "calculation of yearly change.")),
  br()
) # mainPanel end
  
) # shinyUI end
) # fluidPage end