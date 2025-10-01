const jwt = require('jsonwebtoken');
const { buildResponse } = require('../api/lib/response');

/**
 * Lambda Authorizer with JWT validation
 */
exports.handler = async (event) => {
    try {
        // Extract token from Authorization header
        const authHeader = event.authorizationToken;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            throw new Error('Invalid authorization header');
        }

        const token = authHeader.split(' ')[1];
        
        // Verify JWT token
        // In production, use AWS Secrets Manager for JWT_SECRET
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // Generate IAM policy
        const policy = generatePolicy(decoded.sub, 'Allow', event.methodArn);
        
        // Add additional context (optional)
        policy.context = {
            userId: decoded.sub,
            scope: decoded.scope
        };

        return policy;

    } catch (error) {
        console.error('Authorization Error:', error);
        return generatePolicy('user', 'Deny', event.methodArn);
    }
};

/**
 * Generates IAM policy document
 */
const generatePolicy = (principalId, effect, resource) => {
    return {
        principalId,
        policyDocument: {
            Version: '2012-10-17',
            Statement: [{
                Action: 'execute-api:Invoke',
                Effect: effect,
                Resource: resource
            }]
        }
    };
};