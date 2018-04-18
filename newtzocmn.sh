clear
sleep 1
if [ -e getinfo.json ]
then
	echo "Script running already"
else

#sudo apt-get install jq -y

killall zerooned
rm -rf zero*
rm -rf .zero*
wget https://github.com/zocteam/zeroonecoin/releases/download/V0.12.1.6/zeroone-linux.tar.gz
tar -xvzf zeroone-linux.tar.gz



mkdir ~/.zeroonecore
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=yesme\nrpcpassword=f5hanfsdfia\nrpcallowip=127.0.0.1\nlisten=1\nserver=1\ndeamon=1\nlogtimestamps=1\nmaxconnections=64\ntestnet=1\ngen=0\n\nexternalip=$EXIP\nbind=$EXIP:10001\n\naddnode=01coin.io\n\n" > ~/.zeroonecore/zeroone.conf
~/zeroone/zerooned -daemon
sleep 10
MKEY=$(~/zeroone/zeroone-cli masternode genkey)
~/zeroone/zeroone-cli stop
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.zeroonecore/zeroone.conf
sleep 10
~/zeroone/zerooned -daemon






echo "blah" > getinfo.json
sleep 2
ARRAY=$(~/zeroone/zeroone-cli getinfo)
echo "$ARRAY" > getinfo.json
BLOCKCOUNT=$(curl https://testexplorer.01coin.io/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			sleep 20
			BLOCKCOUNT=$(curl https://testexplorer.01coin.io/api/getblockcount)
			ARRAY=$(~/zeroone/zeroone-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
echo "Now wait for AssetID: 999..."
sleep 3
MNSYNC=$(~/zeroone/zeroone-cli mnsync status)
echo "$MNSYNC" > mnsync.json
ASSETID=$(jq '.AssetID' mnsync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 10
			MNSYNC=$(~/zeroone/zeroone-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
~/zeroone/zeroone-cli mnsync status
echo " "
echo " "
echo "  You can now Start Alias in the windows wallet!"
rm getinfo.json

fi





echo " "
THISHOST=$(hostname -f)
echo "For windows wallet masternode.conf:"
echo "$THISHOST $EXIP:10001 $MKEY TXID VOUT"
