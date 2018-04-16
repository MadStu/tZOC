if [ -e getinfo.json ]
then
	sleep 2
else
	ARRAY=$(zeroone-cli getinfo)
	echo "$ARRAY" > getinfo.json
	sleep 5
	IVERSION=$(jq '.version' getinfo.json)
	sleep 5
	LVERSION=$(curl https://raw.githubusercontent.com/MadStu/tZOC/master/version.tx$
	sleep 5

	if [ $LVERSION == $IVERSION ]
	then
		echo "Versions match: $IVERSION"
		sleep 5
	else
		BLOCKCOUNT=$(curl https://explorer.01coin.io/api/getblockcount)
		sleep 5
		WALLETBLOCKS=$(jq '.blocks' getinfo.json)
		sleep 5
		echo "     Latest Version: $LVERSION"
		echo "  Installed Version: $IVERSION"
		echo " "
		echo "    Blocks on Chain: $BLOCKCOUNT"
		echo "      Wallet Blocks: $WALLETBLOCKS"
	fi
	sleep 5
	rm getinfo.json

fi



