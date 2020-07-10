from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors import LinkExtractor
from bs4 import BeautifulSoup
import pandas as pd
import re
import os

class AFLSpida(CrawlSpider):
    """
    Page Spider for AFL indidual player stats
    """

    name = "AFLstats"
    allowed_domains = ["afl.com.au"]

    # start_rnd = getattr(self, 'start', 1)
    # end_rnd = getattr(self, 'end', 23)

    start_urls = ["http://www.afl.com.au/fixture?roundId=CD_R2017014%s#tround" % rnd for rnd in [str(item).zfill(2) for item in range(1,23)]]

    rules = (
        Rule(
            # Only interested in the game by game URLs
            LinkExtractor(allow="afl\.com\.au/match\-centre/2017/\d+/.+\-v\-.+"),
            callback='parse_page'
            ),
    )

    counter = 1

    def parse_page(self, response):

        # print(response.url)

        out_location = getattr(self, 'out', os.getcwd())

        # URL
        URL_split = response.url.split("/")

        # Use table ID's to exxtract using xpath
        away_resp = response.xpath('//*[@id="awayTeam-advanced"]')
        home_resp = response.xpath('//*[@id="homeTeam-advanced"]')

        if len(home_resp) > 0 and len(away_resp) > 0:

            # Convert to Pandas DF
            home_df = pd.read_html(home_resp[0].extract())[0]
            away_df = pd.read_html(away_resp[0].extract())[0]

            # +++
            # Need to add some metadata
            # +++
            # Team
            home_team = URL_split[6].split("-")[0]
            away_team = URL_split[6].split("-")[2]

            # Round
            rnd = URL_split[5]
            yr = URL_split[4]

            # Add to df
            home_df["Team"] = home_team
            home_df["Oponnent"] = away_team
            away_df["Team"] = away_team
            home_df["Oponnent"] = home_team

            data = home_df.append(away_df)
            
            # Add metadata
            data["Year"] = yr
            data["Round"] = rnd

            # Remove nums in player string
            data["Player"] = data["Player"].str.replace('\d+\s+','')
            
            # Output filepath
            fl_pth = os.path.join(out_location, 'afl_data_' + yr + '.csv')

            if os.path.isfile(fl_pth):
                data.to_csv(fl_pth, mode='a', header=False, index = False)
            else:
                data.to_csv(fl_pth, index = False)

            print("Successfully logged: {0} vs. {1} in round {2} {3}".format(home_team, away_team, rnd, yr))

        return