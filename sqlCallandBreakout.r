

library(RMySQL)
library(mailR)
library(BreakoutDetection)

#connects to the SQL database
con = dbConnect(MySQL(), 
               user="user",
               host="host.domain.com", 
               dbname = "db_name",
               password= "password")

#runs the query and puts into appropriate format for Twitter 
#breakout detection

query_result = dbGetQuery(con, 
                            "query_placed_here")

#turn query into dataframe
query_result_to_dataframe = data.frame(query_result)

#subsets query timestamp into new dataframe and formats to POSIXct
#Twitter breakout detection tool requires a two colum matrix with the count and time stamp
#or a single vector with the count
formatted_df <- data.frame(as.POSIXct(query_result_to_dataframe$created_on)) 

#adds the count vector to the data frame
formatted_df$date<- query_result_to_dataframe$count.id.

#changes column names, format that Twitter Breakout looks for
colnames(formatted_df) <- c("timestamp", "count")


#runs the damn breakout analysis
res <- breakout(formatted_df, 
                min.size=6, 
                method='multi', 
                beta=.0004, 
                degree=1, 
                plot=TRUE)

#plots the damn thing
res$plot

#Converts julian date format to time stamp
time_stamp = as.Date(res$loc, origin = "2012-12-01")

#turns time_stamp variable into list.
#required to run conditional if statement
list_time_stamp <- as.list(timestamp)

#conditional statement requiring anaomalie date to match current date
todays_Date = Sys.Date()

#conditional statement where if the date of the anomaly matches
#the current date then send the email. If not return blank response
if(any(time_stamp == todays_Date) ) {
  send.mail(from = "from",
            to = c("to_recipient1", "to_recipient2"),
            subject = "BreakoutDetection",
            body = "Its about to Blow!",
            html = TRUE,
            smtp = list(host.name = "smtp.gmail.com", port = 465, 
                        user.name = "fsauceda24",
                        passwd = "password", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
} else {
  "Don't worry 'bout it!! Anomaly not occuring at this moment..."
}

#poop


