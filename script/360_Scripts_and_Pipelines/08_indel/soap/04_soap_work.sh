for i in `ls -F | grep / | grep m`
{
	cd $i
	sh *sh
	cd ../
	mv $i /mnt/usbhd1/tomato_soap_and_indel
}


for i in `ls -F | grep / | grep L`
{
	cd $i
	sh *sh
	cd ../
	mv $i /mnt/usbhd1/tomato_soap_and_indel
}


for i in `ls -F | grep / | grep 100`
{
	cd $i
	sh *sh
	cd ../
	mv $i /mnt/usbhd1/tomato_soap_and_indel
}

