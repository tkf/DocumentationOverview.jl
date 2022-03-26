# TODO: create FoldsBase and use it here

struct Break{T}
    value::T
end

# unbreak(v) = v
# unbreak(b::Break) = b.value

function foldl_modules_rec(rf, init, m::Module)
    acc = rf(init, m)
    acc isa Break && return acc

    for n in sort!(names(m; all = true))
        sub = try
            getproperty(m, n)
        catch
            continue
        end
        sub isa Module || continue
        parentmodule(sub) === m || continue

        acc = rf(acc, sub)
        acc isa Break && return acc
    end

    return acc
end
