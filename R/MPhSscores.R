#' Project data onto the MPhS subspace
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param data numeric data frame.
#' @param scaling_type character, type of scaling of gene expressions. Available options: \code{none}, \code{scale} (default), \code{means_SDs}.
#' @param gene_keyword character, a keyword used to identify all the columns of \code{data} that refers to gene expression (default \code{"VIT_"})
#' @details The \code{MPhSscores} function performs a preliminary standardization of columns in \code{data}.
#' @seealso \code{\link[MPhS]{MPhStimepoints}}
#' @references 
#' G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @return A list.
#' @export
#' @importFrom dplyr '%>%'

MPhSscores <- function(data, scaling_type="scale", gene_keyword="VIT_") {
  
  MPhSdata <- NULL
  data_path <- system.file("data", "MPhSdata.rda", package="MPhS")
  load(data_path)
  pca_rot_matrix <- MPhSdata$pca$rotation
  
  # Filtering: Retaining only columns that contain gene expression data
  find_gene_cols <- grepl(gene_keyword, names(data))
  X <- data[, find_gene_cols]

  # Gene scaling 
  X <- gene_scaling(X, scaling_type=scaling_type,
                    means=MPhSdata$means, sds=MPhSdata$sds)      
  
  # Filtering: Retain only genes found in MPhSdata dataset
  gene_names_MPhS <- names(MPhSdata$means)  
  filt_genes_data <- names(X) %in% gene_names_MPhS
  X <- X[, filt_genes_data]
  
  # Reorder X columns as in MPhSdata
  filt_genes_MPhS <- gene_names_MPhS %in% names(X)  
  gene_names_MPhS <- gene_names_MPhS[filt_genes_MPhS]
  idx <- match(gene_names_MPhS, names(X))
  X <- X[, idx]

  # Filtering: Retain only genes found in X
  pca_rot_matrix <- pca_rot_matrix[filt_genes_MPhS, ]

  # Applying PCA: Projecting the data onto the principal component subspace  
  scores <- as.matrix(X) %*% as.matrix(pca_rot_matrix)

  out <- list(scores=scores, no_genes=ncol(X))
  return(out)
}


#' @noRd
gene_scaling <- function(data, scaling_type="scale", means=NULL, sds=NULL) {
  
  if (scaling_type!="none" & scaling_type!="scale" & scaling_type!="means_SDs") {
    stop("No scaling_type specified. Please specify one of the following options: 'none', 'scale', or 'means_SDs'.")
  }
  
  if ((is.null(means) | is.null(sds)) & scaling_type=="means_SDs") {
    stop("MPhS_scaling needs means and SDs")
  }
  
  if (scaling_type=="scale") { 
      data <- lapply(data, scale) %>% as.data.frame()
  } else if (scaling_type=="means_SDs") {
    pos_mn <- match(names(data), names(means)) 
    means <- means[pos_mn]
    sds <- sds[pos_mn]
    namecol_data <- names(data)
    data <- lapply(1:ncol(data), function(k) (data[,k]-means[k])/sds[k])
    data <- as.data.frame(do.call(cbind, data))
    names(data) <- namecol_data
  }
  return(data)
}
