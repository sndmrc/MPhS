#' Plot data of class MPhStimepoints
#'
#' @author Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
#' @param x object of class \code{MPhStimepoints}
#' @param title character, plot title
#' @param ylim numeric vector, a vector with two numeric values, specifying the lower and upper limits of the scale
#' @param ncol numerical, number of rows for the sequence of panels (default \code{ncol=1})
#' @param ... other graphical parameters (not yet implemented)
#' @details The \code{plot} function visualizes the output of \code{MPhStimepoints} (i.e. the data projected onto the MPhS scale).
#' @seealso \code{\link[MPhS]{MPhStimepoints}}
#' @references 
#' G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni. 
#' A molecular phenology scale of grape berry development. 
#' Horticulture Research, 2023, 10: uhad048
#' @return A \code{ggplot2} object.
#' @export
#' @method plot MPhStimepoints
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_path
#' @importFrom ggplot2 facet_wrap
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 element_blank
#' @importFrom ggrepel geom_label_repel
#' @importFrom stats as.formula
#' 
#' 

plot.MPhStimepoints <- function(x, title=NULL, ylim=c(-0.015, 0.015), ncol=1, ...) {
  
  y <- tmpts <- timepoint <- stage <- NULL
  MPhS_pts <- x$pred_scores  
  no_genes <- x$no_genes
  npts     <- x$no_MPhS_pts
  df.ln  <- data.frame(x=c(1,npts), y=c(0,0))
  df.tks <- data.frame(tmpts=rep(1:npts,each=2), 
                       x=rep(1:npts,each=2), 
                       y=rep(c(0,-0.001), npts))
  
  strvar <- x$strata_var
  if (length(strvar)==1) {
    facet_formula <- as.formula(paste0(strvar,"~."))
  } else {
    facet_formula <- as.formula(paste0(strvar[1],"~",paste0(strvar[-1], collapse="+")))
  }
  
  p <- ggplot() +
    geom_path(data=df.ln,  aes(x=x, y=y), linewidth=1, alpha=0.5, inherit.aes=F, show.legend=F)  +
    geom_path(data=df.tks, aes(x=x, y=y, group=tmpts), linewidth=1, alpha=0.5, inherit.aes=F, show.legend=F)  +
    geom_label_repel(data=MPhS_pts, aes(x=timepoint, y=0, label=stage), size=4, nudge_y=-0.003, 
                     angle=0, direction="y", force=10) +
    facet_wrap(facet_formula, ncol=ncol) +
    labs(x="MPhS", y="", title=title) +
    scale_x_continuous(breaks=1:npts) +
    ylim(ylim) + 
    theme_bw() +
    theme(axis.ticks.y = element_blank(), axis.text.y = element_blank(), legend.position = "none")

  return(p)  
}
  