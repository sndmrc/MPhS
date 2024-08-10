
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MPhS

<!-- badges: start -->
<!-- badges: end -->

<div style="text-align: center;">

<img src="path/to/image.png" width="50%" />

</div>

With the `MPhS` package, the user can map their transcriptomic dataset
onto the Molecular Phenology Scale (MPhS) proposed by

Tornielli GB, Sandri M, Fasoli M, Amato A, Pezzotti M, Zuccolotto P,
Zenoni S (2023) A molecular phenology scale of grape berry development.
Horticulture Research, Volume 10, Issue 5:uhad048.
[doi:10.1093/hr/uhad048](https://academic.oup.com/hr/article/10/5/uhad048/7077841)

## Installation

You can install the development version of MPhS from
[GitHub](https://github.com/sndmrc/MPhS) with:

``` r
# install.packages("pak")
pak::pak("sndmrc/MPhS")
```

## Example

This is a basic example that shows you how to map the `RPKMdata` dataset
(included in the package) onto the MPhS.

Load libraries and data.

    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union

Preprocess data: create variables representing the experimental
conditions and a variable that defines the maturation stage.

Transpose the gene expression matrix and add the newly derived
variables.

For each stage and each cultivar, calculate the mean value of the 3
replicates (it can takes several minutes).

    #> `summarise()` has grouped output by 'Cultivar'. You can override using the
    #> `.groups` argument.

Map data onto the transcriptomic scale using the `MPhStimepoints`
command.

The object `MPhS_out` command can be plotted using the `plot` command.

<img src="man/figures/README-plot-1.png" width="100%" />
