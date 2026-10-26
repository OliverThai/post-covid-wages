* One entry point. Set the working directory to this repository.
version 16
args rscript
if "`rscript'" == "" local rscript Rscript
do code/00_setup.do
capture erase "outputs/tables/ANALYSIS_COMPLETE.txt"
capture erase "outputs/figures/FIGURES_COMPLETE.txt"
do code/01_build_data.do
do code/02_analysis.do
shell "`rscript'" "code/03_figures.R"
capture confirm file "outputs/figures/FIGURES_COMPLETE.txt"
if _rc {
    display as error "R did not finish. Run Rscript code/03_figures.R, or pass the Rscript executable path to this do-file."
    exit 459
}
display "Stata analysis, R figures and numerical report completed."
