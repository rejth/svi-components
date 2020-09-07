
angular.module("sngPageBuilderCustom").spbDirective("{{name}}", [
    "$http",
    "spbPageModes",
    function ($http, spbPageModes) {
        const
            promise = f => new Promise(result => f.then(result).catch(result)),
            postRequest = (url, data) => promise($http.post(url, data)),
            // Путь до SAS Job на CAS-сервере
            jobFilePath = '/Projects/SASCustom/Jobs/SimpleJSON',
            // Функция удаленного запуска SAS Job с помощью SAS Job Execution REST API
            getJsonFromJob = (jobFilePath) => {
                return postRequest(`/SASJobExecution/?_program=${jobFilePath}&_action=execute`);
            },
            // Функция для получения всех связанных с аккумулятивной транзакцией банковских счетов
            traversalSearch = (id) => {
                return postRequest("/svi-sand/paths?expansionLimit=2000", {
                    "id": id,
                    "type": "vi_accumulative_transaction",
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
                            title: "Дата и время проведения транзакции"
                        },
                        {
                            field: "emp_num",
                            title: "RB работника"
                        }
                    ]
                };
                // Если находимся в карточке "Аккумулятивная транзакция", то исполняем следуюущую логику
                if (scope.pageModel.mode === spbPageModes.VIEW && scope.pageModel.type === "vi_accumulative_transaction") {
                    // Получаем идентификатор аккумулятивной транзакции
                    let entityTypeId = scope.docId || (scope.pageModel && scope.pageModel.id) || scope.tempCreateId;
                    // Получаем все связанные с транзакцией банковские счета. В рамках одной транзакции их два - отправитель и получатель
                    let endPoints = await traversalSearch(entityTypeId);
                    // Получаем идентификаторы этих счетов
                    let ids = endPoints.data.map(e => e.endpoints[0].id);
                    let accountOne = ids[0];
                    let accountTwo = ids[1];
                    // Запускаем SAS Job с помощью SAS Job Execution REST API и принимаем таблицу в JSON формате
                    let response = await getJsonFromJob(jobFilePath);
                    // Записываем результат выполнения SAS Job в переменную для дальнейшей работы
                    let results = response.json();
                    // Достаем только те транзакции, с которыми связана текущая аккумулятивная транзакция, и загружаем в кастомный грид
                    scope.accumTransactionsGrid.data = results.filter(function (e) {
                        return (e.ACCOUNT_FROM == accountOne || e.ACCOUNT_FROM == accountTwo) &&
                                (e.ACCOUNT_TO == accountOne || e.ACCOUNT_TO == accountTwo);
                    });
                }
            }
        };
    }
]);
