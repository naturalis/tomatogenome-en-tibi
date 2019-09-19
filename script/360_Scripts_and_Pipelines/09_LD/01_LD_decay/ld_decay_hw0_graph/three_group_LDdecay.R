pdf("ld_decay_hw0.pdf")
#read.table("ld_decay_hw0.001_hw0.txt")->ld_decay
#read.table("ld_decay_hw0.txt")->ld_decay
read.table("ld_decay_hw0_big_2M.txt")->ld_decay

ld_decay$V1->ix
ld_decay$V2->iy

plot(ix,iy,type="l",col="green",xlim=c(0,950),ylim=c(0,1),bty="n",xlab="Pairwise distance (Kb)",ylab="r2",lwd=2)


ld_decay$V3->cy
lines(ix,cy,col="orange",lwd=2);

ld_decay$V4->ey;
lines(ix,ey,col="blue",lwd=2);

lines(c(0,0.209)~c(8.8,8.8),col="green",lwd=2,lty=3);
lines(c(0,0.3543)~c(256.8,256.8),col="orange",lwd=2,lty=3);
lines(c(0,0.3543)~c(865.7,865.7),col="blue",lwd=2,lty=3);

##legend("topright",c("Indian","East-Asian","Eurasian","Xishuangbanna"),col=c("green","blue","orange","red"),lwd=2,bty="n")
dev.off()
