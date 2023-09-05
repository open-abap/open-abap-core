import * as fs from "node:fs";

const before = JSON.parse(fs.readFileSync("results_before.json"));
const after = JSON.parse(fs.writeFileSync("results_after.json"));

fs.writeFileSync("body.txt", "Performance test results: sdf");