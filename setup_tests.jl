#including the methods file
include("ht_method.jl")
include("htgn_method.jl")
include("gn_method.jl")
#
function run_prob(
        probname::String,
        method::String,
        valp::Int,
        valdraw::Bool,
        probreal::Bool
        )

        #probname -> represents the name of problem (ex, "data-100-300-100-50.dat")
        #method -> represents the method that will be used (HT)
        #valp -> represents the number of trustable points
        #valdraw -> if true, draw the solution
        #probreal -> if true, a method to draw the solution will be used
        if method == "HT" || method== "ht"
                htmain(probname,valdraw,probreal)
        end
        if method == "HTGN" || method== "htgn"
                htgnmain(probname,valdraw,probreal,valp)
        end
        if method == "GN" || method== "gn"
                htgnmain(probname,valdraw,probreal,valp)
        end
end


