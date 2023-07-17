#' Project data onto the MPhS subspace
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param data numeric data frame.
#' @param scaling_type character, type of scaling of gene expressions. Available options: \code{none}, \code{scale} (default), \code{means_SDs}.
#' @details The \code{MPhSscores} function performs a preliminary standardization of columns in \code{data}.
#' @seealso \code{\link[stats]{hclust}}
#' @references 
#' G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @return A \code{hclustering} object.
#' @return If \code{k} is \code{NULL}, the \code{hclustering} object is a list of 3 elements:
#' @export
#' @importFrom stats 'lm'
#' @importFrom stats 'predict'

MPhStimepoints <- function(data, scaling_type="scale") {
  
  MPhSdata <- NULL
  data_path <- system.file("data", "MPhSdata.rda", package="MPhS")
  load(data_path)
  pca_rot_matrix <- MPhSdata$pca$rotation
  raw_data_scores <- MPhSdata$raw_data_scores
  smooth_data_scores <- MPhSdata$smooth_data_scores
  MPhSpcs <- MPhSdata$MPhSpcs

  scores <- MPhSscores(data, scaling_type=scaling_type)
    
  pred_scores <- sapply(1:3, function(k) {
    df <- data.frame(y=smooth_data_scores[,MPhSpcs[k]], 
                     x=raw_data_scores[,MPhSpcs[k]])
    lmfit <- lm(y~x, data=df)
    df_new <- data.frame(x=scores[, MPhSpcs[k]])
    predict(lmfit, newdata=df_new)
  }) %>%
    as.data.frame()  
  
  out <- list(pred_scores=pred_scores)
  return(out)
}

#' @noRd
distxMtx <- function(X, y) {
  apply(X, 2, function(x1, x2) sum((x1-x2)^2), x2=y)
}

#' @noRd
MPhStime <- function(X, MPhSdata, timepoints) {
  apply(X, 1, 
        function(x, data, time) {
          posmin <- which.min(distxMtx(data, x))
          MPhStime <- time[posmin]
        }, data=MPhSdata, time=timepoints)
}  