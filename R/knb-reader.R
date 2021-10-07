# Parser for KNB corpus (http://nlp.ist.i.kyoto-u.ac.jp/kuntt/#ga739fe2)
#
# Copyright 2012- Takeshi Arabiki
# License: MIT License (http://opensource.org/licenses/MIT)
#
# Example:
#
#   # KNB コーパスを data ディレクトリ下にダウンロードして解凍
#   # 返り値は解凍後のファイル名
#   dir <- KNB$downloadCorpus("data")
#   # KNB コーパスの内容をパース
#   docs <- KNB$parseDocs(dir)
#   # パース結果を元にデータフレームを作成
#   # normalize が TRUE だと RUnicode パッケージ（Windows 不可）で Unicode 正規化を行う
#   corpus <- KNB$makeCorpusDF(docs, normalize = TRUE)
#   # 一部の品詞の単語のみを使って単語文書行列を作成する
#   # 品詞を区別するために pos1 の情報も使う
#   library(Matrix)
#   pos <- c("名詞", "接尾辞", "動詞", "副詞", "形容詞", "接頭辞", "連体詞")
#   D <- xtabs(~ paste(term, pos1, sep = ".") + doc,
#              data = subset(corpus, pos1 %in% pos), sparse = TRUE)


KNB <- list()

KNB$url <- "http://nlp.ist.i.kyoto-u.ac.jp/kuntt/KNBC_v1.0_090925.tar.bz2"

KNB$emoticons <- c("\uff08 \u00b4\u0434\uff40\uff09\u2193",
                   "\u30fe\uff08\uff0a \u00b4\u2200\uff40\uff0a\uff09\u30ce\u201d")

KNB$downloadCorpus <- function(dataDir) {
    dir.create(dataDir)
    filename <- file.path(dataDir, basename(KNB$url))
    download.file(KNB$url, filename)
    untar(filename, exdir = dataDir)
    return(sub("\\.tar\\.bz2$", "", filename))
}

KNB$parseFile <- function(filename, skipTag = FALSE) {
    fh <- file(filename, "r", encoding = "euc-jp")
    lines <- readLines(fh)
    close(fh)

    surface <- reading <- term <- pos1 <- pos2 <- pos3 <- character(length(lines))
    i <- 0
    for (line in lines) {
        if (substr(line, 1, 1) %in% c("#", "*", "+")) {
            next
        }
        if (line == "EOS") {
            break
        }

        tokens <- strsplit(line, " ")[[1]]

        if (skipTag) {
            if (tokens[1] == "］") {
                skipTag <- FALSE
            }
            next
        }

        if (paste(tokens[1:2], collapse = " ") %in% KNB$emoticons) {
            # emoticons which have a space
            emoticon <- paste(tokens[1:2], collapse = " ")
            tokens <- c(rep(emoticon, 3), tokens[-(1:6)])
        } else if (tokens[3] == "") {
            # there are redundant spaces in the line
            tokens <- tokens[-3]
        }

        i <- i + 1
        surface[i] <- tokens[1]
        reading[i] <- tokens[2]
        term[i] <- tokens[3]
        pos1[i] <- tokens[4]
        pos2[i] <- tokens[6]
        pos3[i] <- tokens[8]
    }

    return(data.frame(
        surface  = surface[seq_len(i)],
        reading  = reading[seq_len(i)],
        term     = term[seq_len(i)],
        pos1     = pos1[seq_len(i)],
        pos2     = pos2[seq_len(i)],
        pos3     = pos3[seq_len(i)],
        sentence = rep(basename(filename), i)))
}

KNB$parseDoc <- function(dir) {
    files <- list.files(dir, pattern = "^KN", full.names = TRUE)
    doc <- vector("list", length(files))
    for (i in seq_along(files)) {
        doc[[i]] <- KNB$parseFile(files[i], i == 1)
        if (nrow(doc[[i]]) > 0) {
            doc[[i]]$doc <- factor(basename(dir))
        }
    }
    names(doc) <- basename(files)
    return(doc)
}

KNB$parseDocs <- function(corpusDir) {
    dirs <- list.files(file.path(corpusDir, "corpus1"), full.names = TRUE)
    docs <- lapply(dirs, KNB$parseDoc)
    names(docs) <- basename(dirs)
    return(docs)
}

KNB$makeCorpusDF <- function(docs, normalize = FALSE) {
    corpus <- do.call(rbind, lapply(docs, function(doc) {
        do.call(rbind, doc)
    }))
    rownames(corpus) <- NULL

    corpus <- within(corpus, {
        if (normalize && require("RUnicode")) {
            # "Ｔｏｋｙｏ．Ｒ" -> "tokyo.r"
            surface  <- tolower(unormalize(surface))
            term <- tolower(unormalize(term))
        } else {
            # "Tokyo.R" -> "tokyo.r"
            surface  <- tolower(surface)
            term <- tolower(term)
        }
        target <- which(pos2 == "数詞")
        surface[target] <- "<NUMBER>"
        term[target] <- "<NUMBER>"

        target <- grep("^https?://", surface, perl = TRUE)
        surface[target] <- "<URL>"
        term[target] <- "<URL>"

        # tokyo.r!!!!! -> tokyo.r!
        # note: process one multibyte character as one character if `useBytes` is `TRUE`
        regex <- "([!?,.、。，．ー・])\\1+"
        surface <- gsub(regex, "\\1", surface, perl = TRUE)
        term <- gsub(regex, "\\1", term, perl = TRUE)

        category <- factor(sapply(strsplit(as.character(doc), "_"), `[[`, 2))
        rm(target, regex)
    })
    return(corpus)
}
