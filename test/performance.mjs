import { initializeABAP } from '../output/init.mjs';
import * as fs from "node:fs";
import * as path from "node:path";

await initializeABAP();

const results = {};

for (const filename of fs.readdirSync("./test/performance")) {
  global.gc();
  const className = path.basename(filename.split(".")[0]).toUpperCase();

  const t0 = performance.now();
  await abap.Classes[className].run();
  const t1 = performance.now();
  const runtime = Math.round(t1 - t0);

  console.log(className + ": " + runtime + "ms");
  results[className] = runtime;
}

fs.writeFileSync("results.json", JSON.stringify(results, null, 2));