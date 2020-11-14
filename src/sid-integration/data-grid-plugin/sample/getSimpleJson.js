const fetch = require('node-fetch');
const fs = require('fs');

const
    baseUrl = "server",
    user = "user",
    password = "password",
    program = '/Public/JobSimpleJSON',
    action = 'execute';

const getJsonFromServer = () => {
    fetch(`http://${baseUrl}/SASLogon/oauth/token?grant_type=password&username=${user}&password=${password}`, {
        method: 'post',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic c2FzLmVjOg=='
        }
    })
    .then(response => response.json())
    .then(({access_token}) => fetch(`http://${baseUrl}/SASJobExecution/?_program=${program}&_action=${action}`, {
        method: 'post',
        headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + access_token
        },
    }))
    .then(response => {
        console.log(response);
        response.arrayBuffer()
        .then(function(buffer) {
            let content = new Uint8Array(buffer);
            fs.writeFile('test.html', content, function (err) {
                if (err) {
                    throw err;
                }
                console.log('Finished!');
            });
        });
    });
};

getJsonFromServer();
