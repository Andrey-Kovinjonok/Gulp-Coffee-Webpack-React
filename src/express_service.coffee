express = require('express')
app = express()

app.disable('x-powered-by');

console.log __dirname
app.use(express.static(__dirname))

app.get '/hello', (req, res)->
    #console.log res
    console.log __dirname
    res.send('hello world --- ! ! !')

app.listen(8080);
console.log('Listening on port 8080');