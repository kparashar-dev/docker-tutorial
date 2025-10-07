exports.handler = async (event, context) => {
    console.log("Event:", JSON.stringify(event));

    // Determine if this is a REST API or HTTP API request
    const path = event.requestContext.http?.path || event.requestContext.resourcePath;
    const method = event.requestContext.http?.method || event.httpMethod;

    return {
        statusCode: 200,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS"
        },
        body: JSON.stringify({
            message: "Hello from Lambda!",
            path: path,
            method: method,
            requestId: context.awsRequestId,
            apiType: event.requestContext.http ? "HTTP API" : "REST API",
            event: event
        })
    };
};