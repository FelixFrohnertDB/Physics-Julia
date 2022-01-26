import Statistics
using DelimitedFiles
using Printf


function slicematrix(A::AbstractMatrix)
    return [A[i, :] for i in 1:size(A,1)]
end


temp = slicematrix(readdlm("/home/felix/PycharmProjects/physics/cusum_data.txt", Int) )

display(typeof(temp))

time = temp[:,0]
event_val = temp[:,0]

display(length(event_val))

w = Statistics.mean(event_val)
h = 100*w
std_max = 150
min_range = 100
i = 1
number = size(time, 1)


r = min_range:std_max

display(time[r])


s = Array{Float64}(undef, size(time, 1))
sp = Array{Float64}(undef, number)
sn = Array{Float64}(undef, number)
cusum_points = Array{Float64}(undef, 1)
cusum_p_points = Array{Float64}(undef, 1)
cusum_n_points = Array{Float64}(undef, 1)


function new_average_and_index(i)
    std = std_max + 1
    while (i+min_range) < number && std > std_max
        std = np.std(event_val[i:(i+min_range)])
        w = np.mean(event_val[i:(i+min_range)])
        i += 100
    return w, i
    end



function new_start(i)
        s[i] = value_current
        sp[i] = value_current
        if sp[i] < 0
            sp[i] = 0
        sn[i] = value_current
        if sn[i] > 0
            sp[i] = 0
    end


w, i = new_average_and_index(i)

display(w)
value_current = (event_value[i] - w)
new_start(i)

while i < number

    value_current = (event_value[i] - w)

    s[i] = s[i-1] + value_current
    sp[i] = sp[i-1] + value_current
    if sp[i] < 0
        sp[i] = 0     # sp wird nie < 0
    sn[i] = sn[i-1] + value_current
    if sn[i] > 0
        sn[i] = 0     # sn wird nie > 0


    if (s[i] < -h || s[i] > h)

        cusum_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)
    if sp[i] > h

        cusum_p_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)
    if sn[i] < -h

        cusum_n_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)

    i += 1
end