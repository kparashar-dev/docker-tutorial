const { buildResponse } = require('../lib/response');
const { validateInput } = require('../lib/validation');

exports.handler = async (event) => {
    try {
        // Log incoming request
        console.log('GET request:', JSON.stringify(event, null, 2));

        // Validate path parameters
        const { id } = event.pathParameters || {};
        if (!id) {
            return buildResponse(400, { error: 'Item ID is required' });
        }

        // Mock data response
        const item = {
            id,
            name: 'Example Item',
            description: 'This is a mock item for demonstration',
            createdAt: new Date().toISOString()
        };

        // Return success response
        return buildResponse(200, item);

    } catch (error) {
        console.error('Error:', error);
        return buildResponse(500, { error: 'Internal Server Error' });
    }
};