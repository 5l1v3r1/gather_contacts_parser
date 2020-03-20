# gather_contacts_parser
Parses output from GatherContacts BurpSuite plugin into a CSV Format

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
