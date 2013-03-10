
# Bad line endings from in csv files from mac version of Excel #
Add the following text to .git/config
This must be done on **each clone**

[filter "cr"]

    clean =  tr '\\r' '\\n'

    smudge = tr '\\n' '\\r'

