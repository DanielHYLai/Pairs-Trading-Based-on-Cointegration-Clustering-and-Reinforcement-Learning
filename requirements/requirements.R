package_name <- as.vector(
    unlist(
        read.table(file = "requirements.txt", header = FALSE, sep = "\n")
    )
)

for (name in package_name) {
    if (!require(name, character.only = TRUE)) {
        install.packages(name)
    }
    library(name, character.only = TRUE)
}

rm(list = ls())