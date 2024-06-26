% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.MPhStimepoints.R
\name{plot.MPhStimepoints}
\alias{plot.MPhStimepoints}
\title{Plot data of class MPhStimepoints}
\usage{
\method{plot}{MPhStimepoints}(x, title = NULL, ylim = c(-0.015, 0.015), ncol = 1, nudge_y = 0.005, ...)
}
\arguments{
\item{x}{object of class \code{MPhStimepoints}}

\item{title}{character, plot title}

\item{ylim}{numeric vector, a vector with two numeric values, specifying the lower and upper limits of the scale}

\item{ncol}{numerical, number of rows for the sequence of panels (default \code{ncol=1})}

\item{nudge_y}{numerical, vertical adjustments to nudge the starting position of each text label}

\item{...}{other graphical parameters (not yet implemented)}
}
\value{
A \code{ggplot2} object.
}
\description{
Plot data of class MPhStimepoints
}
\details{
The \code{plot} function visualizes the output of \code{MPhStimepoints} (i.e. the data projected onto the MPhS scale).
}
\references{
G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni.
A molecular phenology scale of grape berry development.
Horticulture Research, 2023, 10: uhad048
}
\seealso{
\code{\link[MPhS]{MPhStimepoints}}
}
\author{
Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
}
