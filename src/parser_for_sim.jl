mutable struct LTSpice
    filename::String
    names_plots::Vector{String}
    plots_vec
    function LTSpice(filename::String)
        new(filename, String[], [])
    end
end


"""
Funtion to be called by the main parser if the data in the .txt file is real
"""
function real_parser(file::Vector{SubString{String}})
    inter = Vector{Vector{Float64}}()
    for i = 1:length(split(file[1], "\t"))
        list = [begin
            c =  split(file[j], "\t")
            parse(Float64, c[i]) 
            end for j = 2:length(file)-1]
        push!(inter, list)
    end
    return inter
end


"""
Funtion to be called by the main parser if the data in the .txt file is complex
"""
function complex_parser(file::Vector{SubString{String}})
    return [[]]
end


"""
Main parser to know which kind of data is in the file

Return
------
Nothing and the data in the file is parsed
"""
function parser_fs(lts::LTSpice)
    file = open(io->read(io, String), lts.filename)
    file = split(file, "\n")
    lts.names_plots = [word for word in split(file[1], "\t")]
    f_split = split(file[2], "\t")
    if occursin(",", f_split[2])
        lts.plots_vec = complex_parser(file)
    else
        lts.plots_vec = real_parser(file)
    end
    return
end


"""
Function to get the time data asociated with the file.

Note
----

This function is meant to be called after the function parser_fs() or it will return a bound error
"""
function time_t(lts::LTSpice)
    return lts.plots_vec[1]
end


"""
Function to get the data associated with the name given in argument as a vector

Note
----

This function is meant to be called after the function parser_fs() or it will return a bound error
"""
function data_t(lts::LTSpice, name::String)
    if name in lts.names_plots
        for k=1:length(lts.names_plots)
            if name == lts.names_plots[k]
                return lts.plots_vec[k]
            end
        end
    else
        throw(ArgumentError("The name does not correspoond to the parsed data"))
    end
end