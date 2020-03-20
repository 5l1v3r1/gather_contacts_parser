# gather_contacts_parser
Parses output from GatherContacts BurpSuite plugin into a CSV Format
## ABOUT
The GatherContacts.jar format is like so,
```
xxx?.linkedin.com first middle?.? last description
```

This code will format to the follow types:
* {first initial}{last name}@domain.com
* {last name}{first initial}@domain.com
* {first name}.{last name}@domain.com
* {last name}.{first name}@domain.com

If you know of other commmon naming schemes, feel free to let me know and I will add them.

## USAGE
```
 HELP: 
 ./parse_gather_contacts (FILE) (DOMAIN) (FORMATTER OPTION) ([OPTIONAL] FILTER OUT USER'S LAST NAME.)
   FILE = log file from GatherContacts.jar
   DOMAIN = Email domain to use for the output
   FORMATTER OPTION = 
     1 = {first initial}{last name}@{domain}
     2 = {first name}{last initial}@{domain}
     3 = {first name}.{last name}@{domain}
     4 = {last name}.{first name}@{domain}
   FILTER_USER = user's last name to filter out.
```
