import { ValidationError } from 'yup';

export const errorValidationHandler = (err, req, res, next) => {
    if (err instanceof ValidationError) {
        return res.status(422).json({
            message: err.errors[0],
        });
    }

    next(err);
};

export const errorHandlers = (err, req, res, next) => {
    if (res.headersSent) {
        return next(err);
    }

    const status = err.status || 500;
    const message = err.message || 'Something went wrong';

    res.status(status).json({
        message,
    });
};