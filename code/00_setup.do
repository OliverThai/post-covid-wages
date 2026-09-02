* Create the folders the project

clear all
set more off

global project "`c(pwd)'"

cd "$project"

pwd

capture mkdir "$project/data"
capture mkdir "$project/data/raw"
capture mkdir "$project/data/raw/remote"
capture mkdir "$project/data/processed"
capture mkdir "$project/outputs"
capture mkdir "$project/outputs/tables"
capture mkdir "$project/outputs/figures"
