include("htgn_method_forall.jl")

function run_all(names,p)
    curr_dir=pwd()
    cd("..")
    output= "output_htgn.dat"
    f=open(output,"a")
    for i=1:length(names)
        chk = htgnmain(names[i],true,false,p)
        sout= htgnmain(names[i],false,false,p) 
        println(f,"$(names[i]) :: $(sout) $(chk)")
    end    
    cd(curr_dir)
    close(f)
end

function cleario()
    curr_dir=pwd()
    cd("..")
    output= "output_htgn.dat"
    f=open(output,"w")
    cd(curr_dir)
    close(f)
end

cleario()

run_all(["datafile-50-300-30-10","datafile-50-300-30-20","datafile-50-300-30-30","datafile-50-300-30-40",
"datafile-50-300-30-50","datafile-50-300-100-10",
"datafile-50-300-100-20","datafile-50-300-100-30",
"datafile-50-300-100-40","datafile-50-300-100-50",
"datafile-50-300-200-10","datafile-50-300-200-20",
"datafile-50-300-200-20","datafile-50-300-200-30",
"datafile-50-300-200-40","datafile-50-300-200-50",
"datafile-50-300-300-10","datafile-50-300-300-20",
"datafile-50-300-300-30","datafile-50-300-300-40",
"datafile-50-300-300-50"],25)

 run_all(["datafile-100-300-300-10","datafile-100-300-300-20","datafile-100-300-300-30","datafile-100-300-300-40","datafile-100-300-300-50","datafile-100-300-300-60",
"datafile-100-300-300-70","datafile-100-300-300-80","datafile-100-300-300-90","datafile-100-300-300-90","datafile-100-300-300-100"],50)

run_all(["clustering-50-300-30-1","clustering-50-300-30-2","clustering-50-300-30-3","clustering-50-300-30-4",
"clustering-50-300-30-5","clustering-50-300-30-6",
"clustering-50-300-30-7","clustering-50-300-30-8",
"clustering-50-300-30-9","clustering-50-300-30-10"],25)