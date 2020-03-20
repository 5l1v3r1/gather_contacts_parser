#!/usr/bin/env bash
#
# PGC -
#
# Parse the logged output of GatherContacts.jar into a nice CSV
# 2020 Douglas Berdeaux
# WeakNet Labs
#
## HELP DIALOG:
app_help () {
	printf "\n HELP: \n";
	printf " ./parse_gather_contacts (FILE) (DOMAIN) (FORMATTER OPTION) ([OPTIONAL] FILTER OUT USER'S LAST NAME.)\n"
	printf "   FILE = log file from GatherContacts.jar\n"
	printf "   DOMAIN = Email domain to use for the output\n";
	printf "   FORMATTER OPTION = \n"
	printf "     1 = {first initial}{last name}@{domain}\n"
	printf "     2 = {first name}{last initial}@{domain}\n"
	printf "     3 = {first name}.{last name}@{domain}\n"
	printf "     4 = {last name}.{first name}@{domain}\n"
	printf "   FILTER_USER = user's last name to filter out.\n\n"
	exit 1337;
}
export -f app_help;

## FILE option:
if [[ "$1" != "" ]];
then
	FILE=$1
	# printf "[i] Using file: $FILE\n"; ## DEBUG
else
	printf "[E] No file provided.\n";
	app_help;
fi

## DOMAIN option:
if [[ "$2" != "" ]]
then
	# printf "[i] Using domain: $DOMAIN\n"; ## DEBUG
	DOMAIN=$2
else
	printf "[E] No domain provided.\n"
	app_help;
fi

## FORMAT option:


case $3 in
	"")
		printf "[E] Please provide a formatter option.\n"
		app_help;
		;;
	1)
		FORMAT=1
		;;
	2)
		FORMAT=2
		;;
	3)
		FORMAT=3
		;;
	4)
		FORMAT=4
		;;
	*)
		printf "[E] Wrong format specifier provided.\n"
		app_help;
		;;
esac

## Check file exists:
if [[ -f "$FILE" ]]
then
	# printf "[i] File $FILE exists.\n" ## DEBUG
	echo -n ""
else
	printf "[E] Cannot open file $FILE.\n"
	app_help;
fi

## FILTER user option:
if [[ "$4" != "" ]]
then
	FILTER_USER=$4
else
	FILTER_USER="djd9203di8j923idj923dj2i93jdij" # filter something out at least.
fi

## OUTPUT to the terminal - leave it up to the user to put into a file with $(tee)
IFS_OLD=$IFS ## Preserve the field separator
IFS=$'\n' ## make the field separator a newline
TEMP_FILE=$(date|sed -r 's/\s+/_/g') ## TODO - just use an array?
for line in $(grep -i linkedin $FILE | sort -u | grep -iv "$FILTER_USER")
do
	fn=$(echo $line |awk '{print $2}');
	ln=$(echo $line |awk '{print $3}');
	pattern="^[A-Za-z]\.$"; ## Middle initial, not a last name.
	if [[ "$ln" =~ $pattern ]]
	then
		ln=$(echo $line |awk '{print $4}');
	fi
	fi=$(echo $fn |sed -r 's/^(.).*/\1/')
	if [ $FORMAT -eq 1 ]
	then
		email="${fi}${ln}@${DOMAIN}"
	elif [ $FORMAT -eq 2 ]
	then
		email="${ln}${fi}@${DOMAIN}"
	elif [ $FORMAT -eq 3 ]
	then
		email="${fn}.${ln}@${DOMAIN}";
	elif [ $FORMAT -eq 4 ]
	then
		email="${ln}.${fn}@${DOMAIN}";
	fi
	printf "${fn},${ln},$email\n" >> $DOMAIN_${TEMP_FILE}
done
printf "First, Last, Email\n" # The CSV header required.
sort -u $TEMP_FILE | egrep -E -v '[^a-zA-Z0-9.,@_-]' && rm $TEMP_FILE
IFS=$IFS_OLD # return this in tact.
# printf "[i] Script completed successfully.\n" ## DEBUG
