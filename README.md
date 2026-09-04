# Post COVID Wages

This project looks at how wage income changed after COVID using public ACS/IPUMS labor market data. The main question is whether wage growth after COVID looked different across workers, industries, states, and occupations that were more or less suited to remote work.

The project uses Stata for the main cleaning and regression work. R is used at the end to make the figures.

## Research Question

How were wages affected after COVID, and did those changes differ across groups of workers?

The project also keeps the original remote work question:

Did workers in occupations suited to remote work experience different wage growth after COVID compared with workers in occupations less suited to remote work?

## Data

The worker data comes from ACS/IPUMS. The raw ACS file should be saved here:

```text
data/raw/usa_00001.dta
```

The project uses these ACS/IPUMS variables:

```text
YEAR
AGE
SEX
RACE
EDUC
EMPSTAT
OCC
OCCSOC
IND
STATEICP
INCWAGE
PERWT
```

Remote work feasibility comes from the Dingel and Neiman occupation level work from home feasibility file. Save it here:

```text
data/raw/remote/occupations_workathome.csv
```

That file should include:

```text
onetsoccode
title
teleworkable
```

The ACS extract includes `OCCSOC`, so the Stata code can merge workers to the remote work data using SOC occupation codes.

## Main Variables

The outcome is annual wage income:

```stata
gen annual_wage = incwage
gen log_wage = log(annual_wage)
```

I use annual wage income instead of hourly wage because `WKSWORK1` is missing for 2016-2018 in the current ACS extract. Using `INCWAGE` keeps the full 2016-2024 sample.

The after COVID variable is:

```stata
gen covid = year > 2020
```

The sample keeps employed workers ages 25 to 54.

## Method

The basic regression compares wages before and after COVID:

```text
log_wage = covid + controls
```

The remote work regression uses an interaction:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

If this coefficient is positive, occupations suited to remote work had higher wage growth after COVID relative to occupations less suited to remote work. If it is negative, they had lower relative wage growth.

Because the outcome is log wage income, a coefficient like `0.05` is roughly a 5 percent difference.

## How to Run

Open Stata and move into the project folder:

```stata
cd "PATH/TO/post-covid-wages"
```

Replace `PATH/TO` with the place where the project is saved on your computer.

Then run:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

The last Stata file runs the R figure script automatically. If R does not run from Stata, run this separately in Terminal:

```text
Rscript code/03_figures.R
```

## Outputs

Main cleaned data files:

```text
data/processed/cleaned.dta
data/processed/remote_soc_only.dta
data/processed/analysis_data.dta
```

Tables:

```text
outputs/tables/summary_stats.txt
outputs/tables/regressions.txt
outputs/tables/top_industry_growth.csv
outputs/tables/top_state_wage_levels.csv
outputs/tables/percent_growth_by_group.csv
```

Figures:

```text
outputs/figures/overall_wage_growth.png
outputs/figures/log_wage_trends.png
outputs/figures/top_industry_growth.png
outputs/figures/state_wage_levels.png
outputs/figures/p10_p50_p90_trends.png
outputs/figures/percent_growth_by_group.png
```

## Results

The finished writeup is in:

```text
research_summary.md
```

The main result is that wage income was higher after COVID in the ACS sample, but the gains were not the same across groups. Younger workers, women, and workers without college degrees had larger percent increases in average annual wage income.

The remote work result is more mixed. Workers in occupations suited to remote work had higher wage levels overall, but the remote work interaction was slightly negative after controls. The key number for that part is:

```text
1.remote_workable#1.covid
```

The full regression output is saved in `outputs/tables/regressions.txt`.
