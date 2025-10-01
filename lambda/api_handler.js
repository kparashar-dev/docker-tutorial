// Main API Handler Function
// This function handles the actual API request after authorization
exports.handler = async (event) => {
    try {
        // Sample response
        const response = {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' // Enable CORS
            },
            body: JSON.stringify({
                message: 'Hello from protected API!',
                timestamp: new Date().toISOString()
            })
        };
        
        return response;
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' })
        };
    }
};