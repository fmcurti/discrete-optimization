using OffsetArrays

function solve(input)
    n,K,values,weights = (0,0,[],[])
    if length(input) < 1
        n,K,values,weights = parseFile("tmp.data")
    else 
        n,K,values,weights = parseFile(input[1])
    end
    M = fill(-1,(n+1,K+1))
    M = OffsetArray(M,0:n,0:K)

    for i in range(0,stop=n)
        for w in range(0,stop=K)
            if (i == 0 || w == 0)
                M[i,w] = 0
            elseif weights[i] <= w   
                M[i,w] = max(values[i] + M[(i-1),(w - weights[i])],M[i-1,w])
            else 
                M[i,w] = M[i-1,w]
            end
        end
    end

    println("$(M[n,K]) 1")
    
    selected = ""
    while n > 0
        if M[n,K] == M[n-1,K]
            selected = string(selected," 0")
        else 
            selected = string(selected," 1")
            K = K - weights[n]
        end
        n -= 1
    end
    
    println(reverse(selected))


    
end


function parseFile(file)
    lines = readlines(file)

    n,K = split(lines[1],' ')
    n = parse(Int32,n)
    K = parse(Int32,K)
    values = []
    weights = []

    for l in lines[2:end]
        v,w = split(l,' ')
        append!(values,parse(Int32,v))
        append!(weights,parse(Int32,w))
    end

    return n,K,values,weights
end

solve(ARGS)