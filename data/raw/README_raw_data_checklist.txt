Raw data checklist
==================

Put the ACS/IPUMS Stata file here:

data/raw/usa_00001.dta

Put the Dingel-Neiman remote-workability CSV here:

data/raw/remote/occupations_workathome.csv

The ACS/IPUMS file should include OCCSOC.

That lets the project merge ACS occupations to the Dingel-Neiman SOC codes
without a separate crosswalk file.

The scripts will not create fake results if these files are missing.
