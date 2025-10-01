/**
 * Utility function to build standardized API responses
 */
const buildResponse = (statusCode, body) => ({
    statusCode,
    headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': true,
        'X-Request-ID': Date.now().toString()
    },
    body: JSON.stringify(body)
});

module.exports = {
    buildResponse
};