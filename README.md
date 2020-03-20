# gather_contacts_parser
Parses output from [GatherContacts.jar](https://github.com/clr2of8/GatherContacts) [BurpSuite](https://portswigger.net/burp) plugin into a CSV Format
## ABOUT
The GatherContacts.jar format is like so,
```
xxx?.linkedin.com first middle?.? last description
```
`./gather_contacts_parser.sh` will format to the follow types:

* {first initial}{last name}@domain.com
* {last name}{first initial}@domain.com
* {first name}.{last name}@domain.com
* {last name}.{first name}@domain.com

I made this out of frustration with Excel. I am a penetration tester that uses Linux to pentest, not Microsoft Office. BTW, If you know of other commmon naming schemes, feel free to let me know and I will add them.

## USAGE
```
 HELP: 
 ./parse_gather_contacts (FILE) (DOMAIN) (FORMATTER OPTION) ([OPTIONAL] FILTER_USER) ([OPTIONAL] -H)
   FILE = log file from GatherContacts.jar
   DOMAIN = Email domain to use for the output
   FORMATTER OPTION = 
     1 = {first initial}{last name}@{domain}
     2 = {first name}{last initial}@{domain}
     3 = {first name}.{last name}@{domain}
     4 = {last name}.{first name}@{domain}
   FILTER_USER = user's last name to filter out.
   -H = Create CSV header ([first],[last],[email])
```
