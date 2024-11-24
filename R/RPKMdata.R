#' An example dataset with V1 gene annotation containing RPKM expression data.
#'
#' @author G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni (\email{sandri.marco@gmail.com})
#' @description An unpublished dataset containing expression (RPKM data) levels of 29,971 genes for Sangiovese nad Passerina grapes, measured at four time points (Pea size, Touch, Soft, and Harvest) and T1) with three biological replicates.
#' @references G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @usage data(RPKMdata)
#' @format 
#' A data frame with 29971 rows and 25 columns.
#' \describe{
#'  \item{gene_id}{A unique identifier for each gene.}
#'  \item{Sangiovese_Pea_1, Sangiovese_Pea_2, Sangiovese_Pea_3}{Sample #1, Cultivar=Sangiovese, Stage=Pea size, Replicates 1, 2 and 3}
#'  \item{Sangiovese_Touch_1, Sangiovese_Touch_2, Sangiovese_Touch_3}{Sample #2, Cultivar=Sangiovese, Stage=Touch, Replicates 1, 2 and 3}
#'  \item{Sangiovese_Soft_1, Sangiovese_Soft_2, Sangiovese_Soft_3}{Sample #3, Cultivar=Sangiovese, Stage=Soft, Replicates 1, 2 and 3}
#'  \item{Sangiovese_Harv_1, Sangiovese_Harv_2, Sangiovese_Harv_3}{Sample #4, Cultivar=Sangiovese, Stage=Harvest, Replicates 1, 2 and 3}
#'  \item{Passerina_Pea_1, Passerina_Pea_2, Passerina_Pea_3}{Sample #5, Cultivar=Passerina, Stage=Pea size, Replicates 1, 2 and 3}
#'  \item{Passerina_Touch_1, Passerina_Touch_2, Passerina_Touch_3}{Sample #6, Cultivar=Passerina, Stage=Touch, Replicates 1, 2 and 3}
#'  \item{Passerina_Soft_1, Passerina_Soft_2, Passerina_Soft_3}{Sample #7, Cultivar=Passerina, Stage=Soft, Replicates 1, 2 and 3}
#'  \item{Passerina_Harv_1, Passerina_Harv_2, Passerina_Harv_3}{Sample #8, Cultivar=Passerina, Stage=Harvest, Replicates 1, 2 and 3}
#' }
#' @examples
#' data(RPKMdata)
#' @source <https://doi.org/10.1093/hr/uhad048>
"RPKMdata"