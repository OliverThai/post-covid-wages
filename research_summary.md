# Post COVID Wages

This project studies how wages changed after COVID using public ACS/IPUMS labor market data, and whether those changes looked different across groups of workers.

## 1. Hypothesis

My hypothesis is that the average real wage would decrease after COVID, as the shift in demand for less services and increased government stimuluses are expected to increase inflation. I expect wage changes to differ across occupations, industries, and ages.

## 2. Data

The main worker data comes from ACS/IPUMS. The sample includes employed workers ages 25 to 54 from 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. Those who were employed, between the ages of 25 and 54, and had a valid annual wage were kept in this data set. The initial data included 26,255,293 observations, and the final data included 3,771,395 observations after switching to the inflation adjusted wage setup.

The wage variable comes from `INCWAGE`. Because the project covers years with very different price levels, the main outcome is inflation adjusted annual wage income. Each year is converted into 2024 dollars using CPI-U annual averages:

```text
real_annual_wage = annual_wage * CPI_2024 / CPI_year
```

This is to compare real wages along with nominal wages.

The remote work measure comes from Dingel and Neiman work from home scores. Workers are merged to this file using the `OCCSOC` occupation code. About 42 percent of workers in the sample are in occupations classified as more suited to remote work.

## 3. Empirical Strategy

The main before and after regression is:

```text
log_real_wage = covid + controls
```

The project also estimates a difference in differences style regression:

```text
log_real_wage = remote_workable + covid + remote_workable x covid + controls
```

The main remote work coefficient is:

```text
1.remote_workable#1.covid
```

This coefficient shows whether purchasing power wages changed differently after COVID for workers in occupations suited to remote work, compared with workers in occupations less suited to remote work. The main controls include age, age squared, education, sex, race, state, year, and industry.

## 4. Results

In nominal dollars, average annual wage income rose from about $47,738 before COVID to about $58,288 after COVID, an increase of about 22 percent. However, after adjusting each year according to inflation, the increase is much smaller. Average real annual wage income rose from about $60,381 before COVID to about $61,848 after COVID according to the 2024 dollar value. That is an increase of about 2.4 percent. Even though wages increased a lot in nominal terms, purchasing power increased only slightly.

In the main regression with controls, the coefficient on `1.covid` is about `0.006`. Since the outcome is log real annual wage income, that means wages were about 0.6 percent higher after COVID after controlling for age, education, sex, race, state, and industry.

The remote work comparison also changes once the focus is on purchasing power. Workers in remote suited occupations had higher real wage levels overall, but their after COVID growth was slightly weaker. In the full remote work regression with controls, the coefficient on `1.remote_workable#1.covid` is about `-0.010`. That means remote suited occupations had about 1.0 percent lower real wage growth after COVID relative to less remote suited occupations.

The group comparisons show different patterns:

```text
Workers ages 25 to 34 had real wage growth of about 5.0 percent.
Workers ages 35 to 44 had real wage growth of about 1.9 percent.
Workers ages 45 to 54 had real wage growth of about 0.5 percent.
Women had real wage growth of about 5.1 percent.
Men had real wage growth of about 0.5 percent.
Workers without a college degree had real wage growth of about 1.5 percent.
Workers with a college degree had real wage growth of about -1.4 percent.
```

By race, the largest real wage increases were for workers listed as other race, White workers, and Black workers. Other race workers had real wage growth of about 6.9 percent, White workers about 5.5 percent, and Black workers about 3.8 percent. Asian and Pacific Islander workers had real wage growth of about 3.0 percent, while multiracial workers had real wage growth of about -2.6 percent.

The industry results show that some industries still had real wage increases after accounting for inflation. The largest real wage increases in the updated output were for industry codes 9790, 6695, 8170, 7580, and 1890.

The state figure reports average real wage levels after COVID. The highest post COVID real wage levels are in the District of Columbia, Massachusetts, Maryland, New Jersey, and Washington. These levels should be interpreted as purchasing power wage levels in 2024 dollars, not nominal wage levels.

The inequality figure compares P10, P50, and P90 real annual wages over time. This helps show whether purchasing power changed similarly across the wage distribution or whether the bottom, middle, and top moved differently.

## 5. Limitations

These results should not be interpreted as the causal effect of COVID by itself. The project compares years before and after COVID, but many other things changed during the same period, including labor demand, industry composition, job switching, and worker selection.

ACS does not directly show whether each person worked remotely. The project measures whether the person's occupation is suited to remote work, which is related but not the same thing.

The wage outcome is annual wage income, not hourly pay. That means changes may reflect changes in hours, weeks worked, job switching, and employment patterns, not only changes in wage rates.

The inflation adjustment uses national CPI-U, so it does not account for different local price changes across states or metro areas.

Some industry and state results are descriptive. They are useful for showing patterns, but they should not be read as proof that a state or industry caused higher wage growth.

## 6. Conclusion

The main finding is that nominal wage income rose sharply after COVID, but real purchasing power wages rose only modestly once inflation is included. This changes the interpretation of the project. The stronger conclusion is not simply that wages grew after COVID, but that much of the nominal wage growth was offset by higher prices.

The group results suggest that younger workers, women, and workers without college degrees saw better real wage outcomes than older workers, men, and workers with college degrees. Workers in occupations suited to remote work still had higher wage levels overall, but their real wage growth after COVID was slightly weaker than the growth for workers in less remote suited occupations.

This project is inspired by research on hybrid work, turnover, and promotion outcomes, including papers that use internal firm records to study career advancement. This project is different because it uses public labor market data and studies inflation adjusted wage income as a proxy for career progress rather than direct promotion records.
