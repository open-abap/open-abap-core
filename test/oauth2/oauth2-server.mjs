import http from "node:http";

const expectedForm = {
  grant_type: "client_credentials",
  client_id: "test-client",
  client_secret: "test-secret",
  scope: "test.scope",
};

function respond(response, status, body) {
  response.writeHead(status, {"content-type": "application/json"});
  response.end(body);
}

function collectBody(request) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    request.on("data", (chunk) => chunks.push(chunk));
    request.on("error", reject);
    request.on("end", () => resolve(Buffer.concat(chunks).toString()));
  });
}

const server = http.createServer(async (request, response) => {
  if (request.method === "GET" && request.url === "/health") {
    response.writeHead(200);
    response.end("ok");
    return;
  }

  if (request.method !== "POST") {
    respond(response, 405, '{"error":"method_not_allowed"}');
    return;
  }

  if (request.url === "/unauthorized") {
    respond(response, 401, '{"error":"invalid_client"}');
    return;
  }

  const contentType = request.headers["content-type"] || "";
  const form = new URLSearchParams(await collectBody(request));
  const validRequest =
    contentType.startsWith("application/x-www-form-urlencoded") &&
    Object.entries(expectedForm).every(([name, value]) => form.get(name) === value);

  if (!validRequest) {
    respond(response, 400, '{"error":"invalid_request"}');
    return;
  }

  switch (request.url) {
    case "/token":
      respond(response, 200, '{"access_token":"test-token","token_type":"Bearer"}');
      break;
    case "/spaced-token":
      respond(response, 200, '{ "token_type": "Bearer", "access_token": "spaced-token" }');
      break;
    case "/missing-token":
      respond(response, 200, '{"token_type":"Bearer"}');
      break;
    default:
      respond(response, 404, '{"error":"not_found"}');
  }
});

server.listen(8081, "0.0.0.0");

process.on("SIGTERM", () => server.close());
