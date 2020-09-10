
angular.module("sngPageBuilderCustom").spbDirective("{{name}}", [
    "$http",
    "spbPageModes",
    function ($http, spbPageModes) {
        const
            promise = f => new Promise(result => f.then(result).catch(result)),
            postRequest = (url, data) => promise($http.post(url, data)),
            decisionName = 'select_test',
            // Функция для запуска SID стратегии по MAS REST API
            startDecision = (decisionName, data) => {
                return postRequest(`/microanalyticScore/modules/${decisionName}/steps/execute_internal`, data);
            },
            // Функция для получения всех связанных с аккумулятивной транзакцией банковских счетов
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
            // Имплементируем HTML-шаблон в код AngularJS директивы
            template: `{{template}}`,
            // Ниже описывается основная логика директивы
            link: async function (scope) {
                // Задаем структуру кастомного грида
                scope.accumTransactionsGrid = {
                    data: [],
                    columns: [
                        {
                            field: "account_from",
                            title: "Счет отправителя"
                        },
                        {
                            field: "account_to",
                            title: "Счет получателя"
                        },
                        {
                            field: "client_fio_from",
                            title: "ФИО отправителя"
                        },
                        {
                            field: "client_fio_to",
                            title: "ФИО получателя"
                        },
                        {
                            field: "currency",
                            title: "Валюта"
                        },
                        {
                            field: "payment_rub",
                            title: "Сумма транзакции в руб."
                        },
                        {
                            field: "transaction_dttm",
                            title: "Дата и время проведения транзакции",
                            format: "{0: dd.MM.yyyy HH:mm:ss}"
                        },
                        {
                            field: "emp_num",
                            title: "RB работника"
                        }
                    ]
                };
                // Если находимся в карточке "Аккумулятивная транзакция", то исполняем следуюущую логику
                if (scope.pageModel.mode === spbPageModes.VIEW && scope.pageModel.type === "vi_accumulative_trnx") {
                    // Получаем идентификатор аккумулятивной транзакции
                    let entityTypeId = scope.docId || (scope.pageModel && scope.pageModel.id) || scope.tempCreateId;
                    // Получаем все связанные с транзакцией банковские счета
                    let endPoints = await traversalSearch(entityTypeId);
                    // Получаем идентификаторы этих счетов
                    let ids = endPoints.data.map(e => e.endpoints[0].id);
                    // Тело запроса по MAS REST API
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
                    // Запускаем SID стратгию и ждем ответа
                    let response = await startDecision(decisionName, requestBody);
                    // Получаем результат выполнения SID стратегии в формате JSON String
                    let results = response.data.outputs[0].value;
                    // Преобразуем String в Object и достаем данные таблицы в качестве Array
                    let transactions = JSON.parse(results)[1].data;
                    // Загружаем данные в таблицу accumTransactionsGrid
                    scope.accumTransactionsGrid.data = transactions.map(e => {
                        return {
                            account_from: e[0],
                            account_to: e[1],
                            client_fio_from: e[2],
                            client_fio_to: e[3],
                            currency: e[4],
                            payment_rub: e[5],
                            transaction_dttm: new Date(Date(e[6])),
                            emp_num: e[7]
                        }
                    });
                    scope.$apply();
                };
            }
        };
    }
]);
