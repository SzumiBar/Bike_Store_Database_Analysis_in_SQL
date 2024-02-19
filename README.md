# Analysis of 'Bike Stores' relational database downloaded from Kaggle.
### After setting up database in PostgreSQL (with the use of DBeaver), I came up with some useful questions, for which I wrote queries available in files above. Below is visible database schema design, as well as all the questions with the resulting tables from the previously mentioned queries.

<br />

## ER Diagram
![Bike Store Diagram](https://github.com/SzumiBar/Bike_Store_Database_Analysis_in_SQL/assets/158743658/8dbb331e-e613-4766-a420-807902ab9a69)

<br />

### Relative proportions of bike categories sold in each state
|State|Category           |Proportion|
|-----|-------------------|:--------:|
|CA   |Cruisers Bicycles  |28%       |
|CA   |Mountain Bikes     |25%       |
|CA   |Children Bicycles  |17%       |
|CA   |Comfort Bicycles   |11%       |
|CA   |Road Bikes         |8%        |
|CA   |Cyclocross Bicycles|6%        |
|CA   |Electric Bikes     |5%        |
|NY   |Cruisers Bicycles  |29%       |
|NY   |Mountain Bikes     |25%       |
|NY   |Children Bicycles  |17%       |
|NY   |Comfort Bicycles   |11%       |
|NY   |Road Bikes         |8%        |
|NY   |Cyclocross Bicycles|6%        |
|NY   |Electric Bikes     |4%        |
|TX   |Cruisers Bicycles  |31%       |
|TX   |Mountain Bikes     |25%       |
|TX   |Children Bicycles  |15%       |
|TX   |Comfort Bicycles   |11%       |
|TX   |Road Bikes         |9%        |
|TX   |Electric Bikes     |5%        |
|TX   |Cyclocross Bicycles|4%        |

<br />

### Proportions and counts of delayed shipments for each bike store, along with average delay time in hours
|Store           |Proportion of delayed shipments|Number of delayed shipments|Average delay in hours|
|----------------|:-----------------------------:|:-------------------------:|:--------------------:|
|Santa Cruz Bikes|36.6%                          |104                        |11                    |
|Baldwin Bikes   |31.1%                          |317                        |10                    |
|Rowlett Bikes   |26.1%                          |37                         |8                     |

<br />

### Which product categories are sold by which brands, and what are the average prices for products from these categories within specific brands
|Brand       |Children bicycles|Comfort bicycles|Cyclocross bicycles|Electric bikes|Mountain bikes|Road bikes|
|------------|:---------------:|:--------------:|:-----------------:|:------------:|:------------:|:--------:|
|Surly       |                 |                |1,582              |              |1,303         |1,246     |
|Pure Cycles |                 |                |                   |              |              |          |
|Sun Bicycles|110              |472             |                   |1,560         |833           |          |
|Ritchey     |                 |                |                   |              |750           |          |
|Electra     |330              |772             |                   |2,800         |              |          |
|Haro        |250              |                |                   |              |870           |          |
|Trek        |260              |                |3,183              |3,511         |1,926         |3,430     |
|Heller      |                 |                |                   |              |2,173         |          |
|Strider     |210              |                |                   |              |              |          |

<br />

### Mean shipping time (in hours) between each store and customers cities, displayed in form of 3 store-city combinations with shortest time of delivery and 3 store-city combinations with longest time of delivery
|Store           |Category      |Customer location|Shipping time in hours|
|----------------|--------------|-----------------|:--------------------:|
|Baldwin Bikes   |Top 3 Longest |Fresh Meadows    |64                    |
|Baldwin Bikes   |Top 3 Longest |Westbury         |72                    |
|Baldwin Bikes   |Top 3 Longest |Tonawanda        |72                    |
|Baldwin Bikes   |Top 3 Shortest|Woodhaven        |27                    |
|Baldwin Bikes   |Top 3 Shortest|Yonkers          |28                    |
|Baldwin Bikes   |Top 3 Shortest|Rockville Centre |31                    |
|Rowlett Bikes   |Top 3 Longest |Fort Worth       |67                    |
|Rowlett Bikes   |Top 3 Longest |Amarillo         |58                    |
|Rowlett Bikes   |Top 3 Longest |El Paso          |64                    |
|Rowlett Bikes   |Top 3 Shortest|Mcallen          |32                    |
|Rowlett Bikes   |Top 3 Shortest|Sugar Land       |32                    |
|Rowlett Bikes   |Top 3 Shortest|Copperas Cove    |32                    |
|Santa Cruz Bikes|Top 3 Longest |San Pablo        |57                    |
|Santa Cruz Bikes|Top 3 Longest |Mountain View    |72                    |
|Santa Cruz Bikes|Top 3 Longest |South El Monte   |59                    |
|Santa Cruz Bikes|Top 3 Shortest|Yuba City        |24                    |
|Santa Cruz Bikes|Top 3 Shortest|Fresno           |38                    |
|Santa Cruz Bikes|Top 3 Shortest|Rocklin          |38                    |

<br />

## Top 5 customers who:<br>  • saved the most money due to discounts<br>  • spent the most money overall
|ID   |Customer name  |Money saved due to discounts|
|-----|---------------|:--------------------------:|
|75   |Abby Gamble    |4,698                       |
|10   |Pamelia Newman |4,168                       |
|61   |Elinore Aguilar|4,025                       |
|1023 |Adena Blake    |3,670                       |
|93   |Corrina Sawyer |3,602                       |

<br />

|ID |Customer name |Total money spent|
|---|--------------|:---------------:|
|10 |Pamelia Newman|37,802           |
|75 |Abby Gamble   |37,501           |
|94 |Sharyn Hopkins|37,139           |
|6  |Lyndsey Bean  |35,858           |
|16 |Emmitt Sanchez|34,504           |

<br />

## The three cities that bring in the most revenue for each store
|Store           |City                  |Total revenue|
|----------------|----------------------|:-----------:|
|Baldwin Bikes   |Mount Vernon          |105,563      |
|Baldwin Bikes   |Ballston Spa          |98,620       |
|Baldwin Bikes   |Baldwinsville         |96,376       |
|Rowlett Bikes   |San Angelo            |98,429       |
|Rowlett Bikes   |Houston               |81,022       |
|Rowlett Bikes   |Harlingen             |76,870       |
|Santa Cruz Bikes|Canyon Country        |86,521       |
|Santa Cruz Bikes|Palos Verdes Peninsula|74,642       |
|Santa Cruz Bikes|South El Monte        |69,112       |

<br />

## How the number of orders changes during the year
###### No distinguishable pattern based on years 2016/2017. Year 2018 has clearly deviated pattern of orders - probably falsely inputed, or due to some unclarified circumstances.
|Month    |Proportion 2016|Count 2016|Proportion 2017|Count 2017|Proportion 2018|Count 2018|
|---------|:-------------:|:--------:|:-------------:|:--------:|:-------------:|:--------:|
|JANUARY  |8%             |50        |7%             |50        |18%            |52        |
|FEBRUARY |8%             |49        |8%             |57        |12%            |35        |
|MARCH    |9%             |55        |10%            |67        |23%            |68        |
|APRIL    |7%             |43        |8%             |57        |43%            |125       |
|JUNE     |7%             |45        |9%             |63        |0%             |1         |
|JULY     |8%             |50        |8%             |52        |1%             |4         |
|AUGUST   |10%            |63        |9%             |65        |1%             |2         |
|SEPTEMBER|11%            |67        |8%             |53        |0%             |1         |
|OCTOBER  |10%            |64        |9%             |65        |0%             |1         |
|NOVEMBER |7%             |43        |8%             |55        |1%             |2         |
|DECEMBER |9%             |55        |7%             |47        |0%             |1         |


