## Script for sending email from R
##
## Based on code by Nathan Grigg:
## code: https://gist.github.com/nathangrigg/2475544
## blog: http://nathangrigg.net/2012/04/send-emails-from-the-command-line/
## 
## In the internally used functions, the prefix 'as' stands for
## AppleScript, not the word "as".
## 
## Example use:
##   email("This is a test content", "My subject!",
##         "fitzjohn@zoology.ubc.ca", "rich.fitzjohn@gmail.com",
##         files="R/email.R")
##
##   email(content, "About your data",
##        c("daniel.falster@mq.edu.au", "daniel@falsters.net"),
##        "rich.fitzjohn@gmail.com",
##        bcc=c("fitzjohn@zoology.ubc.ca", "dfalster@bio.mq.edu.au"),
##        files="R/email.R", send=TRUE)
## 
## If 'from' is omitted, Mail uses whatever Cmd-N would use.
## 
## Arguments to, cc, bcc, files are all optional, and may be vectors
## or single elements if present.
##
## Paths can be absolute or relative to R's working directory.
## 
## By default, this does not send the email, but simply opens Mail so
## you can review it.  If you are super-confident you're not going to
## shoot yourself in the foot, pass send=TRUE to send the email
## straight away.
## 
## WARNING: This script is really, really, dangerous.  No input
## sanitisation is done and it would be trivial to write an
## injection-based attack.  This runs with full privlidges of the
## user.  But then R is too, so in environments where R can be used
## this should be no worse.
email <- function(content, subject, to, from=character(0),
                  cc=character(0), bcc=character(0),
                  files=character(0), send=FALSE) {
  str.properties <- c(as.property("visible", tolower(!send)),
                      as.property("subject", subject, TRUE),
                      as.property("sender", from, TRUE),
                      as.property("content", as.escape(content), TRUE))
  str.new <- c(as.new("to recipient", "address", to),
               as.new("cc recipient", "address", cc),
               as.new("bcc recipient", "address", bcc),
               as.new("attachment", "file name", normalizePath(files)),
               if ( send ) "send")

  template <- 'tell application "Mail"
  make new outgoing message with properties {%s}
  tell result\n%s
  end tell\nend tell\n'
  script <- sprintf(template, paste(str.properties, collapse=","),
                    paste(paste0("    ", str.new), collapse="\n"))
  as.run(script)
}

as.new <- function(thing, key, value) {
  if ( length(value) > 0 )
    sprintf('make new %s with properties {%s:"%s"}', thing, key, value)
  else
    character(0)
}

as.property <- function(key, value, quote=FALSE)
  paste(key, if (quote) sprintf('"%s"', value) else value, sep=":")

as.run <- function(script, quiet=TRUE) {
  filename <- tempfile()
  writeLines(script, filename)
  on.exit(unlink(filename))
  retval <- system(paste(as.program(), filename),
                   ignore.stderr=quiet, ignore.stdout=quiet)
  retval == 0
}

as.program <- function() {
  path <- Sys.which("osascript")[[1]]
  if ( path == "" || !file.exists(path) )
    stop("Apple script executable not found")
  path
}

as.escape <- function(s)
  gsub('"', '\\\\"', s)
