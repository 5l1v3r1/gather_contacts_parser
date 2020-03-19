#!/usr/bin/env bash
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
	exit;
fi

## DOMAIN option:
if [[ "$2" != "" ]]
then
	# printf "[i] Using domain: $DOMAIN\n"; ## DEBUG
	DOMAIN=$2
else
	printf "[E] No domain provided.\n"
	app_help;
	exit;

fi

## FORMAT option:
if [[ "$3" == "" ]]
then
	printf "[E] Please provide a formatter option.\n"
	app_help;
	exit;
else
	if [[ "$3" == 1 ]]
	then
		FORMAT=1
	elif [[ "$3" == 2 ]]
	then
		FORMAT=2
	else
		printf "[E] Wrong format specifier provided.\n"
		app_help;
		exit;
	fi
fi

## Check file exists:
if [[ -f "$FILE" ]]
then
	# printf "[i] File $FILE exists.\n" ## DEBUG
	echo -n ""
else
	printf "[E] Cannot open file $FILE.\n"
	app_help;
	exit;
fi

## FILTER user option:
if [[ "$4" != "" ]]
then
	FILTER_USER=$4
else
	FILTER_USER="djd9203di8j923idj923dj2i93jdij"
fi

IFS_OLD=$IFS
IFS=$'\n'
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
	if [[ "$FORMAT" == 1 ]]
	then
		email=$(echo -n ${fi}${ln}@${DOMAIN})
	elif [[ "$FORMAT" == 2 ]]
	then
		email=$(echo -n ${ln}${fi}@${DOMAIN})
	fi
	printf "${fn},${ln},$email\n" >> $DOMAIN_${TEMP_FILE}
done
sort -u $TEMP_FILE | egrep -E -v '[^a-zA-Z0-9.,@_-]' && rm $TEMP_FILE
IFS=$IFS_OLD # return this in tact.
# printf "[i] Script completed successfully.\n" ## DEBUG
