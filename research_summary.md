# Post COVID Wages

## 1. Introduction

This project studies how wages changed after COVID using public ACS/IPUMS labor market data. The main question is how wage income changed after 2020, and whether those changes looked different across groups of workers.

The project also keeps a remote work angle. Instead of using private company promotion records, it uses public occupation data to compare workers in occupations that are more suited to remote work with workers in occupations that are less suited to remote work.

## 2. Data

The main worker data comes from ACS/IPUMS. The sample includes employed workers ages 25 to 54 from 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. The final analysis sample has 3,761,679 workers.

The outcome is annual wage income from `INCWAGE`. I use annual wage income instead of hourly wage because `WKSWORK1` is missing for 2016 to 2018 in the current ACS extract. The average annual wage income in the final sample is about $54,055.

The remote work measure comes from Dingel and Neiman occupation level work from home feasibility scores. Workers are merged to this file using the ACS `OCCSOC` occupation code. About 42 percent of workers in the sample are in occupations classified as more suited to remote work.

## 3. Empirical Strategy

The main before and after regression is:

```text
log_wage = covid + controls
```

The project also estimates a difference in differences style regression:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main remote work coefficient is:

```text
1.remote_workable#1.covid
```

This coefficient shows whether wages changed differently after COVID for workers in occupations suited to remote work, compared with workers in occupations less suited to remote work. The main controls include age, age squared, education, sex, race, state, year, and industry.

## 4. Results

Overall wages were higher after COVID in this sample. Average annual wage income rose from about $48,269 before COVID to about $57,083 after COVID, an increase of about 18 percent. In the main regression with controls, the after COVID coefficient is 0.162, which means log wage income was roughly 16 percent higher after 2020.

The remote work results are more mixed. Workers in occupations suited to remote work had higher wage levels overall, but the after COVID interaction is negative. In the full remote work regression with controls, the coefficient on `1.remote_workable#1.covid` is about `-0.022`. That means wages for remote suited occupations grew about 2.2 percent less after COVID relative to less remote suited occupations, after controlling for worker and job characteristics.

The group comparisons show different patterns:

```text
Younger workers ages 25 to 34 had the largest wage growth, about 23 percent.
Workers ages 35 to 44 had wage growth of about 17 percent.
Workers ages 45 to 54 had wage growth of about 15 percent.
Women had wage growth of about 22 percent.
Men had wage growth of about 15 percent.
Workers without a college degree had wage growth of about 19 percent.
Workers with a college degree had wage growth of about 12 percent.
```

By race, the largest percent increases were for workers listed as other race, White workers, and Black workers. Black workers had wage growth of about 22 percent, White workers about 22 percent, and other race workers about 26 percent. Asian and Pacific Islander workers had growth of about 16 percent, while multiracial workers had growth of about 13 percent.

The industry results show that some industries had much larger wage increases than others. The largest increases in the output table are for industry codes 1890, 9790, 8170, 7580, and 6695. These are saved in `outputs/tables/top_industry_growth.csv`.

The state results show that average wage levels after COVID were highest in the District of Columbia, Massachusetts, Maryland, Washington, and New Jersey. These rankings are saved in `outputs/tables/top_state_wage_levels.csv`.

The inequality figure compares P10, P50, and P90 annual wages over time. This helps show whether wage growth was similar across the wage distribution or stronger at the bottom, middle, or top.

## 5. Limitations

These results should not be interpreted as the causal effect of COVID by itself. The project compares years before and after COVID, but many other things changed during the same period, including inflation, labor demand, industry composition, and worker selection.

ACS does not directly show whether each person worked remotely. The project measures whether the person's occupation is suited to remote work, which is related but not the same thing.

The wage outcome is annual wage income, not hourly pay. That means changes may reflect changes in hours, weeks worked, job switching, and employment patterns, not only changes in wage rates.

Some industry and state results are descriptive. They are useful for showing patterns, but they should not be read as proof that a state or industry caused higher wage growth.

## 6. Conclusion

The main finding is that wage income rose after COVID in the ACS sample, but the gains were not the same for every group. Younger workers, women, and workers without college degrees had larger percent increases in average annual wage income. Workers in occupations suited to remote work had higher wage levels overall, but their wage growth after COVID was slightly lower relative to workers in less remote suited occupations in the regression model.

This project is inspired by research on hybrid work, turnover, and promotion outcomes, including papers that use internal firm records to study career advancement. This project is different because it uses public labor market data and studies wage income as a proxy for career progress rather than direct promotion records.
