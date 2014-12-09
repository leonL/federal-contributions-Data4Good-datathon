library(dplyr)
library(magrittr)

## iterate gsub over a vector of patterns (i.e. set of special characters)
gsub2 <- function(pattern, replacement, x, ...) {      
  for(i in 1:length(pattern))
    x <- gsub(pattern[i], replacement[i], x, ...)
  x
}

#coerce a character vector to only contain alphabetical characters
coerce_to_alpha <- function(names){  
  
  #convert accented characters to their alphabetical counterparts
  from <- c('Š', 'š', 'Ž', 'ž', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É',
            'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', 'Ø', 'Ù',
            'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç',
            'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ',
            'ö', 'ø', 'ù', 'ú', 'û', 'ý', 'ý', 'þ', 'ÿ')
  
  to <- c('S', 's', 'Z', 'z', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'C', 'E', 'E',
          'E', 'E', 'I', 'I', 'I', 'I', 'N', 'O', 'O', 'O', 'O', 'O', 'O', 'U',
          'U', 'U', 'U', 'Y', 'B', 'Ss','a', 'a', 'a', 'a', 'a', 'a', 'a', 'c',
          'e', 'e', 'e', 'e', 'i', 'i', 'i', 'i', 'o', 'n', 'o', 'o', 'o', 'o',
          'o', 'o', 'u', 'u', 'u', 'y', 'y', 'b', 'y')
  
  normalized <- gsub2(from, to, names)
  
  return(normalized)
}  