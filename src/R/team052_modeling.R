#CSE 6242 Project File

setwd("~/CSE6242/Project")
library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(broom)
library(corrplot)

##This code was used for modeling.

#Load main datasets game details represents all of the box scores and games are the game final scores
games_details <- read_csv("games_details.csv")
games <- read_csv("games.csv")
teams <- read_csv("teams.csv")


#update dataset to join games and game details information
df = merge(x = games_details, y = games, by = "GAME_ID")

df$WHERE_PLAYED <- ifelse(df$TEAM_ID == df$HOME_TEAM_ID, "HOME_GAME", "AWAY_GAME")
df$OPPOSING_TEAM_ID <- ifelse(df$TEAM_ID == df$HOME_TEAM_ID, df$VISITOR_TEAM_ID,df$HOME_TEAM_ID)
df <- left_join(df, teams, by = c("OPPOSING_TEAM_ID" = "TEAM_ID"))

df$ABBREVIATION <- factor(df$ABBREVIATION)
df$WHERE_PLAYED <- factor(df$WHERE_PLAYED)



#Load teams with their last 10 games games to use for prediction used in visual tool
# these 12 teams were selected as part of MVP
ATL_grouped_df_last_10games <- read_csv("ATL_grouped_df_last_10games.csv")
DAL_grouped_df_last_10games <- read_csv("DAL_grouped_df_last_10games.csv")
CHI_grouped_df_last_10games <- read_csv("CHI_grouped_df_last_10games.csv")
MEM_grouped_df_last_10games <- read_csv("MEM_grouped_df_last_10games.csv")
POR_grouped_df_last_10games <- read_csv("POR_grouped_df_last_10games.csv")
MIN_grouped_df_last_10games <- read_csv("MIN_grouped_df_last_10games.csv")
CHA_grouped_df_last_10games <- read_csv("CHA_grouped_df_last_10games.csv")
TOR_grouped_df_last_10games <- read_csv("TOR_grouped_df_last_10games.csv")
BKN_grouped_df_last_10games <- read_csv("BKN_grouped_df_last_10games.csv")
WAS_grouped_df_last_10games <- read_csv("WAS_grouped_df_last_10games.csv")
NYK_grouped_df_last_10games <- read_csv("NYK_grouped_df_last_10games.csv")
UTA_grouped_df_last_10games <- read_csv("UTA_grouped_df_last_10games.csv")



# The following code is used for developing the model for each player in each team. As part of MVP development, each team section is focused on the players from that team

################################################### ATLANTA #############################################

#This code below creates the lm model for each player and stores its in a dataframe
for (id in ATL_grouped_df_last_10games$PLAYER_ID) {
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("atl_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) # new line to assign the model with player name
  }
  else {
    NULL
  } 
} 

# This code is used for the prediction, Goal was to create an automated process since we want to create a series of models and predictions
prediction_atlanta_grouped_df_last_10games <- na.omit(ATL_grouped_df_last_10games)
prediction_atlanta_grouped_df_last_10games <- select(prediction_atlanta_grouped_df_last_10games, -PTS)
prediction_atlanta_grouped_df_last_10games <- mutate(prediction_atlanta_grouped_df_last_10games, ABBREVIATION = "DAL")
prediction_atlanta_grouped_df_last_10games <- mutate(prediction_atlanta_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME")

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

# This code allows for a prediction to be run over a series of players for the specified team.
for (id in unique(ATL_grouped_df_last_10games$PLAYER_ID)) {
  #Get the model name which is tied to the player id
  model_name <- paste0("", id)
  model <- get(model_name)
  
  # Filter the prediction dataset for this player
  player_data <- prediction_atlanta_grouped_df_last_10games %>%
    filter(PLAYER_ID == id)
  
  # Run the prediction for the player
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
  # put the player prediction into a dataframe so it creates one dataframe per team
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))


write.csv(prediction_df, file = "ATL_DALVSATL_GAMEID22201167.csv", row.names = FALSE)

################################################### DALLAS #############################################

for (id in DAL_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("DAL_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model)
  }
  else {
    NULL
  } 
} 

prediction_DAL_grouped_df_last_10games <- na.omit(DAL_grouped_df_last_10games) 
prediction_DAL_grouped_df_last_10games <- select(prediction_DAL_grouped_df_last_10games, -PTS)
prediction_DAL_grouped_df_last_10games <- mutate(prediction_DAL_grouped_df_last_10games, ABBREVIATION = "ATL") 
prediction_DAL_grouped_df_last_10games <- mutate(prediction_DAL_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME")

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(DAL_grouped_df_last_10games$PLAYER_ID)) { ###CHANGE 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_DAL_grouped_df_last_10games %>% ###CHANGE 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))


write.csv(prediction_df, file = "DAL_DALVSATL_GAMEID22201167.csv", row.names = FALSE)

################################################### CHICAGO #############################################

for (id in CHI_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("CHI_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 


prediction_CHI_grouped_df_last_10games <- na.omit(CHI_grouped_df_last_10games) 
prediction_CHI_grouped_df_last_10games <- select(prediction_CHI_grouped_df_last_10games, -PTS)
prediction_CHI_grouped_df_last_10games <- mutate(prediction_CHI_grouped_df_last_10games, ABBREVIATION = "MEM") 
prediction_CHI_grouped_df_last_10games <- mutate(prediction_CHI_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(CHI_grouped_df_last_10games$PLAYER_ID)) { 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_CHI_grouped_df_last_10games %>% 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))

write.csv(prediction_df, file = "CHI_MEMVSCHI_GAMEID.csv", row.names = FALSE)

################################################### MEMPHIS #############################################

for (id in MEM_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("MEM_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_MEM_grouped_df_last_10games <- na.omit(MEM_grouped_df_last_10games)
prediction_MEM_grouped_df_last_10games <- select(prediction_MEM_grouped_df_last_10games, -PTS)
prediction_MEM_grouped_df_last_10games <- mutate(prediction_MEM_grouped_df_last_10games, ABBREVIATION = "CHI") 
prediction_MEM_grouped_df_last_10games <- mutate(prediction_MEM_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME")

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(MEM_grouped_df_last_10games$PLAYER_ID)) { ###CHANGE 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_MEM_grouped_df_last_10games %>% ###CHANGE 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))

write.csv(prediction_df, file = "MEM_MEMVSCHI_GAMEID22201165.csv", row.names = FALSE)

################################################### PORTLAND #############################################

for (id in POR_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("POR_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_POR_grouped_df_last_10games <- na.omit(POR_grouped_df_last_10games) 
prediction_POR_grouped_df_last_10games <- select(prediction_POR_grouped_df_last_10games, -PTS)
prediction_POR_grouped_df_last_10games <- mutate(prediction_POR_grouped_df_last_10games, ABBREVIATION = "MIN") 
prediction_POR_grouped_df_last_10games <- mutate(prediction_POR_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(POR_grouped_df_last_10games$PLAYER_ID)) { ###CHANGE 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_POR_grouped_df_last_10games %>% ###CHANGE 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))

write.csv(prediction_df, file = "POR_PORVSMINGAMEID22201166.csv", row.names = FALSE)

################################################### MINNESOTA #############################################

for (id in MIN_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("MIN_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_MIN_grouped_df_last_10games <- na.omit(MIN_grouped_df_last_10games) 
prediction_MIN_grouped_df_last_10games <- select(prediction_MIN_grouped_df_last_10games, -PTS)
prediction_MIN_grouped_df_last_10games <- mutate(prediction_MIN_grouped_df_last_10games, ABBREVIATION = "POR") 
prediction_MIN_grouped_df_last_10games <- mutate(prediction_MIN_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(MIN_grouped_df_last_10games$PLAYER_ID)) {
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_MIN_grouped_df_last_10games %>% 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

prediction_df <- prediction_df %>% 
  mutate(TOTAL = sum(PTS_pred))

write.csv(prediction_df, file = "MIN_PORVSMINGAMEID22201166.csv", row.names = FALSE)

################################################### TORONTO #############################################

for (id in TOR_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("TOR_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_TOR_grouped_df_last_10games <- na.omit(TOR_grouped_df_last_10games) 
prediction_TOR_grouped_df_last_10games <- select(prediction_TOR_grouped_df_last_10games, -PTS)
prediction_TOR_grouped_df_last_10games <- mutate(prediction_TOR_grouped_df_last_10games, ABBREVIATION = "CHA") 
prediction_TOR_grouped_df_last_10games <- mutate(prediction_TOR_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME") 



prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(TOR_grouped_df_last_10games$PLAYER_ID)) { ###CHANGE 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_TOR_grouped_df_last_10games %>% ###CHANGE 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "TOR_CHAVSTORGAMEID22201163.csv", row.names = FALSE)

################################################### CHARLOTTE #############################################

for (id in CHA_grouped_df_last_10games$PLAYER_ID) {
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("CHA_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_CHA_grouped_df_last_10games <- na.omit(CHA_grouped_df_last_10games) 
prediction_CHA_grouped_df_last_10games <- select(prediction_CHA_grouped_df_last_10games, -PTS)
prediction_CHA_grouped_df_last_10games <- mutate(prediction_CHA_grouped_df_last_10games, ABBREVIATION = "TOR") 
prediction_CHA_grouped_df_last_10games <- mutate(prediction_CHA_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(CHA_grouped_df_last_10games$PLAYER_ID)) { 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_CHA_grouped_df_last_10games %>% 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "CHA_CHAVSTORGAMEID22201163", row.names = FALSE)

################################################### UTAH #############################################

for (id in UTA_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("UTA_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_UTA_grouped_df_last_10games <- na.omit(UTA_grouped_df_last_10games) 
prediction_UTA_grouped_df_last_10games <- select(prediction_UTA_grouped_df_last_10games, -PTS)
prediction_UTA_grouped_df_last_10games <- mutate(prediction_UTA_grouped_df_last_10games, ABBREVIATION = "BKN") 
prediction_UTA_grouped_df_last_10games <- mutate(prediction_UTA_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(UTA_grouped_df_last_10games$PLAYER_ID)) { 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_UTA_grouped_df_last_10games %>% #
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "UTA_UTAVSBKNGAMEID22201163.csv", row.names = FALSE)

################################################### BROOKLYN #############################################

for (id in BKN_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("BKN_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  else {
    NULL
  } 
} 

prediction_BKN_grouped_df_last_10games <- na.omit(BKN_grouped_df_last_10games) 
prediction_BKN_grouped_df_last_10games <- select(prediction_BKN_grouped_df_last_10games, -PTS)
prediction_BKN_grouped_df_last_10games <- mutate(prediction_BKN_grouped_df_last_10games, ABBREVIATION = "UTA") 
prediction_BKN_grouped_df_last_10games <- mutate(prediction_BKN_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(BKN_grouped_df_last_10games$PLAYER_ID)) {
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_BKN_grouped_df_last_10games %>% 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "BKN_UTAVSBKNGAMEID22201163.csv", row.names = FALSE)

################################################### NEW YORK #############################################

for (id in NYK_grouped_df_last_10games$PLAYER_ID) { 
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("NYK_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) 
  }
  else {
    NULL
  } 
} 

prediction_NYK_grouped_df_last_10games <- na.omit(NYK_grouped_df_last_10games) 
prediction_NYK_grouped_df_last_10games <- select(prediction_NYK_grouped_df_last_10games, -PTS)
prediction_NYK_grouped_df_last_10games <- mutate(prediction_NYK_grouped_df_last_10games, ABBREVIATION = "WAS") 
prediction_NYK_grouped_df_last_10games <- mutate(prediction_NYK_grouped_df_last_10games, WHERE_PLAYED = "HOME_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(NYK_grouped_df_last_10games$PLAYER_ID)) { 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_NYK_grouped_df_last_10games %>%  
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "NYK_WASVSNYKGAMEID22201168.csv", row.names = FALSE)

################################################### WASHINGTON #############################################

for (id in WAS_grouped_df_last_10games$PLAYER_ID) { ### CHange this to target city
  if (any(id %in% df$PLAYER_ID)) {
    df_filtered <- df %>% filter(PLAYER_ID == id)
    model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)
    model_df <- tidy(model)
    model_df <- select(model_df,c(term,estimate,p.value))
    df_name <- paste("WAS_df_", id, sep="")
    assign(df_name, model_df)
    model_name <- paste("", id, sep="")
    assign(model_name, model) # new line to assign the model with player name
  }
  else {
    NULL
  } 
} 

prediction_WAS_grouped_df_last_10games <- na.omit(WAS_grouped_df_last_10games)
prediction_WAS_grouped_df_last_10games <- select(prediction_WAS_grouped_df_last_10games, -PTS)
prediction_WAS_grouped_df_last_10games <- mutate(prediction_WAS_grouped_df_last_10games, ABBREVIATION = "NYK") 
prediction_WAS_grouped_df_last_10games <- mutate(prediction_WAS_grouped_df_last_10games, WHERE_PLAYED = "AWAY_GAME") 

prediction_df <- data.frame(TEAM_ID = numeric(),
                            PLAYER_ID = numeric(),
                            PLAYER_NAME = character(),
                            PTS_pred = numeric(),
                            stringsAsFactors = FALSE)

for (id in unique(WAS_grouped_df_last_10games$PLAYER_ID)) { 
  model_name <- paste0("", id)
  model <- get(model_name)
  
  player_data <- prediction_WAS_grouped_df_last_10games %>% 
    filter(PLAYER_ID == id)
  
  if (nrow(player_data) > 0) {
    prediction <- predict(model, newdata = player_data)
    
    prediction_df <- rbind(prediction_df, data.frame(
      TEAM_ID = player_data$TEAM_ID[1],
      PLAYER_ID = id,
      PLAYER_NAME = player_data$PLAYER_NAME[1],
      PTS_pred = ifelse(is.na(prediction), 0, prediction)
    ))
  }
}

write.csv(prediction_df, file = "WAS_WASVSNYKGAMEID22201168.csv", row.names = FALSE)

################################################ PLAYER POINTS PREDICTION #############################################

# In order to test player point prediction, the following script was used
#Using player game data outside of the prediction timeframe 
#Model development using data from 2004 - 2022 up to December of current season, player predictions are based on player points for all games after January 1, 2023

playerbygame_forecasting <- read_csv("playerbygame_forecasting.csv", 
                                     col_types = cols(GAME_DATE = col_date(format = "%Y-%m-%d")))

#selected list of 10 random players

TARGET_PLAYERS = unique(playerbygame_forecasting$PLAYER_ID)
TARGET_PLAYERS <- data.frame(TARGET_PLAYERS)


df_filtered <- df %>% filter(PLAYER_ID == 203078) #filtered on specific player id
model <- lm(PTS ~ WHERE_PLAYED + ABBREVIATION,data = df_filtered)

forecast_test <- playerbygame_forecasting %>% filter(PLAYER_ID == 203078)

#This process was slightly manual but allowed for testing beyond game comparison
#Given a player may not have played all games, we created a matrix of games for each the forecast would be entered
N = nrow(forecast_test)

final_output <- matrix(NA, nrow=N)

for (i in seq(N)) {
  predict_data <- forecast_test[i,]
  final_output[i,] <- predict(model, predict_data)
}

final_output <- data.frame(final_output)

result <- cbind(forecast_test, final_output)

#Creating MSE for specific player
result$mse <- (result$final_output - result$PTS)^2
result<- na.omit(result)

#creates a result per player id
write.csv(result, file = "result_203078.csv", row.names = FALSE)


