Report for US social determinants of health by county dataset
================
Joshua Sia, Morgan Rosenberg, Sufang Tan, Yinan Guo (Group 25) </br>
2021/11/27

-   [Summary](#summary)
-   [Introduction](#introduction)
-   [Methods](#methods)
    -   [Data](#data)
    -   [Analysis](#analysis)
-   [Results](#results)
    -   [Exploratory Data Analysis
        (EDA)](#exploratory-data-analysis-eda)
    -   [Multiple linear regression
        model](#multiple-linear-regression-model)
-   [Discussion](#discussion)
-   [References](#references)

# Summary

Here, we attempt to build a multiple linear regression model which is
used to quantify the influence of socioeconomic factors on the COVID-19
prevalence (measured by cases per 100,000 population) among all US
counties. Factors such as percentage of smokers, income ratio,
population density, percent unemployed, etc. are explored. Our final
regression model suggests that the percentage of smokers, teenage birth
rates, and chlamydia rates are the three features more strongly
associated with COVID-19 prevalence. However, the original data set
contained over 200 features and a subset of these features were chosen
arbitrarily which means that there is still room to explore other
socioeconomic features that are significantly associated with COVID-19
prevalence.

# Introduction

COVID-19 is a serious pandemic that has introduced a wide variety of
challenges since 2019. By analysing the association of certain
socioeconomic factors with COVID-19 prevalence, we hope to shed some
light onto the societal features that may be associated with a high
number of COVID-19 cases. Identifying the socioeconomic factors could
also help policymakers and leaders make more informed decisions in
combatting COVID-19.

# Methods

## Data

The original data set used in this project is of US social determinants
of health by county created by Dr. John Davis at Indiana University, the
United States. Each row in the original data set represents a day for a
county with the cumulative number of COVID-19 cases, and other
socioeconomic features of the county. There are over 790,000 rows and
over 200 features in the data set. We identified a subset of these
features which we were interested in and also added a few “wildcard”
features such as the teen birth rate and chlamydia rate which might be
related to broader social determinants of public health. In the future,
additional features could be chosen as they become of interest to the
team, or are requested by the community.

The data set reports time series data per county for the cumulative
COVID-19 cases and different socioeconomic features. However, due to
limits in measurements and reporting, COVID-19 cases and socioeconomic
features were updated at irregular intervals (e.g. COVID-19 cases were
reported daily, whereas the socioeconomic features were reported no more
than once a month). Thus, we created summary statistics for the
socioeconomic features per county such as the mean percentage of
smokers.

The processed data contains 1621 observations and 18 features where each
row corresponds to the cumulative COVID-19 cases, and aggregated
socioeconomic features for each county.

## Analysis

A multiple linear regression model with interaction terms was used to
quantify the association of the socioeocnomic features with COVID-19
prevalence. The R programming language (R Core Team 2019) and the
following R packages were used to perform the analysis: broom (Robinson,
Hayes, and Couch 2021), docopt (de Jonge 2018), knitr (Xie 2014),
tidyverse (Wickham 2017), testhat(Wickham 2011), and here (Müller 2020).
The code used to perform the analysis and create this report can be
found
[here](https://github.com/UBC-MDS/DSCI_522_US_social_determinants_of_health_by_county).

# Results

## Exploratory Data Analysis (EDA)

Exploratory data analysis was first carried out to determine the
distributions of data, as well as to get early hints into how certain
socioeconomic features might be associated with COVID-19 prevalence.
First, we create a summary table to check COVID-19 prevalence for each
county.

### COVID-19 prevalence for every county

| county   | cases_per_100k | percent_smokers | income_ratio | percent_unemployed_CHR |
|:---------|---------------:|----------------:|-------------:|-----------------------:|
| Franklin |       56251.54 |          18.075 |        4.439 |                  3.971 |
| Brown    |       42577.30 |          16.292 |        4.050 |                  3.377 |
| Marion   |       40167.81 |          19.135 |        4.664 |                  4.268 |
| Union    |       39026.50 |          17.805 |        4.674 |                  4.327 |
| Clark    |       36860.96 |          18.495 |        4.168 |                  4.171 |
| Wayne    |       33275.47 |          19.610 |        4.610 |                  4.823 |

Table 5. Top 5 counties with highest number of cumulative COVID-19
cases.

|      | county      | cases_per_100k | percent_smokers | income_ratio | percent_unemployed_CHR |
|:-----|:------------|---------------:|----------------:|-------------:|-----------------------:|
| 1616 | Sagadahoc   |        483.862 |          13.591 |        3.946 |                  2.711 |
| 1617 | Rutland     |        445.679 |          14.580 |        4.423 |                  3.131 |
| 1618 | Windsor     |        406.126 |          13.396 |        4.351 |                  2.337 |
| 1619 | Piscataquis |        334.429 |          18.901 |        4.650 |                  4.165 |
| 1620 | Aroostook   |        249.262 |          18.593 |        5.049 |                  4.813 |
| 1621 | Kauai       |        170.341 |          12.738 |        4.417 |                  2.512 |

Table 6. Top 5 counties with lowest number of cumulative COVID-19 cases

### Distributions of numeric features

Density plots for all numeric variables are also created to check their
distributions. The is a positive skew for many of the variables.

<img src="../results/numeric_feats_dist.png" title="Figure 1. Density plots of numeric feature" alt="Figure 1. Density plots of numeric feature" width="100%" />

### Relationships between cumulative COVID-19 cases per 100,000 of each county and socioeconomic features

Plots to demonstrate the relationship between COVID-19 cases per 100,000
and socioeconomic features are created for each county. The linear
relationships are not strong individually, however, this could be
because each feature is observed in isolation. There might be
interactions between these features which can have a linear relationship
with COVID-19 prevalence.

<img src="../results/cases_per_100k.png" title="Figure 2. Plots of total COVID-19 cases per 100k v.s. other features" alt="Figure 2. Plots of total COVID-19 cases per 100k v.s. other features" width="100%" />

## Multiple linear regression model

The coefficients for a random sample of 10 features are selected, along
with the p-values and whether they are significant at the 0.05
significance level.

| term                                               |     estimate |    conf.low |  conf.high |   p.value | is_sig |
|:---------------------------------------------------|-------------:|------------:|-----------:|----------:|:-------|
| percent_unemployed_CHR                             | -1035.480119 | -1360.17867 | -710.78156 | 0.0000000 | TRUE   |
| percent_fair_or_poor_health:percent_unemployed_CHR |   394.047408 |    42.66174 |  745.43308 | 0.0279792 | TRUE   |
| percent_smokers:percent_fair_or_poor_health        |  -613.882978 | -1068.95261 | -158.81334 | 0.0082261 | TRUE   |
| population_density_per_sqmi:chlamydia_rate         |  -240.525299 |  -630.69991 |  149.64932 | 0.2267829 | FALSE  |
| violent_crime_rate                                 |   211.739489 |  -118.18567 |  541.66465 | 0.2082769 | FALSE  |
| percent_vaccinated:percent_unemployed_CHR          |  -236.785678 |  -492.00469 |   18.43333 | 0.0689788 | FALSE  |
| percent_vaccinated:percent_fair_or_poor_health     |  -299.976440 |  -762.92609 |  162.97321 | 0.2039269 | FALSE  |
| population_density_per_sqmi:percent_unemployed_CHR |   470.454185 |   -85.80346 | 1026.71183 | 0.0973327 | FALSE  |
| income_ratio:percent_unemployed_CHR                |    -8.633577 |  -313.66957 |  296.40241 | 0.9557341 | FALSE  |
| percent_smokers:population_density_per_sqmi        |  -368.353360 | -1158.78317 |  422.07645 | 0.3608157 | FALSE  |

Table 9. Coefficients of each feature of the multiple linear regression
model.

### Coefficients of significant feature of the multiple linear regression model with 95% confidence intervals

The coefficients along with their 95% confidence intervals are plotted
as error bars for features that were significant at the 0.05
significance level.

<img src="../results/feature_coefs.png" title="Figure 4. Coefficients of each feature of the multiple linear regression model with 95% confidence intervals." alt="Figure 4. Coefficients of each feature of the multiple linear regression model with 95% confidence intervals." width="100%" />

# Discussion

PLEASE EDIT

The multiple linear regression result reveals that only three features
and the intercept term are statistically significant on 5% significant
level. After normalizing all features, the value of the intercept term
is larger than the sum of the absolute coefficient of all other
significant features. This means our current model has low explanatory
power on the responsive variable COVID-19 cases, which enables the
intercept term to capture most of the changes. To further improve this
model in future with hopes of finding the essential influence factors of
COVID-19 prevalence, we need to improve our feature selecting process by
using methods like PCA model and incorporating advanced feature
engineering techniques.

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-docopt" class="csl-entry">

de Jonge, Edwin. 2018. *Docopt: Command-Line Interface Specification
Language*. <https://CRAN.R-project.org/package=docopt>.

</div>

<div id="ref-here" class="csl-entry">

Müller, Kirill. 2020. *Here: A Simpler Way to Find Your Files*.
<https://CRAN.R-project.org/package=here>.

</div>

<div id="ref-R" class="csl-entry">

R Core Team. 2019. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-broom" class="csl-entry">

Robinson, David, Alex Hayes, and Simon Couch. 2021. *Broom: Convert
Statistical Objects into Tidy Tibbles*.
<https://CRAN.R-project.org/package=broom>.

</div>

<div id="ref-testhat" class="csl-entry">

Wickham, Hadley. 2011. “Testthat: Get Started with Testing.” *The R
Journal* 3: 5–10.
<https://journal.r-project.org/archive/2011-1/RJournal_2011-1_Wickham.pdf>.

</div>

<div id="ref-tidyverse" class="csl-entry">

———. 2017. *Tidyverse: Easily Install and Load the ’Tidyverse’*.
<https://CRAN.R-project.org/package=tidyverse>.

</div>

<div id="ref-knitr" class="csl-entry">

Xie, Yihui. 2014. “Knitr: A Comprehensive Tool for Reproducible Research
in R.” In *Implementing Reproducible Computational Research*, edited by
Victoria Stodden, Friedrich Leisch, and Roger D. Peng. Chapman;
Hall/CRC. <http://www.crcpress.com/product/isbn/9781466561595>.

</div>

</div>
