DELETE FROM fdhmetadata.dh_control WHERE control_id = <id>;
INSERT INTO fdhmetadata.dh_control VALUES (<id>, 'accumTransactionsTableDirective', 4, 'accum-transactions-table-directive', null, 'Accumulative transactions grid', null, 'Accumulative transactions grid', null, 'Accumulative transactions grid', null, '{"metadata":{"icon":"images/page-designer/GroupBox.svg"},"attributes":{}}', null, '//# sourceURL=accumTransactionsTableDirective.js

angular.module("sngPageBuilderCustom").spbDirective("accumTransactionsTableDirective", [
    "$http",
    "spbPageModes",
    function ($http, spbPageModes) {
        const
            promise = f => new Promise(result => f.then(result).catch(result)),
            postRequest = (url, data) => promise($http.post(url, data)),
            decisionName = ''select_test'',
            // \u0424\u0443\u043D\u043A\u0446\u0438\u044F \u0434\u043B\u044F \u0437\u0430\u043F\u0443\u0441\u043A\u0430 SID \u0441\u0442\u0440\u0430\u0442\u0435\u0433\u0438\u0438 \u043F\u043E MAS REST API
            startDecision = (decisionName, data) => {
                return postRequest(`/microanalyticScore/modules/${decisionName}/steps/execute_internal`, data);
            },
            // \u0424\u0443\u043D\u043A\u0446\u0438\u044F \u0434\u043B\u044F \u043F\u043E\u043B\u0443\u0447\u0435\u043D\u0438\u044F \u0432\u0441\u0435\u0445 \u0441\u0432\u044F\u0437\u0430\u043D\u043D\u044B\u0445 \u0441 \u0430\u043A\u043A\u0443\u043C\u0443\u043B\u044F\u0442\u0438\u0432\u043D\u043E\u0439 \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0435\u0439 \u0431\u0430\u043D\u043A\u043E\u0432\u0441\u043A\u0438\u0445 \u0441\u0447\u0435\u0442\u043E\u0432
            traversalSearch = (id) => {
                return postRequest("/svi-sand/paths?expansionLimit=2000", {
                    "id": id,
                    "type": "vi_accumulative_trnx",
                    "nextLevel": {
                        "vertexTypes": ["vi_account"]
                    }
                });
            };
        return {
            restrict: "E",
            replace: false,
            scope: {
                childNode: "=",
                pageModel: "="
            },
            transclude: true,
            // \u0418\u043C\u043F\u043B\u0435\u043C\u0435\u043D\u0442\u0438\u0440\u0443\u0435\u043C HTML-\u0448\u0430\u0431\u043B\u043E\u043D \u0432 \u043A\u043E\u0434 AngularJS \u0434\u0438\u0440\u0435\u043A\u0442\u0438\u0432\u044B
            template: `<div style="display: grid; grid-row-gap: 10px;">
    <h3 class="spb-layout-no-margin">\u0422\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0438 \u043A\u043B\u0438\u0435\u043D\u0442\u0430</h3>
    <sng-grid-kendo
        grid-data = "accumTransactionsGrid.data"
        columns = "accumTransactionsGrid.columns"
        sortable = "true"
        filterable = "true"
        auto-height = "true"
        no-data-message = "\u041D\u0435 \u043D\u0430\u0439\u0434\u0435\u043D \u043D\u0438 \u043E\u0434\u0438\u043D \u0441\u0432\u044F\u0437\u0430\u043D\u043D\u044B\u0439 \u043E\u0431\u044A\u0435\u043A\u0442">
    </sng-grid-kendo>
</div>
`,
            // \u041D\u0438\u0436\u0435 \u043E\u043F\u0438\u0441\u044B\u0432\u0430\u0435\u0442\u0441\u044F \u043E\u0441\u043D\u043E\u0432\u043D\u0430\u044F \u043B\u043E\u0433\u0438\u043A\u0430 \u0434\u0438\u0440\u0435\u043A\u0442\u0438\u0432\u044B
            link: async function (scope) {
                // \u0417\u0430\u0434\u0430\u0435\u043C \u0441\u0442\u0440\u0443\u043A\u0442\u0443\u0440\u0443 \u043A\u0430\u0441\u0442\u043E\u043C\u043D\u043E\u0433\u043E \u0433\u0440\u0438\u0434\u0430
                scope.accumTransactionsGrid = {
                    data: [],
                    columns: [
                        {
                            field: "account_from",
                            title: "\u0421\u0447\u0435\u0442 \u043E\u0442\u043F\u0440\u0430\u0432\u0438\u0442\u0435\u043B\u044F"
                        },
                        {
                            field: "account_to",
                            title: "\u0421\u0447\u0435\u0442 \u043F\u043E\u043B\u0443\u0447\u0430\u0442\u0435\u043B\u044F"
                        },
                        {
                            field: "client_fio_from",
                            title: "\u0424\u0418\u041E \u043E\u0442\u043F\u0440\u0430\u0432\u0438\u0442\u0435\u043B\u044F"
                        },
                        {
                            field: "client_fio_to",
                            title: "\u0424\u0418\u041E \u043F\u043E\u043B\u0443\u0447\u0430\u0442\u0435\u043B\u044F"
                        },
                        {
                            field: "currency",
                            title: "\u0412\u0430\u043B\u044E\u0442\u0430"
                        },
                        {
                            field: "payment_rub",
                            title: "\u0421\u0443\u043C\u043C\u0430 \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0438 \u0432 \u0440\u0443\u0431."
                        },
                        {
                            field: "transaction_dttm",
                            title: "\u0414\u0430\u0442\u0430 \u0438 \u0432\u0440\u0435\u043C\u044F \u043F\u0440\u043E\u0432\u0435\u0434\u0435\u043D\u0438\u044F \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0438"
                        },
                        {
                            field: "emp_num",
                            title: "RB \u0440\u0430\u0431\u043E\u0442\u043D\u0438\u043A\u0430"
                        }
                    ]
                };
                // \u0415\u0441\u043B\u0438 \u043D\u0430\u0445\u043E\u0434\u0438\u043C\u0441\u044F \u0432 \u043A\u0430\u0440\u0442\u043E\u0447\u043A\u0435 "\u0410\u043A\u043A\u0443\u043C\u0443\u043B\u044F\u0442\u0438\u0432\u043D\u0430\u044F \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u044F", \u0442\u043E \u0438\u0441\u043F\u043E\u043B\u043D\u044F\u0435\u043C \u0441\u043B\u0435\u0434\u0443\u044E\u0443\u0449\u0443\u044E \u043B\u043E\u0433\u0438\u043A\u0443
                if (scope.pageModel.mode === spbPageModes.VIEW && scope.pageModel.type === "vi_accumulative_trnx") {
                    // \u041F\u043E\u043B\u0443\u0447\u0430\u0435\u043C \u0438\u0434\u0435\u043D\u0442\u0438\u0444\u0438\u043A\u0430\u0442\u043E\u0440 \u0430\u043A\u043A\u0443\u043C\u0443\u043B\u044F\u0442\u0438\u0432\u043D\u043E\u0439 \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0438
                    let entityTypeId = scope.docId || (scope.pageModel && scope.pageModel.id) || scope.tempCreateId;
                    // \u041F\u043E\u043B\u0443\u0447\u0430\u0435\u043C \u0432\u0441\u0435 \u0441\u0432\u044F\u0437\u0430\u043D\u043D\u044B\u0435 \u0441 \u0442\u0440\u0430\u043D\u0437\u0430\u043A\u0446\u0438\u0435\u0439 \u0431\u0430\u043D\u043A\u043E\u0432\u0441\u043A\u0438\u0435 \u0441\u0447\u0435\u0442\u0430
                    let endPoints = await traversalSearch(entityTypeId);
                    // \u041F\u043E\u043B\u0443\u0447\u0430\u0435\u043C \u0438\u0434\u0435\u043D\u0442\u0438\u0444\u0438\u043A\u0430\u0442\u043E\u0440\u044B \u044D\u0442\u0438\u0445 \u0441\u0447\u0435\u0442\u043E\u0432
                    let ids = endPoints.data.map(e => e.endpoints[0].id);
                    // \u0422\u0435\u043B\u043E \u0437\u0430\u043F\u0440\u043E\u0441\u0430 \u043F\u043E MAS REST API
                    let requestBody = {
                        "inputs": [{
                                "name": "ACCOUNT_FIRST",
                                "value": ids[0]
                            },
                            {
                                "name": "ACCOUNT_SECOND",
                                "value": ids[1]
                            }
                        ]
                    }
                    // \u0417\u0430\u043F\u0443\u0441\u043A\u0430\u0435\u043C SID \u0441\u0442\u0440\u0430\u0442\u0433\u0438\u044E \u0438 \u0436\u0434\u0435\u043C \u043E\u0442\u0432\u0435\u0442\u0430
                    let response = await startDecision(decisionName, requestBody);
                    // \u041F\u043E\u043B\u0443\u0447\u0430\u0435\u043C \u0440\u0435\u0437\u0443\u043B\u044C\u0442\u0430\u0442 \u0432\u044B\u043F\u043E\u043B\u043D\u0435\u043D\u0438\u044F SID \u0441\u0442\u0440\u0430\u0442\u0435\u0433\u0438\u0438 \u0432 \u0444\u043E\u0440\u043C\u0430\u0442\u0435 JSON String
                    let results = response.data.outputs[0].value;
                    // \u041F\u0440\u0435\u043E\u0431\u0440\u0430\u0437\u0443\u0435\u043C String \u0432 Object \u0438 \u0434\u043E\u0441\u0442\u0430\u0435\u043C \u0434\u0430\u043D\u043D\u044B\u0435 \u0442\u0430\u0431\u043B\u0438\u0446\u044B \u0432 \u043A\u0430\u0447\u0435\u0441\u0442\u0432\u0435 Array
                    let transactions = JSON.parse(results)[1].data;
                    // \u0417\u0430\u0433\u0440\u0443\u0436\u0430\u0435\u043C \u0434\u0430\u043D\u043D\u044B\u0435 \u0432 \u0442\u0430\u0431\u043B\u0438\u0446\u0443 accumTransactionsGrid
                    scope.accumTransactionsGrid.data = transactions.map(e => {
                        return {
                            account_from: e[0],
                            account_to: e[1],
                            client_fio_from: e[2],
                            client_fio_to: e[3],
                            currency: e[4],
                            payment_rub: e[5],
                            transaction_dttm: e[6],
                            emp_num: e[7]
                        }
                    });
                    scope.$apply();
                };
            }
        };
    }
]);
', '2020-09-08 10:20:54', '2020-09-08 10:20:54', 1, 1)