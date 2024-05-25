#' Project data onto the MPhS subspace
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param data numeric data frame.
#' @param strata_var vector of character, the name of the stratification variable(s)
#' @param stage_var, character, the name of the variable defining fruit development (stage)
#' @param scaling_type character, type of scaling of gene expressions. Available options: \code{"none"}, \code{"scale"} (default), \code{"means_SDs"}.
#' @param gene_keyword character, a keyword used to identify all the columns of \code{data} that refers to gene expression (default \code{"VIT_"})
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

MPhStimepoints <- function(data, strata_var, stage_var, scaling_type="scale", gene_keyword="VIT_") {
  
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
  scores <- MPhSscores(data, scaling_type=scaling_type, gene_keyword=gene_keyword)
  
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
  names_PCscores <- names(PCscores)

  strata <- data[, strata_var, drop=F]  
  PCscores <- cbind(PCscores, strata, data[, stage_var])
  names(PCscores) <- c(names_PCscores, strata_var, stage_var)
  PCscores$strata <- as.character(interaction(as.list(strata), sep=" - "))

  out <- list(PCscores=PCscores, no_genes=scores$no_genes, no_MPhS_pts=no_pts, 
              strata_var=strata_var, stage_var=stage_var)
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