// Lambda Authorizer Function
// This function validates the Authorization header token
exports.handler = async (event) => {
    // Get the Authorization header from the request
    const token = event.authorizationToken;
    
    // Get the expected token from environment variables
    const expectedToken = process.env.AUTH_TOKEN;
    
    // Check if the token is valid
    const isValid = token === `Bearer ${expectedToken}`;
    
    // Generate the IAM policy
    const policy = {
        principalId: 'user',
        policyDocument: {
            Version: '2012-10-17',
            Statement: [
                {
                    Action: 'execute-api:Invoke',
                    Effect: isValid ? 'Allow' : 'Deny',
                    Resource: event.methodArn
                }
            ]
        }
    };
    
    return policy;
};