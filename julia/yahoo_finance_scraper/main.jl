import HTTP
using Gumbo

#r = HTTP.request("GET", "https://in.finance.yahoo.com/quote/BTC-INR?p=BTC-INR")
#println(r.status)
#html_body = String(r.body)
#tmp_file = open("tmp_file.html", "w")
#write(tmp_file, html_body)
#close(tmp_file)

tmp_file = open("tmp_file.html", "r")
tmp_data = read(tmp_file, String)
r_parsed = parsehtml(tmp_data)
r_body = r_parsed.root[2]
for i in 1:10
    println(i)
    println(r_body[i])
end
#https://query1.finance.yahoo.com/v7/finance/download/BTC-INR?period1=1584299797&period2=1615835797&interval=1d&events=history&includeAdjustedClose=true
