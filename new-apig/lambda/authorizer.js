exports.handler = async (event) => {
    console.log("Auth Event:", JSON.stringify(event));

    // Get the Authorization header
    const authHeader = event.headers?.Authorization || event.headers?.authorization;

    if (!authHeader) {
        throw new Error("Unauthorized");
    }

    try {
        // Remove 'Bearer ' from the header
        const token = authHeader.replace("Bearer ", "");

        // In a real application, you would validate the token
        // This is a simple example that checks if the token is "allow"
        if (token.toLowerCase() === "allow") {
            return generatePolicy("user", "Allow", event.methodArn);
        }

        return generatePolicy("user", "Deny", event.methodArn);
    } catch (error) {
        console.error("Error:", error);
        throw new Error("Unauthorized");
    }
};

const generatePolicy = (principalId, effect, resource) => {
    const authResponse = {
        principalId: principalId,
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: effect,
                    Resource: resource
                }
            ]
        },
        // Optional context
        context: {
            stringKey: "value",
            numberKey: 123,
            booleanKey: true
        }
    };

    console.log("Generated Policy:", JSON.stringify(authResponse));
    return authResponse;
};