# Post COVID Wages

## 1. Introduction

This project studies how wages changed after COVID and whether those changes differed by race, age, gender, education, industry, state, and whether an occupation was suited to remote work.

## 2. Data

The project uses ACS/IPUMS worker level data and Dingel and Neiman occupation level remote work data.

The ACS file should be saved as `data/raw/usa_00001.dta`.

The remote work file should be saved as `data/raw/remote/occupations_workathome.csv`.

The ACS extract includes `OCCSOC`, so the project can merge worker occupations directly with the Dingel and Neiman SOC occupation file for the remote work part of the analysis.

## 3. Empirical Strategy

The main regression is:

```text
log_wage = covid + controls
```

The project also estimates difference in differences style regressions:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

Since the outcome is log annual wage income, this coefficient is roughly a percent wage income difference.

The project also compares wage changes after COVID across race, age, gender, education, industry, and state groups. It keeps the final figures focused on overall wage growth, percent growth by group, industry growth, state wage levels, and inequality trends using P10, P50, and P90 wages.

## 4. Results Placeholder

Results will be added after the Stata do files are run and the tables and figures are reviewed.

## 5. Limitations

This is a before and after labor market project, so the after COVID coefficient should not be interpreted as the effect of COVID alone.

ACS does not directly show whether a person worked remotely. The project measures whether the person's occupation is suited to remote work.

The occupation merge may miss some observations if Dingel and Neiman occupation codes do not match every IPUMS `OCCSOC` code.

## 6. Conclusion

This project creates a simple, reproducible Stata/R workflow for studying wage growth after COVID using public data.
