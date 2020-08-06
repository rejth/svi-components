const fetch = require('node-fetch');
const fs = require('fs');
// const FormData = require('form-data');

const
    baseUrl = "banff.ruspfraudvi.rus.sas.com",
    user = "user1",
    password = "Go4thsas";

// const formData = new FormData();

// formData.append("_program", "/Public/JobSimpleJSON");
// formData.append("_action", "execute");
// formData.append("_output_type", "ods_html5");
// formData.append("_csrf" , "$CSRF$");

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
    .then(({access_token}) => fetch(`http://${baseUrl}/SASJobExecution/?_program=/Public/JobSimpleJSON&_action=execute`, {
        method: 'post',
        headers: {
            // 'Accept': 'application/json',
            // 'Content-Type': 'form/multipart',
            'Authorization': 'Bearer ' + access_token
        },
        // body: formData
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
    // .then(({response}) => console.log(JSON.stringify(response)));
    });
};

getJsonFromServer();
