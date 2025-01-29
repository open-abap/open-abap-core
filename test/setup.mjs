import {SQLiteDatabaseClient} from "@abaplint/database-sqlite";
import {PostgresDatabaseClient} from "@abaplint/database-pg";

export async function setup(abap, schemas, insert) {
  abap.context.databaseConnections["DEFAULT"] = new SQLiteDatabaseClient();
  await abap.context.databaseConnections["DEFAULT"].connect();
  await abap.context.databaseConnections["DEFAULT"].execute(schemas.sqlite);
  await abap.context.databaseConnections["DEFAULT"].execute(insert);

  abap.context.databaseConnections["PG"] = new PostgresDatabaseClient({
    user: "postgres",
    host: "localhost",
    database: "postgres",
    password: "postgres",
    port: 5432,
  });
}