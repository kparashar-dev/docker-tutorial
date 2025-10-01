const { buildResponse } = require('../lib/response');
const { validateInput } = require('../lib/validation');

exports.handler = async (event) => {
    try {
        // Log incoming request
        console.log('PUT request:', JSON.stringify(event, null, 2));

        // Parse and validate request body
        const body = JSON.parse(event.body);
        const validationResult = validateInput(body);
        
        if (!validationResult.isValid) {
            return buildResponse(400, { 
                error: 'Validation Error', 
                details: validationResult.errors 
            });
        }

        // Mock data creation
        const item = {
            id: Date.now().toString(),
            ...body,
            createdAt: new Date().toISOString()
        };
        
        // In a real application, you would save this to a database
        console.log('Created item:', JSON.stringify(item, null, 2));

        // Return success response
        return buildResponse(201, item);

    } catch (error) {
        console.error('Error:', error);
        if (error instanceof SyntaxError) {
            return buildResponse(400, { error: 'Invalid JSON in request body' });
        }
        return buildResponse(500, { error: 'Internal Server Error' });
    }
};