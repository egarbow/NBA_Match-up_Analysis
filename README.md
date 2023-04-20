# NBA_Match-up_Analysis
This project seeks to use data analytics and social sentiment to predict the outcome of NBA games

```
Project Visualization in D3

### Loading data
Download the visualization folder. 
The structure of your folder should look like this:

-- <Team 52 folder> 
	| -- visualization/
		| -- data/
			| -- Filled_Attributes.csv
			| -- gameid_22201163.csv
 			| -- gameid_22201164.csv
			| -- gameid_22201165.csv
			| -- gameid_22201166.csv
			| -- gameid_22201167.csv
			| -- gameid_22201168.csv
			| -- merged_df.csv
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
```
### Setting up the server
Open a terminal and navigate to the visualization folder, e.g. `cd team52/visualization`
Run the following command:

	python -m http.server 8000

### Opening the document

Open your web browser (Google Chrome is preferred) 
On the URL, type

	http://localhost:8000/

You will see the Directory listing for the folder.

Click on nba.html
Voila! Navigate the page at your own will.

On the first tab (Stats):
You can select up to 10 players (you can remove them by clicking the "x" next to their names), and select which statistic you want to visualize.

On the second tab (Matchup Predictions):
You can select 1 out of 6 different games we predicted the score (only from the starting 5 players on the game). 
You can hover your mouse over the players names to see information about the sentiment score based on the tweets related to that player.

On the third tab (About):
You can read information about the best team in CSE 6242: Group #52
