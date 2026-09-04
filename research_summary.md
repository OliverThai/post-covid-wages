# Post COVID Wages

## 1. Introduction

This project studies how purchasing power wages changed after COVID using public ACS/IPUMS labor market data. The main question is whether workers were actually better off after COVID once inflation is taken into account, and whether those changes looked different across groups of workers.

The project also keeps a remote work angle. Instead of using private company promotion records, it uses public occupation data to compare workers in occupations that are more suited to remote work with workers in occupations that are less suited to remote work.

## 2. Data

The main worker data comes from ACS/IPUMS. The sample includes employed workers ages 25 to 54 from 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. The final analysis sample has about 3.76 million workers.

The wage variable comes from `INCWAGE`. Because the project covers years with very different price levels, the main outcome is inflation adjusted annual wage income. Each year is converted into 2024 dollars using CPI-U annual averages:

```text
real_annual_wage = annual_wage * CPI_2024 / CPI_year
```

This means a wage from 2016 is adjusted using the 2016 CPI, a wage from 2021 is adjusted using the 2021 CPI, and so on. The goal is to compare wages in the same dollar value instead of mixing wage growth with inflation.

The remote work measure comes from Dingel and Neiman occupation level work from home feasibility scores. Workers are merged to this file using the ACS `OCCSOC` occupation code. About 42 percent of workers in the sample are in occupations classified as more suited to remote work.

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

The nominal wage numbers and the inflation adjusted numbers tell different stories. In nominal dollars, average annual wage income rose from about $48,269 before COVID to about $57,083 after COVID, an increase of about 18 percent.

After adjusting each year into 2024 dollars, the pattern is much flatter. Average real annual wage income was about $61,058 before COVID and about $60,611 after COVID. That is a decrease of about 0.7 percent. In plain words, wages rose on paper, but inflation erased most of the gain in purchasing power.

The remote work comparison also changes once the focus is on purchasing power. Before COVID, workers in remote suited occupations had higher real wage income than workers in less remote suited occupations. However, average real wage growth was lower for remote suited occupations after COVID. Real wage income increased by about 1.8 percent for less remote suited occupations, while it fell by about 4.6 percent for remote suited occupations.

The group comparisons show different patterns:

```text
Workers ages 25 to 34 had real wage growth of about 3.4 percent.
Workers ages 35 to 44 had real wage growth of about -1.6 percent.
Workers ages 45 to 54 had real wage growth of about -3.5 percent.
Women had real wage growth of about 2.8 percent.
Men had real wage growth of about -3.3 percent.
Workers without a college degree had real wage growth of about 0.3 percent.
Workers with a college degree had real wage growth of about -5.8 percent.
```

By race, the largest real wage increases were for workers listed as other race, Black workers, and White workers. Other race workers had real wage growth of about 5.5 percent, Black workers about 2.2 percent, and White workers about 2.0 percent. Asian and Pacific Islander workers had real wage growth of about -2.4 percent, while multiracial workers had real wage growth of about -5.0 percent.

The industry results show that some industries still had real wage increases after accounting for inflation. The largest real wage increases in the updated calculation were for industry codes 8170, 7580, 1890, 1470, and 7860.

The state figure reports average real wage levels after COVID. These levels should be interpreted as purchasing power wage levels in 2024 dollars, not nominal wage levels.

The inequality figure compares P10, P50, and P90 real annual wages over time. This helps show whether purchasing power changed similarly across the wage distribution or whether the bottom, middle, and top moved differently.

## 5. Limitations

These results should not be interpreted as the causal effect of COVID by itself. The project compares years before and after COVID, but many other things changed during the same period, including labor demand, industry composition, job switching, and worker selection.

ACS does not directly show whether each person worked remotely. The project measures whether the person's occupation is suited to remote work, which is related but not the same thing.

The wage outcome is annual wage income, not hourly pay. That means changes may reflect changes in hours, weeks worked, job switching, and employment patterns, not only changes in wage rates.

The inflation adjustment uses national CPI-U, so it does not account for different local price changes across states or metro areas.

Some industry and state results are descriptive. They are useful for showing patterns, but they should not be read as proof that a state or industry caused higher wage growth.

## 6. Conclusion

The main finding is that nominal wage income rose after COVID, but real purchasing power wages were roughly flat once inflation is included. This changes the interpretation of the project. The stronger conclusion is not simply that wages grew after COVID, but that much of the nominal wage growth was offset by higher prices.

The group results suggest that younger workers, women, and workers without college degrees saw better real wage outcomes than older workers, men, and workers with college degrees. Workers in occupations suited to remote work still had higher wage levels overall, but their real wage growth after COVID was weaker than the growth for workers in less remote suited occupations.

This project is inspired by research on hybrid work, turnover, and promotion outcomes, including papers that use internal firm records to study career advancement. This project is different because it uses public labor market data and studies inflation adjusted wage income as a proxy for career progress rather than direct promotion records.
