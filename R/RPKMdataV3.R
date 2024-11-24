#' An example dataset with V3 gene annotation containing RPKM expression data.
#'
#' @author G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni (\email{sandri.marco@gmail.com})
#' @description An unpublished dataset containing expression (RPKM data) levels of 43,664 genes for Corvina grape, measured at two time points (T0 and T1) with three biological replicates.
#' @references Unpublished
#' @usage data(RPKMdataV3)
#' @format 
#' A data frame with 43664 rows and 7 columns.
#' \describe{
#'  \item{gene_id}{A unique identifier for each gene (Vitvi annotation).}
#'  \item{CT0R1}{Sample #1, Cultivar=Corvina, Stage=T0, Replicate=1}
#'  \item{CT0R2}{Sample #2, Cultivar=Corvina, Stage=T0, Replicate=2}
#'  \item{CT0R3}{Sample #3, Cultivar=Corvina, Stage=T0, Replicate=3}
#'  \item{CT1R1}{Sample #4, Cultivar=Corvina, Stage=T1, Replicate=1}
#'  \item{CT1R2}{Sample #5, Cultivar=Corvina, Stage=T1, Replicate=2}
#'  \item{CT1R3}{Sample #6, Cultivar=Corvina, Stage=T1, Replicate=3}
#' }
#' @examples
#' data(RPKMdataV3)
"RPKMdataV3"