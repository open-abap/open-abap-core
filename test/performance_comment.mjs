import * as fs from "node:fs";

fs.writeFileSync("results_before.json", JSON.stringify(results, null, 2));
fs.writeFileSync("results_after.json", JSON.stringify(results, null, 2));

fs.writeFileSync("body.txt", "Performance test results: sdf");