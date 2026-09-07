# Post COVID Wages

This project studies how wages changed after COVID using public ACS/IPUMS labor market data, and whether those changes looked different across groups of workers.

## 1. Hypothesis

My hypothesis is that average real wages would either fall or grow only slightly after COVID because inflation reduced the value of wage gains. I also expect wage changes to differ across occupations, industries, and age groups because COVID affected different parts of the labor market in different ways.

## 2. Data

The main data comes from ACS/IPUMS. I use workers from 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. I keep workers who were employed, ages 25 to 54, and had valid annual wage income. The initial file included 26,255,293 observations, and the final sample includes 3,771,395 observations.

The wage variable is `INCWAGE`, which is annual wage income. Since prices changed a lot during this period, I adjust wages for inflation. Each year is converted into 2024 dollars using the Consumer Price Index (CPI):

```text
real_annual_wage = annual_wage * CPI_2024 / CPI_year
```

This lets me compare real wages instead of only nominal wages.

The remote work measure comes from Dingel and Neiman work from home scores. I merge it to ACS using the `OCCSOC` occupation code. About 42 percent of workers in the sample are in occupations classified as more suited to remote work.

## 3. Empirical Strategy

The main regression is:

```text
log_real_wage = covid + controls
```

The project also uses a difference in differences style regression:

```text
log_real_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient for the remote work part is:

```text
1.remote_workable#1.covid
```

This shows whether real wages changed differently after COVID for workers in remote suited occupations compared with workers in less remote suited occupations. The controls include age, age squared, education, sex, race, state, year, and industry.

## 4. Results

Nominal wages increased a lot after COVID. Average annual wage income rose from about $47,738 before COVID to about $58,288 after COVID, which is about a 22 percent increase.

After adjusting for inflation, the increase is much smaller. Average real annual wage income rose from about $60,381 before COVID to about $61,848 after COVID. That is only about a 2.4 percent increase. This means wages went up in dollar terms, but higher prices reduced most of the gain.

The main regression shows the same basic idea. The coefficient on `1.covid` is about `0.006`, so real wage income was about 0.6 percent higher after COVID after adding controls.

For remote work, workers in remote suited occupations had higher wage levels overall. However, they did not have stronger real wage growth after COVID. In the full regression, the coefficient on `1.remote_workable#1.covid` is about `-0.010`, meaning remote suited occupations had about 1.0 percent lower real wage growth after COVID compared with less remote suited occupations.

The group results show that real wage growth was not the same for everyone:

```text
Workers ages 25 to 34 had real wage growth of about 5.0 percent.
Workers ages 35 to 44 had real wage growth of about 1.9 percent.
Workers ages 45 to 54 had real wage growth of about 0.5 percent.
Women had real wage growth of about 5.1 percent.
Men had real wage growth of about 0.5 percent.
Workers without a college degree had real wage growth of about 1.5 percent.
Workers with a college degree had real wage growth of about -1.4 percent.
```

By race, real wage growth was highest for workers listed as other race, White workers, and Black workers. Other race workers had growth of about 6.9 percent, White workers about 5.5 percent, and Black workers about 3.8 percent. Asian and Pacific Islander workers had growth of about 3.0 percent, while multiracial workers had growth of about -2.6 percent.

Some industries still had strong real wage growth even after inflation. The largest real wage increases were in industry codes 9790, 6695, 8170, 7580, and 1890.

The state figure shows average real wage levels after COVID. The highest real wage levels are in the District of Columbia, Massachusetts, Maryland, New Jersey, and Washington.

The inequality figure compares P10, P50, and P90 real annual wages over time. This helps show whether lower wage, middle wage, and higher wage workers moved differently after COVID.

## 5. Limitations

This project does not prove that COVID caused these wage changes. It compares years before and after COVID, but other things were changing at the same time.

ACS does not say whether each person actually worked remotely. I only know whether their occupation is more suited to remote work.

The wage measure is annual wage income, not hourly pay. That means the results may reflect hours worked, weeks worked, job changes, and employment patterns, not just wage rates.

The inflation adjustment uses one national price index, so it does not account for local cost of living differences.

Some results, like industry and state rankings, are descriptive. They show patterns, but they do not prove that an industry or state caused higher wages.

## 6. Conclusion

The main finding is that nominal wages rose a lot after COVID, but real wages rose only a little after adjusting for inflation. In other words, workers earned more dollars, but higher prices took away most of the gain.

The results also show that wage changes differed across groups. Younger workers, women, and workers without college degrees had better real wage growth than older workers, men, and workers with college degrees. Workers in remote suited occupations had higher wage levels overall, but their real wage growth after COVID was slightly weaker than the growth for workers in less remote suited occupations.

This project is related to research on hybrid work, turnover, and promotions, but it uses public labor market data instead of company records. Since ACS does not measure promotions directly, I use inflation adjusted wage income as a rough measure of career progress.
