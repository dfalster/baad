
# Bad line endings from in csv files from mac version of Excel #
Add the following text to .git/config
This must be done on **each clone**

[filter "cr"]
    clean = LC_CTYPE=C awk '{printf(\"%s\\n\", $0)}' | LC_CTYPE=C tr '\\r' '\\n'
    smudge = tr '\\n' '\\r'

