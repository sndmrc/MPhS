#' Project data onto the MPhS subspace
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param data numeric data frame.
#' @param strata_var vector of character, the name of the stratification variable(s)
#' @param stage_var, character, the name of the variable defining fruit development (stage)
#' @param scaling_type character, type of scaling of gene expressions. Available options: \code{"none"}, \code{"scale"} (default), \code{"means_SDs"}.
#' @param geneID character, the name of the format of gene codes that the function supports. 
#' Available options: \code{VIT} (the V1 annotation format, default), \code{Vitvi} (the V3 annotation format):
#' 
#' - **v1 format (e.g., "VIT_01s0011g01230")**: This format is used in the V1 annotation of the grapevine genome. The gene code is structured as follows:
#'   - "VIT": A prefix indicating the species (Vitis vinifera).
#'   - "_": A separator underscore.
#'   - "01s": Indicates the chromosome number, where "01" is the chromosome number, followed by "s" to denote a scaffold.
#'   - "0011": Denotes the scaffold or contig number within the chromosome.
#'   - "g01230": Indicates the gene number within the scaffold or contig, with "g" as a prefix followed by a zero-padded numeric identifier.
#'
#' - **v3 format (e.g., "Vitvi03g000100")**: This format is used in the V3 annotation of the grapevine genome. The gene code is structured as follows:
#'   - "Vitvi": A prefix derived from the species name (Vitis vinifera) with a consistent capitalization pattern.
#'   - "03": Indicates the chromosome number as a two-digit value.
#'   - "g": A separator denoting the start of the gene identifier.
#'   - "000100": A zero-padded gene identifier within the chromosome.
#' @details The \code{MPhSscores} function performs a preliminary standardization of columns in \code{data}.
#' @seealso \code{\link[MPhS]{plot.MPhStimepoints}}
#' @references 
#' G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @return An object of class \code{MPhStimepoints} (a list).
#' @export
#' @importFrom stats 'lm'
#' @importFrom stats 'predict'

MPhStimepoints <- function(data, strata_var, stage_var, scaling_type="scale", geneID="VIT") {
  
  MPhSdata <- NULL
  data_path <- system.file("data", "MPhSdata.rda", package="MPhS")
  load(data_path)
  pca_rot_matrix <- MPhSdata$pca$rotation
  raw_data_scores <- MPhSdata$raw_data_scores
  smooth_data_scores <- MPhSdata$smooth_data_scores
  MPhSpcs <- MPhSdata$MPhSpcs
  MPhSpts <- MPhSdata$MPhSpts
  no_pts  <- nrow(MPhSpts)

  data <- as.data.frame(data)
  scores <- MPhSscores(data, scaling_type=scaling_type, geneID=geneID)
  
  PCscores <- sapply(1:3, function(k) {
    df <- data.frame(y=smooth_data_scores[,MPhSpcs[k]], 
                     x=raw_data_scores[,MPhSpcs[k]])
    lmfit <- lm(y~x, data=df)
    df_new <- data.frame(x=scores$scores[, MPhSpcs[k]])
    predict(lmfit, newdata=df_new)
  }) %>%
  as.data.frame()  
  
  PCscores$timepoint <- 
    MPhS_time_pts(PCscores, t(MPhSpts[, c("x1","x2","x3")]), MPhSpts$timepoint)
  names_PCscores <- c(paste0("PC", MPhSpcs), "timepoint")

  strata <- data[, strata_var, drop=F]  
  PCscores <- cbind(PCscores, strata, data[, stage_var])
  names(PCscores) <- c(names_PCscores, strata_var, stage_var)
  PCscores$strata <- as.character(interaction(as.list(strata), sep=" - "))

  out <- list(PCscores=PCscores, no_genes=scores$no_genes, data=scores$data, 
              no_MPhS_pts=no_pts, strata_var=strata_var, stage_var=stage_var)
  class(out) <- c("MPhStimepoints", class(out))
  return(out)
}

#' @noRd
distxMtx <- function(X, y) {
  apply(X, 2, function(x1, x2) sum((x1-x2)^2), x2=y)
}

#' @noRd
MPhS_time_pts <- function(X, MPhSdata, timepoints) {
  apply(X, 1, 
        function(x, data, time) {
          posmin <- which.min(distxMtx(data, x))
          MPhStime <- time[posmin]
        }, data=MPhSdata, time=timepoints)
}  