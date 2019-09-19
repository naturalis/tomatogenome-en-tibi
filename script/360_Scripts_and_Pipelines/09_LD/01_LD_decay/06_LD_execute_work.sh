cd shell

for i in `ls Lbi_chr2_*`
do
	nohup sh $i >$i.log;
done
