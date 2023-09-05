import * as fs from "node:fs";

const before = JSON.parse(fs.readFileSync("results_before.json"));
const after = JSON.parse(fs.writeFileSync("results_after.json"));

let comment = "Performance test results:\n";

comment += "| Performance | Before | After | Delta |\n";
comment += "| :--- | ---: | ---: | ---: |\n";
for (const key of Object.keys(after)) {
  let delta = after[key] - before[key];
  if (Math.abs(delta) > 1000) {
    delta += ":red_circle:";
  } else {
    delta += ":green_circle:";
  }
  comment += "| " + key + " | " + before[key] + "ms | " + after[key] + "ms | " + delta + " |\n";
}

comment += "\nUpdated: " + new Date().toISOString() + "\n";
comment += "\nSHA: " + process.env.GITHUB_SHA + "\n";

console.dir(comment);

fs.writeFileSync("comment-performance.txt", comment);

fs.writeFileSync("body.txt", "Performance test results: sdf");