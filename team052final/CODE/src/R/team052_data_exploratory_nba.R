library(tidyverse)
library(dplyr)
library(corrplot)
library(ggplot2)

#########################################################################################################
############################ Correlation Matrix Plot and Heat Map ######################################
########################################################################################################
# Recent Data
games_details <- read.csv("C:/Users/escal/OneDrive/Documents/player stats nba/Recent Data/games_players_040223.csv")

# Correlation Matrix interest variables
games_details1 <- games_details[,-c(1,2,3,4,5,6,7,8,9,10,11,12)] 
games_details1 <- games_details1[,-18] 

# Correlation Matrix
corr = cor(games_details1, use = "complete.obs")
corr

# Corr Plot
corrplot(corr, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

# Heat Map Plot
col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = corr, col = col, symm = TRUE)


########################################################################################################
################### Parallel Coordinate Avg Stats for Starting Lineups in NBA Teams ####################
#######################################################################################################
# Recent Data
games_details <- read.csv("C:/Users/escal/OneDrive/Documents/player stats nba/Recent Data/games_players_040223.csv")
# Historical Data
games_details2 <- read.csv("C:/Users/escal/OneDrive/Documents/player stats nba/matchups/games_details.csv")
games_details <- games_details[,-1]
# Combining columns and rows
games_details <- rbind(games_details,games_details2)

# Filtering Season data , Oct 18 2022
games_details <- games_details[1:12891,] 

# Team Starting Lineups for predicted games 
uta_selected_players <- c('Talen Horton-Tucker','Kris Dunn','Lauri Markkanen','Udoka Azubuike','Juan Toscano-Anderson') 

bkn_selected_players = c('Spencer Dinwiddie','Patty Mills','Markieff Morris','Seth Curry','Joe Harris')

mem_selected_players = c('Ja Morant','Desmond Bane','Dillon Brooks','Jaren Jackson Jr.','Xavier Tillman')

chi_selected_players = c('Patrick Beverley','Zach LaVine','DeMar DeRozan','Patrick Williams','Nikola Vucevic')

por_selected_players = c('Damian Lillard','Anfernee Simons','Cam Reddish','Matisse Thybulle','Jusuf Nurkic')

min_selected_players = c('Mike Conley','Anthony Edwards','Kyle Anderson','Jaden McDaniels','Rudy Gobert')

was_selected_players = c('Delon Wright','Johnny Davis','Corey Kispert','Anthony Gill','Daniel Gafford')

nyk_selected_players = c('Immanuel Quickley','Quentin Grimes','RJ Barrett','Obi Toppin','Isaiah Hartenstein')

tor_selected_players = c("Fred VanVleet","OG Anunoby","Scottie Barnes","Pascal Siakam","Jakob Poeltl")

cha_selected_players = c('Dennis Smith Jr.','Terry Rozier','Svi Mykhailiuk','Theo Maledon','JT Thor')

atl_selected_players = c('Trae Young', 'Dejounte Murray','Saddiq Bey','John Collins','Clint Capela')

dal_selected_players = c('Kyrie Irving', 'Josh Green','Luka Doncic','Dwight Powell','Reggie Bullock')

# List of Starting Players
all_selected_players <- c(uta_selected_players, bkn_selected_players, mem_selected_players, chi_selected_players, por_selected_players, min_selected_players, was_selected_players, nyk_selected_players,
                          tor_selected_players,cha_selected_players,atl_selected_players,dal_selected_players)

# Filtering the selected teams starting players  
all_games <- games_details %>%
  filter(PLAYER_NAME %in% all_selected_players)
         
# Grouping players by team and averaging their stats 
all_avg <- all_games %>%
  na.omit() %>%
  group_by(TEAM_ABBREVIATION) %>%
  summarize(across(c(FGM:PTS), mean), .groups = 'drop')

all_avg <- all_avg %>%
  filter(TEAM_ABBREVIATION %in% c("UTA","BKN","MEM","CHI","POR","MIN","WAS","NYK","TOR","CHA","ATL","DAL"))

# Increasing the number of rows and decreasing the number of columns for plot purpose
all_long <- all_avg %>%
  pivot_longer(cols = c(FGM:PTS), names_to = "stat", values_to = "value")

# Parallel Coordinate Plot 
ggplot(all_long, aes(x = stat, y = value, group = TEAM_ABBREVIATION, color = TEAM_ABBREVIATION)) +
  geom_line(alpha = 0.5) +
  geom_point(size = 2) +
  labs(x = "", y = "Value", color = "", title = "Average Stats for Starting Lineups in NBA Teams") +
  scale_color_manual(values = c("#1b9e77", "#000000", "#7399C6", "#8B0000", "#E03A3E", "#9A32CD", "#8B8682", "#F58426","#0000FF", "#00FF00","#B8860B","#556B2F")) +
  theme_classic() +
  theme(legend.position = "right")

##########################################################################################################
############################## Chicago Bulls vs Memphis Grizzlies Historical Matchups ####################
##########################################################################################################
games <- read.csv("C:/Users/escal/OneDrive/Documents/player stats nba/Recent Data/games (1).csv")

# Filtering CHI and MEM home and away games 
df <- games %>%
  filter(MATCHUP == "CHI @ MEM")

df2 <- games %>%
  filter(MATCHUP == "MEM @ CHI")

# Merging both dataframes
merge1 <- rbind(df,df2) 

# Dropping unnecesary columns
dat <- merge1[,c(4:11)]

# Exporting dataframe to csv
write.csv(dat, "C:/Users/escal/OneDrive/Documents/player stats nba/Data_Exploratory_NBA/por_min.csv", row.names=FALSE)








