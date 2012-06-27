\name{read.sif}
\alias{read.sif}
\title{Reading network files}
\usage{
  read.sif(sif.file, format = "graphNEL", directed = FALSE,
    header = TRUE, sep = "\t", ...)
}
\arguments{
  \item{sif.file}{Name of network file in SIF format.}

  \item{format}{Output format: igraph0 or graphNEL}

  \item{directed}{Logical. Directed/undirected graph. Not
  used in the current model.}

  \item{header}{Logical. Indicate whether the SIF file has
  header or not.}

  \item{sep}{Field separator.}

  \item{...}{Further optional arguments to be passed for
  file reading.}
}
\value{
  R graph object in igraph0 or graphNEL format.
}
\description{
  Function to read network files.
}
\details{
  Read in SIF network file, return R graph object in igraph
  or graphNEL format.
}
\examples{
#net <- read.sif("network.sif")
}
\author{
  Leo Lahti \email{leo.lahti@iki.fi}
}
\keyword{utilities}
