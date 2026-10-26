* Run from the repository root. Stata 16+; R is only used for figures.
version 16
clear all
set more off
set varabbrev off
global project "`c(pwd)'"
foreach folder in data/processed outputs outputs/tables outputs/figures outputs/logs {
    capture mkdir "`folder'"
}
capture confirm file "data/raw/usa_00001.dta"
if _rc {
    display as error "Run from the project folder and put the ACS extract in data/raw/usa_00001.dta."
    exit 601
}
