using PyPlot

function syntetic_gen_circle(cirpoint,imsize,nout,pout)

    center=[101,42]

    radius=25

    theta=[0:(2.0*pi)/cirpoint:2.0*pi;]

    xp=zeros(length(theta))

    yp=zeros(length(theta))

    select_point_circ=zeros(pout)

    for i=1:length(theta)

        xp[i]=round(center[1]+ (radius.*cos(theta[i])))

        yp[i]=round(center[2]+ (radius.*sin(theta[i])))

        if i in select_point_circ
            
            xp[i]=xp[i]+rand([-2,-1,0,1,2])

            yp[i]=yp[i]+rand([-2,-1,0,1,2])
        
        end

    end

    randpoints=zeros(nout,2)

    for i=1:nout
    
        randpoints[i,1]=rand([1:1.0:imsize;])

        randpoints[i,2]=rand([1:1.0:imsize;])

    end

    plot(xp, yp, color="red",".")

    plot(randpoints[:,1],randpoints[:,2],color="blue",".")

    ax=gca()

    ax[:axis]("equal")

    datafile= "datafile-$cirpoint-$imsize-$nout-$pout.dat"

    f=open(datafile,"w")

    for i=1:length(xp)

        println(f,xp[i]," " ,yp[i])

    end

    for i=1:nout

        println(f,randpoints[i,1]," " ,randpoints[i,2])
    
    end

    close(f)

end

function creating_tests()

    for i=10:10:100

        syntetic_gen_circle(100,300,300,i)

    end

end