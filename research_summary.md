# Post COVID Wages

An increase in wages does not always mean workers can afford more. When prices rise, the same income buys fewer goods and services. This project uses public ACS/IPUMS data to study how wages changed after COVID after accounting for inflation. It also compares groups of workers to see whether some had stronger growth than others.

## 1. Hypothesis

My hypothesis is that average real wages would either fall or grow only slightly after COVID because inflation reduced the value of wage gains. I also expect wage changes to differ across occupations, industries, and age groups because COVID affected different parts of the labor market in different ways.

## 2. Data

The data comes from the American Community Survey (ACS), accessed through IPUMS. I use observations from 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. The sample includes employed workers ages 25 to 54 with valid annual wage income. After cleaning the data and applying the sample restrictions, the number of observations fell from 26,255,293 to 3,771,395.

The wage variable, `INCWAGE`, measures annual wage income. Because prices changed during this period, comparing the reported dollar amounts alone would not show whether workers could afford more. I use the Consumer Price Index (CPI) to convert each year's income into 2024 dollars:

```text
real_annual_wage = annual_wage * CPI_2024 / CPI_year
```

This gives real annual wage income, which accounts for inflation, instead of just nominal income, which is the dollar amount reported.

The remote work measure comes from Dingel and Neiman work from home scores. I merge it to ACS using the `OCCSOC` occupation code. About 42 percent of workers in the sample are in occupations classified as more suited to remote work.

## 3. Method

I use ordinary least squares (OLS) regressions to compare the log of real annual wage income before and after COVID. The years before COVID are 2016 through 2019, and the years after COVID are 2021 through 2024. The basic model can be written as:

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

This interaction shows whether real wage income changed more or less in occupations suited to remote work compared with other occupations. The main before and after regression controls for age, age squared, education, sex, race, state, and industry. Additional remote work specifications include year controls. These comparisons help account for differences between workers, but do not prove that COVID or remote work caused the changes.

## 4. Results

Nominal wages increased a lot after COVID. Average annual wage income rose from about $47,738 before COVID to about $58,288 after COVID, which is about a 22 percent increase.

After adjusting for inflation, the increase is much smaller. Average real annual wage income rose from about $60,381 before COVID to about $61,848 after COVID. That is only about a 2.4 percent increase. This means wages went up in dollar terms, but higher prices reduced most of the gain.

The main regression shows the same basic idea. The coefficient on `1.covid` is about `0.006`, so real wage income was about 0.6 percent higher after COVID after adding controls.

For remote work, workers in remote suited occupations had higher wage levels overall. However, they did not have stronger real wage growth after COVID. In the full regression, the coefficient on `1.remote_workable#1.covid` is about `-0.010`, meaning remote suited occupations had about 1.0 percent lower real wage growth after COVID compared with less remote suited occupations.

Real wage growth differed across age groups. Workers ages 25 to 34 had growth of about 5.0 percent, compared with 1.9 percent for workers ages 35 to 44 and 0.5 percent for workers ages 45 to 54. Women had growth of about 5.1 percent, while men had growth of about 0.5 percent. Workers without a college degree had an increase of about 1.5 percent, compared with a decrease of about 1.4 percent for college graduates. These are comparisons of group averages, not changes in the earnings of the same people.

By race, real wage growth was highest for workers listed as other race, White workers, and Black workers. Other race workers had growth of about 6.9 percent, White workers about 5.5 percent, and Black workers about 3.8 percent. Asian and Pacific Islander workers had growth of about 3.0 percent, while multiracial workers had growth of about -2.6 percent.

Some industries still had strong real wage growth even after inflation. The largest real wage increases were in industry codes 9790, 6695, 8170, 7580, and 1890.

The state figure shows average real wage levels after COVID. The highest real wage levels are in the District of Columbia, Massachusetts, Maryland, New Jersey, and Washington.

The inequality figure compares real annual wages at the 10th, 50th, and 90th percentiles. These represent the lower end, middle, and upper end of the sample's earnings distribution. Comparing them helps show whether growth was concentrated at a particular part of the distribution.

Competition for workers could help explain the differences by age and education. When employers have difficulty hiring, workers may have more opportunities to leave for better paying jobs. This can also push employers to raise wages to keep their current workers. Research by Autor, Dube, and McGrew found stronger wage growth and more job switching among young workers with a high school education or less during the recovery. While their education groups differ from mine, this could help explain why younger workers and workers without college degrees had stronger growth in my sample. My analysis does not track job changes, so it cannot test this explanation directly. [The Unexpected Compression](https://www.nber.org/papers/w31010)

Older workers may have experienced smaller gains if they stayed in jobs where raises did not keep up with inflation. Working hours could also contribute to this difference. For example, someone who reduced their hours could earn less over the year even if their hourly pay increased. Weaker growth among college graduates does not mean a degree stopped being valuable. A group can still earn more than another group while having a smaller increase in earnings.

Changes in who remained employed could help explain the results for women. If women with lower earnings left work, the average earnings of those still employed could rise without anyone receiving a raise. Changes in pay and hours could also contribute. BLS reported that the loss of lower paying jobs affected earnings statistics during the pandemic. While this does not explain my later sample on its own, it shows why higher average earnings do not necessarily mean all women became better off. Women who left employment are not included in my comparison. [BLS discussion of pandemic effects on earnings](https://www.bls.gov/regions/west/news-release/pdf/womensearnings_alaska.pdf)

Differences in hiring could also explain the remote work result. Employers in jobs that require workers to be there in person may have raised pay more if they had difficulty finding staff. This would allow those jobs to gain ground compared with occupations suited to remote work. Another possibility is that workers valued the flexibility of working from home enough to accept smaller raises. However, the data does not measure these choices, so neither explanation can be confirmed by this project.

## 5. Limitations

This project does not prove that COVID caused these wage changes. It compares years before and after COVID, but other things were changing at the same time.

The data includes different workers each year, so changes in average earnings may reflect who was employed as well as changes in pay. More information on job changes, working hours, and people leaving employment would be needed to test the possible explanations discussed above.

The remote work measure used here only shows whether an occupation is suited to working from home. It does not establish whether each worker actually worked remotely.

The wage measure is annual wage income, not hourly pay. That means the results may reflect hours worked, weeks worked, job changes, and employment patterns, not just wage rates.

The inflation adjustment uses one national price index, so it does not account for local cost of living differences.

Some results, like industry and state rankings, are descriptive. They show patterns, but they do not prove that an industry or state caused higher wages.

## 6. Conclusion

The main finding is that nominal wages rose a lot after COVID, but real wages rose only a little after adjusting for inflation. In other words, workers earned more dollars, but higher prices took away most of the gain.

The groups with higher earnings did not always have stronger growth. Workers without college degrees had larger increases than college graduates, and occupations suited to remote work did not have an additional increase compared with other occupations. Greater competition for workers could have helped some lower paid workers gain ground. However, changes in hours and who remained employed could also explain part of these differences. Overall, purchasing power improved only slightly, and the increase was not shared equally across groups. The results do not show that every worker in a group with stronger growth became better off.

This project is connected to research on hybrid work, turnover, and promotions. While those studies may use company records, this project uses public labor market data. Annual wage income gives some information about workers' earnings, but it does not directly measure promotions or follow individual career progress.
