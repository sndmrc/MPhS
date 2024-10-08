% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MPhSdata.R
\docType{data}
\name{MPhSdata}
\alias{MPhSdata}
\title{R Objects from the molecular phenology scale (MPhS) proposed by Tornielli, Sandri, Fasoli, et al (2023)}
\format{
A list containing the following R objects:
\describe{
\item{pca}{A prcomp object}
\item{means}{A numeric vector of 10129 mean values from the original dataset of Tornielli et al. (2023)}
\item{sds}{A numeric vector of 10129 standard deviations from the original dataset of Tornielli et al. (2023)}
\item{raw_data_scores}{Raw data of Tornielli et al. (2023) projected onto the PCA space}
\item{smooth_data_scores}{Smoothed data of Tornielli et al. (2023) projected onto the PCA space}
\item{MPhSpcs}{A numeric vector of PC numbers (1, 2, and 5)}
\item{MPhSpts}{A data frame with columns \code{x1},\code{x2}, and \code{x3} (the PCA scores), and the column \code{timepoint} (the MPhS timepoint)}
\item{v1v3}{A data frame with columns \code{v1} (12X.v1 VIT code) and \code{v3} (12X.v2 VCOST.v3)}
}
}
\source{
\url{https://doi.org/10.1093/hr/uhad048}
}
\usage{
data(MPhSdata)
}
\description{
In this file, there are all the objects required for projecting a new dataset onto the MPhS.
}
\examples{
data(MPhSdata)
plot(MPhSdata$pca)
}
\references{
G.B. Tornielli, M. Sandri, M. Fasoli, A. Amato, M. Pezzotti, P. Zuccolotto and S. Zenoni.
A molecular phenology scale of grape berry development.
Horticulture Research, 2023, 10: uhad048
}
\author{
Marco Sandri, Paola Zuccolotto (\email{sandri.marco@gmail.com})
}
\keyword{datasets}
