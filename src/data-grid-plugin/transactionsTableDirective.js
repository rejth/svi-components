
angular.module("sngPageBuilderCustom").spbDirective("{{name}}", [
    "$http",
    "spbPageModes",
    function ($http, spbPageModes) {
        const
            PROMISE = f => new Promise(result => f.then(result).catch(result)),
            GET  = (url) => PROMISE($http.get(url)),
            POST = (url, data) => PROMISE($http.post(url, data)),
            // Функция для получения всех связанных с транзакцией банковских счетов (отправитель и получатель)
            traversalSearch = (id) => {
                return POST("/svi-sand/paths?expansionLimit=2000", {
                    "id": id,
                    "type": "vi_other_transaction",
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
            template: `{{template}}`,
            link: async function (scope) {
                // Создаем таблицу, в которой будут содержаться все транзакции между двумя счетами
                scope.transactionGrid = {
                    data: [],
                    columns: [
                        {
                            field: "account_from",
                            title: "Счет отправителя"
                        },
                        {
                            field: "account_id_from",
                            title: "ID счета отправителя"
                        },
                        {
                            field: "account_id_to",
                            title: "ID счета получателя"
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
                            field: "employee",
                            title: "ФИО работника"
                        },
                        {
                            field: "payment",
                            title: "Сумма транзакции"
                        },
                        {
                            field: "transaction_date",
                            title: "Дата и время проведения транзакции"
                        },
                        {
                            field: "transaction_id",
                            title: "ID транзакции"
                        }
                    ]
                };

                // Если находимся в карточке "Аккумулятивная транзакция", то исполняем следуюущую логику
                if (scope.pageModel.mode === spbPageModes.VIEW && scope.pageModel.type === "vi_other_transaction") {
                    // Получаем идентификатор транзакции
                    let entityTypeId = scope.docId || (scope.pageModel && scope.pageModel.id) || scope.tempCreateId;
                    // Получаем все связанные с транзакцией банковские счета. В рамках одной транзакции их два - отправитель и получатель
                    let endPoints = await traversalSearch(entityTypeId);
                    // Получаем идентификаторы этих счетов
                    let ids = endPoints.data.map(e => e.endpoints[0].id);

                    let i = true;

                    repeat:
                    while (i === true) {
                        // Формируем source (отправитель) и target (получатель) для GET-запроса на получение данных по транзакции
                        let sourceId = ids[0];
                        let targetId = ids[1];
                        // Формируем запрос на получение данных по транзакции
                        let url = "/svi-datahub/transactions/transaction" +
                            "?entityId=" + encodeURIComponent(sourceId) +
                            "&entityId=" + encodeURIComponent(targetId) +
                            "&entityTypeName=" + "vi_account" +
                            "&entityTypeName=" + "vi_account";
                        // Отправляем запрос - получаем данные по транзакции
                        let transactionsArray = await GET(url);
                        // При получении идентификаторов банковских счетов, source и target в некоторых случаях меняются местами.
                        // Причина этого непонятна.
                        // Из-за этого не получается достать данные по транзакции, и потому необходимо проверять результат запроса на наличие данных.
                        // В случае, если запрос ничего не возвращает, нужно поменять местами source и target обратно и повторить запрос
                        if (transactionsArray.data.count === 0) {
                            // Меняем местами идентификаторы банковских счетов
                            ids.reverse();
                            // Повторяем GET-запрос
                            continue repeat;
                        }
                        // Отправляем данные по транзакции в таблицу
                        scope.transactionGrid.data = transactionsArray.data.items.map(e => e.fieldValues);
                    }
                }
            }
        };
    }]
);
