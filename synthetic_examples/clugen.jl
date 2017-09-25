#using PyPlot
using Images, Colors, FixedPointNumbers, ImageView

function clustering_gen_circle(cirpoint,imsize,nout,nclus)
    center=[101,42]
    radius=25
    theta=[0:(2.0*pi)/cirpoint:2.0*pi;]
    xp=zeros(length(theta))
    yp=zeros(length(theta))
    ncl=30 #numero de pontos por cluster
    for i=1:length(theta)
        xp[i]=round(center[1]+ (radius.*cos(theta[i])))
        yp[i]=round(center[2]+ (radius.*sin(theta[i])))
    end
    randpoints=zeros(nout,2)
    for i=1:nout 
        randpoints[i,1]=rand([1:1.0:imsize;])
        randpoints[i,2]=rand([1:1.0:imsize;])
    end
    cluspoints=zeros(nclus,2)
    rcluspoint=zeros(ncl,2,nclus)
    for i=1:nclus
        cluspoints[i,1]=rand([1:1.0:imsize;])
        cluspoints[i,2]=rand([1:1.0:imsize;])
        for j=1:ncl
        rcluspoint[j,1,i]=minimum([imsize,cluspoints[i,1]+rand([1:1.0:2*radius;])])
        rcluspoint[j,2,i]=minimum([imsize,cluspoints[i,2]+rand([1:1.0:2*radius;])])
        end
    end
   # plot(xp, yp, color="red",".")
    #plot(randpoints[:,1],randpoints[:,2],color="blue",".")
   # for i=1:nclus
   # plot(rcluspoint[:,1,i],rcluspoint[:,2,i],color="green",".")
   # end
   # ax=gca()
   # ax[:axis]("equal")
    datafile= "clustering-$cirpoint-$imsize-$nout-$nclus.dat"
    f=open(datafile,"w")
    for i=1:length(xp)
        println(f,xp[i]," " ,yp[i])
    end
    for i=1:nout
        println(f,randpoints[i,1]," " ,randpoints[i,2])
    end
    for i=1:nclus
        println(f,cluspoints[i,1]," ", cluspoints[i,2])
        for j=1:ncl
            println(f,rcluspoint[j,1,i]," ",rcluspoint[j,2,i])
        end
    end
    close(f)
    A=readdlm(datafile, Float64)
     img=Gray.(ones(300,300))
        img=RGB{Float32}.(img)
        for i=1:length(A[:,1])
            img[Int(A[i,1]),Int(A[i,2])]=RGB{Float32}(0.0,0.0,1.0)
        end
         imshow(img)
end

##function creating_tests()
#    for i=1:1:10
#       clustering_gen_circle(50,300,30,i)
#    end
#end
#
 clustering_gen_circle(50,300,30,7)