# This script parses a list of transactions from a VISA statement and writes them back to
# stdout in comma-separated fields.  This can be helpful when trying to reconcile a statement
# and there is more than one error in my accounting so the exact amount of the unreconciled
# amount does not show up in either my books or on the statement.  In that case, I dump the
# transaction to Excel and sort them by the amount, and do the same for the booked transactions.
# The errors are much easier to spot that way.
#
# An input line of VisaTransactions.txt should would like:
#  DEC 15 DEC 17 NESTERS MARKET #088821 VANCOUVER $98.97
#
# and the output will be:
#  Date, Description, Amount
#  Dec 15, "NESTERS MARKET #088821 ", "$98.97"
#
# Refunds (negative transactions) are not handled quite correctly but there will only be few
# on each statement and I can deal with them manually.
#
# TOOD:
# * ingest statement transactions and booked transactions and find unmatched ones.  Would save
#   the hassle of doing a manual search.
# * make this into a PowerShell module
# * separate the transactions by user, so James' transctions are separated from Tanya's

$searchPattern = '(?<date>\w{3} \d+)\s\w{3}\s\d+\s(?<description>[^$]+)(?<amount>\$[\d\.\,\-]+)'
(Get-Content VisaStatement.txt).ForEach({
	if ($_ -match $searchPattern) {
		Write-Output "$($Matches.date),`"$($Matches.description)`",`"$($Matches.amount)`""
	}
})
