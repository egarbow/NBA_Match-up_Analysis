#Project Visualization in D3

#Team 052 - NBA Matchup Analysis

- Dan Goldin (dgoldin3)
- Diego Escalera (dayala9)
- Ethan Garbow (egarbow3)
- Michael Lamontagne (mlamontagne6)
- Sebastián de la Hoz (sluna7)
- Yotan Demi-ejegi (ydemiejegi3)


##  ************** DESCRIPTION ************** 

## Directory structure:

-- <team052final> 
	| -- CODE/
		| -- data/
			| -- Filled_Attributes.csv
			| -- gameid_22201163.csv
 			| -- gameid_22201164.csv
			| -- gameid_22201165.csv
			| -- gameid_22201166.csv
			| -- gameid_22201167.csv
			| -- gameid_22201168.csv
			| -- merged_df.csv
			| -- etc.
		| -- lib/
			| -- d3-dsv.min.js
			| -- d3-tip.min.js
			| -- d3.v5.min.js
		| -- nba.html
		| -- team_logos/
			| -- Atlanta.png
				| -- Brooklyn.png
				| -- Charlotte.png
				| -- Chicago.png
				| -- Dallas.png
				| -- Memphis.png
				| -- Minnesota.png
				| -- New York.png
				| -- Portland.png
				| -- README.txt
				| -- Toronto.png
				| -- Utah.png
				| -- Washington.png
	| -- DOC/
		| -- team052poster.pdf
		| -- team052report.pdf
	
	| -- README.txt/


There are two folders CODE and DOC, and a readme.txt file (which you are reading at this very moment!!!). 
The directory structure can be seen visually by the directory tree diagram above. In the code folder there is the 
data, lib, src, and team_logos folder. The data folder contains the .csv files needed by nba.html and a plethera of 
other data files that can be used to perform data analysis and continue the work of this project. The main data
files are game_details.csv and games.csv, with which you can derrive the other .csv files. game_details.csv contains 
player data for a given game, and games.csv contains game related stats and who played against who when.

The lib folder contains the d3 libraries needed by nba.htlm. team_logos contains the team logo images used by
nba.html. The src folder contains the jupyter and r files used to conduct data collection and analysis. The process of
data collection and analysis can be automated using these files with a few tweeks. The Twitter_Sampling.ipynd and 
team052_nba_datataccess.ipynb files can be used for data collection which can feed into the team052_finalscoresprediction.ipynb
and team052_nba_team_player.ipynb files for further processing. Then the R files, team052_data_exploratory_nba.R and
team052_modeling.R can be used to perform the prediction analysis and output it into csvs like gameid_xxxxx.csv which can 
finally be used by nba.html.

 ************** TO SEE A LIVE EXAMPLE OF nba.html RUNNING SEE BELOW ************** 

LIVE LINK: https://egarbow.github.io/NBA_Match-up_Analysis

GITHUB REPOSITORY: https://github.com/egarbow/NBA_Match-up_Analysis

 

##  ************** INSTALLATION/SETUP (LOCAL)  ************** 


### Setting up the server
Open a terminal and navigate to the visualization folder, e.g. `cd CODE`
Run the following command:

	python -m http.server 8000

### Opening the document

Open your web browser (Google Chrome is preferred) 
On the URL, type

	http://localhost:8000/

You will see the Directory listing for the folder.

Click on nba.html
Voila! Navigate the page at your own will.


##  ************** EXECUTION (USING THE TOOL)  ************** 

On the first tab (Stats):
You can select up to 10 players (you can remove them by clicking the "x" next to their names), and select which statistic you want to visualize.

On the second tab (Matchup Predictions):
You can select 1 out of 6 different games we predicted the score (only from the starting 5 players on the game). 
You can hover your mouse over the players names to see information about the sentiment score based on the tweets related to that player.

************** IMPORTANT: MUST FIRST CLICK OUT OF WINDOW THEN HOVER MOUSE OVER IF USING PC/MAC **************

On the third tab (About):
You can read information about the best team in CSE 6242: Group #52






