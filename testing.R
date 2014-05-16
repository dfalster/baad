# Not a real project file.  Just for developing tests.
library(dataMashR)
for (d in dir("data")) {
  validate(d)
}
