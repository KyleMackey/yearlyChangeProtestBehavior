##==============================================================##
##                                                              ##
##    Project:  Mass Mobilization Change in Protest Behavior    ##
##                                                              ##
##    File:     server.R                                        ##
##    Author:   Kyle Mackey                                     ##
##    Purpose:  Reactive plot of each country's change in       ##
##              yearly protest behavior                         ##
##    Updated:  Oct 12, 2018                                    ##
##                                                              ##
##    Requires: mmProtestChange.csv                             ##
##              ui.R                                            ##
##                                                              ##
##==============================================================##

##
##  Load in packages
##
library(shiny)
library(ggplot2)
library(foreign)
library(ggthemes)
library(RCurl)

## 
##  Custom ggplot2 theme
##
theme_set(theme_minimal())
custom <- theme_update(axis.text.x = element_text(colour = "black", 
                                                  size = 20),
                       axis.text.y = element_text(colour = "black", 
                                                  size = 20),
                       axis.title.x = element_text(size = 20),
                       axis.title.y = element_text(size = 20, 
                                                   angle = 90),
                       title = element_text(size = 20)
)  

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
##  shinyServer start
##
shinyServer(function(input, output) {
  
##########################################################
######           CHANGE IN TOTAL PROTESTS           ######
##########################################################  

##
##  renderPlot start
##
output$totalProtests <- renderPlot({ 
    
##
##  Subset the data that the user 
##  selects in the app (by country)
##
temp1 <- subset(temp, temp$country == input$country)

##
##  Plot a bar plot of yearly protests for the 
##  user-selected country
##
yrCh <- ggplot(temp1, aes(x = year, y = protestnumberchange)) +
        geom_smooth(size = 10, 
                    se = FALSE, 
                    span = 0.5, 
                    col = "gray75") +
        geom_bar(stat = "identity", 
                 position ="identity", 
                 aes(fill = yearlyChange)) +
        geom_hline(yintercept = 0, lwd = 1) +
        scale_x_discrete(limits = seq(1991, 2014, 2)) +
        scale_fill_manual(values = c(decrease = "#990000", 
                                     increase = "#0099FF")) +
        ggtitle(" ") + 
        xlab(" ") + 
        ylab("Change") +
        theme(legend.position = "none",
              axis.text.x = element_text(angle = 90))
    
##
##  Print out the plot to screen
##
print(yrCh)
    
})  # renderPlot end
     
})  # shinyServer end
