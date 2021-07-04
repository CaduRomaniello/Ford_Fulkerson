using Base
using Pkg

try 
    using Base
catch
    println("Installing Base...")
    Pkg.add("Base")
end

try 
    using Random
catch
    println("Installing Random...")
    Pkg.add("Random")
end

try 
    using JSON
catch
    println("Installing JSON...")
    Pkg.add("JSON")
end

try 
    using Printf
catch
    println("Installing Printf...")
    Pkg.add("Printf")
end

try 
    using PrettyTables
catch
    println("Installing PrettyTables...")
    Pkg.add("PrettyTables")
end
