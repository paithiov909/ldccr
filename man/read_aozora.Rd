% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aozora-reader.R
\name{read_aozora}
\alias{read_aozora}
\title{Download text file from Aozora Bunko}
\usage{
read_aozora(
  url = "https://www.aozora.gr.jp/cards/000081/files/472_ruby_654.zip",
  txtname = NULL,
  directory = file.path(getwd(), "cache")
)
}
\arguments{
\item{url}{URL of text download link.}

\item{txtname}{New file name as which text is saved.
If left with \code{NULL}, keeps name of the source file.}

\item{directory}{Path where new file is saved.}
}
\value{
The path to the file downloaded.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#superseded}{\figure{lifecycle-superseded.svg}{options: alt='[Superseded]'}}}{\strong{[Superseded]}}
Downloads a file from specified URL, unzips and converts it as UTF-8.

If you want to read a large part of texts published at Aozora Bunko,
you can download them at once
via \href{https://huggingface.co/datasets/globis-university/aozorabunko-clean}{globis-university/aozorabunko-clean}.
}
