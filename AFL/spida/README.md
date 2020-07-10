# Spida

Spida is an scrapy spider that enables you to scrape 2017 AFL advanced stats from the AFL match-centre.

I'll eventaully get around to making a web-app to enable self serve scrapy'ing.

## Use (for now)

The spider has one argument: __out\_location__ (the location you want to output the csv data)

To use, clone this repo and navigate (at terminal) to the project. Then use


```Python
scrapy crawl AFLSpida -a out = "C:/Users/Tom Bishop/Desktop/"
```

Change the out location obvs.

## Fields

Field | Description
--- | ---
Player | Player name
No. | Player number
K | Kicks
H | Handballs
D | Disposals
CP | Contested posessions
UP | Uncontested possesions
DE% | Effective dosposal percentage
CLG | Clangers
M | Marks
CM | Contested marks
M50 | Marks inside 50
HO | Hit outs
CLR | Clearances
CC | Centre clearances
ST | Stoppages
R50 | Rebound 50s
FF | Frees for
FA | Frees against
T | Tackles
1PC | 1 percenter
Bo | Bounces
i50 | Inside 50s
G | Goals
B | Behinds
GA | Goal assists
G% | Goal accuracy
TG% | Time on ground %
AF | AFL fantasy points
Team | Team
Year | Year
Round | Round

## Source

Data source is the individual game pages on AFL.com match centre.

## Issues & Improvements

* __Add:__ Round filtering as a spider argument.
* __Add:__ Year filtering as a spider argument.
* __Add:__ Build as Flask web-app
