import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

final mysql:Client mysqlClient = check new (host = dbHost,
                                    user = dbUser,
                                    password = dbPassword,
                                    database = dbName,
                                    port = dbPort);
