import {CREATE_TASK_VALIDATION_SCHEMA, UPDATE_TASK_VALIDATION_SCHEMA,} from '../utils/index.js';


export const validateTaskOnCreate = async (req, res, next) => {
    try {
        req.body = await CREATE_TASK_VALIDATION_SCHEMA.validate(req.body, {
            abortEarly: false,
            stripUnknown: true,
        });

        next();
    } catch (err) {
        next(err);
    }
};

export const validateTaskOnUpdate = async (req, res, next) => {
    try {
        if (Object.keys(req.body).length === 0) {
            return res.status(400).json({
                message: 'At least one field is required',
            });
        }

        const validatedBody = await UPDATE_TASK_VALIDATION_SCHEMA.validate(req.body, {
            abortEarly: false,
            stripUnknown: true,
        });

        req.body = validatedBody;
        next();
    } catch (err) {
        next(err);
    }
};