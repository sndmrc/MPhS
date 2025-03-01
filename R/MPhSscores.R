#' Project data onto the MPhS subspace
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param data numeric data frame.
#' @param scaling_type character, type of scaling of gene expressions. Available options: \code{none}, \code{scale} (default), \code{means_SDs}.
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
#'
#' The \code{geneID} parameter allows the function to accurately recognize and handle grapevine gene identifiers according to the specific V1 and V3 genome annotation formats.
#' @details The \code{MPhSscores} function performs a preliminary standardization of columns in \code{data}.
#' @seealso \code{\link[MPhS]{MPhStimepoints}}
#' @references 
#' G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @return A list.
#' @export
#' @importFrom dplyr '%>%'

MPhSscores <- function(data, scaling_type="scale", geneID="VIT") {
  
  MPhSdata <- NULL
  data_path <- system.file("data", "MPhSdata.rda", package="MPhS")
  load(data_path)
  pca_rot_matrix <- MPhSdata$pca$rotation
  
  # Conversion from VIT to VitVi
  if (geneID=="Vitvi") {
    # Filtering: Retaining only columns that contain gene expression data
    find_gene_cols <- grepl("Vitvi", names(data))
    if (sum(find_gene_cols)==0) stop("The gene IDs used in the dataset do not contain the prefix 'VitVi'.")
    X <- data[, find_gene_cols]
    # Matching V3 to V1 annotation
    filt1 <- names(X) %in% MPhSdata$v1v3$v3
    X <- X[, filt1]
    idx1 <- match(names(X), MPhSdata$v1v3$v3)
    idx1 <- idx1[!is.na(idx1)]
    if (sum(idx1)>0) {
      names(X) <- MPhSdata$v1v3$v1[idx1]
    } else {
      stop("I cannot find any match between the gene IDs in the dataset and those in the conversion table.")            
    }
  } else if (geneID=="VIT") {
    # Filtering: Retaining only columns that contain gene expression data
    find_gene_cols <- grepl("VIT_", names(data))
    if (sum(find_gene_cols)==0) stop("The gene IDs used in the dataset do not contain the prefix 'VIT'.")
    X <- data[, find_gene_cols]    
  }
  # Remove genes with zero variance
  filt2 <- apply(X, 2, function(x) length(unique(x))==1)
  n2 <- sum(filt2)
  if (n2==1) {
    warning(paste0(n2," gene was removed because it has constant expression levels across all samples."))
  } else if (n2>1) {
    warning(paste0(n2," genes were removed because they have constant expression levels across all samples."))
  }
  X <- X[, !filt2]
  # Remove genes with NAs
  filt3 <- apply(X, 2, function(x) any(is.na(x)))
  n3 <- sum(filt3)
  if (n3==1) {
    warning(paste0(n3," gene was removed because it has missing expression levels across all samples."))
  } else if (n2>1) {
    warning(paste0(n3," genes were removed because they have missing expression levels across all samples."))
  }
  X <- X[, !filt3]  
  
  # Filtering: Retain only genes found in MPhSdata dataset
  gene_names_MPhS <- names(MPhSdata$means)  
  filt_genes_data <- names(X) %in% gene_names_MPhS
  X <- X[, filt_genes_data]
  
  # Reorder X columns as in MPhSdata
  filt_genes_MPhS <- gene_names_MPhS %in% names(X)  
  gene_names_MPhS <- gene_names_MPhS[filt_genes_MPhS]
  idx_ord <- match(gene_names_MPhS, names(X))
  X <- X[, idx_ord]
  
  # Gene scaling 
  X <- gene_scaling(X, scaling_type=scaling_type,
                    means=MPhSdata$means, sds=MPhSdata$sds)   
  
  # Filtering: Retain only genes found in X
  pca_rot_matrix <- pca_rot_matrix[filt_genes_MPhS, ]
  
  # Applying PCA: Projecting the data onto the principal component subspace  
  scores <- as.matrix(X) %*% as.matrix(pca_rot_matrix)
  
  out <- list(scores=scores, no_genes=ncol(X), data=X)
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
