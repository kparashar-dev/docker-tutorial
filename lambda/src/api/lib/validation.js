/**
 * Input validation utilities
 */

const validateInput = (input) => {
    const errors = [];

    // Validate required fields
    if (!input.name) {
        errors.push('Name is required');
    }

    // Validate field types
    if (input.name && typeof input.name !== 'string') {
        errors.push('Name must be a string');
    }

    if (input.description && typeof input.description !== 'string') {
        errors.push('Description must be a string');
    }

    // Validate field lengths
    if (input.name && input.name.length > 100) {
        errors.push('Name must be less than 100 characters');
    }

    if (input.description && input.description.length > 500) {
        errors.push('Description must be less than 500 characters');
    }

    return {
        isValid: errors.length === 0,
        errors
    };
};

module.exports = {
    validateInput
};