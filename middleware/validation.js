import {
    CREATE_TASK_VALIDATION_SCHEMA,
    UPDATE_TASK_VALIDATION_SCHEMA,
} from '../utils/index.js';

import { getTaskById } from '../models/Tasks.js';

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
    const { id } = req.params;

    const task = getTaskById(id);

    if (!task) {
        return res.status(404).json({
            message: 'Could not find task',
        });
    }

    if (Object.keys(req.body).length === 0) {
        return res.status(400).json({
            message: 'At least one field is required',
        });
    }

    try {
        req.body = await UPDATE_TASK_VALIDATION_SCHEMA.validate(req.body, {
            stripUnknown: true,
            abortEarly: false,
        });

        next();
    } catch (err) {
        next(err);
    }
};